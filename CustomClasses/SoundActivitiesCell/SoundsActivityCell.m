//
//  OtherDevicesSoundActivityCell.m
//  TinnitusCoach
//
//  Created by Creospan   on 09/04/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "SoundsActivityCell.h"

@implementation SoundsActivityCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(IBAction)onDeletePressed:(id)sender{
    [self.delegate onDeleteSoundItem:self];
}

@end
