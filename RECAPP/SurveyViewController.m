//
//  SurveyViewController.m
//  RECAPP
//
//  Created by RECAPP Developer on 08/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import "SurveyViewController.h"
#import "MutiAnswerQuestionCell.h"
#import "SurveyQuestion.h"
#import "SurveyLikertQuestion.h"
#import "SurveyMultiOptionQuestion.h"
#import "MultiOption.h"
#import "QuestionLikertCell.h"
#import "AppDelegate.h"
#import "Project.h"
#import "QuestionOptionsView.h"
#import "LikertOption.h"
#import "PaneButton.h"
#import "SurveyForm.h"
#import "AlertsManager.h"
#import "SurveyHeaderCell.h"
#import "ImageExperienceCapture.h"
#import "ImageExperienceCaptureController.h"
#import "ImageExperienceCapture.h"
#import "ImageExperienceCaptureCell.h"
#import "ImageExperienceCaptureController.h"
#import "StimulusSurveyForm.h"
#import "StimulusAllocation.h"
#import "Stimulus.h"
#import "StimulusQuestion.h"
#import "StimulusQuestionCell.h"
#import "RecallQuestionCell.h"
#import "RecallQuestion.h"
#import "FilledStimulusSurveyForm.h"
#import "Stimulus.h"


@interface SurveyViewController ()

@end

@implementation SurveyViewController

@synthesize questionList, pickerBar, pickerView, surveyForm, sortedQuestions, selectedQuestionOrdinal, triggerID, captureControllers, cellTypes, surveyCoreDataID, questionToDisplay, responseOrdinal;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)optionSelected:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    //////////NSLog(@"%d",btn.tag);
    selectedQuestionOrdinal = btn.tag;
    [pickerView reloadAllComponents];
    pickerView.hidden = NO;
    pickerBar.hidden = NO;
    
    SurveyMultiOptionQuestion *question = [self.sortedQuestions objectAtIndex:selectedQuestionOrdinal];
    MultiOption *mop = [[question.options sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"ordinal" ascending:YES]]] objectAtIndex:0];
    question.answer = mop;

    [self.questionList reloadData];
}


- (void)viewDidLoad
{
    selectedQuestionOrdinal = -1;
    [super viewDidLoad];
	pickerView.hidden = YES;
    pickerBar.hidden = YES;
    
    captureControllers = [[NSMutableArray alloc] init];
    cellTypes = [[NSMutableDictionary alloc] init];
    
    ////NSLog(@"viewDidLoad");
    /*NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    responseOrdinal = [NSNumber numberWithInt:0];
    [defaults setObject:responseOrdinal forKey:@"recallOrdinal"];
    [defaults synchronize];*/
}

-(void)viewWillAppear:(BOOL)animated
{
   for(SurveyQuestion *question in surveyForm.questions)
   {
       [question removeCapturedData];
   }
    
    surveyCoreDataID = [self.surveyForm.identifier copy];
    
    [self updateSurveyForm];
    
    sortedQuestions = [[NSArray alloc] initWithArray:[self.surveyForm.questions sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"ordinal" ascending:YES]]]];
    
    if(self.surveyForm.project.studyType.intValue == StimulusProject)
    {
        
        int pos = questionToDisplay.intValue;
        
        ////NSLog(@"SurveyView:viewWillAppear Show Question %d", pos);
        
        SurveyQuestion *StimSurveyQ = (StimulusQuestion*)[sortedQuestions objectAtIndex:pos]; // 2 equals next stim to show
        
        AppDelegate *appDel = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        NSFetchRequest *fetchSurveyRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityform = [NSEntityDescription entityForName:@"StimulusAllocation" inManagedObjectContext:[appDel managedObjectContext]];
        [fetchSurveyRequest setEntity:entityform];
        [fetchSurveyRequest setFetchLimit:1];
        
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"trial_identifier == %@",self.surveyCoreDataID];
        [fetchSurveyRequest setPredicate:predicate1];
        NSError *error;
        NSArray *surveyAllocation = [[appDel managedObjectContext] executeFetchRequest:fetchSurveyRequest error:&error];
        
        
        if(surveyAllocation.count > 0)
        {
            StimulusAllocation *alloc = [surveyAllocation objectAtIndex:0];
            
            //////NSLog(@"trial_timulus_count:%d", alloc.stimulus.count);
            
            if(pos < alloc.stimulus.count)
            {
                StimulusQuestion *stimQuestion = (StimulusQuestion*) StimSurveyQ;
                for(Stimulus *stimQ in alloc.stimulus)
                {
                    if([stimQ.stimulus_question_identifier isEqualToString:stimQuestion.identifier])
                    {
                        stimQuestion.stimulus = stimQ.value;
                    }
                }
            }
            else
            {
                RecallQuestion *stimQuestion = (RecallQuestion*) StimSurveyQ;
                //do something with recaqll question
            }
        }
        
        sortedQuestions = [[NSArray alloc] initWithObjects:StimSurveyQ, nil];
        
        
        if ([sortedQuestions[0] isKindOfClass:[StimulusQuestion class]]) {
            ////NSLog(@"pre save");
            [self.surveyForm saveSurvey:self.sortedQuestions forTrigger:self.triggerID];
        }
        
    }
    [self.questionList reloadData];
}


