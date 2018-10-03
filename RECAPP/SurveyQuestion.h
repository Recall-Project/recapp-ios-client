//
//  SurveyQuestion.h
//  RECAPP
//
//  Created by RECAPP Developer on 05/06/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ExtendedManagedObject.h"

@class FilledSurveyForm;

@interface SurveyQuestion : ExtendedManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * ordinal;
@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) FilledSurveyForm *filledsurvey;

-(void) removeCapturedData;
-(BOOL) isEmpty;

@end
