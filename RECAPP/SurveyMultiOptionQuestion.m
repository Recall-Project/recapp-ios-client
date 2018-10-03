//
//  SurveyMultiOptionQuestion.m
//  RECAPP
//
//  Created by RECAPP Developer on 09/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import "SurveyMultiOptionQuestion.h"


@implementation SurveyMultiOptionQuestion

@dynamic options;
@dynamic answer;

-(void) removeCapturedData
{
    self.answer = nil;
}

-(BOOL) isEmpty
{
    return self.answer ? NO : YES;
}

@end
