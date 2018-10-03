//
//  UISignalBox.m
//  RECAPP
//
//  Created by RECAPP Developer on 07/06/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import "UISignalBox.h"
#import "RECAPPMainViewController.h"
#import "AppDelegate.h"

@implementation UISignalBox

static UISignalBox *uiBox = nil;


-(id) init
{
    return self;
}

+(UISignalBox*) getInstance
{
    if(!uiBox)
    {
        uiBox = [[UISignalBox alloc] init];
    }
    
    return uiBox;
}

-(void)update
{
    AppDelegate *del = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    RECAPPMainViewController *mainView = (RECAPPMainViewController*) del.window.rootViewController;
    [mainView refreshSurveyListings];
    
    //////////NSLog(@"updating UI");
}

@end
