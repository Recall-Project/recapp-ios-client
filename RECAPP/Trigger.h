//
//  Trigger.h
//  RECAPP
//
//  Created by RECAPP Developer on 22/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ExtendedManagedObject.h"

@class SurveyForm, Trigger;

@interface Trigger : ExtendedManagedObject

typedef enum {
    InActive,
    Active,
    Available,
    Completed,
    Expired
} TriggerState;

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) SurveyForm *survey;
@property (nonatomic, retain) NSSet *children;

-(void)activateTrigger;
-(void)disableTrigger;
-(void)refresh;
-(void)completeTrigger;
-(void)validateTrigger;

@end

@interface Trigger (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(Trigger *)value;
- (void)removeChildrenObject:(Trigger *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end
