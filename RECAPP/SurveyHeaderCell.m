//
//  SurveyHeaderCell.m
//  RECAPP
//
//  Created by RECAPP Developer on 28/07/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import "SurveyHeaderCell.h"

@implementation SurveyHeaderCell

@synthesize desc, surveyName, projectName, surveyID, surveyType;



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
