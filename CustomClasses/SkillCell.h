//
//  SkillCell.h
//  TinnitusCoach
//
//  Created by Ashwani Hundwani on 11/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkillCell : UITableViewCell

@property(nonatomic, strong)IBOutlet UILabel *titleLabel;

@property(nonatomic, strong)IBOutlet UILabel *descriptionLabel;

@property(nonatomic, weak)IBOutlet NSLayoutConstraint *titleHeightConst;

@end
