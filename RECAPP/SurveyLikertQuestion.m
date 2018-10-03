//
//  SurveyLikertQuestion.m
//  RECAPP
//
//  Created by RECAPP Developer on 09/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import "SurveyLikertQuestion.h"
#import "LikertOption.h"


@implementation SurveyLikertQuestion

@dynamic low_end_descriptor;
@dynamic high_end_descriptor;
@dynamic answer;
@dynamic options;

-(void) removeCapturedData
{
    self.answer = nil;
}

-(BOOL) isEmpty
{
    
    //////NSLog(@"%d",self.answer.value.intValue);
    
    return self.answer ? NO : YES;
}

@end
