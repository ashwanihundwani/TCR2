//
//  ImageryViewController+Table.h
//  TinnitusCoach
//
//  Created by Ashwani Hundwani on 13/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "ImageryViewController.h"

#import "SkillIntroInfo.h"
#import "SkillReminderCell.h"
#import "SkillIntroductionCell.h"
#import "SkillReminderInfo.h"


@interface ImageryViewController (Table)< UITableViewDataSource, UITableViewDelegate, SkillIntroductionCellDelegate, SkillReminderCellDelegate>


-(IBAction)learnMoreClicked:(id)sender;
-(IBAction)viewIntroductionAgainClicked:(id)sender;
- (IBAction)DeleteReminder:(id)sender;
-(IBAction)goToScheduler:(id)sender;

- (IBAction)BreathingTimer:(id)sender;
- (IBAction)PlayVideoTwo:(id)sender;
- (IBAction)PlayVideoOne:(id)sender;

@end
