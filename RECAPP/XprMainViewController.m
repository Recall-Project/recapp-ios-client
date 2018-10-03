//
//  RECAPPMainViewController.m
//  RECAPP
//
//  Created by RECAPP Developer on 08/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import "RECAPPMainViewController.h"
#import "StandardSurveyCell.h"
#import "SurveyViewController.h"
#import "PaneButton.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "SurveyForm.h"
#import "FilledSurveyForm.h"
#import "Project.h"
#import "Trigger.h"
#import "SpatialTrigger.h"
#import "TemporalTrigger.h"
#import "NSDate+TimeAgo.h"
#import "DateTimeUtil.h"
#import "MBProgressHUD.h"
#import "HistoryItemWrapper.h"
#import "SurveyMultiOptionQuestion.h"
#import "Guid.h"
#import "FilledFormCache.h"
#import "FilledStimulusSurveyForm.h"
#import "AlertsManager.h"

@interface RECAPPMainViewController ()

@end


@implementation RECAPPMainViewController

@synthesize surveylist, primedSurveys, previousSurveys, availableSurveys;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PaneButton *logButton = [PaneButton buttonWithType:UIButtonTypeCustom];
    logButton.titleLabel.font = [UIFont fontWithName:@"Futura-CondensedMedium" size:17];
    [logButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [logButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [logButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fliptosettings)]];
    logButton.frame = CGRectMake((self.view.frame.size.width - 70.0), 0, 70.0 , 65.0);
    UIColor *logBlue = [UIColor colorWithRed:208.0f / 255.0f green:208.0f / 255.0f blue:34.0f / 255.0f alpha:1];
    [logButton setBackgroundColor:logBlue forState:UIControlStateNormal];
    [logButton setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [logButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logButton setTitle:@"Settings" forState:UIControlStateNormal];
    [self.view addSubview:logButton];
    
    logButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor colorWithRed:96.0f / 255.0f green:96.0f / 255.0f blue:96.0f / 255.0f alpha:1];
    [refreshControl addTarget:self action:@selector(pullrefresh) forControlEvents:UIControlEventValueChanged];
    [self.surveylist addSubview:refreshControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(pulldownloadCompleted:)
     name:@"StudyDownloadComplete"
     object:nil];
     
    
}

-(void)viewDidAppear:(BOOL)animated
{
      ////NSLog(@"viewDidAppear");
    [self refreshSurveyListings];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([[defaults objectForKey:@"has_registered"] boolValue] == NO)
    {
        UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        
        LoginViewController *loginController = [storybord instantiateViewControllerWithIdentifier:@"login"];
        loginController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:loginController animated:YES completion:nil];
    }
    
   
    
    /*NSMutableDictionary *project = [[NSMutableDictionary alloc] init];
    [project setObject:@"Project" forKey:@"type"];
    [project setObject:@"ESM Group" forKey:@"name"];
    [project setObject:@"8498184f-89b3-4240-a397-255ec6359a26" forKey:@"identifier"];
    [project setObject:[[Guid getInstance] newGuid] forKey:@"revision"];
    
    NSMutableDictionary *eveningform = [[NSMutableDictionary alloc] init];
    [eveningform setObject:@"SurveyForm" forKey:@"type"];
    [eveningform setObject:@"b9e92153-8430-40be-8f66-16b175ec75dc" forKey:@"identifier"];
    [eveningform setObject:[NSNumber numberWithInt:0] forKey:@"state"];
    [eveningform setObject:@"Test" forKey:@"title"];
    
    NSMutableDictionary *imageCapture = [[NSMutableDictionary alloc] init];
    [imageCapture setObject:@"ImageExperienceCapture" forKey:@"type"];
    [imageCapture setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
    [imageCapture setObject:[NSNumber numberWithInt:1] forKey:@"ordinal"];
    [imageCapture setObject:@"blar" forKey:@"question"];
    
    NSMutableDictionary *imageCapture2 = [[NSMutableDictionary alloc] init];
    [imageCapture2 setObject:@"ImageExperienceCapture" forKey:@"type"];
    [imageCapture2 setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
    [imageCapture2 setObject:[NSNumber numberWithInt:2] forKey:@"ordinal"];
    [imageCapture2 setObject:@"blar" forKey:@"question"];

    NSMutableSet *questions = [NSMutableSet setWithObjects:imageCapture,imageCapture2, nil];
    [eveningform setObject:questions forKey:@"questions"];
    
    NSMutableSet *surveys = [NSMutableSet setWithObjects:eveningform, nil];
    [project setObject:surveys forKey:@"surveys"];
        Project *projectEntity = //(Project*)[ExtendedManagedObject createManagedObjectFromDictionary:project inContext:[ap managedObjectContext]];*/
    
    
    //[defaults setBool:NO forKey:@"isWorkingWithSurvey"];
    
    //[defaults setBool:YES forKey:@"isWorkingWithSurvey"];
    //[defaults synchronize];
    
    /* AppDelegate *ap = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:[ap managedObjectContext]];
    [fetchRequest setEntity:entityDesc];
    NSError *error;
    NSArray *existingStudies = [[ap managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    ////NSLog(@"%lu", (unsigned long)existingStudies.count);
    
    Project *project = [existingStudies objectAtIndex:0];
    
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    SurveyViewController *formController = [storybord instantiateViewControllerWithIdentifier:@"form"];
   
    for(SurveyForm *existingForm in [project.surveys allObjects])
    {
        //if([existingForm.identifier isEqualToString:@"c1a4ca99-e031-4a18-ada1-1c10fae7cc45"])
        //{
            //////NSLog(@"%@", existingForm.title);
             formController.surveyForm = existingForm;
        //}
    }
    
    formController.triggerID = @"";
    formController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:formController animated:YES completion:nil];*/
 
}


