//
//  OtherDevicesWithCommentsCell.m
//  TinnitusCoach
//
//  Created by Creospan on 3/30/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "OtherDevicesWithCommentsCell.h"

@implementation OtherDevicesWithCommentsCell

-(void)onTap:(id)sender
{
    if(self.checkDelegate
       && [self.checkDelegate respondsToSelector:@selector(didTapCheckBox:)])
    {
        [self.checkDelegate didTapCheckBox:self];
    }
}


- (void)awakeFromNib {
    // Initialization code
    
    self.commentsTextField.delegate = self;
    
    [Utils addTapGestureToView:self.checkImageView target:self selector:@selector(onTap:)];
    
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma  mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.delegate captureDeviceComments:self];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
