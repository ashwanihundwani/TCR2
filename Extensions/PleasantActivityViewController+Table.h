//
//  PleasantActivityViewController+Table.h
//  TinnitusCoach
//
//  Created by Ashwani Hundwani on 13/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "PleasantActivityViewController.h"

#import "SkillIntroInfo.h"
#import "SkillIntroductionCell.h"


@interface PleasantActivityViewController (Table)< UITableViewDataSource, UITableViewDelegate, SkillIntroductionCellDelegate>


-(IBAction)learnMoreClicked:(id)sender;
-(IBAction)viewIntroductionAgainClicked:(id)sender;
-(IBAction)favoritesClicked:(id)sender;
-(IBAction) valuesClicked:(id)sender;
@end
