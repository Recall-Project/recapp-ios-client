//
//  PaneButton.h
//  Flooder
//
//  Created by RECAPP Developer on 02/04/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PaneButton : UIButton
{

@private
NSMutableDictionary *backgroundStates;
@public

}

- (void) setBackgroundColor:(UIColor *) _backgroundColor forState:(UIControlState) _state;
- (UIColor*) backgroundColorForState:(UIControlState) _state;

@end
