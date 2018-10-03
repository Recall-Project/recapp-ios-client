//
//  SurveyMultiOptionQuestion.h
//  RECAPP
//
//  Created by RECAPP Developer on 09/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SurveyQuestion.h"

@class MultiOption;

@interface SurveyMultiOptionQuestion : SurveyQuestion

@property (nonatomic, retain) NSSet *options;
@property (nonatomic, retain) MultiOption *answer;
@end

@interface SurveyMultiOptionQuestion (CoreDataGeneratedAccessors)

- (void)addOptionsObject:(NSManagedObject *)value;
- (void)removeOptionsObject:(NSManagedObject *)value;
- (void)addOptions:(NSSet *)values;
- (void)removeOptions:(NSSet *)values;

-(void) removeCapturedData;
-(BOOL) isEmpty;

@end
