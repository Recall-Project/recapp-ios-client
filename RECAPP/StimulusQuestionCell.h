//
//  StimulusQuestionCell.h
//  
//
//  Created by RECAPP Developer on 17/06/2015.
//
//

#import <UIKit/UIKit.h>
#import "QuestionOptionsView.h"

@interface StimulusQuestionCell : UITableViewCell


@property (nonatomic, strong) IBOutlet UILabel* stimulus;
@property (nonatomic,strong) IBOutlet UILabel *question;
@property (nonatomic,strong) IBOutlet QuestionOptionsView *optionSelector;

@end
