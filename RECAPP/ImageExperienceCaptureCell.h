//
//  ImageExperienceCaptureCell.h
//  RECAPP
//
//  Created by RECAPP Developer on 01/05/2014.
//  Copyright (c) 2014 Lancaster University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageExperienceCaptureCell : UITableViewCell 

@property (nonatomic, strong) IBOutlet UILabel* question;
@property (nonatomic, strong) IBOutlet UIImageView* photoView;
@property (nonatomic, strong) IBOutlet UIButton* openCamera;



@end
