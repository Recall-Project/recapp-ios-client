//
//  FilledSurveyForm.h
//  RECAPP
//
//  Created by RECAPP Developer on 10/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ExtendedManagedObject.h"

@class SurveyQuestion;

@interface FilledSurveyForm : ExtendedManagedObject

@property (nonatomic, retain) NSDate * completed;
@property (nonatomic, retain) NSString * form_identifier;
@property (nonatomic, retain) NSString * form_name;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * sync;
@property (nonatomic, retain) NSNumber * not_filled;
@property (nonatomic, retain) NSSet *completed_questions;
@property (nonatomic, retain) NSString * user_identifier;


@end

@interface FilledSurveyForm (CoreDataGeneratedAccessors)

- (void)addCompleted_questionsObject:(SurveyQuestion *)value;
- (void)removeCompleted_questionsObject:(SurveyQuestion *)value;
- (void)addCompleted_questions:(NSSet *)values;
- (void)removeCompleted_questions:(NSSet *)values;

@end
