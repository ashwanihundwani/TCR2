//
//  WebsitesandAppsCell.m
//  TinnitusCoach
//
//  Created by Creospan on 3/30/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "WebsitesandAppsCell.h"

@implementation WebsitesandAppsCell

-(void)onTap:(id)sender
{
    if(self.delegate
       && [self.delegate respondsToSelector:@selector(didTapCheckBox:)])
    {
        [self.delegate didTapCheckBox:self];
    }
}


- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    
    self.checkView.layer.cornerRadius = 12;
    self.checkView.layer.masksToBounds = YES;
    self.checkView.layer.borderColor = [UIColor grayColor].CGColor;
    self.checkView.layer.borderWidth = 1;
    
    [Utils addTapGestureToView:self.checkView target:self selector:@selector(onTap:)];
    
    self.contentView.backgroundColor = [Utils colorWithHexValue:@"EFEFF4"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