-(void) pullrefresh
{
     ////NSLog(@"pullrefresh");
    [[FilledFormCache getInstance] updateStudiesList];
}

-(void) pulldownloadCompleted:(NSNotification *) notification
{
     ////NSLog(@"pulldownloadCompleted");
    //[self refreshSurveyListings];
}

-(void)refreshSurveyListings
{
    
    ////NSLog(@"refreshSurveyListings");
    
    previousSurveys = [[NSMutableArray alloc] init];
    availableSurveys = [[NSMutableArray alloc] init];
    primedSurveys = [[NSMutableArray alloc] init];
    
    AppDelegate *ap = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSFetchRequest *fetchCompletedRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"FilledSurveyForm" inManagedObjectContext:[ ap managedObjectContext]];
    [fetchCompletedRequest setEntity:entityDesc];
    NSError *error;
    NSArray *completedForms = [[ap managedObjectContext] executeFetchRequest:fetchCompletedRequest error:&error];
    
    for(FilledSurveyForm *filledForm in completedForms)
    {
        if([filledForm.not_filled boolValue])
        {
            HistoryItemWrapper *filleditemWrapper = [[HistoryItemWrapper alloc] init];
            filleditemWrapper.item = filledForm;
            filleditemWrapper.timestamp = filledForm.completed;
            [previousSurveys addObject:filleditemWrapper];
        }
    }
    
    
    
    NSFetchRequest *fetchSurveyRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityform = [NSEntityDescription entityForName:@"SurveyForm" inManagedObjectContext:[ap managedObjectContext]];
    [fetchSurveyRequest setEntity:entityform];
    //NSPredicate *predicate1 = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"state == 0"]]; //inactive
    //[fetchSurveyRequest setPredicate:predicate1];
    NSArray *surveys = [[ap managedObjectContext] executeFetchRequest:fetchSurveyRequest error:&error];
    
    
    ////NSLog(@"survey count: %lu", (unsigned long)[surveys count]);
    
    for(SurveyForm *form in surveys)
    {
       
        /*InActive 0,
        Active 1,
        Available 2,
        Completed 3,
        Expired 4
        */
        
        //[form disableForm];
        [form validateForm];
        [form activateForm];
        
        
        //////NSLog(@"%d", form.state.intValue);
        
        for(Trigger *trigger in form.triggers)
        {
            if(trigger.state.intValue == Available)
            {
                [availableSurveys addObject:trigger];
            }
            
            if(trigger.state.intValue == Expired)
            {
                if([trigger isKindOfClass:[TemporalTrigger class]])
                {
                    TemporalTrigger *timetrigger = (TemporalTrigger*)trigger;
                    
                    HistoryItemWrapper *expiredsurveyitemWrapper = [[HistoryItemWrapper alloc] init];
                    expiredsurveyitemWrapper.item = timetrigger;
                    expiredsurveyitemWrapper.timestamp = [timetrigger.activation_time dateByAddingTimeInterval:timetrigger.duration.longValue];
                    
                    [previousSurveys addObject:expiredsurveyitemWrapper];
                }
                else if([trigger isKindOfClass:[SpatialTrigger class]])
                {
                    SpatialTrigger *spacetrigger = (SpatialTrigger*)trigger;
                    
                    HistoryItemWrapper *expiredsurveyitemWrapper = [[HistoryItemWrapper alloc] init];
                    expiredsurveyitemWrapper.item = spacetrigger;
                    
                    if([spacetrigger.children anyObject])
                    {
                        Trigger *child = [spacetrigger.children anyObject];
                        if([child isKindOfClass:[TemporalTrigger class]])
                        {
                            TemporalTrigger *timechildtrigger = (TemporalTrigger*)child;
                            expiredsurveyitemWrapper.timestamp = [timechildtrigger.activation_time dateByAddingTimeInterval:timechildtrigger.duration.longValue];
                            
                            [previousSurveys addObject:expiredsurveyitemWrapper];
                        }
                    }
                }
            }
        }
        
        if(form.state.intValue == Active || form.state.intValue == Available)
        {
            [primedSurveys addObject:form];
        }
        else if(form.state.intValue == Completed || form.state.intValue == Expired || form.state.intValue == InActive)
        {
            
            ////NSLog(@"1");
            NSMutableArray *temporalTriggers = [[NSMutableArray alloc] init];
            for(Trigger *trigger in form.triggers)
            {
                ////NSLog(@"Trigger Class: %@",[TemporalTrigger class] );
                if([trigger isKindOfClass:[TemporalTrigger class]])
                {
                     ////NSLog(@"1a");
                    [temporalTriggers addObject:trigger];
                }
            }
            
            if(temporalTriggers.count > 0)
            {
                NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                                    sortDescriptorWithKey:@"activation_time"
                                                    ascending:NO];
                NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
                NSArray *sortedTriggersArray = [temporalTriggers
                                                sortedArrayUsingDescriptors:sortDescriptors];
                TemporalTrigger *lastTrigger = (TemporalTrigger*) [sortedTriggersArray objectAtIndex:0];
                HistoryItemWrapper *closedsurveyitemWrapper = [[HistoryItemWrapper alloc] init];
                closedsurveyitemWrapper.item = form;
                closedsurveyitemWrapper.timestamp = [lastTrigger.activation_time dateByAddingTimeInterval:lastTrigger.duration.longValue];
                [previousSurveys addObject:closedsurveyitemWrapper];
                
                  ////NSLog(@"2");
            }
        }
    }
    
    NSSortDescriptor *dateDescriptor2 = [NSSortDescriptor
                                        sortDescriptorWithKey:@"timestamp"
                                        ascending:NO];
    NSArray *sortDescriptors2 = [NSArray arrayWithObject:dateDescriptor2];
    NSArray *sortedHistoricItems = [previousSurveys
                                    sortedArrayUsingDescriptors:sortDescriptors2];
    previousSurveys = [sortedHistoricItems mutableCopy];
    
     ////NSLog(@"3");
    
     ////NSLog(@"previousSurveys count: %lu", (unsigned long)[previousSurveys count]);
     ////NSLog(@"primedSurveys count: %lu", (unsigned long)[primedSurveys count]);
     ////NSLog(@"availableSurveys count: %lu", (unsigned long)[availableSurveys count]);
    
    [self.surveylist reloadData];
    [self endRefresh];
    
}


