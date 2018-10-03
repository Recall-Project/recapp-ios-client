//
//  MultiOption.h
//  RECAPP
//
//  Created by RECAPP Developer on 09/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ExtendedManagedObject.h"

@class SurveyMultiOptionQuestion;

@interface MultiOption : ExtendedManagedObject

@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) SurveyMultiOptionQuestion *question;
@property (nonatomic, retain) NSNumber * ordinal;

@end
