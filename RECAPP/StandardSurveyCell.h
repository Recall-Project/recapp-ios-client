//
//  StandardSurveyCell.h
//  RECAPP
//
//  Created by RECAPP Developer on 08/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StandardSurveyCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel* projectName;
@property (nonatomic, strong) IBOutlet UILabel* surveyName;
@property (nonatomic, strong) IBOutlet UILabel* surveyID;
@property (nonatomic, strong) IBOutlet UILabel* closingDate;
@property (nonatomic, strong) IBOutlet UILabel* nextShowTime;
@property (nonatomic, strong) IBOutlet UILabel* spatialShowPlacename;
@property (nonatomic, strong) IBOutlet UIImageView *surveyType;

@end
