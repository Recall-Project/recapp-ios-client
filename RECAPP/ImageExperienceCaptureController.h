//
//  ImageExperienceCaptureController.h
//  RECAPP
//
//  Created by RECAPP Developer on 02/05/2014.
//  Copyright (c) 2014 Lancaster University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExperienceCaptureController.h"

@interface ImageExperienceCaptureController : ExperienceCaptureController <UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate>

@property(nonatomic, weak) UITableViewCell *expCaptureCell;

@property (nonatomic, strong) UIImage *selectedUIImage;
@property (nonatomic, strong) NSData *selectedDataImage;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

-(void)showCamera:(id)sender;

@end
