//
//  SoundIntroCell.m
//  TinnitusCoach
//
//  Created by Ashwani Hundwani on 14/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "SoundIntroCell.h"
#import "SoundIntroInfo.h"

@implementation SoundIntroCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)onExplore:(id)sender
{
    if(self.delegate
       && [self.delegate respondsToSelector:@selector(didTapOnExplore:)])
    {
        [self.delegate didTapOnExplore:self];
    }
}

-(void)setIntroInfo:(SoundIntroInfo *)info
{
    self.titleLabel.text = info.title;
    self.descriptionLabel.text = info.subTitle;
}

@end
