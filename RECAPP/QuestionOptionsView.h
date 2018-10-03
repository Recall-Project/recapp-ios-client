//
//  QuestionOptionsView.h
//  reflect
//
//  Created by RECAPP Developer on 28/06/2012.
//  Copyright (c) 2012 Lancaster University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyLikertQuestion.h"

@interface QuestionOptionsView : UIView

@property (nonatomic,strong) IBOutlet  UIButton *one;
@property (nonatomic,strong) IBOutlet UIButton *two;
@property (nonatomic,strong) IBOutlet UIButton *three;
@property (nonatomic,strong) IBOutlet UIButton *four;
@property (nonatomic,strong) IBOutlet UIButton *five;
@property (nonatomic,strong) IBOutlet UIButton *six;
@property (nonatomic,strong) IBOutlet UIButton *seven;

@property (nonatomic,strong) NSNumber *selectedOption;

@property (nonatomic,strong) SurveyLikertQuestion *question;

@end
