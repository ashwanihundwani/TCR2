//
//  SupportTableViewCell.m
//  TinnitusCoach
//
//  Created by Creospan on 25/04/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "emotionsTableViewCell.h"

@implementation EmotionsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

}

-(void)clearCell
{
    [self.lblEmotionName setText:@""];
    [self.lblRating setText:@""];

}

@end
