//
//  EmailEntryCell.m
//  RECAPP
//
//  Created by RECAPP Developer on 10/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import "EmailEntryCell.h"

@implementation EmailEntryCell

@synthesize email;
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
