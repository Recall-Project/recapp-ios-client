//
//  AppDelegate.h
//  RECAPP
//
//  Created by RECAPP Developer on 28/04/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) MBProgressHUD *HUD;

@property(nonatomic, strong) CLLocationManager * locationManager;

-(void)dirtyMOCSave;
-(void)createMonitoredRegion:(CLRegion*)region withID:(NSString*)complexid;
-(void)stopMonitoringRegion:(NSString*)complexID;
-(void) cancelSurveyLocalNotifications:(NSString*)surveyID withTrigger:(NSString*)triggerID;

-(void)showSpinner;
-(void)stopSpinner;
-(void)cancelAllSurveyLocalNotifications;
-(void)resetPersistentStore;
@end
