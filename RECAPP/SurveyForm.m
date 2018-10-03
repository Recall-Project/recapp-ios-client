//
//  SurveyForm.m
//  RECAPP
//
//  Created by RECAPP Developer on 10/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import "SurveyForm.h"
#import "Project.h"
#import "SurveyQuestion.h"
#import "Trigger.h"
#import "AppDelegate.h"
#import "FilledSurveyForm.h"
#import "CurrentUser.h"
#import "SpatialTrigger.h"
#import "TemporalTrigger.h"
#import "SurveyQuestion.h"
#import "Guid.h"
#import "SurveyLikertQuestion.h"
#import "SurveyMultiOptionQuestion.h"
#import "LikertOption.h"
#import "MultiOption.h"
#import "FilledStimulusSurveyForm.h"
#import "RecallQuestion.h"
#import "StimulusQuestion.h"

@implementation SurveyForm

@dynamic identifier;
@dynamic state;
@dynamic project;
@dynamic questions;
@dynamic triggers;
@dynamic title;


-(void) activateForm
{
    ////NSLog(@"activateform");
    //if(self.state.intValue == InActive)
    //{
    
    int triggersExpired = 0;
    int triggersAvailable = 0;
    int triggersCompleted = 0;
    int triggersActive = 0;
    
        for(Trigger *child in self.triggers)
        {
            [child activateTrigger]; //setups underlying notifications and checks trigger in current context
            if(child.state.intValue == Expired)
            {
                triggersExpired++;
            }
            else if(child.state.intValue == Available)
            {
                triggersAvailable++;
            }
            else if(child.state.intValue == Completed)
            {
                triggersCompleted++;
            }
            else if(child.state.intValue == Active)
            {
                triggersActive++;
            }
        }
    //}
    
    if(triggersExpired == self.triggers.count)
    {
        self.state = [NSNumber numberWithInt:Expired];
    }
    else if(triggersCompleted == self.triggers.count)
    {
        self.state = [NSNumber numberWithInt:Completed];
    }
    else if(triggersAvailable > 0)
    {
        self.state = [NSNumber numberWithInt:Available];
    }
    else if(triggersActive > 0)
    {
        self.state = [NSNumber numberWithInt:Active];
    }
    else
    {
        self.state = [NSNumber numberWithInt:InActive];
    }
    
    [(AppDelegate*)[UIApplication sharedApplication].delegate dirtyMOCSave];
}

-(void) disableForm
{
    for(Trigger *trigger in self.triggers)
    {
        [trigger disableTrigger];
    }
}

-(void) validateForm
{
    int triggersExpired = 0;
    int triggersAvailable = 0;
    int triggersCompleted = 0;
    int triggersActive = 0;
    
    for(Trigger *child in self.triggers)
    {
        [child validateTrigger];
        if(child.state.intValue == Expired)
        {
            triggersExpired++;
        }
        else if(child.state.intValue == Available)
        {
            triggersAvailable++;
        }
        else if(child.state.intValue == Completed)
        {
            triggersCompleted++;
        }
        else if(child.state.intValue == Active)
        {
            triggersActive++;
        }
    }
    
    if(triggersExpired == self.triggers.count)
    {
        self.state = [NSNumber numberWithInt:Expired];
    }
    else if(triggersCompleted == self.triggers.count)
    {
        self.state = [NSNumber numberWithInt:Completed];
    }
    else if(triggersAvailable > 0)
    {
        self.state = [NSNumber numberWithInt:Available];
    }
    else if(triggersActive > 0)
    {
        self.state = [NSNumber numberWithInt:Active];
    }
    else
    {
        self.state = [NSNumber numberWithInt:InActive];
    }
    
    [(AppDelegate*)[UIApplication sharedApplication].delegate dirtyMOCSave];
}



-(void)updateformState
{
    
}


