//
//  QuestionOptionsView.m
//  reflect
//
//  Created by RECAPP Developer on 28/06/2012.
//  Copyright (c) 2012 Lancaster University. All rights reserved.
//

#import "QuestionOptionsView.h"
#import "LikertOption.h"

@implementation QuestionOptionsView

@synthesize one, two, three, four, five, six, seven,selectedOption = _selectedOption, question;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void) awakeFromNib
{
    
    _selectedOption = [NSNumber numberWithInt:0];
    one.tag = 1;
    two.tag = 2;
    three.tag = 3;
    four.tag = 4;
    five.tag = 5;
    six.tag = 6;
    seven.tag = 7;
    

    
    
    [one addTarget:self 
            action:@selector(buttonClicked:)
  forControlEvents:UIControlEventTouchUpInside];
    [two addTarget:self 
            action:@selector(buttonClicked:)
  forControlEvents:UIControlEventTouchUpInside];
    [three addTarget:self 
              action:@selector(buttonClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [four addTarget:self 
             action:@selector(buttonClicked:)
   forControlEvents:UIControlEventTouchUpInside];
    [five addTarget:self 
             action:@selector(buttonClicked:)
   forControlEvents:UIControlEventTouchUpInside];
    [six addTarget:self 
            action:@selector(buttonClicked:)
  forControlEvents:UIControlEventTouchUpInside];
    [seven addTarget:self 
              action:@selector(buttonClicked:)
    forControlEvents:UIControlEventTouchUpInside];

}


- (IBAction)buttonClicked:(id)sender
{
    [self resetOptions];
    UIButton *btn = (UIButton*)sender;
    [btn setSelected:YES];
    
    ////NSLog(@"clicked %ld", (long)btn.tag);
    
    [self setSelectedOption:[NSNumber numberWithInt:btn.tag]];

    ////NSLog(@"%lu", (unsigned long)question.options.count);
    
    for(LikertOption *option in question.options)
    {
        ////NSLog(@"ffff");
        ////NSLog(@"%d", [option.value intValue]);
        if([option.value intValue] == btn.tag)
        {
            ////NSLog(@"set");
            question.answer = option;
            break;
        }
    }
}


-(void)resetOptions
{
    UIFont *font = [UIFont fontWithName:@"Futura-CondensedMedium" size:20.0];
    [one setSelected:NO];
    one.titleLabel.font = font;
    [two setSelected:NO];
      two.titleLabel.font = font;
    [three setSelected:NO];
      three.titleLabel.font =font;
    [four setSelected:NO];
      four.titleLabel.font = font;
    [five setSelected:NO];
      five.titleLabel.font = font;
    [six setSelected:NO];
      six.titleLabel.font = font;
    [seven setSelected:NO];
      seven.titleLabel.font = font;
}


-(void)setSelectedOption:(NSNumber *)selectedOption
{
    [self resetOptions];
    _selectedOption = selectedOption;
    UIFont *font = [UIFont fontWithName:@"Futura-CondensedMedium" size:40.0];
    
    switch ([_selectedOption intValue]) {
        case 1:
            [one setSelected:YES];
            one.titleLabel.font = font;
            break;
        case 2:
            [two setSelected:YES];
            two.titleLabel.font = font;
            break;
        case 3:
            [three setSelected:YES];
            three.titleLabel.font = font;
            break;
        case 4:
            [four setSelected:YES];
            four.titleLabel.font = font;
            break;
        case 5:
            [five setSelected:YES];
            five.titleLabel.font = font;
            break;
        case 6:
            [six setSelected:YES];
            six.titleLabel.font = font;
            break;
        case 7:
            [seven setSelected:YES];
            seven.titleLabel.font = font;
            break;
        default:
            break;
    } 
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
