//
//  Project.h
//  RECAPP
//
//  Created by RECAPP Developer on 07/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ExtendedManagedObject.h"

@class SurveyForm;


typedef enum {
    
    ExperienceProject,
    StimulusProject
} StudyType;

@interface Project : ExtendedManagedObject

@property (nonatomic, assign) NSNumber * studyType;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * revision;
@property (nonatomic, retain) NSSet *surveys;
@property (nonatomic, retain) NSNumber * ask_recall;

@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addSurveysObject:(SurveyForm *)value;
- (void)removeSurveysObject:(SurveyForm *)value;
- (void)addSurveys:(NSSet *)values;
- (void)removeSurveys:(NSSet *)values;

@end
