//
//  StandardSurveyCell.m
//  RECAPP
//
//  Created by RECAPP Developer on 08/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import "StandardSurveyCell.h"

@implementation StandardSurveyCell

@synthesize projectName,surveyType, surveyName, closingDate, nextShowTime, spatialShowPlacename, surveyID;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
