//
//  SurveyLikertQuestion.h
//  RECAPP
//
//  Created by RECAPP Developer on 09/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SurveyQuestion.h"

@class LikertOption;

@interface SurveyLikertQuestion : SurveyQuestion

@property (nonatomic, retain) NSString* low_end_descriptor;
@property (nonatomic, retain) NSString* high_end_descriptor;
@property (nonatomic, retain) LikertOption *answer;
@property (nonatomic, retain) NSSet *options;
@end

@interface SurveyLikertQuestion (CoreDataGeneratedAccessors)

- (void)addOptionsObject:(LikertOption *)value;
- (void)removeOptionsObject:(LikertOption *)value;
- (void)addOptions:(NSSet *)values;
- (void)removeOptions:(NSSet *)values;

-(void) removeCapturedData;
-(BOOL) isEmpty;

@end
