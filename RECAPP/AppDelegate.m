//
//  AppDelegate.m
//  RECAPP
//
//  Created by RECAPP Developer on 28/04/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import "AppDelegate.h"
#import "DateTimeUtil.h"
#import "ExtendedManagedObject.h"
#import "Project.h"
#import "SurveyForm.h"
#import "SurveyQuestion.h"
#import "SurveyLikertQuestion.h"
#import "AlertsManager.h"
#import "RECAPPMainViewController.h"
#import "Trigger.h"
#import "SpatialTrigger.h"
#import "Guid.h"
#import "TemporalTrigger.h"
#import "RECAPPRestAPI.h"
#import "MBProgressHUD.h"
#import "FilledFormCache.h"
#import "FilledSurveyForm.h"
#import "UISignalBox.h"

@implementation AppDelegate

#define FOLD 1

@synthesize managedObjectModel,managedObjectContext, persistentStoreCoordinator, locationManager = _locationManager,HUD;

-(void)showSpinner
{
    AppDelegate *appDel = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    HUD = [[MBProgressHUD alloc] initWithView:[appDel.window.subviews objectAtIndex:0]];
    [[appDel.window.subviews objectAtIndex:0] addSubview:HUD];
    [HUD show:YES];
}

-(void)stopSpinner
{
    ////NSLog(@"stopSpinner");
    [HUD hide:NO];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
   
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    if (localNotif)
    {
        [self application:application didReceiveLocalNotification:localNotif];
    }
    else if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]){
        
        //////////NSLog(@"OpenUIApplicationLaunchOptionsLocationKey");
        if(_locationManager == nil)
        {
            [self initializeLocationManager];
        }
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        //[defaults setBool:YES forKey:@"isWorkingWithSurvey"];
        
        ////////NSLog(@"%@",[defaults objectForKey:@"has_registered"]);
        
        if(![defaults objectForKey:@"has_registered"])
        {
            ////////NSLog(@"Cancelling All Notification");
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
          
            /*NSArray *regions = [_locationManager.monitoredRegions allObjects];
            for(CLRegion* region in regions)
            {
                [_locationManager stopMonitoringForRegion:region];
            }*/
        }
        
        
        /*NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[NSDate date]];
        [components setDay:6];
        [components setMinute:0];
        [components setHour:9];
        NSDate *baseDate = [calendar dateFromComponents:components];
        
        //////////NSLog(@"%@",baseDate);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     
        [self initializeLocationManager];

        if(![defaults objectForKey:@"trial_config"])
        {
            [defaults setBool:NO forKey:@"has_registered"];
            [defaults synchronize];
            
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            [self resetPersistentStore];
            NSArray *regions = [_locationManager.monitoredRegions allObjects];
            for(CLRegion* region in regions)
            {
                [_locationManager stopMonitoringForRegion:region];
            }
            
        
            
            
            NSMutableDictionary *project = [[NSMutableDictionary alloc] init];
            [project setObject:@"Project" forKey:@"type"];
            [project setObject:@"ESM Group" forKey:@"name"];
            [project setObject:@"8498184f-89b3-4240-a397-255ec6359a26" forKey:@"identifier"];
            [project setObject:[[Guid getInstance] newGuid] forKey:@"revision"];
            
             //---SURVEY-START-------------------------------------------------
            //Journey To Work Survey
            NSMutableDictionary *jnyToWorkForm = [[NSMutableDictionary alloc] init];
            [jnyToWorkForm setObject:@"SurveyForm" forKey:@"type"];
            [jnyToWorkForm setObject:@"2e51a365-a728-40a9-b354-2530f2df2591" forKey:@"identifier"];
            [jnyToWorkForm setObject:[NSNumber numberWithInt:0] forKey:@"state"];
            [jnyToWorkForm setObject:@"Journey To Work Survey" forKey:@"title"];
         
            //Likert Options
            NSMutableDictionary *likertOption1 = [[NSMutableDictionary alloc] init];
            [likertOption1 setObject:@"LikertOption" forKey:@"type"];
            [likertOption1 setObject:[NSNumber numberWithInt:1] forKey:@"value"];
            NSMutableDictionary *likertOption2 = [[NSMutableDictionary alloc] init];
            [likertOption2 setObject:@"LikertOption" forKey:@"type"];
            [likertOption2 setObject:[NSNumber numberWithInt:2] forKey:@"value"];
            NSMutableDictionary *likertOption3 = [[NSMutableDictionary alloc] init];
            [likertOption3 setObject:@"LikertOption" forKey:@"type"];
            [likertOption3 setObject:[NSNumber numberWithInt:3] forKey:@"value"];
            NSMutableDictionary *likertOption4 = [[NSMutableDictionary alloc] init];
            [likertOption4 setObject:@"LikertOption" forKey:@"type"];
            [likertOption4 setObject:[NSNumber numberWithInt:4] forKey:@"value"];
            NSMutableDictionary *likertOption5 = [[NSMutableDictionary alloc] init];
            [likertOption5 setObject:@"LikertOption" forKey:@"type"];
            [likertOption5 setObject:[NSNumber numberWithInt:5] forKey:@"value"];
            NSMutableDictionary *likertOption6 = [[NSMutableDictionary alloc] init];
            [likertOption6 setObject:@"LikertOption" forKey:@"type"];
            [likertOption6 setObject:[NSNumber numberWithInt:6] forKey:@"value"];
            NSMutableDictionary *likertOption7 = [[NSMutableDictionary alloc] init];
            [likertOption7 setObject:@"LikertOption" forKey:@"type"];
            [likertOption7 setObject:[NSNumber numberWithInt:7] forKey:@"value"];
            NSMutableSet *likertOptions = [NSMutableSet setWithObjects:likertOption1,likertOption2,likertOption3,likertOption4,likertOption5,likertOption6,likertOption7, nil];
            
            //Happiness Likert Question
            NSMutableDictionary *happylikertQuestion = [[NSMutableDictionary alloc] init];
            [happylikertQuestion setObject:@"SurveyLikertQuestion" forKey:@"type"];
            [happylikertQuestion setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [happylikertQuestion setObject:[NSNumber numberWithInt:1] forKey:@"ordinal"];
            [happylikertQuestion setObject:@"Very Happy" forKey:@"high_end_descriptor"];
            [happylikertQuestion setObject:@"Not At All" forKey:@"low_end_descriptor"];
            [happylikertQuestion setObject:@"How happy do you currently feel?" forKey:@"question"];
            [happylikertQuestion setObject:likertOptions forKey:@"options"];
            
            //Happiness Likert Question
            NSMutableDictionary *tiredlikertQuestion = [[NSMutableDictionary alloc] init];
            [tiredlikertQuestion setObject:@"SurveyLikertQuestion" forKey:@"type"];
            [tiredlikertQuestion setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [tiredlikertQuestion setObject:[NSNumber numberWithInt:2] forKey:@"ordinal"];
            [tiredlikertQuestion setObject:@"Very Tired" forKey:@"high_end_descriptor"];
            [tiredlikertQuestion setObject:@"Not At All" forKey:@"low_end_descriptor"];
            [tiredlikertQuestion setObject:@"How tired do you currently feel?" forKey:@"question"];
            [tiredlikertQuestion setObject:likertOptions forKey:@"options"];
            
            //content Likert Question
            NSMutableDictionary *contentlikertQuestion = [[NSMutableDictionary alloc] init];
            [contentlikertQuestion setObject:@"SurveyLikertQuestion" forKey:@"type"];
            [contentlikertQuestion setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [contentlikertQuestion setObject:[NSNumber numberWithInt:3] forKey:@"ordinal"];
            [contentlikertQuestion setObject:@"Very Content" forKey:@"high_end_descriptor"];
            [contentlikertQuestion setObject:@"Not At All" forKey:@"low_end_descriptor"];
            [contentlikertQuestion setObject:@"How content do you currently feel?" forKey:@"question"];
            [contentlikertQuestion setObject:likertOptions forKey:@"options"];
            
            //stressed Likert Question
            NSMutableDictionary *stressedlikertQuestion = [[NSMutableDictionary alloc] init];
            [stressedlikertQuestion setObject:@"SurveyLikertQuestion" forKey:@"type"];
            [stressedlikertQuestion setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [stressedlikertQuestion setObject:[NSNumber numberWithInt:4] forKey:@"ordinal"];
            [stressedlikertQuestion setObject:@"Very Stressed" forKey:@"high_end_descriptor"];
            [stressedlikertQuestion setObject:@"Not At All" forKey:@"low_end_descriptor"];
            [stressedlikertQuestion setObject:@"How stressed do you currently feel?" forKey:@"question"];
            [stressedlikertQuestion setObject:likertOptions forKey:@"options"];
            
            //stressed Likert Question
            NSMutableDictionary *inpatientlikertQuestion = [[NSMutableDictionary alloc] init];
            [inpatientlikertQuestion setObject:@"SurveyLikertQuestion" forKey:@"type"];
            [inpatientlikertQuestion setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [inpatientlikertQuestion setObject:[NSNumber numberWithInt:5] forKey:@"ordinal"];
            [inpatientlikertQuestion setObject:@"Very Inpatient" forKey:@"high_end_descriptor"];
            [inpatientlikertQuestion setObject:@"Not At All" forKey:@"low_end_descriptor"];
            [inpatientlikertQuestion setObject:@"Are you inpatient for this journey to end?" forKey:@"question"];
            [inpatientlikertQuestion setObject:likertOptions forKey:@"options"];
            
            //worthwhile Likert Question
            NSMutableDictionary *worthwhilelikertQuestion = [[NSMutableDictionary alloc] init];
            [worthwhilelikertQuestion setObject:@"SurveyLikertQuestion" forKey:@"type"];
            [worthwhilelikertQuestion setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [worthwhilelikertQuestion setObject:[NSNumber numberWithInt:6] forKey:@"ordinal"];
            [worthwhilelikertQuestion setObject:@"Very Worthwhile" forKey:@"high_end_descriptor"];
            [worthwhilelikertQuestion setObject:@"Not At All" forKey:@"low_end_descriptor"];
            [worthwhilelikertQuestion setObject:@"Do you feel this journey is worthwhile?" forKey:@"question"];
            [worthwhilelikertQuestion setObject:likertOptions forKey:@"options"];
            
            NSMutableDictionary *companyMultiQuestion = [[NSMutableDictionary alloc] init];
            [companyMultiQuestion setObject:@"SurveyMultiOptionQuestion" forKey:@"type"];
            [companyMultiQuestion setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [companyMultiQuestion setObject:[NSNumber numberWithInt:7] forKey:@"ordinal"];
            [companyMultiQuestion setObject:@"Are you travelling alone or with come one you know?" forKey:@"question"];
            NSMutableDictionary *companyMultiQuestionOption1 = [[NSMutableDictionary alloc] init];
            [companyMultiQuestionOption1 setObject:@"MultiOption" forKey:@"type"];
            [companyMultiQuestionOption1 setObject:@"Alone" forKey:@"value"];
            [companyMultiQuestionOption1 setObject:[NSNumber numberWithShort:0]  forKey:@"ordinal"];
            NSMutableDictionary *companyMultiQuestionOption2 = [[NSMutableDictionary alloc] init];
            [companyMultiQuestionOption2 setObject:@"MultiOption" forKey:@"type"];
            [companyMultiQuestionOption2 setObject:@"With someone I Know" forKey:@"value"];
            [companyMultiQuestionOption2 setObject:[NSNumber numberWithShort:1]  forKey:@"ordinal"];
            NSMutableSet *multioptions = [NSMutableSet setWithObjects:companyMultiQuestionOption1, companyMultiQuestionOption2, nil];
            [companyMultiQuestion setObject:multioptions forKey:@"options"];
            
            NSMutableDictionary *howlongMultiQuestion = [[NSMutableDictionary alloc] init];
            [howlongMultiQuestion setObject:@"SurveyMultiOptionQuestion" forKey:@"type"];
            [howlongMultiQuestion setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [howlongMultiQuestion setObject:[NSNumber numberWithInt:8] forKey:@"ordinal"];
            [howlongMultiQuestion setObject:@"How long with this journey last (approx)?" forKey:@"question"];
            NSMutableDictionary *howlongMultiQuestionOption1 = [[NSMutableDictionary alloc] init];
            [howlongMultiQuestionOption1 setObject:@"MultiOption" forKey:@"type"];
            [howlongMultiQuestionOption1 setObject:@"0-5" forKey:@"value"];
            [howlongMultiQuestionOption1 setObject:[NSNumber numberWithShort:0]  forKey:@"ordinal"];
            NSMutableDictionary *howlongMultiQuestionOption2 = [[NSMutableDictionary alloc] init];
            [howlongMultiQuestionOption2 setObject:@"MultiOption" forKey:@"type"];
            [howlongMultiQuestionOption2 setObject:@"6-10" forKey:@"value"];
         [howlongMultiQuestionOption2 setObject:[NSNumber numberWithShort:1]  forKey:@"ordinal"];
            NSMutableDictionary *howlongMultiQuestionOption3 = [[NSMutableDictionary alloc] init];
            [howlongMultiQuestionOption3 setObject:@"MultiOption" forKey:@"type"];
            [howlongMultiQuestionOption3 setObject:@"11-15" forKey:@"value"];
         [howlongMultiQuestionOption3 setObject:[NSNumber numberWithShort:2]  forKey:@"ordinal"];
            NSMutableDictionary *howlongMultiQuestionOption4 = [[NSMutableDictionary alloc] init];
            [howlongMultiQuestionOption4 setObject:@"MultiOption" forKey:@"type"];
            [howlongMultiQuestionOption4 setObject:@"16-20" forKey:@"value"];
            [howlongMultiQuestionOption4 setObject:[NSNumber numberWithShort:3]  forKey:@"ordinal"];
            NSMutableDictionary *howlongMultiQuestionOption5 = [[NSMutableDictionary alloc] init];
            [howlongMultiQuestionOption5 setObject:@"MultiOption" forKey:@"type"];
            [howlongMultiQuestionOption5 setObject:@"More than 20" forKey:@"value"];
            [howlongMultiQuestionOption5 setObject:[NSNumber numberWithShort:4]  forKey:@"ordinal"];
            NSMutableSet *howlongMultiQuestionmultioptions = [NSMutableSet setWithObjects:howlongMultiQuestionOption1, howlongMultiQuestionOption2,howlongMultiQuestionOption3,howlongMultiQuestionOption4, howlongMultiQuestionOption5, nil];
            [howlongMultiQuestion setObject:howlongMultiQuestionmultioptions forKey:@"options"];
            
            NSMutableDictionary *activityMultiQuestion = [[NSMutableDictionary alloc] init];
            [activityMultiQuestion setObject:@"SurveyMultiOptionQuestion" forKey:@"type"];
            [activityMultiQuestion setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [activityMultiQuestion setObject:[NSNumber numberWithInt:9] forKey:@"ordinal"];
            [activityMultiQuestion setObject:@"Are you doing anything on the journey?" forKey:@"question"];
            NSMutableDictionary *activityMultiQuestionOption1 = [[NSMutableDictionary alloc] init];
            [activityMultiQuestionOption1 setObject:@"MultiOption" forKey:@"type"];
            [activityMultiQuestionOption1 setObject:@"Nothing" forKey:@"value"];
         [activityMultiQuestionOption1 setObject:[NSNumber numberWithShort:0]  forKey:@"ordinal"];
            NSMutableDictionary *activityMultiQuestionOption2 = [[NSMutableDictionary alloc] init];
            [activityMultiQuestionOption2 setObject:@"MultiOption" forKey:@"type"];
            [activityMultiQuestionOption2 setObject:@"Reading" forKey:@"value"];
         [activityMultiQuestionOption2 setObject:[NSNumber numberWithShort:1]  forKey:@"ordinal"];
            NSMutableDictionary *activityMultiQuestionOption3 = [[NSMutableDictionary alloc] init];
            [activityMultiQuestionOption3 setObject:@"MultiOption" forKey:@"type"];
            [activityMultiQuestionOption3 setObject:@"Listening to Music" forKey:@"value"];
         [activityMultiQuestionOption3 setObject:[NSNumber numberWithShort:2]  forKey:@"ordinal"];
            NSMutableDictionary *activityMultiQuestionOption4 = [[NSMutableDictionary alloc] init];
            [activityMultiQuestionOption4 setObject:@"MultiOption" forKey:@"type"];
            [activityMultiQuestionOption4 setObject:@"In Conversation" forKey:@"value"];
         [activityMultiQuestionOption4 setObject:[NSNumber numberWithShort:3]  forKey:@"ordinal"];
            NSMutableDictionary *activityMultiQuestionOption5 = [[NSMutableDictionary alloc] init];
            [activityMultiQuestionOption5 setObject:@"MultiOption" forKey:@"type"];
            [activityMultiQuestionOption5 setObject:@"Social Networking" forKey:@"value"];
         [activityMultiQuestionOption5 setObject:[NSNumber numberWithShort:4]  forKey:@"ordinal"];
            NSMutableDictionary *activityMultiQuestionOption6 = [[NSMutableDictionary alloc] init];
            [activityMultiQuestionOption6 setObject:@"MultiOption" forKey:@"type"];
            [activityMultiQuestionOption6 setObject:@"Other" forKey:@"value"];
         [activityMultiQuestionOption6 setObject:[NSNumber numberWithShort:5]  forKey:@"ordinal"];
            NSMutableSet *activityMultiQuestionmultioptions = [NSMutableSet setWithObjects:activityMultiQuestionOption1, activityMultiQuestionOption2,activityMultiQuestionOption3,activityMultiQuestionOption4, activityMultiQuestionOption5,activityMultiQuestionOption6, nil];
            [activityMultiQuestion setObject:activityMultiQuestionmultioptions forKey:@"options"];
            
            NSMutableSet *questions = [NSMutableSet setWithObjects:happylikertQuestion,tiredlikertQuestion,contentlikertQuestion,stressedlikertQuestion,inpatientlikertQuestion,worthwhilelikertQuestion, companyMultiQuestion,howlongMultiQuestion,activityMultiQuestion, nil];
            [jnyToWorkForm setObject:questions forKey:@"questions"];
            
            //Survey Trigger
            NSMutableDictionary *spatialTrigger = [[NSMutableDictionary alloc] init];
            [spatialTrigger setObject:@"SpatialTrigger" forKey:@"type"];
            [spatialTrigger setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [spatialTrigger setObject:[NSNumber numberWithShort:0] forKey:@"state"];
            [spatialTrigger setObject:[NSNumber numberWithDouble:53.311564] forKey:@"latitude"];
            [spatialTrigger setObject:[NSNumber numberWithDouble:-0.661484] forKey:@"longitude"];
            [spatialTrigger setObject:[NSNumber numberWithDouble:1000.0] forKey:@"radius"]; //282
            [spatialTrigger setObject:@"Sturton By Stow, UK" forKey:@"placename"];
            
            NSMutableDictionary *spatTempTrigger = [[NSMutableDictionary alloc] init];
            [spatTempTrigger setObject:@"TemporalTrigger" forKey:@"type"];
            [spatTempTrigger setObject:[[Guid getInstance]newGuid] forKey:@"identifier"];
            [spatTempTrigger setObject:[NSNumber numberWithShort:0] forKey:@"state"];
            [spatTempTrigger setObject:[NSNumber numberWithLong:(60.0 * 60.0 * 10)] forKey:@"duration"]; //6pm
            [spatTempTrigger setObject:baseDate forKey:@"activation_time"];
            
            NSMutableSet *times = [NSMutableSet setWithObjects:spatTempTrigger, nil];
            
            [spatialTrigger setObject:times forKey:@"children"];
            
            
            NSMutableSet *triggers = [NSMutableSet setWithObjects:spatialTrigger, nil];
            [jnyToWorkForm setObject:triggers forKey:@"triggers"];
            
            //---------------SURVEY-END--------------------------------------------
            
            //-----------------ESM-MORNING-SURVEY-START----------------------------
            //Morning Work Survey
            NSMutableDictionary *atworkform = [[NSMutableDictionary alloc] init];
            [atworkform setObject:@"SurveyForm" forKey:@"type"];
            [atworkform setObject:@"cc8f1804-9ac3-46a3-95f4-25b4a3752ed6" forKey:@"identifier"];
            [atworkform setObject:[NSNumber numberWithInt:0] forKey:@"state"];
            [atworkform setObject:@"At Work Survey" forKey:@"title"];
            
            NSMutableDictionary *workactivityMultiQuestion = [[NSMutableDictionary alloc] init];
            [workactivityMultiQuestion setObject:@"SurveyMultiOptionQuestion" forKey:@"type"];
            [workactivityMultiQuestion setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [workactivityMultiQuestion setObject:[NSNumber numberWithInt:1] forKey:@"ordinal"];
            [workactivityMultiQuestion setObject:@"What activity are you currently engaged in?" forKey:@"question"];
            NSMutableDictionary *workactivityMultiQuestionOption1 = [[NSMutableDictionary alloc] init];
            [workactivityMultiQuestionOption1 setObject:@"MultiOption" forKey:@"type"];
            [workactivityMultiQuestionOption1 setObject:@"Work Alone At Desk" forKey:@"value"];
         [workactivityMultiQuestionOption1 setObject:[NSNumber numberWithShort:0]  forKey:@"ordinal"];
            NSMutableDictionary *workactivityMultiQuestionOption2 = [[NSMutableDictionary alloc] init];
            [workactivityMultiQuestionOption2 setObject:@"MultiOption" forKey:@"type"];
            [workactivityMultiQuestionOption2 setObject:@"Work Alone Not At Desk" forKey:@"value"];
         [workactivityMultiQuestionOption2 setObject:[NSNumber numberWithShort:1]  forKey:@"ordinal"];
            NSMutableDictionary *workactivityMultiQuestionOption3 = [[NSMutableDictionary alloc] init];
            [workactivityMultiQuestionOption3 setObject:@"MultiOption" forKey:@"type"];
            [workactivityMultiQuestionOption3 setObject:@"Working With A Group" forKey:@"value"];
         [workactivityMultiQuestionOption3 setObject:[NSNumber numberWithShort:2]  forKey:@"ordinal"];
            NSMutableDictionary *workactivityMultiQuestionOption4 = [[NSMutableDictionary alloc] init];
            [workactivityMultiQuestionOption4 setObject:@"MultiOption" forKey:@"type"];
            [workactivityMultiQuestionOption4 setObject:@"Non Work Activity" forKey:@"value"];
         [workactivityMultiQuestionOption4 setObject:[NSNumber numberWithShort:3]  forKey:@"ordinal"];
            NSMutableDictionary *workactivityMultiQuestionOption5 = [[NSMutableDictionary alloc] init];
            [workactivityMultiQuestionOption5 setObject:@"MultiOption" forKey:@"type"];
            [workactivityMultiQuestionOption5 setObject:@"Other" forKey:@"value"];
         [workactivityMultiQuestionOption5 setObject:[NSNumber numberWithShort:4]  forKey:@"ordinal"];
            NSMutableSet *workactivityMultiQuestionmultioptions = [NSMutableSet setWithObjects:workactivityMultiQuestionOption1, workactivityMultiQuestionOption2,workactivityMultiQuestionOption3,workactivityMultiQuestionOption4, workactivityMultiQuestionOption5, nil];
            [workactivityMultiQuestion setObject:workactivityMultiQuestionmultioptions forKey:@"options"];
            
            //Happiness Likert Question
            NSMutableDictionary *morninghappylikertQuestion = [[NSMutableDictionary alloc] init];
            [morninghappylikertQuestion setObject:@"SurveyLikertQuestion" forKey:@"type"];
            [morninghappylikertQuestion setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [morninghappylikertQuestion setObject:[NSNumber numberWithInt:2] forKey:@"ordinal"];
            [morninghappylikertQuestion setObject:@"Very Happy" forKey:@"high_end_descriptor"];
            [morninghappylikertQuestion setObject:@"Not At All" forKey:@"low_end_descriptor"];
            [morninghappylikertQuestion setObject:@"How happy do you currently feel?" forKey:@"question"];
            [morninghappylikertQuestion setObject:likertOptions forKey:@"options"];
            
            //Happiness Likert Question
            NSMutableDictionary *morningtiredlikertQuestion = [[NSMutableDictionary alloc] init];
            [morningtiredlikertQuestion setObject:@"SurveyLikertQuestion" forKey:@"type"];
            [morningtiredlikertQuestion setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [morningtiredlikertQuestion setObject:[NSNumber numberWithInt:3] forKey:@"ordinal"];
            [morningtiredlikertQuestion setObject:@"Very Tired" forKey:@"high_end_descriptor"];
            [morningtiredlikertQuestion setObject:@"Not At All" forKey:@"low_end_descriptor"];
            [morningtiredlikertQuestion setObject:@"How tired do you currently feel?" forKey:@"question"];
            [morningtiredlikertQuestion setObject:likertOptions forKey:@"options"];
            
            //content Likert Question
            NSMutableDictionary *morningcontentlikertQuestion = [[NSMutableDictionary alloc] init];
            [morningcontentlikertQuestion setObject:@"SurveyLikertQuestion" forKey:@"type"];
            [morningcontentlikertQuestion setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [morningcontentlikertQuestion setObject:[NSNumber numberWithInt:4] forKey:@"ordinal"];
            [morningcontentlikertQuestion setObject:@"Very Content" forKey:@"high_end_descriptor"];
            [morningcontentlikertQuestion setObject:@"Not At All" forKey:@"low_end_descriptor"];
            [morningcontentlikertQuestion setObject:@"How content do you currently feel?" forKey:@"question"];
            [morningcontentlikertQuestion setObject:likertOptions forKey:@"options"];
            
            //stressed Likert Question
            NSMutableDictionary *morningstressedlikertQuestion = [[NSMutableDictionary alloc] init];
            [morningstressedlikertQuestion setObject:@"SurveyLikertQuestion" forKey:@"type"];
            [morningstressedlikertQuestion setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [morningstressedlikertQuestion setObject:[NSNumber numberWithInt:5] forKey:@"ordinal"];
            [morningstressedlikertQuestion setObject:@"Very Stressed" forKey:@"high_end_descriptor"];
            [morningstressedlikertQuestion setObject:@"Not At All" forKey:@"low_end_descriptor"];
            [morningstressedlikertQuestion setObject:@"How stressed do you currently feel?" forKey:@"question"];
            [morningstressedlikertQuestion setObject:likertOptions forKey:@"options"];
            
            //stressed Likert Question
            NSMutableDictionary *morninginpatientlikertQuestion = [[NSMutableDictionary alloc] init];
            [morninginpatientlikertQuestion setObject:@"SurveyLikertQuestion" forKey:@"type"];
            [morninginpatientlikertQuestion setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [morninginpatientlikertQuestion setObject:[NSNumber numberWithInt:6] forKey:@"ordinal"];
            [morninginpatientlikertQuestion setObject:@"Very Inpatient" forKey:@"high_end_descriptor"];
            [morninginpatientlikertQuestion setObject:@"Not At All" forKey:@"low_end_descriptor"];
            [morninginpatientlikertQuestion setObject:@"Are you inpatient for this current activity to end?" forKey:@"question"];
            [morninginpatientlikertQuestion setObject:likertOptions forKey:@"options"];
            
            //worthwhile Likert Question
            NSMutableDictionary *morningworthwhilelikertQuestion = [[NSMutableDictionary alloc] init];
            [morningworthwhilelikertQuestion setObject:@"SurveyLikertQuestion" forKey:@"type"];
            [morningworthwhilelikertQuestion setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [morningworthwhilelikertQuestion setObject:[NSNumber numberWithInt:6] forKey:@"ordinal"];
            [morningworthwhilelikertQuestion setObject:@"Very Worthwhile" forKey:@"high_end_descriptor"];
            [morningworthwhilelikertQuestion setObject:@"Not At All" forKey:@"low_end_descriptor"];
            [morningworthwhilelikertQuestion setObject:@"Do you feel this current activity is worthwhile?" forKey:@"question"];
            [morningworthwhilelikertQuestion setObject:likertOptions forKey:@"options"];
            
            NSMutableDictionary *morninghowlongMultiQuestion = [[NSMutableDictionary alloc] init];
            [morninghowlongMultiQuestion setObject:@"SurveyMultiOptionQuestion" forKey:@"type"];
            [morninghowlongMultiQuestion setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [morninghowlongMultiQuestion setObject:[NSNumber numberWithInt:8] forKey:@"ordinal"];
            [morninghowlongMultiQuestion setObject:@"How long will this activity last (approx)?" forKey:@"question"];
            NSMutableDictionary *morninghowlongMultiQuestionOption1 = [[NSMutableDictionary alloc] init];
            [morninghowlongMultiQuestionOption1 setObject:@"MultiOption" forKey:@"type"];
            [morninghowlongMultiQuestionOption1 setObject:@"0-5" forKey:@"value"];
         [morninghowlongMultiQuestionOption1 setObject:[NSNumber numberWithShort:0]  forKey:@"ordinal"];
            NSMutableDictionary *morninghowlongMultiQuestionOption2 = [[NSMutableDictionary alloc] init];
            [morninghowlongMultiQuestionOption2 setObject:@"MultiOption" forKey:@"type"];
            [morninghowlongMultiQuestionOption2 setObject:@"6-10" forKey:@"value"];
         [morninghowlongMultiQuestionOption2 setObject:[NSNumber numberWithShort:1]  forKey:@"ordinal"];
            NSMutableDictionary *morninghowlongMultiQuestionOption3 = [[NSMutableDictionary alloc] init];
            [morninghowlongMultiQuestionOption3 setObject:@"MultiOption" forKey:@"type"];
            [morninghowlongMultiQuestionOption3 setObject:@"11-15" forKey:@"value"];
         [morninghowlongMultiQuestionOption3 setObject:[NSNumber numberWithShort:2]  forKey:@"ordinal"];
            NSMutableDictionary *morninghowlongMultiQuestionOption4 = [[NSMutableDictionary alloc] init];
            [morninghowlongMultiQuestionOption4 setObject:@"MultiOption" forKey:@"type"];
            [morninghowlongMultiQuestionOption4 setObject:@"16-20" forKey:@"value"];
         [morninghowlongMultiQuestionOption4 setObject:[NSNumber numberWithShort:3]  forKey:@"ordinal"];
            NSMutableDictionary *morninghowlongMultiQuestionOption5 = [[NSMutableDictionary alloc] init];
            [morninghowlongMultiQuestionOption5 setObject:@"MultiOption" forKey:@"type"];
            [morninghowlongMultiQuestionOption5 setObject:@"More than 20" forKey:@"value"];
         [morninghowlongMultiQuestionOption5 setObject:[NSNumber numberWithShort:4]  forKey:@"ordinal"];
            NSMutableSet *morninghowlongMultiQuestionmultioptions = [NSMutableSet setWithObjects:morninghowlongMultiQuestionOption1, morninghowlongMultiQuestionOption2,morninghowlongMultiQuestionOption3,morninghowlongMultiQuestionOption4, morninghowlongMultiQuestionOption5, nil];
            [morninghowlongMultiQuestion setObject:morninghowlongMultiQuestionmultioptions forKey:@"options"];
                    
            NSMutableSet *morningquestions = [NSMutableSet setWithObjects:workactivityMultiQuestion, morninghappylikertQuestion,morningtiredlikertQuestion,morningcontentlikertQuestion,morningstressedlikertQuestion,morninginpatientlikertQuestion,morningworthwhilelikertQuestion,morninghowlongMultiQuestion, nil];
            [atworkform setObject:morningquestions forKey:@"questions"];
            
            //Survey Trigger
            NSMutableDictionary *temporalTrigger = [[NSMutableDictionary alloc] init];
            [temporalTrigger setObject:@"TemporalTrigger" forKey:@"type"];
            [temporalTrigger setObject:[[Guid getInstance]newGuid] forKey:@"identifier"];
            [temporalTrigger setObject:[NSNumber numberWithShort:0] forKey:@"state"];
            [temporalTrigger setObject:[NSNumber numberWithLong:(60.0 * 5.0)] forKey:@"duration"];
            [temporalTrigger setObject:[baseDate dateByAddingTimeInterval:(60.0 * 60.0 * 3.0)] forKey:@"activation_time"]; //11am 6th
            
            NSMutableDictionary *temporalTrigger2 = [[NSMutableDictionary alloc] init];
            [temporalTrigger2 setObject:@"TemporalTrigger" forKey:@"type"];
            [temporalTrigger2 setObject:[[Guid getInstance]newGuid] forKey:@"identifier"];
            [temporalTrigger2 setObject:[NSNumber numberWithShort:0] forKey:@"state"];
            [temporalTrigger2 setObject:[NSNumber numberWithLong:(60.0 * 5.0)] forKey:@"duration"];
            [temporalTrigger2 setObject:[baseDate dateByAddingTimeInterval:(60.0 * 60 * 27.0)] forKey:@"activation_time"]; //11am 7th
            NSMutableSet *morningtriggers = [NSMutableSet setWithObjects:temporalTrigger,temporalTrigger2, nil];
            
            [atworkform setObject:morningtriggers forKey:@"triggers"];
            
            //--------------------ESM MORNING SURVEY--------------------------------
            
            //--------------------ESM JOURNEY FROM WORK-----------------------------
            //Journey To Work Survey
            NSMutableDictionary *jnyToFromForm = [[NSMutableDictionary alloc] init];
            [jnyToFromForm setObject:@"SurveyForm" forKey:@"type"];
            [jnyToFromForm setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [jnyToFromForm setObject:[NSNumber numberWithInt:0] forKey:@"state"];
            [jnyToFromForm setObject:@"Journey From Work Survey" forKey:@"title"];
            
            //Happiness Likert Question
            NSMutableDictionary *happylikertQuestionEsm2 = [[NSMutableDictionary alloc] init];
            [happylikertQuestionEsm2 setObject:@"SurveyLikertQuestion" forKey:@"type"];
            [happylikertQuestionEsm2 setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [happylikertQuestionEsm2 setObject:[NSNumber numberWithInt:1] forKey:@"ordinal"];
            [happylikertQuestionEsm2 setObject:@"Very Happy" forKey:@"high_end_descriptor"];
            [happylikertQuestionEsm2 setObject:@"Not At All" forKey:@"low_end_descriptor"];
            [happylikertQuestionEsm2 setObject:@"How happy do you currently feel?" forKey:@"question"];
            [happylikertQuestionEsm2 setObject:likertOptions forKey:@"options"];
            
            //Happiness Likert Question
            NSMutableDictionary *tiredlikertQuestionEsm2 = [[NSMutableDictionary alloc] init];
            [tiredlikertQuestionEsm2 setObject:@"SurveyLikertQuestion" forKey:@"type"];
            [tiredlikertQuestionEsm2 setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [tiredlikertQuestionEsm2 setObject:[NSNumber numberWithInt:2] forKey:@"ordinal"];
            [tiredlikertQuestionEsm2 setObject:@"Very Tired" forKey:@"high_end_descriptor"];
            [tiredlikertQuestionEsm2 setObject:@"Not At All" forKey:@"low_end_descriptor"];
            [tiredlikertQuestionEsm2 setObject:@"How tired do you currently feel?" forKey:@"question"];
            [tiredlikertQuestionEsm2 setObject:likertOptions forKey:@"options"];
            
            //content Likert Question
            NSMutableDictionary *contentlikertQuestionEsm2 = [[NSMutableDictionary alloc] init];
            [contentlikertQuestionEsm2 setObject:@"SurveyLikertQuestion" forKey:@"type"];
            [contentlikertQuestionEsm2 setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [contentlikertQuestionEsm2 setObject:[NSNumber numberWithInt:3] forKey:@"ordinal"];
            [contentlikertQuestionEsm2 setObject:@"Very Content" forKey:@"high_end_descriptor"];
            [contentlikertQuestionEsm2 setObject:@"Not At All" forKey:@"low_end_descriptor"];
            [contentlikertQuestionEsm2 setObject:@"How content do you currently feel?" forKey:@"question"];
            [contentlikertQuestionEsm2 setObject:likertOptions forKey:@"options"];
            
            //stressed Likert Question
            NSMutableDictionary *stressedlikertQuestionEsm2 = [[NSMutableDictionary alloc] init];
            [stressedlikertQuestionEsm2 setObject:@"SurveyLikertQuestion" forKey:@"type"];
            [stressedlikertQuestionEsm2 setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [stressedlikertQuestionEsm2 setObject:[NSNumber numberWithInt:4] forKey:@"ordinal"];
            [stressedlikertQuestionEsm2 setObject:@"Very Stressed" forKey:@"high_end_descriptor"];
            [stressedlikertQuestionEsm2 setObject:@"Not At All" forKey:@"low_end_descriptor"];
            [stressedlikertQuestionEsm2 setObject:@"How stressed do you currently feel?" forKey:@"question"];
            [stressedlikertQuestionEsm2 setObject:likertOptions forKey:@"options"];
            
            //stressed Likert Question
            NSMutableDictionary *inpatientlikertQuestionEsm2 = [[NSMutableDictionary alloc] init];
            [inpatientlikertQuestionEsm2 setObject:@"SurveyLikertQuestion" forKey:@"type"];
            [inpatientlikertQuestionEsm2 setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [inpatientlikertQuestionEsm2 setObject:[NSNumber numberWithInt:5] forKey:@"ordinal"];
            [inpatientlikertQuestionEsm2 setObject:@"Very Inpatient" forKey:@"high_end_descriptor"];
            [inpatientlikertQuestionEsm2 setObject:@"Not At All" forKey:@"low_end_descriptor"];
            [inpatientlikertQuestionEsm2 setObject:@"Are you inpatient for this journey to end?" forKey:@"question"];
            [inpatientlikertQuestionEsm2 setObject:likertOptions forKey:@"options"];
            
            //worthwhile Likert Question
            NSMutableDictionary *worthwhilelikertQuestionEsm2 = [[NSMutableDictionary alloc] init];
            [worthwhilelikertQuestionEsm2 setObject:@"SurveyLikertQuestion" forKey:@"type"];
            [worthwhilelikertQuestionEsm2 setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [worthwhilelikertQuestionEsm2 setObject:[NSNumber numberWithInt:6] forKey:@"ordinal"];
            [worthwhilelikertQuestionEsm2 setObject:@"Very Worthwhile" forKey:@"high_end_descriptor"];
            [worthwhilelikertQuestionEsm2 setObject:@"Not At All" forKey:@"low_end_descriptor"];
            [worthwhilelikertQuestionEsm2 setObject:@"Do you feel this journey is worthwhile?" forKey:@"question"];
            [worthwhilelikertQuestionEsm2 setObject:likertOptions forKey:@"options"];
            
            NSMutableDictionary *companyMultiQuestionEsm2 = [[NSMutableDictionary alloc] init];
            [companyMultiQuestionEsm2 setObject:@"SurveyMultiOptionQuestion" forKey:@"type"];
            [companyMultiQuestionEsm2 setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [companyMultiQuestionEsm2 setObject:[NSNumber numberWithInt:7] forKey:@"ordinal"];
            [companyMultiQuestionEsm2 setObject:@"Are you travelling alone or with come one you know?" forKey:@"question"];
            NSMutableDictionary *companyMultiQuestionOption1Esm2 = [[NSMutableDictionary alloc] init];
            [companyMultiQuestionOption1Esm2 setObject:@"MultiOption" forKey:@"type"];
             [companyMultiQuestionOption1Esm2 setObject: [NSNumber numberWithShort:0] forKey:@"ordinal"];
            [companyMultiQuestionOption1Esm2 setObject:@"Alone" forKey:@"value"];
            NSMutableDictionary *companyMultiQuestionOption2Esm2 = [[NSMutableDictionary alloc] init];
            [companyMultiQuestionOption2Esm2 setObject:@"MultiOption" forKey:@"type"];
            [companyMultiQuestionOption2Esm2 setObject:@"With someone I Know" forKey:@"value"];
              [companyMultiQuestionOption2Esm2 setObject: [NSNumber numberWithShort:1] forKey:@"ordinal"];
            NSMutableSet *multioptionsEsm2 = [NSMutableSet setWithObjects:companyMultiQuestionOption1Esm2, companyMultiQuestionOption2Esm2, nil];
            [companyMultiQuestionEsm2 setObject:multioptionsEsm2 forKey:@"options"];
            
            NSMutableDictionary *howlongMultiQuestionEsm2 = [[NSMutableDictionary alloc] init];
            [howlongMultiQuestionEsm2 setObject:@"SurveyMultiOptionQuestion" forKey:@"type"];
            [howlongMultiQuestionEsm2 setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [howlongMultiQuestionEsm2 setObject:[NSNumber numberWithInt:8] forKey:@"ordinal"];
            [howlongMultiQuestionEsm2 setObject:@"How long will this journey last (approx)?" forKey:@"question"];
            NSMutableDictionary *howlongMultiQuestionOption1Esm2 = [[NSMutableDictionary alloc] init];
            [howlongMultiQuestionOption1Esm2 setObject:@"MultiOption" forKey:@"type"];
            [howlongMultiQuestionOption1Esm2 setObject:@"0-5" forKey:@"value"];
            [howlongMultiQuestionOption1Esm2 setObject: [NSNumber numberWithShort:0] forKey:@"ordinal"];
            NSMutableDictionary *howlongMultiQuestionOption2Esm2 = [[NSMutableDictionary alloc] init];
            [howlongMultiQuestionOption2Esm2 setObject:@"MultiOption" forKey:@"type"];
            [howlongMultiQuestionOption2Esm2 setObject:@"6-10" forKey:@"value"];
              [howlongMultiQuestionOption2Esm2 setObject: [NSNumber numberWithShort:1] forKey:@"ordinal"];
            NSMutableDictionary *howlongMultiQuestionOption3Esm2 = [[NSMutableDictionary alloc] init];
            [howlongMultiQuestionOption3Esm2 setObject:@"MultiOption" forKey:@"type"];
            [howlongMultiQuestionOption3Esm2 setObject:@"11-15" forKey:@"value"];
               [howlongMultiQuestionOption3Esm2 setObject: [NSNumber numberWithShort:2] forKey:@"ordinal"];
            NSMutableDictionary *howlongMultiQuestionOption4Esm2 = [[NSMutableDictionary alloc] init];
            [howlongMultiQuestionOption4Esm2 setObject:@"MultiOption" forKey:@"type"];
            [howlongMultiQuestionOption4Esm2 setObject:@"16-20" forKey:@"value"];
             [howlongMultiQuestionOption4Esm2 setObject: [NSNumber numberWithShort:3] forKey:@"ordinal"];
            NSMutableDictionary *howlongMultiQuestionOption5Esm2 = [[NSMutableDictionary alloc] init];
            [howlongMultiQuestionOption5Esm2 setObject:@"MultiOption" forKey:@"type"];
            [howlongMultiQuestionOption5Esm2 setObject:@"More than 20" forKey:@"value"];
               [howlongMultiQuestionOption5Esm2 setObject: [NSNumber numberWithShort:4] forKey:@"ordinal"];
            NSMutableSet *howlongMultiQuestionmultioptionsEsm2 = [NSMutableSet setWithObjects:howlongMultiQuestionOption1Esm2, howlongMultiQuestionOption2Esm2,howlongMultiQuestionOption3Esm2,howlongMultiQuestionOption4Esm2, howlongMultiQuestionOption5Esm2, nil];
            [howlongMultiQuestionEsm2 setObject:howlongMultiQuestionmultioptionsEsm2 forKey:@"options"];
            
            NSMutableDictionary *activityMultiQuestionEsm2 = [[NSMutableDictionary alloc] init];
            [activityMultiQuestionEsm2 setObject:@"SurveyMultiOptionQuestion" forKey:@"type"];
            [activityMultiQuestionEsm2 setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [activityMultiQuestionEsm2 setObject:[NSNumber numberWithInt:9] forKey:@"ordinal"];
            [activityMultiQuestionEsm2 setObject:@"Are you doing anything on the journey?" forKey:@"question"];
            NSMutableDictionary *activityMultiQuestionOption1Esm2 = [[NSMutableDictionary alloc] init];
            [activityMultiQuestionOption1Esm2 setObject:@"MultiOption" forKey:@"type"];
            [activityMultiQuestionOption1Esm2 setObject:@"Nothing" forKey:@"value"];
              [activityMultiQuestionOption1Esm2 setObject: [NSNumber numberWithShort:0] forKey:@"ordinal"];
            NSMutableDictionary *activityMultiQuestionOption2Esm2 = [[NSMutableDictionary alloc] init];
            [activityMultiQuestionOption2Esm2 setObject:@"MultiOption" forKey:@"type"];
            [activityMultiQuestionOption2Esm2 setObject:@"Reading" forKey:@"value"];
               [activityMultiQuestionOption2Esm2 setObject: [NSNumber numberWithShort:1] forKey:@"ordinal"];
            NSMutableDictionary *activityMultiQuestionOption3Esm2 = [[NSMutableDictionary alloc] init];
            [activityMultiQuestionOption3Esm2 setObject:@"MultiOption" forKey:@"type"];
            [activityMultiQuestionOption3Esm2 setObject:@"Listening to Music" forKey:@"value"];
               [activityMultiQuestionOption3Esm2 setObject: [NSNumber numberWithShort:2] forKey:@"ordinal"];
            NSMutableDictionary *activityMultiQuestionOption4Esm2 = [[NSMutableDictionary alloc] init];
            [activityMultiQuestionOption4Esm2 setObject:@"MultiOption" forKey:@"type"];
            [activityMultiQuestionOption4Esm2 setObject:@"In Conversation" forKey:@"value"];
               [activityMultiQuestionOption4Esm2 setObject: [NSNumber numberWithShort:3] forKey:@"ordinal"];
            NSMutableDictionary *activityMultiQuestionOption5Esm2 = [[NSMutableDictionary alloc] init];
            [activityMultiQuestionOption5Esm2 setObject:@"MultiOption" forKey:@"type"];
            [activityMultiQuestionOption5Esm2 setObject:@"Social Networking" forKey:@"value"];
               [activityMultiQuestionOption5Esm2 setObject: [NSNumber numberWithShort:4] forKey:@"ordinal"];
            NSMutableDictionary *activityMultiQuestionOption6Esm2 = [[NSMutableDictionary alloc] init];
            [activityMultiQuestionOption6Esm2 setObject:@"MultiOption" forKey:@"type"];
            [activityMultiQuestionOption6Esm2 setObject:@"Other" forKey:@"value"];
               [activityMultiQuestionOption6Esm2 setObject: [NSNumber numberWithShort:5] forKey:@"ordinal"];
            NSMutableSet *activityMultiQuestionmultioptionsEsm2 = [NSMutableSet setWithObjects:activityMultiQuestionOption1Esm2, activityMultiQuestionOption2Esm2,activityMultiQuestionOption3Esm2,activityMultiQuestionOption4Esm2, activityMultiQuestionOption5Esm2,activityMultiQuestionOption6Esm2, nil];
            [activityMultiQuestionEsm2 setObject:activityMultiQuestionmultioptionsEsm2 forKey:@"options"];
            
            NSMutableSet *questionsEsm2 = [NSMutableSet setWithObjects:happylikertQuestionEsm2,tiredlikertQuestionEsm2,contentlikertQuestionEsm2,stressedlikertQuestionEsm2,inpatientlikertQuestionEsm2,worthwhilelikertQuestionEsm2, companyMultiQuestionEsm2,howlongMultiQuestionEsm2,activityMultiQuestionEsm2, nil];
            [jnyToFromForm setObject:questionsEsm2 forKey:@"questions"];
            
            //Survey Trigger
            NSMutableDictionary *spatialTriggerEsm2 = [[NSMutableDictionary alloc] init];
            [spatialTriggerEsm2 setObject:@"SpatialTrigger" forKey:@"type"];
            [spatialTriggerEsm2 setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [spatialTriggerEsm2 setObject:[NSNumber numberWithShort:1] forKey:@"state"];
            [spatialTriggerEsm2 setObject:[NSNumber numberWithDouble:14.041865] forKey:@"latitude"];
            [spatialTriggerEsm2 setObject:[NSNumber numberWithDouble:-2.796493] forKey:@"longitude"];
            [spatialTriggerEsm2 setObject:[NSNumber numberWithDouble:282.0] forKey:@"radius"];
            [spatialTriggerEsm2 setObject:@"Pointer Roundabout, Lancaster, UK" forKey:@"placename"];
            NSMutableSet *triggersEsm2 = [NSMutableSet setWithObjects:spatialTriggerEsm2, nil];
            [jnyToFromForm setObject:triggersEsm2 forKey:@"triggers"];
            
            //--------------------------SURVEY-END-----------------------------------------------
            
            //----------------------ESM-AFTERNOON-SURVEY-START-----------------------------------
            //Morning Work Survey
            NSMutableDictionary *eveningform = [[NSMutableDictionary alloc] init];
            [eveningform setObject:@"SurveyForm" forKey:@"type"];
            [eveningform setObject:@"b9e92153-8430-40be-8f66-16b175ec75dc" forKey:@"identifier"];
            [eveningform setObject:[NSNumber numberWithInt:0] forKey:@"state"];
            [eveningform setObject:@"Non-Work Evening Survey" forKey:@"title"];
            
            NSMutableDictionary *workactivityMultiQuestionEsm2 = [[NSMutableDictionary alloc] init];
            [workactivityMultiQuestionEsm2 setObject:@"SurveyMultiOptionQuestion" forKey:@"type"];
            [workactivityMultiQuestionEsm2 setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [workactivityMultiQuestionEsm2 setObject:[NSNumber numberWithInt:1] forKey:@"ordinal"];
            [workactivityMultiQuestionEsm2 setObject:@"What activity are you currently engaged in?" forKey:@"question"];
            NSMutableDictionary *workactivityMultiQuestionOption1Esm2 = [[NSMutableDictionary alloc] init];
            [workactivityMultiQuestionOption1Esm2 setObject:@"MultiOption" forKey:@"type"];
            [workactivityMultiQuestionOption1Esm2 setObject:@"Leisure Activity Alone" forKey:@"value"];
               [workactivityMultiQuestionOption1Esm2 setObject: [NSNumber numberWithShort:0] forKey:@"ordinal"];
            NSMutableDictionary *workactivityMultiQuestionOption2Esm2 = [[NSMutableDictionary alloc] init];
            [workactivityMultiQuestionOption2Esm2 setObject:@"MultiOption" forKey:@"type"];
            [workactivityMultiQuestionOption2Esm2 setObject:@"Leisure Activity With Others" forKey:@"value"];
                [workactivityMultiQuestionOption2Esm2 setObject: [NSNumber numberWithShort:1] forKey:@"ordinal"];
            NSMutableDictionary *workactivityMultiQuestionOption3Esm2 = [[NSMutableDictionary alloc] init];
            [workactivityMultiQuestionOption3Esm2 setObject:@"MultiOption" forKey:@"type"];
            [workactivityMultiQuestionOption3Esm2 setObject:@"Working Alone" forKey:@"value"];
                [workactivityMultiQuestionOption3Esm2 setObject: [NSNumber numberWithShort:2] forKey:@"ordinal"];
            NSMutableDictionary *workactivityMultiQuestionOption4Esm2 = [[NSMutableDictionary alloc] init];
            [workactivityMultiQuestionOption4Esm2 setObject:@"MultiOption" forKey:@"type"];
            [workactivityMultiQuestionOption4Esm2 setObject:@"Working With Others" forKey:@"value"];
                [workactivityMultiQuestionOption4Esm2 setObject: [NSNumber numberWithShort:3] forKey:@"ordinal"];
            NSMutableDictionary *workactivityMultiQuestionOption5Esm2 = [[NSMutableDictionary alloc] init];
            [workactivityMultiQuestionOption5Esm2 setObject:@"MultiOption" forKey:@"type"];
            [workactivityMultiQuestionOption5Esm2 setObject:@"Other" forKey:@"value"];
                [workactivityMultiQuestionOption5Esm2 setObject: [NSNumber numberWithShort:4] forKey:@"ordinal"];
            NSMutableSet *workactivityMultiQuestionmultioptionsEsm2 = [NSMutableSet setWithObjects:workactivityMultiQuestionOption1Esm2, workactivityMultiQuestionOption2Esm2,workactivityMultiQuestionOption3Esm2,workactivityMultiQuestionOption4Esm2, workactivityMultiQuestionOption5Esm2, nil];
            [workactivityMultiQuestionEsm2 setObject:workactivityMultiQuestionmultioptionsEsm2 forKey:@"options"];
            
            //Happiness Likert Question
            NSMutableDictionary *morninghappylikertQuestionEsm2 = [[NSMutableDictionary alloc] init];
            [morninghappylikertQuestionEsm2 setObject:@"SurveyLikertQuestion" forKey:@"type"];
            [morninghappylikertQuestionEsm2 setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [morninghappylikertQuestionEsm2 setObject:[NSNumber numberWithInt:2] forKey:@"ordinal"];
            [morninghappylikertQuestionEsm2 setObject:@"Very Happy" forKey:@"high_end_descriptor"];
            [morninghappylikertQuestionEsm2 setObject:@"Not At All" forKey:@"low_end_descriptor"];
            [morninghappylikertQuestionEsm2 setObject:@"How happy do you currently feel?" forKey:@"question"];
            [morninghappylikertQuestionEsm2 setObject:likertOptions forKey:@"options"];
            
            //Happiness Likert Question
            NSMutableDictionary *morningtiredlikertQuestionEsm2 = [[NSMutableDictionary alloc] init];
            [morningtiredlikertQuestionEsm2 setObject:@"SurveyLikertQuestion" forKey:@"type"];
            [morningtiredlikertQuestionEsm2 setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [morningtiredlikertQuestionEsm2 setObject:[NSNumber numberWithInt:3] forKey:@"ordinal"];
            [morningtiredlikertQuestionEsm2 setObject:@"Very Tired" forKey:@"high_end_descriptor"];
            [morningtiredlikertQuestionEsm2 setObject:@"Not At All" forKey:@"low_end_descriptor"];
            [morningtiredlikertQuestionEsm2 setObject:@"How tired do you currently feel?" forKey:@"question"];
            [morningtiredlikertQuestionEsm2 setObject:likertOptions forKey:@"options"];
            
            //content Likert Question
            NSMutableDictionary *morningcontentlikertQuestionEsm2 = [[NSMutableDictionary alloc] init];
            [morningcontentlikertQuestionEsm2 setObject:@"SurveyLikertQuestion" forKey:@"type"];
            [morningcontentlikertQuestionEsm2 setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [morningcontentlikertQuestionEsm2 setObject:[NSNumber numberWithInt:4] forKey:@"ordinal"];
            [morningcontentlikertQuestionEsm2 setObject:@"Very Content" forKey:@"high_end_descriptor"];
            [morningcontentlikertQuestionEsm2 setObject:@"Not At All" forKey:@"low_end_descriptor"];
            [morningcontentlikertQuestionEsm2 setObject:@"How content do you currently feel?" forKey:@"question"];
            [morningcontentlikertQuestionEsm2 setObject:likertOptions forKey:@"options"];
            
            //stressed Likert Question
            NSMutableDictionary *morningstressedlikertQuestionEsm2 = [[NSMutableDictionary alloc] init];
            [morningstressedlikertQuestionEsm2 setObject:@"SurveyLikertQuestion" forKey:@"type"];
            [morningstressedlikertQuestionEsm2 setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [morningstressedlikertQuestionEsm2 setObject:[NSNumber numberWithInt:5] forKey:@"ordinal"];
            [morningstressedlikertQuestionEsm2 setObject:@"Very Stressed" forKey:@"high_end_descriptor"];
            [morningstressedlikertQuestionEsm2 setObject:@"Not At All" forKey:@"low_end_descriptor"];
            [morningstressedlikertQuestionEsm2 setObject:@"How stressed do you currently feel?" forKey:@"question"];
            [morningstressedlikertQuestionEsm2 setObject:likertOptions forKey:@"options"];
            
            //stressed Likert Question
            NSMutableDictionary *morninginpatientlikertQuestionEsm2 = [[NSMutableDictionary alloc] init];
            [morninginpatientlikertQuestionEsm2 setObject:@"SurveyLikertQuestion" forKey:@"type"];
            [morninginpatientlikertQuestionEsm2 setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [morninginpatientlikertQuestionEsm2 setObject:[NSNumber numberWithInt:6] forKey:@"ordinal"];
            [morninginpatientlikertQuestionEsm2 setObject:@"Very Inpatient" forKey:@"high_end_descriptor"];
            [morninginpatientlikertQuestionEsm2 setObject:@"Not At All" forKey:@"low_end_descriptor"];
            [morninginpatientlikertQuestionEsm2 setObject:@"Are you inpatient for this current activity to end?" forKey:@"question"];
            [morninginpatientlikertQuestionEsm2 setObject:likertOptions forKey:@"options"];
            
            //worthwhile Likert Question
            NSMutableDictionary *morningworthwhilelikertQuestionEsm2 = [[NSMutableDictionary alloc] init];
            [morningworthwhilelikertQuestionEsm2 setObject:@"SurveyLikertQuestion" forKey:@"type"];
            [morningworthwhilelikertQuestionEsm2 setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [morningworthwhilelikertQuestionEsm2 setObject:[NSNumber numberWithInt:6] forKey:@"ordinal"];
            [morningworthwhilelikertQuestionEsm2 setObject:@"Very Worthwhile" forKey:@"high_end_descriptor"];
            [morningworthwhilelikertQuestionEsm2 setObject:@"Not At All" forKey:@"low_end_descriptor"];
            [morningworthwhilelikertQuestionEsm2 setObject:@"Do you feel this current activity is worthwhile?" forKey:@"question"];
            [morningworthwhilelikertQuestionEsm2 setObject:likertOptions forKey:@"options"];
            
            NSMutableDictionary *morninghowlongMultiQuestionEsm2 = [[NSMutableDictionary alloc] init];
            [morninghowlongMultiQuestionEsm2 setObject:@"SurveyMultiOptionQuestion" forKey:@"type"];
            [morninghowlongMultiQuestionEsm2 setObject:[[Guid getInstance] newGuid] forKey:@"identifier"];
            [morninghowlongMultiQuestionEsm2 setObject:[NSNumber numberWithInt:8] forKey:@"ordinal"];
            [morninghowlongMultiQuestionEsm2 setObject:@"How long will this activity last (approx)?" forKey:@"question"];
            NSMutableDictionary *morninghowlongMultiQuestionOption1Esm2 = [[NSMutableDictionary alloc] init];
            [morninghowlongMultiQuestionOption1Esm2 setObject:@"MultiOption" forKey:@"type"];
            [morninghowlongMultiQuestionOption1Esm2 setObject:@"0-5" forKey:@"value"];
                [morninghowlongMultiQuestionOption1Esm2 setObject: [NSNumber numberWithShort:0] forKey:@"ordinal"];
            NSMutableDictionary *morninghowlongMultiQuestionOption2Esm2 = [[NSMutableDictionary alloc] init];
            [morninghowlongMultiQuestionOption2Esm2 setObject:@"MultiOption" forKey:@"type"];
            [morninghowlongMultiQuestionOption2Esm2 setObject:@"6-10" forKey:@"value"];
              [morninghowlongMultiQuestionOption2Esm2 setObject: [NSNumber numberWithShort:1] forKey:@"ordinal"];
            NSMutableDictionary *morninghowlongMultiQuestionOption3Esm2 = [[NSMutableDictionary alloc] init];
            [morninghowlongMultiQuestionOption3Esm2 setObject:@"MultiOption" forKey:@"type"];
            [morninghowlongMultiQuestionOption3Esm2 setObject:@"11-15" forKey:@"value"];
              [morninghowlongMultiQuestionOption3Esm2 setObject: [NSNumber numberWithShort:2] forKey:@"ordinal"];
            NSMutableDictionary *morninghowlongMultiQuestionOption4Esm2 = [[NSMutableDictionary alloc] init];
            [morninghowlongMultiQuestionOption4Esm2 setObject:@"MultiOption" forKey:@"type"];
            [morninghowlongMultiQuestionOption4Esm2 setObject:@"16-20" forKey:@"value"];
              [morninghowlongMultiQuestionOption4Esm2 setObject: [NSNumber numberWithShort:3] forKey:@"ordinal"];
            NSMutableDictionary *morninghowlongMultiQuestionOption5Esm2 = [[NSMutableDictionary alloc] init];
            [morninghowlongMultiQuestionOption5Esm2 setObject:@"MultiOption" forKey:@"type"];
            [morninghowlongMultiQuestionOption5Esm2 setObject:@"More than 20" forKey:@"value"];
              [morninghowlongMultiQuestionOption5Esm2 setObject: [NSNumber numberWithShort:4] forKey:@"ordinal"];
            NSMutableSet *morninghowlongMultiQuestionmultioptionsEsm2 = [NSMutableSet setWithObjects:morninghowlongMultiQuestionOption1Esm2, morninghowlongMultiQuestionOption2Esm2,morninghowlongMultiQuestionOption3Esm2,morninghowlongMultiQuestionOption4Esm2, morninghowlongMultiQuestionOption5Esm2, nil];
            [morninghowlongMultiQuestionEsm2 setObject:morninghowlongMultiQuestionmultioptionsEsm2 forKey:@"options"];
            
            NSMutableSet *morningquestionsEsm2 = [NSMutableSet setWithObjects:workactivityMultiQuestionEsm2, morninghappylikertQuestionEsm2,morningtiredlikertQuestionEsm2,morningcontentlikertQuestionEsm2,morningstressedlikertQuestionEsm2,morninginpatientlikertQuestionEsm2,morningworthwhilelikertQuestionEsm2,morninghowlongMultiQuestionEsm2, nil];
            [eveningform setObject:morningquestionsEsm2 forKey:@"questions"];
            
            //Survey Trigger
            NSMutableDictionary *temporalTriggerEsm2 = [[NSMutableDictionary alloc] init];
            [temporalTriggerEsm2 setObject:@"TemporalTrigger" forKey:@"type"];
            [temporalTriggerEsm2 setObject:[[Guid getInstance]newGuid] forKey:@"identifier"];
            [temporalTriggerEsm2 setObject:[NSNumber numberWithShort:1] forKey:@"state"];
            [temporalTriggerEsm2 setObject:[NSNumber numberWithLong:(60 * 5)] forKey:@"duration"];
            [temporalTriggerEsm2 setObject:[baseDate dateByAddingTimeInterval:(60 * 60 * 12)] forKey:@"activation_time"];
            NSMutableSet *morningtriggersEsm2 = [NSMutableSet setWithObjects:temporalTriggerEsm2, nil]; // 6th 8pm
            [eveningform setObject:morningtriggersEsm2 forKey:@"triggers"];
            
            //-----------------------------------ESM AFTERNOON SURVEY------------------------------------------

            //NSMutableSet *surveys = [NSMutableSet setWithObjects:jnyToWorkForm,atworkform, nil];
            NSMutableSet *surveys = [NSMutableSet setWithObjects:jnyToWorkForm, atworkform,eveningform, nil];
            [project setObject:surveys forKey:@"surveys"];
            Project *projectEntity = (Project*)[ExtendedManagedObject createManagedObjectFromDictionary:project inContext:[self managedObjectContext]];
            
            
            NSDictionary *projectdict = [projectEntity toDictionary];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:projectdict options:nil error:nil];
            NSString *jsonItemsAsString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            //////////NSLog(@"%@",jsonItemsAsString);
            

            NSError *error;
            if(![self.managedObjectContext save:&error])
            {
                //////////NSLog(@"Error when saving new feed items");
            }
            
            [defaults setBool:YES forKey:@"trial_config"];
            [defaults synchronize];
        }*/

    }
    
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:(60 * 60 * 8)];
  
    
    return YES;
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSFetchRequest *fetchSurveyRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityform = [NSEntityDescription entityForName:@"SurveyForm" inManagedObjectContext:[self managedObjectContext]];
    [fetchSurveyRequest setEntity:entityform];
   
    NSError *error = nil;
    NSArray *surveys = [[self managedObjectContext] executeFetchRequest:fetchSurveyRequest error:&error];
    
    //NSLog(@"survey count: %lu", (unsigned long)[surveys count]);
    
    for(SurveyForm *form in surveys)
    {
        [form activateForm];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}


