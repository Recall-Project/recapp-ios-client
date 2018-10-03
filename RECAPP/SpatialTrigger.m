//
//  SpatialTrigger.m
//  RECAPP
//
//  Created by RECAPP Developer on 07/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import "SpatialTrigger.h"
#import "AppDelegate.h"
#import "SurveyForm.h"
#import "TemporalTrigger.h"


@implementation SpatialTrigger

@dynamic latitude;
@dynamic longitude;
@dynamic radius;
@dynamic lastTripTime;
@dynamic placename;

-(void)activateTrigger
{    
    if(self.state.intValue != Expired)
    {
        self.state = [NSNumber numberWithInt:Active];
        CLLocationDegrees latitude = [self.latitude doubleValue];
        CLLocationDegrees longitude =[self.longitude doubleValue];
        
        //////NSLog(@"%.20f %.20f", latitude,longitude );
        
        CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        CLLocationDistance regionRadius = [self.radius doubleValue];
        NSString *complexID = [NSString stringWithFormat:@"%@:%@", self.survey.identifier, self.identifier];
        CLCircularRegion *region = [[CLCircularRegion alloc] initCircularRegionWithCenter:centerCoordinate radius:regionRadius identifier:complexID];
        
        region.notifyOnEntry = YES;
        region.notifyOnExit = YES;
        
        AppDelegate *ad = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [ad createMonitoredRegion:region withID:complexID];
    }
}

-(void)validateTrigger
{
    int childrenExpired = 0;
    int childrenAvailable = 0;
     int childrenActive = 0;
    
    self.state = [NSNumber numberWithInt:InActive];
    
    bool hasKids = false;
    
    for(Trigger *child in self.children)
    {
        hasKids = true;
        if([child isKindOfClass:[TemporalTrigger class]])
        {
            [child validateTrigger];
            if(child.state.intValue == Expired)
            {
                childrenExpired++;
            }
            else if(child.state.intValue == Available)
            {
                childrenAvailable++;
            }
            else if(child.state.intValue == Active)
            {
                childrenActive++;
            }
        }
    }
    
    if(self.lastTripTime)
    {
        NSDate *now = [NSDate date];
        
        //////NSLog(@"now:%@ trip:%@", now, self.lastTripTime);
        if([now compare:[self.lastTripTime dateByAddingTimeInterval:(60.0 * 20.0)]] == NSOrderedAscending)
        {
            //now is earlier so keep as available
            if(self.state.intValue != Completed)
            {
                //self.state = [NSNumber numberWithShort:Available];
                
                if(childrenAvailable > 0)
                {
                    self.state = [NSNumber numberWithShort:Available];
                }
                else
                {
                    self.state = [NSNumber numberWithShort:Active];
                }
            }
            else
            {
                self.lastTripTime = nil;
                self.state = [NSNumber numberWithShort:Active];
            }
        }
        else
        {
    
            self.state = [NSNumber numberWithShort:Active];
        }
    }
    else
    {
        if(childrenActive > 0 || childrenAvailable > 0 || self.children.count == 0)
        {
            self.state = [NSNumber numberWithShort:Active];
        }
    }
    
    
    
    if (childrenExpired == self.children.count && hasKids)
    {
        self.state = [NSNumber numberWithShort:Expired];
    }
    
    ////////NSLog(@"%@ Journey validated to %d",self.identifier, self.state.intValue);
}


-(void)refresh
{
    [self disableTrigger];
    [self validateTrigger];
    [self activateTrigger];
}

-(void)disableTrigger
{
    NSString *complexID = [NSString stringWithFormat:@"%@:%@", self.survey.identifier, self.identifier];
    AppDelegate *ad = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [ad stopMonitoringRegion:complexID];
}

-(void)completeTrigger
{
    if(self.children.count > 0)
    {
        for(Trigger *child in self.children)
        {
            if([child isKindOfClass:[TemporalTrigger class]])
            {
                [child validateTrigger];
                if([child.state intValue] == Available)
                {
                    [child completeTrigger];
                }
            }
        }
    }
   
    self.state = [NSNumber numberWithShort:Completed]; //keep it alive continuously if no times specified
}


@end
