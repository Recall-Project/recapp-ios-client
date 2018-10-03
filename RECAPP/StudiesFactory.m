//
//  StudiesFactory.m
//  RECAPP
//
//  Created by RECAPP Developer on 07/06/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import "StudiesFactory.h"
#import "Project.h"
#import "AppDelegate.h"
#import "Project.h"
#import "SurveyForm.h"
#import "Trigger.h"
#import "TemporalTrigger.h"
#import "SpatialTrigger.h"
#import "FilledStimulusSurveyForm.h"
#import "Guid.h"
#import "StimulusSurveyForm.h"
#import "StimulusQuestion.h"
#import "LikertOption.h"

@implementation StudiesFactory

@synthesize managedObjectContext, sharedpersistentStoreCoordinator, studiesJSON;


-(id)initWithData:(NSData *)studies
{
    if (self = [super init])
    {
        studiesJSON = [studies copy];
        
        ////NSLog(@"factory1");
        NSString *newStr = [[NSString alloc] initWithData:studiesJSON encoding:NSUTF8StringEncoding];
        ////NSLog(@"%@", newStr);
        AppDelegate *del = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        sharedpersistentStoreCoordinator = [del persistentStoreCoordinator];
    }
    return self;
}

-(void)main
{
    __block BOOL isWorkingWithSurvey = NO;
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
       isWorkingWithSurvey = [defaults boolForKey:@"isWorkingWithSurvey"];
    });
    
    ////NSLog(@"factory2");
    if(!isWorkingWithSurvey)
    {
         ////NSLog(@"factory2");
        NSAssert([self sharedpersistentStoreCoordinator], @"PSC is nil");
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [self.managedObjectContext setUndoManager:nil];
        [self.managedObjectContext setPersistentStoreCoordinator:[self sharedpersistentStoreCoordinator]];
        
        NSArray *studies = [NSJSONSerialization JSONObjectWithData:studiesJSON options:NSJSONReadingMutableContainers error:nil];
        //NSString *jsonItemsAsString = [[NSString alloc] initWithData:studiesJSON encoding:NSUTF8StringEncoding];
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entityDesc];
        NSError *error;
        NSArray *existingStudies = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        ////NSLog(@"ERE");
 
        for(NSDictionary *study in studies)
        {
            
            NSError * err;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:study options:0 error:&err];
            NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            //NSLog(@"%@",myString);
            
            BOOL isExists = NO;
            NSString *studyID = [study objectForKey:@"identifier"];
            Project *purgedProject = nil;
            
            for(Project *project in existingStudies)
            {
                if([studyID isEqualToString:project.identifier])
                {
                    purgedProject = project;
                    isExists = YES;
                    break;
                }
            }
            
        
           // ////NSLog(@"Dictionary: %@", [study description]);
            
            /**for(NSMutableDictionary *survey in [study objectForKey:@"surveys"])
            {
                NSMutableDictionary *questions = [survey objectForKey:@"questions"];
                
                for(NSMutableDictionary *question in questions)
                {
                    if([[question objectForKey:@"ordinal"] isKindOfClass:[NSString class]])
                    {
                        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
                        NSNumber *myNumber = [formatter numberFromString:[question objectForKey:@"ordinal"]];
                        
                        ////NSLog(@"ordinal is string: %@", [question objectForKey:@"ordinal"]);
                        [question setObject:myNumber forKey:@"ordinal"];
                        
                        if([[question objectForKey:@"ordinal"] isKindOfClass:[NSNumber class]])
                        {
                             ////NSLog(@"ordinal is converted to int: %@", [question objectForKey:@"ordinal"]);
                        }
                    }
                }
            }**/
            
            //////NSLog(@"Surveys: %@", [study objectForKey:@"surveys"]);
            
            
            ////NSLog(@"%@",study);
            //NSLog(@"---");
            //NSLog(@"---");
            //NSLog(@"---");
            //NSLog(@"---");
            
      
            
        
            Project *newProject = (Project*)[Project createManagedObjectFromDictionary:study inContext:self.managedObjectContext];
            
            if([[study objectForKey:@"type"] isEqualToString:@"StimulusStudy"])
            {
                newProject.studyType = [NSNumber numberWithShort:StimulusProject];
                
                for (SurveyForm *form in newProject.surveys)
                {
                    FilledStimulusSurveyForm *stimulusEntryForm = (FilledStimulusSurveyForm *)[NSEntityDescription insertNewObjectForEntityForName:@"FilledStimulusSurveyForm" inManagedObjectContext:self.managedObjectContext];
                    
                    //NSLog(@"%@",form.title);
                    stimulusEntryForm.form_identifier = form.identifier;
                    stimulusEntryForm.form_name = form.title;
                    stimulusEntryForm.identifier = [[Guid getInstance] newGuid];
                    stimulusEntryForm.not_filled = [NSNumber numberWithShort:0];
                    stimulusEntryForm.sync = @"0";
                    
                    
                    
                    StimulusSurveyForm *StimulusTemplateForm = (StimulusSurveyForm*) form;
                    
                    for(SurveyQuestion * q in StimulusTemplateForm.questions)
                    {
                        if([q isKindOfClass:[StimulusQuestion class]])
                        {
                            StimulusQuestion *template_q = (StimulusQuestion *) q;
                            StimulusQuestion *copy_q = NULL;
                            
                            //NSLog(@"A");
                            copy_q = [NSEntityDescription insertNewObjectForEntityForName:@"StimulusQuestion" inManagedObjectContext:self.managedObjectContext];
                             //NSLog(@"B");
                            copy_q.question = [template_q.question copy];
                            copy_q.low_end_descriptor = [template_q.low_end_descriptor copy];
                            copy_q.high_end_descriptor = [template_q.high_end_descriptor copy];
                            copy_q.identifier = [template_q.identifier copy];
                            
                            ////NSLog(@"Before: ordinal is %d", [template_q.ordinal intValue]);
                            
                           
                        
                            copy_q.ordinal = [template_q.ordinal copy];
                            ////NSLog(@"After: ordinal is %d", [copy_q.ordinal intValue]);
                            
                            copy_q.completed = [NSDate date];
                            
            
                            NSMutableSet *new_options = [NSMutableSet set];
                            for(LikertOption * temp_opt in template_q.options)
                            {
                                //NSLog(@"c");
                                LikertOption *new_opt = [NSEntityDescription insertNewObjectForEntityForName:@"LikertOption" inManagedObjectContext:self.managedObjectContext];
                                //NSLog(@"D");
                                new_opt.value = [temp_opt.value copy];
                                new_opt.question = copy_q;
                                
                                [new_options addObject:new_opt];
                            }
                            [copy_q setOptions:new_options];
                            
                            LikertOption *answerObj = NULL;
                            if(!template_q.answer)
                            {
                                 //NSLog(@"E");
                                answerObj = [NSEntityDescription insertNewObjectForEntityForName:@"LikertOption" inManagedObjectContext:self.managedObjectContext];
                                answerObj.value = [NSNumber numberWithInt:-1];
                                //NSLog(@"F");
                                answerObj.question = copy_q;
                            }
                            else
                            {
                                answerObj.value = [template_q.answer.value copy];
                                answerObj.question = copy_q;
                            }
                            
                            copy_q.answer = answerObj;
                            [stimulusEntryForm addCompleted_questionsObject:copy_q];
                        }
                    }
                }
            }
            else
            {
                newProject.studyType = [NSNumber numberWithShort:ExperienceProject];
            }
            
                //NSLog(@"G");
            //NSDictionary *projDic = [newProject toDictionary];
            //NSData *jd = [NSJSONSerialization dataWithJSONObject:projDic options:nil error:nil];
            //NSString *jsonItemsAsString = [[NSString alloc] initWithData:jd encoding:NSUTF8StringEncoding];
            //////NSLog(@"%@", jsonItemsAsString);
            
            //NSLog(@"H");
            
        
            if(isExists)
            {
                for(SurveyForm *newForm in [newProject.surveys allObjects])
                {
                    for(SurveyForm *existingForm in [purgedProject.surveys allObjects])
                    {
                        if([newForm.identifier isEqualToString:existingForm.identifier])
                        {
                            newForm.state = existingForm.state;
                            
                            for(Trigger *newFormTrigger in [newForm.triggers allObjects])
                            {
                                
                                for(Trigger *existingFormTrigger in [existingForm.triggers allObjects])
                                {
                                    ////////NSLog(@"%@ %@",newFormTrigger.identifier, existingFormTrigger.identifier);
                                    //////NSLog(@"%@", newForm.title);
                                    if([newFormTrigger.identifier isEqualToString:existingFormTrigger.identifier])
                                    {
                                        //NSLog(@"I");
                                        if([newFormTrigger isKindOfClass:[TemporalTrigger class]])
                                        {
                                            [newFormTrigger setState:existingFormTrigger.state];
                                        }
                                        else
                                        {
                                            
                                            SpatialTrigger *spatial = (SpatialTrigger*) newFormTrigger;
                                            ////////NSLog(@"", spatial.latitude, spatial.longitude);
                                               //NSLog(@"J");
                                        }
                                        
                                        [newFormTrigger refresh]; //resets any registered platform notifications
                                         //NSLog(@"K");
                                    }
                                }
                            }
                        }
                    }
                }
    //NSLog(@"L");
                [self.managedObjectContext deleteObject:purgedProject];
                  //NSLog(@"M");
            }
        }
        
        if(![self.managedObjectContext save:&error])
        {
            //NSLog(@"Error saving Study Items");
        }
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"StudyDownloadComplete" object:self];
    }
}

@end
