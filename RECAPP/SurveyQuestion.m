//
//  SurveyQuestion.m
//  RECAPP
//
//  Created by RECAPP Developer on 05/06/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import "SurveyQuestion.h"
#import "FilledSurveyForm.h"


@implementation SurveyQuestion

@dynamic identifier;
@dynamic ordinal;
@dynamic question;
@dynamic filledsurvey;


-(void) removeCapturedData
{
    //polymorphed in extensions
}

-(BOOL) isEmpty
{
    return false;
}

@end
