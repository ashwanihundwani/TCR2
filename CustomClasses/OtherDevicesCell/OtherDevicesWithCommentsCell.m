//
//  OtherDevicesWithCommentsCell.m
//  TinnitusCoach
//
//  Created by Creospan on 3/30/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "OtherDevicesWithCommentsCell.h"

@implementation OtherDevicesWithCommentsCell

- (void)awakeFromNib {
    // Initialization code
    self.commentsTextField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma  mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.delegate captureDeviceComments:self];
}

@end
