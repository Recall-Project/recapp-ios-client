//
//  CurrentUser.m
//  Flooder
//
//  Created by RECAPP Developer on 09/04/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import "CurrentUser.h"
#import <AdSupport/AdSupport.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "User.h"


@implementation CurrentUser

static CurrentUser *userObj = nil;

+(CurrentUser*)getInstance
{
    if(!userObj)
    {
        userObj = [[CurrentUser alloc] init];
    }
    
    return userObj;
}

-(User*)getUser
{
    AppDelegate *ap = [[UIApplication sharedApplication] delegate];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"User" inManagedObjectContext:[ap managedObjectContext]];
    [fetchRequest setEntity:entityDesc];
    [fetchRequest setFetchLimit:1];
  
    NSError *error;
    NSArray *result = [[ap managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if(result.count > 0)
    {
        return [result objectAtIndex:0];
    }
    
    return nil;
}

-(BOOL)isRegistered
{
    if([self getUser])
    {
        return YES;
    }
    
    return NO;
}




@end
