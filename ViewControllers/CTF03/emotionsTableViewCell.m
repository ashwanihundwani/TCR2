//
//  SupportTableViewCell.m
//  TinnitusCoach
//
//  Created by Jiten on 25/04/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "emotionsTableViewCell.h"

@implementation EmotionsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(void)populateData:(AddressBook *)aBook
//{
  //  if(aBook)
   // {
//        [self.lblPhoneNumber setText:[aBook valueForKey:ph]]
   // }
//}

-(void)clearCell
{
    [self.lblEmotionName setText:@""];
    [self.lblRating setText:@""];

}

@end
