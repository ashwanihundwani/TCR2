//
//  ActivityCell.h
//  TinnitusCoach
//
//  Created by Creospan on 28/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteActivityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *activityNameButton;
@property (weak, nonatomic) IBOutlet UIImageView *initialImageView;
@property (weak, nonatomic) IBOutlet UIButton *removeFavoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *secondView;

@end
