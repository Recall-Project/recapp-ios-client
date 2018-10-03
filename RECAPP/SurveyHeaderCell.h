//
//  SurveyHeaderCell.h
//  RECAPP
//
//  Created by RECAPP Developer on 28/07/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurveyHeaderCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UILabel *desc;

@property (nonatomic, strong) IBOutlet UILabel* projectName;
@property (nonatomic, strong) IBOutlet UILabel* surveyName;
@property (nonatomic, strong) IBOutlet UILabel* surveyID;
@property (nonatomic, strong) IBOutlet UIImageView *surveyType;

@end
