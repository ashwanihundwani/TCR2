//
//  MyTipsHeaderView.h
//  TinnitusCoach
//
//  Created by Jiten on 02/05/15.
//  Copyright (c) 2015 Swipe Video Labs Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTipsHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblReminderHeader;
@property (weak, nonatomic) IBOutlet UIView *viewSkillReminder;
@property (weak, nonatomic) IBOutlet UIView *viewFeedBack;
@property (weak, nonatomic) IBOutlet UISwitch *skillSwitch;
@property (weak, nonatomic) IBOutlet UILabel *lblHelp;
@property (weak, nonatomic) IBOutlet UIButton *btnEditTips;

@end
