//
//  SpatialTrigger.h
//  RECAPP
//
//  Created by RECAPP Developer on 07/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Trigger.h"

@interface SpatialTrigger : Trigger

@property (nonatomic, retain) NSDate * lastTripTime;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) NSString * placename;


@end
