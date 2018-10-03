//
//  StimulusAllocation.h
//  
//
//  Created by RECAPP Developer on 17/06/2015.
//
//

#import <Foundation/Foundation.h>
#import "ExtendedManagedObject.h"
#import <CoreData/CoreData.h>

@class NSManagedObject, StimulusStudy;

@interface StimulusAllocation : ExtendedManagedObject

@property (nonatomic, retain) NSString * trial_identifier;
@property (nonatomic, retain) NSString * trial_name;
@property (nonatomic, retain) NSString * stimulus_list_identifier;
@property (nonatomic, retain) NSSet *stimulus;
@property (nonatomic, retain) StimulusStudy *study;
@end

@interface StimulusAllocation (CoreDataGeneratedAccessors)

- (void)addStimulusObject:(NSManagedObject *)value;
- (void)removeStimulusObject:(NSManagedObject *)value;
- (void)addStimulus:(NSSet *)values;
- (void)removeStimulus:(NSSet *)values;

@end