-(void) cancelSurveyLocalNotifications:(NSString*)surveyID withTrigger:(NSString*)triggerID
{
    for(UILocalNotification *localNoticfication in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        NSDictionary *info = localNoticfication.userInfo;
        
        ////////NSLog(@"comparing surveyID:%@ with:%@",surveyID, [info objectForKey:@"survey-form-id"]);
    
        if([[info objectForKey:@"survey-form-id"] isEqualToString:surveyID] && [[info objectForKey:@"survey-trigger-id"] isEqualToString:triggerID])
        {
            //////NSLog(@"Cancelling Notification For Survey:%@", surveyID);
            [[UIApplication sharedApplication] cancelLocalNotification:localNoticfication];
        }
    }
}


-(void) cancelAllSurveyLocalNotifications
{
    for(UILocalNotification *localNoticfication in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        [[UIApplication sharedApplication] cancelLocalNotification:localNoticfication];
    }
}





- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    //////NSLog(@"didReceiveLocalNotification triggered..handling request.");
    
    /*UIApplicationState applicationState = application.applicationState;
    if (applicationState == UIApplicationStateBackground) {
        [application presentLocalNotificationNow:notification];
    }*/
    
    //use identifier to get surveyform
    NSFetchRequest *fetchSurveyRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityform = [NSEntityDescription entityForName:@"SurveyForm" inManagedObjectContext:[self managedObjectContext]];
    [fetchSurveyRequest setEntity:entityform];
    [fetchSurveyRequest setFetchLimit:1];
    NSDictionary *info = notification.userInfo;
    
    //////////NSLog(@"didReceiveLocalNotification:%@", [info objectForKey:@"survey-form-id"]);
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"identifier == %@",[info objectForKey:@"survey-form-id"]];
    [fetchSurveyRequest setPredicate:predicate1];
     NSError *error;
    NSArray *surveys = [[self managedObjectContext] executeFetchRequest:fetchSurveyRequest error:&error];
    
    ////////NSLog(@"notification response event");
    
    if(surveys.count > 0)
    {
        SurveyForm *form = [surveys objectAtIndex:0];
        [form validateForm];
        
        //////NSLog(@"Found related survey: %@",[info objectForKey:@"survey-form-id"]);
        
        for(Trigger *trigger in form.triggers)
        {
            if([trigger.identifier isEqualToString:[info objectForKey:@"survey-trigger-id"]])
            {
            
                if(trigger.state.intValue == Available || (trigger.state.intValue == Active && trigger.children.count == 0))
                {
                    RECAPPMainViewController *recapp = nil;
               
                    if(!self.window.rootViewController)
                    {
              
                        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
                        UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
                        recapp = [storybord instantiateViewControllerWithIdentifier:@"xprmain"];
                        
                        self.window.rootViewController = recapp;
                        [self.window makeKeyAndVisible];
                    }
                    else
                    {
                        [self.window makeKeyAndVisible];
                        recapp = (RECAPPMainViewController*) self.window.rootViewController;
                    }
                    
                    NSNumber *ordinal = [info objectForKey:@"survey-question-ordinal"];
                    
                    [recapp displaySurveyForm:form forTrigger:[info objectForKey:@"survey-trigger-id"]];
                }
                else if(trigger.state.intValue == Expired)
                {
                    [[AlertsManager getInstance] surveyExpiredAlready];
                }

                break;
            }
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if([self managedObjectContext].hasChanges)
    {
        [self dirtyMOCSave];
    }
}

-(void)applicationWillTerminate:(UIApplication *)application
{
    if([self managedObjectContext].hasChanges)
    {
        [self dirtyMOCSave];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)initializeLocationManager {
    
    if(![CLLocationManager locationServicesEnabled]) {
        [[AlertsManager getInstance] noLocationServices];
        return;
    }
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLLocationAccuracyBest;
    
    
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
       // [_locationManager requestWhenInUseAuthorization];
    }
    
    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
       // [_locationManager requestAlwaysAuthorization];
    }
 
}

