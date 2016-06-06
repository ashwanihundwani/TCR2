//
//  BaseSoundCellTableViewCell.m
//  TinnitusCoach
//
//  Created by Creospan on 14/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "BaseSoundCell.h"

@implementation BaseSoundCell

-(IBAction)onDelete:(id)sender
{
    if(self.delegate
       && [self.delegate respondsToSelector:@selector(didTapDelete:)])
    {
        [self.delegate didTapDelete:self];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
