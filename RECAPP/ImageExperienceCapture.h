//
//  ImageExperienceCapture.h
//  RECAPP
//
//  Created by RECAPP Developer on 15/05/2014.
//  Copyright (c) 2014 Lancaster University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SurveyQuestion.h"


@interface ImageExperienceCapture : SurveyQuestion

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * image_url;

-(void) removeCapturedData;
-(BOOL) isEmpty;

@end
