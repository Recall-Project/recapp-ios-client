//
//  ImageExperienceCaptureController.m
//  RECAPP
//
//  Created by RECAPP Developer on 02/05/2014.
//  Copyright (c) 2014 Lancaster University. All rights reserved.
//

#import "ImageExperienceCaptureController.h"
#import "ImageExperienceCapture.h"

@implementation ImageExperienceCaptureController

@synthesize expCaptureCell, selectedUIImage,selectedDataImage, imagePicker;

-(id) init {
    
    ////////NSLog(@"Init ImageExperienceCaptureController");
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
    
    return self;
}

- (void)showCamera:(id)sender {
    
    ////////NSLog(@"Show Camera for ImageExperienceCaptureID: %@", self.experienceCapture.identifier);
    [self.viewController presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    ////////NSLog(@"Finished Picking Image..");
    
    //ImageExperienceCapture *expCapModel = ((ImageExperienceCapture*) self.experienceCapture);
    
    ((ImageExperienceCapture*) self.experienceCapture).image = [NSData dataWithData:UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage],0.1)];
    
    ////////NSLog(@"%@",((ImageExperienceCapture*) self.experienceCapture).identifier );
    
    ((ImageExperienceCapture*) self.experienceCapture).image_url = [NSString stringWithFormat:@"%@.jpg",((ImageExperienceCapture*) self.experienceCapture).identifier];
    
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    ////////NSLog(@"Hidden Camera..");
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
