//
//  SurveyForm.h
//  RECAPP
//
//  Created by RECAPP Developer on 10/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ExtendedManagedObject.h"

@class Project, SurveyQuestion, Trigger;

@interface SurveyForm : ExtendedManagedObject


@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * header;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSSet *questions;
@property (nonatomic, retain) NSSet *triggers;


-(void) activateForm;
-(void) disableForm;
-(void) validateForm;

-(void) saveSurvey:(NSArray*)qnas forTrigger:(NSString*)triggerID;

@end

@interface SurveyForm (CoreDataGeneratedAccessors)

- (void)addQuestionsObject:(SurveyQuestion *)value;
- (void)removeQuestionsObject:(SurveyQuestion *)value;
- (void)addQuestions:(NSSet *)values;
- (void)removeQuestions:(NSSet *)values;

- (void)addTriggersObject:(Trigger *)value;
- (void)removeTriggersObject:(Trigger *)value;
- (void)addTriggers:(NSSet *)values;
- (void)removeTriggers:(NSSet *)values;

@end