-(void)createMonitoredRegion:(CLRegion*)region withID:(NSString *)complexid
{
    if(![CLLocationManager regionMonitoringAvailable]) {
        [[AlertsManager getInstance] noLocationRegionServices];
        return;
    }
    
    BOOL doesExist = FALSE;
    
    NSArray *regions = [_locationManager.monitoredRegions allObjects];
    for(CLCircularRegion* region in regions)
    {
        if([complexid isEqualToString:region.identifier])
        {
            doesExist = TRUE;
        }
    }
    
    //if(!doesExist)
    //{
          [_locationManager startMonitoringForRegion:region];
    //}
    
}

-(void)stopMonitoringRegion:(NSString*)complexID
{
    if(![CLLocationManager regionMonitoringAvailable]) {
        [[AlertsManager getInstance] noLocationRegionServices];
        return;
    }
    
    NSArray *regions = [_locationManager.monitoredRegions allObjects];
    for(CLCircularRegion* region in regions)
    {
        
        //////NSLog(@"%@ %@",complexID, region.identifier);
        
        if([complexID isEqualToString:region.identifier])
        {
            [_locationManager stopMonitoringForRegion:region];
            break;
        }
        
    }
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSArray *ids = [region.identifier componentsSeparatedByString:@":"];
    
    NSFetchRequest *fetchSurveyRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityform = [NSEntityDescription entityForName:@"SurveyForm" inManagedObjectContext:[self managedObjectContext]];
    [fetchSurveyRequest setEntity:entityform];
    [fetchSurveyRequest setFetchLimit:1];
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"identifier == %@",ids[0]];
    [fetchSurveyRequest setPredicate:predicate1];
    NSError *error;
    NSArray *surveys = [[self managedObjectContext] executeFetchRequest:fetchSurveyRequest error:&error];
    
    if(surveys.count > 0)
    {
        SurveyForm *trippedSurvey = [surveys objectAtIndex:0];
        
        //////NSLog(@"Survey %@ triggered",trippedSurvey.title);
        //////NSLog(@"Location Notification For Survey Tripped:%@", trippedSurvey.title);
        
        for(Trigger *trigger in trippedSurvey.triggers)
        {
            if([trigger.identifier isEqualToString:ids[1]])
            {
                SpatialTrigger *st = (SpatialTrigger*)trigger;
                st.lastTripTime = [NSDate date];
                [self dirtyMOCSave];
                
                [st validateTrigger];
                if(trigger.state.intValue == Available || (trigger.state.intValue == Active && trigger.children.count == 0))
                {
                    UILocalNotification *notification = [[UILocalNotification alloc] init];
                    notification.alertBody = @"A survey is available for you to complete";
                    notification.alertAction = @"Fill Out";
                    notification.fireDate = nil;
                  
                    notification.soundName = UILocalNotificationDefaultSoundName;
                    //////////NSLog(@"didEnterRegion:%@",region.identifier);
                    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:ids[0], @"survey-form-id",
                                              ids[1], @"survey-trigger-id",nil];
                    notification.userInfo = infoDict;
                    notification.timeZone = [NSTimeZone defaultTimeZone];
                    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
                }
                else
                {
                    st.lastTripTime = nil;
                }
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
     //////NSLog(@"didexitregion");
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
     //////NSLog(@"didstartregionmonitoring");
    NSArray *regions = [_locationManager.monitoredRegions allObjects];
    for(CLCircularRegion* region in regions)
    {
        //////NSLog(@"%f %f %f", region.center.latitude, region.center.longitude, region.radius );
        
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //NSDate *now = [NSDate date];
    ////////////NSLog(@"%@ %@",[DateTimeUtil JSON2StringFromNSDate:now], [DateTimeUtil adjustUTCtoLocalTimeZone:now]);
    
    [self initializeLocationManager];
    [FilledFormCache getInstance];
    
    /*CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(51.507351, -0.127758);
    CLLocationDistance regionRadius = 3000.0;
    CLCircularRegion *region = [[CLCircularRegion alloc] initCircularRegionWithCenter:centerCoordinate radius:regionRadius identifier:@"11"];
    region.notifyOnEntry = YES;
    region.notifyOnExit = YES;
    [self createMonitoredRegion:region withID:@"11"];*/
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults objectForKey:@"has_registered"] boolValue] == YES)
    {
        [[FilledFormCache getInstance] updateStudiesList];
    }
    
    for(UILocalNotification *localNoticfication in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        NSDictionary *info = localNoticfication.userInfo;
        //////NSLog(@"Notification Roster: Survey:%@ to fire at:%@",[info objectForKey:@"survey-form-id"],localNoticfication.fireDate);
    }
    
    /*FilledSurveyForm *filledForm = (FilledSurveyForm *)[NSEntityDescription insertNewObjectForEntityForName:@"FilledSurveyForm" inManagedObjectContext:[self managedObjectContext]];
    
    SurveyLikertQuestion *newLikertQ = (SurveyLikertQuestion *)[NSEntityDescription insertNewObjectForEntityForName:@"SurveyLikertQuestion" inManagedObjectContext:[self managedObjectContext]];
    [newLikertQ setQuestion:@"dd"];
    NSMutableSet *set = [NSMutableSet setWithObject:newLikertQ];
    [filledForm setCompleted_questions:set];
    filledForm.completed = [NSDate date];
    filledForm.form_identifier = @"1";
    filledForm.not_filled = [NSNumber numberWithShort:0];
    filledForm.sync = @"1";
    //filledForm.creator = [[CurrentUser getInstance] getUser];
    
    [self dirtyMOCSave];*/
}



