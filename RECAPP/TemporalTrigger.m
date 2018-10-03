//
//  TemporalTrigger.m
//  RECAPP
//
//  Created by RECAPP Developer on 07/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import "TemporalTrigger.h"
#import "SurveyForm.h"
#import "AppDelegate.h"
#import "Project.h"
#import "SurveyForm.h"
#import "SurveyQuestion.h"
#import "FilledStimulusSurveyForm.h"
#import "StimulusQuestion.h"
#import "LikertOption.h"

@implementation TemporalTrigger

@dynamic activation_time;
@dynamic display_rate;
@dynamic duration;
@dynamic interval;

-(void)activateTrigger
{
    //////NSLog(@"%@  %d", self.activation_time,self.state.intValue );
    
    NSLog(@"%lu",[[UIApplication sharedApplication] scheduledLocalNotifications].count);
    
    if(self.state.intValue == InActive || self.state.intValue == Active)
    {
        NSDate *now = [NSDate date];
        //////////NSLog(@"now:%@ activation:%@", now, self.activation_time);
        
        long maxDuration = self.duration.longValue;
        
        if([self.survey.project.studyType intValue] == StimulusProject)
        {
            maxDuration = (long) self.survey.questions.count * [self intervalCodeInSeconds:self.interval];
        }
        
        if([now compare:[self.activation_time dateByAddingTimeInterval:maxDuration]] == NSOrderedAscending)
        {
            
            if([self.survey.project.studyType intValue] == StimulusProject)
            {
                //loop and create notifications for each stimulus + recall question
                
                long intervalSecs = [self intervalCodeInSeconds:self.interval];
                
                
                NSArray *sortedQuestions = [[NSArray alloc] initWithArray:[self.survey.questions sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"ordinal" ascending:YES]]]];
                

                int i = 0;
                
                ////NSLog(@"%lul",(unsigned long)sortedQuestions.count);
                
                for(SurveyQuestion *q in sortedQuestions)
                {
                    
                    
                    NSDictionary *stimDict = [NSDictionary dictionaryWithObjectsAndKeys:self.survey.identifier, @"survey-form-id",
                                              self.identifier, @"survey-trigger-id",q.ordinal, @"survey-question-ordinal", q.identifier, @"survey-question-id", nil];
                    
                    
                    ////NSLog(@"Trial:%@ Process Trigger Question(%@) pos:%d", self.survey.title, q.identifier ,q.ordinal.intValue);
                    
                    NSDate *adjustedTime = [self.activation_time dateByAddingTimeInterval:(intervalSecs * i)];
                    
                    NSDate *registrationWindow = [now dateByAddingTimeInterval:(60 * 60 * 24)];
                    
                    //NSLog(@"Now:%@", now);
                    //NSLog(@"Adjusted:%@", adjustedTime);
                    //NSLog(@"Window End:%@", registrationWindow);
                    
                    for(UILocalNotification *notify in [[UIApplication sharedApplication] scheduledLocalNotifications])
                    {
                        if([[notify.userInfo objectForKey:@"survey-form-id"] isEqualToString:self.survey.identifier] &&
                           [[notify.userInfo objectForKey:@"survey-trigger-id"] isEqualToString:self.identifier] &&
                           [[notify.userInfo objectForKey:@"survey-question-ordinal"] isEqualToNumber:q.ordinal])
                        {
                            [[UIApplication sharedApplication] cancelLocalNotification:notify];
                            
                        }
                    }
                    
                    if([now compare:adjustedTime] == NSOrderedAscending && [adjustedTime compare:registrationWindow] == NSOrderedAscending)
                    {
                    
                        [self scheduleNotification:adjustedTime withMessage:@"A stimulus question is now available" withActionLabel:@"View Stimulus" withUserInfo:stimDict];
                    }
                    
                    i++;
                }
            }
            else
            {
                NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:self.survey.identifier, @"survey-form-id",
                                          self.identifier, @"survey-trigger-id",                                       nil];
                [self scheduleNotification:self.activation_time withMessage:@"A survey is available for you to complete" withActionLabel:@"View Survey" withUserInfo:infoDict];
                [self scheduleNotification:[self.activation_time dateByAddingTimeInterval:(self.duration.longValue / 2)] withMessage:@"Reminder that a survey is available for you to complete" withActionLabel:@"View Survey" withUserInfo:infoDict];
            }
            
            self.state = [NSNumber numberWithShort:Active];
        }
        else
        {
    
            self.state = [NSNumber numberWithShort:Expired];
        }
    }
}

