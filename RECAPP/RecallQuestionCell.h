//
//  RecallQuestionCell.h
//  
//
//  Created by RECAPP Developer on 17/06/2015.
//
//

#import <UIKit/UIKit.h>

@interface RecallQuestionCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIButton* recallBtn;
@property (nonatomic,strong) IBOutlet UITextField *wordBox;
@property (nonatomic,strong) IBOutlet UILabel *questionLabel;

@end
