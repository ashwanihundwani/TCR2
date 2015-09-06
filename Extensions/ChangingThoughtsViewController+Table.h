//
//  ChangingThoughtsViewController+Table.h
//  TinnitusCoach
//
//  Created by Ashwani Hundwani on 06/09/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "ChangingThoughtsViewController.h"
#import "SkillIntroInfo.h"
#import "SkillIntroductionCell.h"

@interface ChangingThoughtsViewController (Table)<SkillIntroductionCellDelegate>

-(IBAction)learnMoreClicked:(id)sender;
-(IBAction)viewIntroductionAgainClicked:(id)sender;

@end
