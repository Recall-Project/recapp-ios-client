//
//  QuestionLikertCell.h
//  RECAPP
//
//  Created by RECAPP Developer on 08/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionOptionsView.h"

@interface QuestionLikertCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *question;
@property (nonatomic,strong) IBOutlet UILabel *leftDescription;
@property (nonatomic,strong) IBOutlet UILabel *rightDescription;
@property (nonatomic,strong) IBOutlet QuestionOptionsView *optionSelector;

@end
