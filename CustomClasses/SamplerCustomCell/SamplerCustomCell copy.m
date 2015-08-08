//
//  SamplerCustomCell.m
//  TinnitusCoach
//
//  Created by Swipe Video Labs Pvt Ltd on 14/03/15.
//  Copyright (c) 2015 Swipe Video Labs Pvt Ltd. All rights reserved.
//

#import "SamplerCustomCell.h"

@implementation SamplerCustomCell

- (void)awakeFromNib {
    // Initialization code


}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.contentView addSubview:self.descriptionLabel];
    [self.contentView addSubview:self.samplerImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.durationLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
