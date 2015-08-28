//
//  SkillReminderCell.h
//  TinnitusCoach
//
//  Created by Ashwani Hundwani on 13/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SkillReminderInfo;

@protocol SkillReminderCellDelegate <NSObject>

-(void)didTapActivate:(id)sender;
-(void)didTapTrash:(id)sender;


@end

@interface SkillReminderCell : UITableViewCell

@property(nonatomic, weak)id<SkillReminderCellDelegate> delegate;

-(void)setReminderInfo:(SkillReminderInfo *)info;

@end
