//
//  StimulusQuestion.h
//  
//
//  Created by RECAPP Developer on 18/06/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SurveyLikertQuestion.h"


@interface StimulusQuestion : SurveyLikertQuestion

@property (nonatomic, retain) NSString * stimulus;
@property (nonatomic, retain) NSDate * completed;

@end
