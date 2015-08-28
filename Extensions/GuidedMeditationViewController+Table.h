//
//  GuidedMeditationViewController+Table.h
//  TinnitusCoach
//
//  Created by Ashwani Hundwani on 13/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "GuidedMeditationViewController.h"


#import "SkillIntroInfo.h"
#import "SkillReminderCell.h"
#import "SkillIntroductionCell.h"
#import "SkillReminderInfo.h"


@interface GuidedMeditationViewController (Table)< UITableViewDataSource, UITableViewDelegate, SkillIntroductionCellDelegate, SkillReminderCellDelegate>


-(IBAction)learnMoreClicked:(id)sender;
-(IBAction)viewIntroductionAgainClicked:(id)sender;
- (IBAction)DeleteReminder:(id)sender;
-(IBAction)goToScheduler:(id)sender;

- (IBAction)PlayAudioTwo:(id)sender;
- (IBAction)PlayAudioOne:(id)sender;
- (IBAction)PlayAudioThree:(id)sender;
- (IBAction)PlayAudioFour:(id)sender;
- (IBAction)PlayAudioFive:(id)sender;


@end
