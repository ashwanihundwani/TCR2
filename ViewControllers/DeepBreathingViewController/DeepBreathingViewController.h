//
//  DeepBreathingViewController.h
//  TinnitusCoach
//
//  Created by Creospan on 18/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSkilDetailViewController.h"

@interface DeepBreathingViewController : BaseSkilDetailViewController

@property (weak, nonatomic) IBOutlet UILabel *reminderSchedule;
@property(nonatomic, weak) IBOutlet UITableView *tableView;

@property(nonatomic, strong)NSArray *exercises;

@property (nonatomic,strong) DBManager *manager;

-(IBAction)learnMoreClicked:(id)sender;
-(IBAction)viewIntroductionAgainClicked:(id)sender;
- (IBAction)DeleteReminder:(id)sender;
-(IBAction)goToScheduler:(id)sender;

- (IBAction)BreathingTimer:(id)sender;
- (IBAction)PlayVideoTwo:(id)sender;
- (IBAction)PlayVideoOne:(id)sender;

@end