-(void) saveSurvey:(NSArray*)qnas forTrigger:(NSString*)triggerID
{
    AppDelegate *ap = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    FilledSurveyForm *filledForm = nil;
    
    if(self.project.studyType.intValue == StimulusProject)
    {
        NSFetchRequest *fetchSurveyRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityform = [NSEntityDescription entityForName:@"FilledStimulusSurveyForm" inManagedObjectContext:[ap managedObjectContext]];
        [fetchSurveyRequest setEntity:entityform];
        [fetchSurveyRequest setFetchLimit:1];
        
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"form_identifier == %@",self.identifier];
        [fetchSurveyRequest setPredicate:predicate1];
        NSError *error;
        NSArray *filledforms = [[ap managedObjectContext] executeFetchRequest:fetchSurveyRequest error:&error];
        
        if(filledforms.count > 0)
        {
            filledForm = (FilledStimulusSurveyForm*) [filledforms objectAtIndex:0];
            SurveyQuestion *q = (SurveyQuestion*) [qnas objectAtIndex:0];
            
            
            if([q isKindOfClass:[StimulusQuestion class]])
            {
                StimulusQuestion *old_likert = (StimulusQuestion *) q;
                StimulusQuestion *new_likert = NULL;
                
                BOOL doesExist = FALSE;
                for(SurveyQuestion *question in filledForm.completed_questions)
                {
                    if([old_likert.identifier isEqualToString:question.identifier])
                    {
                        doesExist = TRUE;
                        new_likert =(StimulusQuestion *) question;
                        break;
                    }
                }
                
                if(!doesExist)
                {
                    new_likert = [NSEntityDescription insertNewObjectForEntityForName:@"StimulusQuestion" inManagedObjectContext:[ap managedObjectContext]];
                    NSMutableSet *new_options = [NSMutableSet set];
                    for(LikertOption * old_opt in old_likert.options)
                    {
                        LikertOption *new_opt = [NSEntityDescription insertNewObjectForEntityForName:@"LikertOption" inManagedObjectContext:[ap managedObjectContext]];
                        new_opt.value = [old_opt.value copy];
                        new_opt.question = new_likert;
                        
                        [new_options addObject:new_opt];
                        
                    }
                
                    [new_likert setOptions:new_options];
                    
                    LikertOption *answerObj = NULL;
                    answerObj = [NSEntityDescription insertNewObjectForEntityForName:@"LikertOption" inManagedObjectContext:[ap managedObjectContext]];
                    answerObj.value = [NSNumber numberWithInt:0];
                    answerObj.question = new_likert;
                    
                    new_likert.answer = answerObj;
                }
                
                ////NSLog(@"Original q optipns: %lu", (unsigned long)old_likert.options.count);
                
                new_likert.question = [old_likert.question copy];
                new_likert.low_end_descriptor = [old_likert.low_end_descriptor copy];
                new_likert.high_end_descriptor = [old_likert.high_end_descriptor copy];
                new_likert.identifier = [old_likert.identifier copy];
                new_likert.ordinal = [old_likert.ordinal copy];
                new_likert.completed = [NSDate date];
                
                if(new_likert.answer)
                {
                    new_likert.answer.value = [NSNumber numberWithInt:0];
                }
                
                if(old_likert.answer)
                {
                    new_likert.answer.value = [old_likert.answer.value copy];
                }
             
                [filledForm addCompleted_questionsObject:new_likert];
            }
            else
            {
                filledForm.completed = [NSDate date];
                //filledForm.form_identifier = [self.identifier copy];
                //filledForm.identifier = [[Guid getInstance] newGuid];
                filledForm.not_filled = [NSNumber numberWithShort:1];
                filledForm.sync = @"1";
                for(Trigger *trig in self.triggers)
                {
                    if([trig.identifier isEqualToString:triggerID])
                    {
                        [trig completeTrigger];
                    }
                }
            }
        }
    }
    else
    {
        filledForm = (FilledSurveyForm *)[NSEntityDescription insertNewObjectForEntityForName:@"FilledSurveyForm" inManagedObjectContext:[ap managedObjectContext]];
        
        for(SurveyQuestion *question in qnas)
        {
            if([question isKindOfClass:[SurveyLikertQuestion class]])
            {
                SurveyLikertQuestion *old_likert = (SurveyLikertQuestion *) question;
                SurveyLikertQuestion *new_likert = [NSEntityDescription insertNewObjectForEntityForName:@"SurveyLikertQuestion" inManagedObjectContext:[ap managedObjectContext]];
                new_likert.question = [old_likert.question copy];
                new_likert.low_end_descriptor = [old_likert.low_end_descriptor copy];
                new_likert.high_end_descriptor = [old_likert.high_end_descriptor copy];
                new_likert.identifier = [old_likert.identifier copy];
                new_likert.ordinal = [old_likert.ordinal copy];
                [new_likert setOptions:old_likert.options];
                new_likert.answer = old_likert.answer;
                [filledForm addCompleted_questionsObject:new_likert];
                
            }
            else if([question isKindOfClass:[SurveyMultiOptionQuestion class]])
            {
                SurveyMultiOptionQuestion *old_opt = (SurveyMultiOptionQuestion *) question;
                SurveyMultiOptionQuestion *new_opt = [NSEntityDescription insertNewObjectForEntityForName:@"SurveyMultiOptionQuestion" inManagedObjectContext:[ap managedObjectContext]];
                new_opt.question = [question.question copy];
                [new_opt setOptions:old_opt.options];
                new_opt.answer = old_opt.answer;
                new_opt.identifier = [old_opt.identifier copy];
                new_opt.ordinal = [old_opt.ordinal copy];
                [filledForm addCompleted_questionsObject:new_opt];
            }
        }
        
        ////////NSLog(@"%d", filledForm.completed_questions.count);
        filledForm.completed = [NSDate date];
        
        
        filledForm.form_identifier = [self.identifier copy];
        //NSLog(@"%@",self.title);
        filledForm.form_name = [self.title copy];
        filledForm.identifier = [[Guid getInstance] newGuid];
        filledForm.not_filled = [NSNumber numberWithShort:1];
        filledForm.sync = @"1";
        
        for(Trigger *trig in self.triggers)
        {
            if([trig.identifier isEqualToString:triggerID])
            {
                [trig completeTrigger];
            }
        }
    }
    
    User *user = [[CurrentUser getInstance] getUser];
    filledForm.user_identifier = user.identifier;
    
 
    [ap dirtyMOCSave];
    

    [self validateForm];
   
}

@end
