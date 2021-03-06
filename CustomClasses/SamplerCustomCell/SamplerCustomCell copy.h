//
//  SamplerCustomCell.h
//  TinnitusCoach
//
//  Created by Swipe Video Labs Pvt Ltd on 14/03/15.
//  Copyright (c) 2015 Swipe Video Labs Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SamplerCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *samplerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@end
