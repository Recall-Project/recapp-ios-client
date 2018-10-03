//
//  UploadFeedItems.m
//  Flooder
//
//  Created by RECAPP Developer on 04/04/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import "FilledFormUploader.h"
#import "AppDelegate.h"
#import "RECAPPRestAPI.h"
#import "FilledSurveyForm.h"
#import "SurveyQuestion.h"
#import "ImageExperienceCapture.h"

@implementation FilledFormUploader

@synthesize managedObjectContext, sharedpersistentStoreCoordinator;

#define IMAGE_CONTENT @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n"
#define BOUNDARY @"------------0x0x0x0x0x0x0x0x"
#define DATA(X)	[X dataUsingEncoding:NSUTF8StringEncoding]


- (id)init
{
    if (self = [super init])
    {
        AppDelegate *del = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        sharedpersistentStoreCoordinator = [del persistentStoreCoordinator];
    }
    return self;
}


-(void)main
{
    NSAssert([self sharedpersistentStoreCoordinator], @"PSC is nil");
    managedObjectContext = [[NSManagedObjectContext alloc] init];
    [self.managedObjectContext setUndoManager:nil];
    [self.managedObjectContext setPersistentStoreCoordinator:[self sharedpersistentStoreCoordinator]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"FilledSurveyForm" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entityDesc];
    //[fetchRequest setFetchLimit:1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"sync == 1"]];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    

    if(result.count > 0)
    {
        for(FilledSurveyForm *filledForm in result)
        {
            [managedObjectContext refreshObject:filledForm mergeChanges:YES];
            
            NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
            
            NSDictionary *survey = [filledForm toDictionary];
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:survey options:nil error:nil];
            NSString *jsonItemsAsString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            //////NSLog(@"%@", jsonItemsAsString);
            
            
            [postData setObject:jsonItemsAsString forKey:@"surveys"];
            
            for(SurveyQuestion *question in filledForm.completed_questions)
            {
                if([question isKindOfClass:[ImageExperienceCapture class]])
                {
                    ////////NSLog(@"%@",((ImageExperienceCapture*) question).identifier);
                    
                    ImageExperienceCapture *imageCapture = (ImageExperienceCapture*) question;
                    [postData setObject:imageCapture.image forKey:imageCapture.identifier];
                }
            }
            
            
            ////////NSLog(@"%@", survey);
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                RECAPPRestAPI *restRequest = [[RECAPPRestAPI alloc] initPostSurveyRequest:postData];
                [restRequest executeRequest];
            });
                
            
        }
    }
}

@end
