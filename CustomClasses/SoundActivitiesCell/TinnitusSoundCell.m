//
//  TinnitusSoundCell.m
//  TinnitusCoach
//
//  Created by Creospan on 14/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "TinnitusSoundCell.h"
#import "TinnitusSoundInfo.h"


@implementation TinnitusSoundCell


-(void)setTinnitusInfo:(TinnitusSoundInfo *)info
{
    self.titleLabel.text = info.title;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
