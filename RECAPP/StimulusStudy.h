//
//  StimulusStudy.h
//  
//
//  Created by RECAPP Developer on 17/06/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Project.h"

@class StimulusAllocation;

@interface StimulusStudy : Project

@property (nonatomic, retain) NSString * stimulus_pool_identifier;
@property (nonatomic, retain) NSString * default_question;
@property (nonatomic, retain) NSString * stimulus_pool;
@property (nonatomic, retain) NSSet *stimulus_alloc;

@end

@interface StimulusStudy (CoreDataGeneratedAccessors)

- (void)addStimulus_allocObject:(StimulusAllocation *)value;
- (void)removeStimulus_allocObject:(StimulusAllocation *)value;
- (void)addStimulus_alloc:(NSSet *)values;
- (void)removeStimulus_alloc:(NSSet *)values;

@end
