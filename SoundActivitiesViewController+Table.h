//
//  SoundActivitiesViewController+Table.h
//  TinnitusCoach
//
//  Created by Ashwani Hundwani on 14/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "SoundActivitiesViewController.h"

#import "SkillIntroInfo.h"
#import "SkillIntroductionCell.h"
#import "SoundIntroInfo.h"
#import "WebsiteSoundInfo.h"
#import "OtherSoundInfo.h"
#import "TinnitusSoundInfo.h"
#import "SoundIntroCell.h"
#import "WebsiteSoundCell.h"
#import "OtherSoundsCell.h"
#import "TinnitusSoundCell.h"
#import "MyOwnSoundInfo.h"
#import "MyOwnSoundCell.h"

@interface SoundActivitiesViewController (Table)< UITableViewDataSource, UITableViewDelegate, SkillIntroductionCellDelegate, OtherSoundsCellDelegate, TinnitusSoundCellDelegate, SoundIntroCellDelegate, WebsiteSoundCellDelegate>

-(IBAction)learnMoreClicked:(id)sender;
-(IBAction)viewIntroductionAgainClicked:(id)sender;

@end