-(void) scheduleNotification:(NSDate *) displayTime withMessage:(NSString *) msg withActionLabel:(NSString*) label withUserInfo:(NSDictionary*) dict
{
    UILocalNotification *primaryNotification = [[UILocalNotification alloc] init];
    primaryNotification.fireDate = displayTime;
    primaryNotification.alertBody = msg;
    primaryNotification.alertAction = label;
    primaryNotification.userInfo = dict;
    primaryNotification.timeZone = [NSTimeZone defaultTimeZone];
    primaryNotification.repeatInterval = 0;
     primaryNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:primaryNotification];
    
    //////NSLog(@"Scheduled Notification for Survey:%@ triggering at %@",self.survey.identifier, displayTime);
    
    NSNumber *num = [dict objectForKey:@"survey-question-ordinal"];
    
    //////NSLog(@"Trial:%@ Process Trigger Question(%@) pos:%d triggerTime:%@", self.survey.title, [dict objectForKey:@"survey-question-id"], num.intValue, displayTime);
}



-(long) intervalCodeInSeconds:(NSNumber*) intervalCode
{
    
    switch ([intervalCode intValue]) {
        case 1:
            return (60 * 60);
        case 2:
            return (60 * 60 * 24);
        case 3:
            return (60 * 60 * 24 * 7);
        case 4:
            return 60;
        case 5:
            return 30;
        default:
            return 0;
    }
}


-(void)disableTrigger
{
    NSMutableArray *notifications = [[NSMutableArray alloc] init];
    for(UILocalNotification *notify in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        if([[notify.userInfo objectForKey:@"survey-form-id"] isEqualToString:self.survey.identifier] &&
           [[notify.userInfo objectForKey:@"survey-trigger-id"] isEqualToString:self.identifier])
        {
            [notifications addObject:notify];
            
            //////NSLog(@"Disable Notification for Survey:%@", self.survey.title);
        }
    }
    
    for(UILocalNotification *not in notifications)
    {
        //NSNumber *num = [not.userInfo objectForKey:@"survey-question-ordinal"];
        //////NSLog(@"Trial:%@ Removing QuestionTrigger (%@) pos:%d", self.survey.title, [not.userInfo objectForKey:@"survey-question-id"], num.intValue);
        [[UIApplication sharedApplication] cancelLocalNotification:not];
    }
    
}

BOOL isRefreshing = NO;

-(void)refresh
{
    isRefreshing = YES;
    if(self.state.intValue != Available)
    {
        [self disableTrigger];
    }
    
    [self validateTrigger];
    [self activateTrigger];
    isRefreshing = NO;
}


-(void)completeTrigger
{
    self.state = [NSNumber numberWithShort:Completed];
    [self disableTrigger];
}



-(NSDate*) slidingActivationTime
{
    if([self.survey.project.studyType intValue] == StimulusProject)
    {
        long intervalSecs = [self intervalCodeInSeconds:self.interval];
         NSDate *now = [NSDate date];
        int i = 0;
        while(i < self.survey.questions.count)
        {
            NSDate *adjustedTime = [self.activation_time dateByAddingTimeInterval:(intervalSecs * i)];
            
            if([now compare:adjustedTime] == NSOrderedAscending)
            {
                //now is earlier than this scheduled activation time for this question
                return adjustedTime;
            }
            i++;
        }
    }
    
    return self.activation_time;
}



