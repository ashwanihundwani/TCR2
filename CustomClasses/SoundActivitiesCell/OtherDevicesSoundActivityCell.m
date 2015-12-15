//
//  OtherDevicesSoundActivityCell.m
//  TinnitusCoach
//
//  Created by Creospan   on 09/04/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "OtherDevicesSoundActivityCell.h"

@implementation OtherDevicesSoundActivityCell

- (void)awakeFromNib {
   // [Utils addTapGestureToView:self.infoImageView target:self selector:@selector(didTapInformation:)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(IBAction)onDeletePressed:(id)sender{
    [self.delegate onDeleteSoundItem:self];
}

@end
