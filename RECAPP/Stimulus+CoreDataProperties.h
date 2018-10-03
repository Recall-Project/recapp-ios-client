//
//  Stimulus+CoreDataProperties.h
//  RECAPP
//
//  Created by RECAPP Developer on 17/11/2015.
//  Copyright © 2015 Lancaster University. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Stimulus.h"

NS_ASSUME_NONNULL_BEGIN

@interface Stimulus (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *identifier;
@property (nullable, nonatomic, retain) NSString *stimulus_question_identifier;
@property (nullable, nonatomic, retain) NSString *value;
@property (nullable, nonatomic, retain) NSString *ordinal;
@property (nullable, nonatomic, retain) StimulusAllocation *stimulus_alloc;

@end

NS_ASSUME_NONNULL_END
