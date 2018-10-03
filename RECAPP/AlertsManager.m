//
//  AlertsManager.m
//  OurTravel
//
//  Created by ecampus on 24/05/2010.
//  Copyright 2010 lancaster university. All rights reserved.
//

#import "AlertsManager.h"
#import "AppDelegate.h"


@implementation AlertsManager

@synthesize alertView;

static AlertsManager *alertManager = nil;


-(id)init{
    
    
    return self;
}


+ (AlertsManager *) getInstance {
	
	@synchronized(self)
	{
		if(alertManager == nil){
			
			alertManager = [[AlertsManager alloc] init];
		}
		//////////////////NSLog@"returning alertmanager object");
		return alertManager;
	}
}



-(void) noLocationServices
{
    alertView = nil;
    alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
	alertView.title = @"RECAPP";
	alertView.tag = 001;
	alertView.message = @"You must enable location services before using this application";
	[alertView addButtonWithTitle:@"Ok"];
	
	if(![alertView isVisible])
    {
		[alertView show];
	}
}


-(void) noLocationRegionServices
{
    alertView = nil;
    alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
	alertView.title = @"RECAPP";
	alertView.tag = 002;
	alertView.message = @"You must enable region location services before using this application";
	[alertView addButtonWithTitle:@"Ok"];
	
	if(![alertView isVisible])
    {
		[alertView show];
	}
}

-(void) registerIssue
{
    alertView = nil;
    alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
	alertView.title = @"RECAPP";
	alertView.tag = 003;
	alertView.message = @"Could not complete login/registration. Please try again.";
	[alertView addButtonWithTitle:@"Ok"];
	
	if(![alertView isVisible])
    {
		[alertView show];
	}
}

-(void) passwordMismatch
{
    alertView = nil;
    alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
	alertView.title = @"RECAPP";
	alertView.tag = 004;
	alertView.message = @"Password does not match.";
	[alertView addButtonWithTitle:@"Ok"];
	
	if(![alertView isVisible])
    {
		[alertView show];
	}
}

-(void)pinInvalid
{
    alertView = nil;
    alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
	alertView.title = @"RECAPP";
	alertView.tag = 004;
	alertView.message = @"The entered pin is invalid. It must be a number with 4 to 8 digits.";
	[alertView addButtonWithTitle:@"Ok"];
	
	if(![alertView isVisible])
    {
		[alertView show];
	}
}

-(void)pinExists
{
    alertView = nil;
    alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
	alertView.title = @"RECAPP";
	alertView.tag = 004;
	alertView.message = @"The pin entered is associated with another user. Please try another one.";
	[alertView addButtonWithTitle:@"Ok"];
	
	if(![alertView isVisible])
    {
		[alertView show];
	}
}

-(void)missingUsername
{
    alertView = nil;
    alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
    alertView.title = @"RECAPP";
    alertView.tag = 004;
    alertView.message = @"Email or password are missing.";
    [alertView addButtonWithTitle:@"Ok"];
    
    if(![alertView isVisible])
    {
        [alertView show];
    }
}


-(void) completeSurvey
{
    alertView = nil;
    alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
	alertView.title = @"RECAPP";
	alertView.tag = 005;
	alertView.message = @"Please answer each question before finishing.";
	[alertView addButtonWithTitle:@"Ok"];
	
	if(![alertView isVisible])
    {
		[alertView show];
	}
}

-(void) surveyExpiredAlready
{
    alertView = nil;
    alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
	alertView.title = @"RECAPP";
	alertView.tag = 006;
	alertView.message = @"The survey information your trying to view has now expired.";
	[alertView addButtonWithTitle:@"Ok"];
	
	if(![alertView isVisible])
    {
		[alertView show];
	}
}





- (void)alertView:(UIAlertView *)theAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	NSInteger tagValue = theAlertView.tag;
	
	if(tagValue == 001 || tagValue == 002 || tagValue == 003 || tagValue == 004  || tagValue == 005 || tagValue == 006){ //notRegsitered Callback
	
		alertView = nil;
	}
}



@end