-(void)resetPersistentStore
{
    @try
    {
        
       
        NSArray *stores = [persistentStoreCoordinator persistentStores];
        
        for(NSPersistentStore *store in stores) {
            [persistentStoreCoordinator removePersistentStore:store error:nil];
            [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:nil];
        }
        
        persistentStoreCoordinator = nil;
       
    }
    @catch (NSException *exception) {
        
    }
}

-(void)dirtyMOCSave
{
    NSError *error;
    
    
    //////////NSLog(@"AppDelegate: save on MOC");
    if(![[self managedObjectContext] save:&error]){
        //////////NSLog(@"Error when doing a dirty save on MOC");
    }
}




#pragma mark Core Data stack

// Returns the path to the application's documents directory.
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
//
- (NSManagedObjectContext *)managedObjectContext {
    
    //////////////NSLog(@"valled");
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [NSManagedObjectContext new];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    //////////////NSLog(@"moc listening");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_mocDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
    
    return managedObjectContext;
}

- (void)_mocDidSaveNotification:(NSNotification *)notification
{
    //////////////NSLog(@"in moc did save");
    
    NSManagedObjectContext *savedContext = [notification object];
    
    // ignore change notifications for the main MOC
    if (managedObjectContext == savedContext)
    {
        return;
    }
    
    if (managedObjectContext.persistentStoreCoordinator != savedContext.persistentStoreCoordinator)
    {
        // that's another database
        return;
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
        [[UISignalBox getInstance] update];
    });
}


// Returns the managed object model for the application.
// If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
//
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it
//
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    @synchronized(self)
    {
        //////////NSLog(@"1 if main:%d", [NSThread isMainThread]);
        
        if (persistentStoreCoordinator != nil) {
            return persistentStoreCoordinator;
        }
        
        NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"RECAPP.sqlite"];
        
        // set up the backing store
        NSFileManager *fileManager = [NSFileManager defaultManager];
        // If the expected store doesn't exist, copy the default store.
        if (![fileManager fileExistsAtPath:storePath]) {
            NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"RECAPP" ofType:@"sqlite"];
            if (defaultStorePath) {
                [fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
            }
        }
        
        NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
        
        NSError *error;
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
        
        if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
          
            //////NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
       
        }
        
        return persistentStoreCoordinator;
    }
}

@end
