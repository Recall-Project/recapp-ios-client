//
//  TemporalTrigger.h
//  RECAPP
//
//  Created by RECAPP Developer on 07/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Trigger.h"


@interface TemporalTrigger : Trigger

@property (nonatomic, retain) NSDate * activation_time;
@property (nonatomic, retain) NSString * display_rate;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * interval;

-(NSDate*) slidingActivationTime;

@end