-(void)validateTrigger
{
    ////NSLog(@"Validating trigger...");
    if(self.state.intValue != Completed)
    {
        NSDate *now = [NSDate date];
        
        ////NSLog(@"Current Time:%@  End Time: %@",now, [self.activation_time dateByAddingTimeInterval:self.duration.longValue]);
        
        
        if([self.survey.project.studyType intValue] == StimulusProject)
        {
            long intervalSecs = [self intervalCodeInSeconds:self.interval];
            
              NSArray *sortedQuestions = [[NSArray alloc] initWithArray:[self.survey.questions sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"ordinal" ascending:YES]]]];
            
            
            AppDelegate *ap = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            NSFetchRequest *fetchSurveyRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entityform = [NSEntityDescription entityForName:@"FilledStimulusSurveyForm" inManagedObjectContext:[ap managedObjectContext]];
            [fetchSurveyRequest setEntity:entityform];
            [fetchSurveyRequest setFetchLimit:1];
            NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"form_identifier == %@",self.survey.identifier];
            [fetchSurveyRequest setPredicate:predicate1];
            NSError *error;
            NSArray *filledforms = [[ap managedObjectContext] executeFetchRequest:fetchSurveyRequest error:&error];
            
            if(filledforms.count > 0)
            {
                FilledStimulusSurveyForm *filledForm = (FilledStimulusSurveyForm*) [filledforms objectAtIndex:0];
                ////NSLog(@"%lu",(unsigned long)filledForm.completed_questions.count);
                
                filledForm.displayed = [NSNumber numberWithInt:-1];
                
                int i = 0;
                while(i < sortedQuestions.count)
                {
                    NSDate *adjustedTime = [self.activation_time dateByAddingTimeInterval:(intervalSecs * i)];
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    ////NSLog(@"NOW: %@",[formatter stringFromDate:now]);
                    ////NSLog(@"SURVEY: %@",[formatter stringFromDate:adjustedTime]);
                    
                    if([now compare:[adjustedTime dateByAddingTimeInterval:self.duration.longValue]] == NSOrderedAscending
                       && [now compare:adjustedTime] == NSOrderedDescending)
                    {
                        SurveyQuestion *avail_question = [sortedQuestions objectAtIndex:i];
                    
        
                        ////NSLog(@"Question Number:%d",i);
                        
                        if([avail_question isKindOfClass:[StimulusQuestion class]])
                        {
                            bool isAvailable = true;
                            
                            NSArray *completed_q_array = [filledForm.completed_questions allObjects];
                            
                            ////NSLog(@"%lu",(unsigned long)completed_q_array.count);
                            
                            for(SurveyQuestion* completed_q in completed_q_array)
                            {
                                StimulusQuestion *stimQ = (StimulusQuestion*) completed_q;
                                if([completed_q.identifier isEqualToString:avail_question.identifier] && stimQ.answer.value.intValue > 0)
                                {
                                    isAvailable = false;
                                }
                            }
                            
                            if(isAvailable)
                            {
                                //not answered the question yet
                                self.state = [NSNumber numberWithShort:Available];
                                filledForm.displayed = [NSNumber numberWithInt:i];
                                break;
                            }
                            else
                            {
                                self.state = [NSNumber numberWithShort:Active];
                                break;
                            }
                        }
                        else
                        {
                            self.state = [NSNumber numberWithShort:Available];
                            
                            filledForm.displayed = [NSNumber numberWithInt:i];
                            break;
                        }
                        
                        
                        
                    }
                    else if([now compare:[adjustedTime dateByAddingTimeInterval:intervalSecs]] == NSOrderedAscending
                            && [now compare:[adjustedTime dateByAddingTimeInterval:self.duration.longValue]] == NSOrderedDescending)
                    {
                        self.state = [NSNumber numberWithShort:Active];
                        break;
                    }
                    
                    i++;
                }
                
                
                
                //provide 5 mins to complete
                if([now compare:[self.activation_time dateByAddingTimeInterval:(intervalSecs * self.survey.questions.count) + (60 * 10)]] == NSOrderedDescending)
                {
                
                    self.state = [NSNumber numberWithShort:Expired];
                }
            }
            
            [ap dirtyMOCSave];
        }
        else
        {
            if([now compare:[self.activation_time dateByAddingTimeInterval:self.duration.longValue]] == NSOrderedAscending
               && [now compare:self.activation_time] == NSOrderedDescending)
            {
                self.state = [NSNumber numberWithShort:Available];
            }
            else
            {
                if([now compare:[self.activation_time dateByAddingTimeInterval:self.duration.longValue]] == NSOrderedDescending)
                {
                    self.state = [NSNumber numberWithShort:Expired];
                }
                else
                {
                    self.state = [NSNumber numberWithShort:Active];
                }
            }
        }
    }
}

@end