-(void) endRefresh
{
    for(UIView *view in self.surveylist.subviews)
    {
        if([view isKindOfClass:[UIRefreshControl class]])
        {
            UIRefreshControl *refresher = (UIRefreshControl*) view;
            
            if(refresher.isRefreshing)
            {
                [refresher endRefreshing];
            }
        }
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
    return 35.0;
}
- (void)fliptosettings {
    
    for(SurveyForm *form in primedSurveys)
    {
        [form validateForm];
    }
    
    for(Trigger *trigger in availableSurveys)
    {
        SurveyForm *form = trigger.survey;
        [form validateForm];
    }
    
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    UITableViewController *settingsController = [storybord instantiateViewControllerWithIdentifier:@"settings"];
    settingsController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:settingsController animated:YES completion:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 35.0)];
    if(section == 0)
    {
        header.backgroundColor= [UIColor lightGrayColor];
        
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 120.0, 35.0)];
        container.backgroundColor= [UIColor darkGrayColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 120.0, 35.0)];
        label.textColor = [UIColor colorWithRed:208.0f / 255.0f green:208.0f / 255.0f blue:34.0f / 255.0f alpha:1];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font =[UIFont fontWithName:@"Futura-CondensedMedium" size:17.0]; //Futura Condensed Medium 20.0
        [container addSubview:label];
        [header addSubview:container];
        label.text = @"To-Do Surveys";
    }
    else if(section == 1)
    {
       
        header.backgroundColor= [UIColor lightGrayColor];
        
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 120.0, 35.0)];
        container.backgroundColor= [UIColor darkGrayColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 120.0, 35.0)];
        label.textColor = [UIColor colorWithRed:208.0f / 255.0f green:208.0f / 255.0f blue:34.0f / 255.0f alpha:1];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font =[UIFont fontWithName:@"Futura-CondensedMedium" size:17.0]; //Futura Condensed Medium 20.0
        [container addSubview:label];
        [header addSubview:container];
        label.text = @"Future Surveys";
    }
    else if(section == 2)
    {
       
        header.backgroundColor= [UIColor lightGrayColor];
        
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 120.0, 35.0)];
        container.backgroundColor= [UIColor darkGrayColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 120.0, 35.0)];
        label.textColor = [UIColor colorWithRed:208.0f / 255.0f green:208.0f / 255.0f blue:34.0f / 255.0f alpha:1];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font =[UIFont fontWithName:@"Futura-CondensedMedium" size:17.0]; //Futura Condensed Medium 20.0
        [container addSubview:label];
        [header addSubview:container];
        label.text = @"Survey History";
    }
    
    return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        if(availableSurveys.count == 0)
        {
            return 1;
        }
        return availableSurveys.count;
    }
    else if(section == 1)
    {
        if(primedSurveys.count == 0)
        {
            return 1;
        }
        return primedSurveys.count;
    }
    else
    {
        if(previousSurveys.count == 0)
        {
            return 1;
        }
        return previousSurveys.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StandardSurveyCell";
    StandardSurveyCell *tempCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (tempCell == nil)
    {
        tempCell = [[StandardSurveyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.section == 0)
    {
        if(availableSurveys.count == 0)
        {
            static NSString *CellIdentifier = @"Placeholder";
            UITableViewCell *placeholder = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (tempCell == nil)
            {
                placeholder = [[StandardSurveyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            return placeholder;
        }
        else
        {
            Trigger *associatedTrigger = [availableSurveys objectAtIndex:indexPath.row];
            SurveyForm *form = associatedTrigger.survey;
            tempCell.surveyName.text = form.title;
            [tempCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            tempCell.surveyType.image = [UIImage imageNamed:@"survey-incomplete.png"];
            tempCell.projectName.text = form.project.name;
            tempCell.surveyID.text = [NSString stringWithFormat:@"%@", form.identifier];
            
            if([associatedTrigger isKindOfClass:[SpatialTrigger class]])
            {
                SpatialTrigger *st = (SpatialTrigger*) associatedTrigger;
                NSDate *expiresAt = [DateTimeUtil adjustUTCtoLocalTimeZone:[st.lastTripTime dateByAddingTimeInterval:(20 * 60)]];
                tempCell.closingDate.text = [NSString stringWithFormat:@"Expires %@",[expiresAt timeAgo]];
            }
            else if([associatedTrigger isKindOfClass:[TemporalTrigger class]])
            {
                TemporalTrigger *temp = (TemporalTrigger*) associatedTrigger;
                
                NSDate *expiresAt = [DateTimeUtil adjustUTCtoLocalTimeZone:[[temp slidingActivationTime] dateByAddingTimeInterval:temp.duration.doubleValue]];
                tempCell.closingDate.text = [NSString stringWithFormat:@"Expires %@",[expiresAt timeAgo]];
            }
        }
    }
    else if(indexPath.section == 1)
    {
        if(primedSurveys.count == 0)
        {
            static NSString *CellIdentifier = @"Placeholder";
            UITableViewCell *placeholder = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (tempCell == nil)
            {
                placeholder = [[StandardSurveyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            return placeholder;
        }
        else
        {
            SurveyForm *form = [primedSurveys objectAtIndex:indexPath.row];
            tempCell.surveyName.text = form.title;
            [tempCell setAccessoryType:UITableViewCellAccessoryNone];
            tempCell.surveyType.image = [UIImage imageNamed:@"survey-active.png"];
            tempCell.projectName.text = form.project.name;
            tempCell.surveyID.text = [NSString stringWithFormat:@"%@", form.identifier];
            
            
            NSMutableArray *temporalTriggers = [[NSMutableArray alloc] init];
            NSMutableArray *spatialTriggers = [[NSMutableArray alloc] init];
            
            for(Trigger *trigger in form.triggers)
            {
                if([trigger isKindOfClass:[TemporalTrigger class]])
                {
                    [temporalTriggers addObject:trigger];
                }
                else if([trigger isKindOfClass:[SpatialTrigger class]])
                {
                    [spatialTriggers addObject:trigger];
                }
            }
            
            NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                                sortDescriptorWithKey:@"activation_time"
                                                ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
            NSArray *sortedTriggersArray = [temporalTriggers
                                            sortedArrayUsingDescriptors:sortDescriptors];
            
            BOOL timeLabelSet = FALSE;
            
            if(sortedTriggersArray.count > 0)
            {
                for(TemporalTrigger *temp in sortedTriggersArray)
                {
                    if(temp.state.intValue == Active)
                    {
                        timeLabelSet = TRUE;
                        
                        NSDate *expiresAt = [DateTimeUtil adjustUTCtoLocalTimeZone:[temp slidingActivationTime]];
                        tempCell.closingDate.text = [NSString stringWithFormat:@"Shown Next %@",[expiresAt timeAgo]];
                        break;
                        
                    }
                }
            }
            
            if(!timeLabelSet)
            {
                if(spatialTriggers.count > 0)
                {
                    SpatialTrigger *st = (SpatialTrigger*) [spatialTriggers objectAtIndex:0];
                    tempCell.closingDate.text = [NSString stringWithFormat:@"Survey shown when at %@",st.placename];
                }
            }
          
            
            /*for(Trigger *trigger in form.triggers)
            {
                if([trigger isKindOfClass:[SpatialTrigger class]])
                {
                    SpatialTrigger *st = (SpatialTrigger*) trigger;
                    tempCell.closingDate.text = [NSString stringWithFormat:@"Survey shown when at %@",st.placename];
                }
                else if([trigger isKindOfClass:[TemporalTrigger class]])
                {
                    TemporalTrigger *temp = (TemporalTrigger*) trigger;
                    NSDate *expiresAt = [DateTimeUtil adjustUTCtoLocalTimeZone:temp.activation_time];
                    tempCell.closingDate.text = [NSString stringWithFormat:@"Shown next %@",[expiresAt timeAgo]];
                }
            }*/
        }
    }
    else if(indexPath.section == 2)
    {
        if(previousSurveys.count == 0)
        {
            static NSString *CellIdentifier = @"Placeholder";
            UITableViewCell *placeholder = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (tempCell == nil)
            {
                placeholder = [[StandardSurveyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            return placeholder;
        }
        else
        {
            [tempCell setAccessoryType:UITableViewCellAccessoryNone];
            tempCell.surveyType.image = [UIImage imageNamed:@"survey-historic.png"];
            
            HistoryItemWrapper *historicSurveyWrapper = (HistoryItemWrapper*) [previousSurveys objectAtIndex:indexPath.row];
            
            NSObject *historicSurvey = historicSurveyWrapper.item;
            if([historicSurvey isKindOfClass:[FilledSurveyForm class]])
            {
                FilledSurveyForm *filledform = (FilledSurveyForm*) historicSurvey;
                
                NSDictionary *survey = [filledform toDictionary];
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:survey options:nil error:nil];
                NSString *jsonItemsAsString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                //////NSLog(@"%@", jsonItemsAsString);
                
                
                AppDelegate *ap = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                NSFetchRequest *projectReq = [[NSFetchRequest alloc] init];
                NSEntityDescription *entityform = [NSEntityDescription entityForName:@"SurveyForm" inManagedObjectContext:[ap managedObjectContext]];
                [projectReq setEntity:entityform];
                [projectReq setFetchLimit:1];
                
                
             
                //////NSLog(@"%@",filledform.form_identifier);
                
                NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"identifier == (%@)",filledform.form_identifier];
               
                [projectReq setPredicate:predicate1];
                NSError *error;
                NSArray *projects = [[ap managedObjectContext] executeFetchRequest:projectReq error:&error];
                SurveyForm *form = [projects objectAtIndex:0];
                tempCell.projectName.text = form.project.name;
                tempCell.surveyName.text = form.title;
                tempCell.surveyID.text = [NSString stringWithFormat:@"%@", form.identifier];
                
                if([filledform.not_filled boolValue])
                {
                    tempCell.closingDate.text = [NSString stringWithFormat:@"Completed (%@)",[[DateTimeUtil adjustUTCtoLocalTimeZone:filledform.completed] timeAgo]];
                }
            }
            else if([historicSurvey isKindOfClass:[SurveyForm class]])
            {
                SurveyForm *form = (SurveyForm*) historicSurvey;
                tempCell.projectName.text = form.project.name;
                tempCell.surveyName.text = form.title;
                tempCell.surveyID.text = [NSString stringWithFormat:@"%@", form.identifier];
                
                tempCell.closingDate.text = [NSString stringWithFormat:@"Has Ended"];// (%@)",[[DateTimeUtil adjustUTCtoLocalTimeZone:historicSurveyWrapper.timestamp] timeAgo]];
            }
            else if([historicSurvey isKindOfClass:[Trigger class]])
            {
                Trigger *trigger = (Trigger*) historicSurvey;
                SurveyForm *form = (SurveyForm*) trigger.survey;
                
                tempCell.projectName.text = form.project.name;
                tempCell.surveyName.text = form.title;
                tempCell.surveyID.text = [NSString stringWithFormat:@"%@", form.identifier];
                tempCell.closingDate.text = [NSString stringWithFormat:@"This survey was made available for completion %@ but you didnt complete it in.",[[DateTimeUtil adjustUTCtoLocalTimeZone:historicSurveyWrapper.timestamp] timeAgo]];
            }
        }
    }
    
    //tempCell.contentView.backgroundColor = [UIColor darkGrayColor];
    
    return tempCell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(availableSurveys.count == 0)
        {
            return 30;
        }
        return 108;
    }
    else if(indexPath.section == 1)
    {
        if(primedSurveys.count == 0)
        {
            return 30;
        }
        return 108;
    }
    else
    {
        if(previousSurveys.count == 0)
        {
            return 30;
        }
        return 108;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        [self refreshSurveyListings];
        ////NSLog(@"didSelectRowAtIndexPath");
        if(availableSurveys.count > 0)
        {
            Trigger *trigger = [availableSurveys objectAtIndex:indexPath.row];
            SurveyForm *form = trigger.survey;
            [self displaySurveyForm:form forTrigger:trigger.identifier];
        }
        else
        {
            [[AlertsManager getInstance] surveyExpiredAlready];
        }
        
        /*NSNumber *num = nil;
        
        if(form.project.studyType.intValue == StimulusProject)
        {
            AppDelegate *appDel = (AppDelegate*) [[UIApplication sharedApplication] delegate];
            NSFetchRequest *fetchSurveyRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entityform = [NSEntityDescription entityForName:@"FilledStimulusSurveyForm" inManagedObjectContext:[appDel managedObjectContext]];
            [fetchSurveyRequest setEntity:entityform];
            [fetchSurveyRequest setFetchLimit:1];
            
            NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"form_identifier == %@",form.identifier];
            [fetchSurveyRequest setPredicate:predicate1];
            NSError *error;
            NSArray *filledforms = [[appDel managedObjectContext] executeFetchRequest:fetchSurveyRequest error:&error];
            
            if(filledforms.count > 0)
            {
                FilledStimulusSurveyForm *filledform = (FilledStimulusSurveyForm*) [filledforms objectAtIndex:0];
                num = filledform.displayed;
            }
        }*/
        
        
    }
    /*else if(indexPath.section == 1)
    {
        SurveyForm *form = [primedSurveys objectAtIndex:indexPath.row];
        [self displaySurveyForm:form];
    }
    else if(indexPath.section == 2)
    {
        FilledSurveyForm *form = [previousSurveys objectAtIndex:indexPath.row];
    }*/
}

-(void)displaySurveyForm:(SurveyForm*)form forTrigger:(NSString*)triggerID
{
    
    ////NSLog(@"displaySurveyForm");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([[defaults objectForKey:@"isWorkingWithSurvey"] boolValue] != YES)
    {
        //[defaults setBool:YES forKey:@"isWorkingWithSurvey"];
        //[defaults synchronize];

        if([[defaults objectForKey:@"has_registered"] boolValue] != NO)
        {    
            BOOL modalPresent = (BOOL)(self.presentedViewController);
            if(!modalPresent)
            {
                UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
                SurveyViewController *formController = [storybord instantiateViewControllerWithIdentifier:@"form"];
                
                if(form.project.studyType.intValue == StimulusProject)
                {
                    //TemporalTrigger *trig = (TemporalTrigger*) [[form.triggers allObjects] objectAtIndex:0];
                    //[form validateForm];
                    
                    AppDelegate *appDel = (AppDelegate*) [[UIApplication sharedApplication] delegate];
                    NSFetchRequest *fetchSurveyRequest = [[NSFetchRequest alloc] init];
                    NSEntityDescription *entityform = [NSEntityDescription entityForName:@"FilledStimulusSurveyForm" inManagedObjectContext:[appDel managedObjectContext]];
                    [fetchSurveyRequest setEntity:entityform];
                    [fetchSurveyRequest setFetchLimit:1];
                    
                    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"form_identifier == %@",form.identifier];
                    [fetchSurveyRequest setPredicate:predicate1];
                    NSError *error;
                    NSArray *filledforms = [[appDel managedObjectContext] executeFetchRequest:fetchSurveyRequest error:&error];
                    
                    if(filledforms.count > 0)
                    {
                        FilledStimulusSurveyForm *filledform = (FilledStimulusSurveyForm*) [filledforms objectAtIndex:0];
                        ////NSLog(@"displaySurveyForm Show Question %d", filledform.displayed.intValue);
                        
                        if(filledform.displayed.intValue > -1)
                        {
                            formController.questionToDisplay = filledform.displayed;
                            formController.surveyForm = form;
                            formController.triggerID = triggerID;
                            formController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                            [self presentViewController:formController animated:YES completion:nil];
                        }
                        else
                        {
                            [[AlertsManager getInstance] surveyExpiredAlready];
                        }
                    }
                    
                    [appDel dirtyMOCSave];
                }
                else
                {
                    formController.surveyForm = form;
                    formController.triggerID = triggerID;
                    formController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    [self presentViewController:formController animated:YES completion:nil];
                }
            }
        }
    }
}


@end
