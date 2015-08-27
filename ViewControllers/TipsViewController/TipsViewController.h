//
//  GuidedMeditationViewController.h
//  TinnitusCoach
//
//  Created by Creospan on 18/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseSkilDetailViewController.h"

@interface TipsViewController : BaseSkilDetailViewController


{IBOutlet UISwitch *switch1;}

@property (nonatomic,strong) DBManager *manager;

@property(nonatomic, strong)NSArray *exercises;

@property(weak, nonatomic)IBOutlet UITableView *tableView;

@end
