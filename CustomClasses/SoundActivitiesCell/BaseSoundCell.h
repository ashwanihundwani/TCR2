//
//  BaseSoundCellTableViewCell.h
//  TinnitusCoach
//
//  Created by Ashwani Hundwani on 14/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseSoundCellDelegate <NSObject>

-(void)didTapDelete:(id)sender;

@end

@interface BaseSoundCell : UITableViewCell

@property(nonatomic, weak)IBOutlet UILabel *titleLabel;

@property(nonatomic, weak)IBOutlet UIImageView *soundImageView;

@property(nonatomic, weak)id<BaseSoundCellDelegate> delegate;

-(IBAction)onDelete:(id)sender;

@end