-(void)updateSurveyForm
{
    AppDelegate *appDel = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSFetchRequest *fetchSurveyRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityform = [NSEntityDescription entityForName:@"SurveyForm" inManagedObjectContext:[appDel managedObjectContext]];
    [fetchSurveyRequest setEntity:entityform];
    [fetchSurveyRequest setReturnsObjectsAsFaults:NO];
    [fetchSurveyRequest setFetchLimit:1];
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"identifier == %@",self.surveyCoreDataID];
    [fetchSurveyRequest setPredicate:predicate1];
    NSError *error;
    NSArray *surveys = [[appDel managedObjectContext] executeFetchRequest:fetchSurveyRequest error:&error];
    
    if(surveys.count > 0)
    {
        self.surveyForm = [surveys objectAtIndex:0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 55.0)];
    header.backgroundColor= [UIColor darkGrayColor];
    
    PaneButton *closebtn = [PaneButton buttonWithType:UIButtonTypeCustom];
    closebtn.titleLabel.font = [UIFont fontWithName:@"Futura-CondensedMedium" size:17];
    [closebtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [closebtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [closebtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeForm:)]];
    closebtn.frame = CGRectMake(0, 0, 70.0 , 55.0);
    UIColor *logBlue = [UIColor colorWithRed:208.0f / 255.0f green:208.0f / 255.0f blue:34.0f / 255.0f alpha:1];
    [closebtn setBackgroundColor:logBlue forState:UIControlStateNormal];
    [closebtn setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [closebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closebtn setTitle:@"Close" forState:UIControlStateNormal];
    //closebtn.layer.borderColor = [UIColor whiteColor].CGColor;
    //closebtn.layer.borderWidth = 1.0f;
    [header addSubview:closebtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((header.frame.size.width / 2) - 22.5, 10.0, 45.0, 45.0)];
    label.textColor = [UIColor colorWithRed:208.0f / 255.0f green:208.0f / 255.0f blue:34.0f / 255.0f alpha:1];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font =[UIFont fontWithName:@"Futura-CondensedMedium" size:17.0]; //Futura Condensed Medium 20.0
    label.text = @"Survey";
    [header addSubview:label];
    
    
    PaneButton *logButton = [PaneButton buttonWithType:UIButtonTypeCustom];
    logButton.titleLabel.font = [UIFont fontWithName:@"Futura-CondensedMedium" size:17];
    [logButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [logButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [logButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveForm:)]];
    logButton.frame = CGRectMake((header.frame.size.width - 70.0), 0, 70.0 , 55.0);
    //UIColor *logBlue = [UIColor colorWithRed:208.0f / 255.0f green:208.0f / 255.0f blue:34.0f / 255.0f alpha:1];
    [logButton setBackgroundColor:logBlue forState:UIControlStateNormal];
    [logButton setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [logButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logButton setTitle:@"Finish" forState:UIControlStateNormal];
    [header addSubview:logButton];
    
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    logButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    header.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    return header;
}

- (void) saveForm:(UITapGestureRecognizer *)recognizer
{
    int answerCount = 0;
    for(SurveyQuestion *question in self.sortedQuestions)
    {
       ([question isEmpty]) ? answerCount : answerCount++;
    }
    
    ////NSLog(@"%d %lu",answerCount, (unsigned long)self.sortedQuestions.count);
    if(answerCount == self.sortedQuestions.count)
    {
        [self updateSurveyForm];
        
        [self.surveyForm saveSurvey:self.sortedQuestions forTrigger:self.triggerID];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:NO forKey:@"isWorkingWithSurvey"];
        
        responseOrdinal = [NSNumber numberWithInt:0];
        NSString *formName = [NSString stringWithFormat:@"%@ro",self.surveyForm.identifier];
        [defaults setObject:responseOrdinal forKey:formName];
        [defaults synchronize];
    }
    else
    {
        [[AlertsManager getInstance] completeSurvey];
    }
}

