//
//  AlertsManager.h
//  OurTravel
//
//  Created by ecampus on 24/05/2010.
//  Copyright 2010 lancaster university. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertsManager : NSObject <UIAlertViewDelegate>{

	UIAlertView *alertView;
	
}
@property (nonatomic, strong) UIAlertView *alertView;
+(AlertsManager *) getInstance;

-(void) noLocationRegionServices;
-(void) noLocationServices;
-(void) registerIssue;
-(void) passwordMismatch;
-(void) pinInvalid;
-(void) completeSurvey;
-(void) surveyExpiredAlready;
-(void) pinExists;
-(void) missingUsername;

@end