- (void) closeForm:(UITapGestureRecognizer *)recognizer
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"isWorkingWithSurvey"];
    [defaults synchronize];
}

- (IBAction)recallAddResponse:(id)sender {
    
    
    [self updateSurveyForm];
    
    UITableViewCell *recallCell = (UITableViewCell*)[(UIButton*) sender superview];
    UITextField *textbox = (UITextField*) [recallCell viewWithTag:1716];
    //////NSLog(@"%@",textbox.text);
    
    //////NSLog(@"%@",textbox.text);
    //////NSLog(@"%@", surveyForm);
    //////NSLog(@"%@", surveyForm.project);
     //////NSLog(@"%@", self.surveyForm.project);
    
    if(surveyForm.project.studyType.intValue == StimulusProject)
    {
        AppDelegate *appDel = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        NSFetchRequest *fetchSurveyRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityform = [NSEntityDescription entityForName:@"FilledStimulusSurveyForm" inManagedObjectContext:[appDel managedObjectContext]];
        [fetchSurveyRequest setEntity:entityform];
        [fetchSurveyRequest setFetchLimit:1];
        
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"form_identifier == %@",surveyForm.identifier];
        [fetchSurveyRequest setPredicate:predicate1];
        NSError *error;
        NSArray *filledforms = [[appDel managedObjectContext] executeFetchRequest:fetchSurveyRequest error:&error];
        
        if(filledforms.count > 0)
        {
            FilledStimulusSurveyForm *filledForm = (FilledStimulusSurveyForm*) [filledforms objectAtIndex:0];
            
            NSString *formName = [NSString stringWithFormat:@"%@ro",surveyForm.identifier];
    
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            responseOrdinal = [defaults objectForKey:formName];
            int value = [responseOrdinal intValue];
            responseOrdinal = [NSNumber numberWithInt:value + 1];
            ////NSLog(@"responseOrdinal is: %d", value + 1);
            [defaults setObject:responseOrdinal forKey:formName];
            [defaults synchronize];
         
            Stimulus *new_stim = [NSEntityDescription insertNewObjectForEntityForName:@"Stimulus" inManagedObjectContext:[appDel managedObjectContext]];
            new_stim.value = [textbox.text copy];
            new_stim.ordinal = [responseOrdinal stringValue];
            //look for match in existing stimulus to specify identifier
            [filledForm addRecallsetObject:new_stim];
            
            [appDel dirtyMOCSave];
        }
    }
    
    textbox.text = @"";
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.sortedQuestions.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"";
    UITableViewCell *cell = nil;// [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(indexPath.row == 0)
    {
         [self updateSurveyForm];
        CellIdentifier = @"SurveyHeaderCell";
        SurveyHeaderCell *headercell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        //UIColor *logBlue = [UIColor colorWithRed:208.0f / 255.0f green:208.0f / 255.0f blue:34.0f / 255.0f alpha:1];
        headercell.contentView.backgroundColor = [UIColor lightGrayColor];//logBlue;
        //headercell.contentView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        //headercell.contentView.layer.borderWidth = 1.0f;
        headercell.projectName.text = self.surveyForm.project.name;
        headercell.surveyName.text = self.surveyForm.title;
        headercell.surveyID.text = self.surveyForm.identifier;
        headercell.surveyType.image = [UIImage imageNamed:@"survey-incomplete.png"];
        headercell.desc.text = self.surveyForm.header;
        cell = headercell;
        
        NSDictionary *survey = [self.surveyForm toDictionary];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:survey options:nil error:nil];
        NSString *jsonItemsAsString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //////NSLog(@"%@", jsonItemsAsString);
    }
    else
    {
        SurveyQuestion *question = [self.sortedQuestions objectAtIndex:(indexPath.row - 1)];
        
        
        if([question isKindOfClass:[StimulusQuestion class]])
        {
            CellIdentifier = @"StimulusQuestionCell";
            StimulusQuestionCell *stimcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            StimulusQuestion *stimQ = (StimulusQuestion*)question;
            
            ////NSLog(@"CellAt:Question options size: %lu", (unsigned long)stimQ.options.count);
            
            stimcell = stimcell ? stimcell : [[StimulusQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            stimcell.question.text = stimQ.question;
            //stimcell.leftDescription.text = likertQ.low_end_descriptor;
            //stimcell.rightDescription.text = likertQ.high_end_descriptor;
            stimcell.stimulus.text = stimQ.stimulus;
            
            LikertOption *option = stimQ.answer;
            stimcell.optionSelector.question = stimQ;
            stimcell.optionSelector.backgroundColor = [UIColor darkGrayColor];
            [stimcell.optionSelector setSelectedOption:option.value];
            
            cell = stimcell;
        }
        else if([question isKindOfClass:[RecallQuestion class]])
        {
            CellIdentifier = @"RecallQuestionCell";
            RecallQuestionCell *recallcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            StimulusQuestion *recallQ = (StimulusQuestion*)question;
            recallcell = recallcell ? recallcell : [[RecallQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            if([self.surveyForm.project.ask_recall intValue] == 0)
            {
                recallcell.recallBtn.hidden = YES;
                recallcell.wordBox.hidden = YES;
                recallcell.questionLabel.text = @"The experiment is now finished. Please click 'Finish' to complete";
            }
            else
            {
                recallcell.recallBtn.hidden = NO;
                recallcell.wordBox.hidden = NO;
                recallcell.questionLabel.text = @"Enter a single word and tap Recall to remember as many words as possible";
            }
            
            cell = recallcell;
            
            // fix above question builder
        }
        else if([question isKindOfClass:[SurveyLikertQuestion class]])
        {
            CellIdentifier = @"QuestionLikertCell";
            QuestionLikertCell *likertcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            SurveyLikertQuestion *likertQ = (SurveyLikertQuestion*)question;
            likertcell = likertcell ? likertcell : [[QuestionLikertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            likertcell.question.text = likertQ.question;
            likertcell.leftDescription.text = likertQ.low_end_descriptor;
            likertcell.rightDescription.text = likertQ.high_end_descriptor;

            LikertOption *option = likertQ.answer;
            likertcell.optionSelector.question = likertQ;
            likertcell.optionSelector.backgroundColor = [UIColor darkGrayColor];
            [likertcell.optionSelector setSelectedOption:option.value];
         
            cell = likertcell;
        }
        else if([question isKindOfClass:[SurveyMultiOptionQuestion class]])
        {
            CellIdentifier = @"MutiAnswerQuestionCell";
            MutiAnswerQuestionCell *multiOpCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            SurveyMultiOptionQuestion *multi = (SurveyMultiOptionQuestion*)question;
            multiOpCell = multiOpCell ? multiOpCell : [[MutiAnswerQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            multiOpCell.question.text = multi.question;
            MultiOption *moption = (MultiOption*) multi.answer;
            NSString *buttonLabel = moption ? moption.value : @"Select Option";
            [multiOpCell.selectionBtn setTitle:buttonLabel forState:UIControlStateNormal];
            multiOpCell.selectionBtn.tag = (indexPath.row - 1);
            
            cell = multiOpCell;
        }
        else if([question isKindOfClass:[ImageExperienceCapture class]])
        {
            CellIdentifier = @"ImageExperienceCaptureCell";
            ImageExperienceCaptureCell *multiOpCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            ImageExperienceCapture *multi = (ImageExperienceCapture*)question;
            //multiOpCell = multiOpCell ? multiOpCell : [[ImageExperienceCaptureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            if(multiOpCell == nil)
            {
                multiOpCell = [[ImageExperienceCaptureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            multiOpCell.question.text = multi.question;
            
            ImageExperienceCaptureController *targetController = nil;
        
            for(ImageExperienceCaptureController *controller in captureControllers)
            {
                [controller.experienceCapture.identifier isEqualToString:multi.identifier] ? targetController = controller : nil;
            }
            
            if(!targetController)
            {
                targetController = [[ImageExperienceCaptureController alloc] init];
                targetController.viewController = self;
                targetController.expCaptureCell = multiOpCell;
                targetController.experienceCapture = multi;
                [captureControllers addObject:targetController];
            }
            
            multiOpCell.photoView.image = [UIImage imageWithData:((ImageExperienceCapture*) targetController.experienceCapture).image];
            
            [multiOpCell.openCamera removeTarget:targetController action:@selector(showCamera:) forControlEvents:UIControlEventTouchUpInside];
            [multiOpCell.openCamera addTarget:targetController action:@selector(showCamera:) forControlEvents:UIControlEventTouchUpInside];
            
            cell = multiOpCell;
        }
    }
    
    //[cellTypes setObject:[cell class] forKey:[NSNumber numberWithInt:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        if(self.surveyForm.header.length > 0)
        {
            
        }
        
        return 106; //106
    }
    
    SurveyQuestion *question = [self.sortedQuestions objectAtIndex:(indexPath.row - 1)];
    
    ////////NSLog(@"%@", [question description]);
    
    if([question isKindOfClass:[ImageExperienceCapture class]])
    {
        return 208;
    }
    else if([question isKindOfClass:[StimulusQuestion class]])
    {
        return 201;
    }
    else if([question isKindOfClass:[RecallQuestion class]])
    {
        return 146;
    }
    else
    {
        return 110;
    }
}
- (IBAction)clearWheel:(id)sender {
    
    
    [pickerView selectRow:0 inComponent:0 animated:NO];
    
    selectedQuestionOrdinal = -1;
    
	pickerView.hidden = YES;
    
    pickerBar.hidden = YES;
}

- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //////NSLog(@"%d", selectedQuestionOrdinal);
    SurveyMultiOptionQuestion *question = [self.sortedQuestions objectAtIndex:selectedQuestionOrdinal];
    NSArray *options = [question.options sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"ordinal" ascending:YES]]];
    MultiOption *opt = [options objectAtIndex:row];
    question.answer = opt;
    //////////NSLog(@"%@",opt.value);
    [questionList reloadData];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(selectedQuestionOrdinal > -1)
    {
        SurveyMultiOptionQuestion *question = [self.sortedQuestions objectAtIndex:selectedQuestionOrdinal];
        //////NSLog(@"%d", question.options.count);
        return question.options.count;
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(selectedQuestionOrdinal > -1)
    {
    //////NSLog(@"%d %d", selectedQuestionOrdinal,self.sortedQuestions.count);
    SurveyMultiOptionQuestion *question = [self.sortedQuestions objectAtIndex:selectedQuestionOrdinal];
    NSArray *options = [question.options sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"ordinal" ascending:YES]]];
    MultiOption *opt = [options objectAtIndex:row];
    
    return opt.value;
    }
    else
    {
        return @"";
    }
}






@end
