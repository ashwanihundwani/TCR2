//
//  GuidedMeditationViewController.h
//  TinnitusCoach
//
//  Created by Creospan on 18/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSkilDetailViewController.h"

@interface ChangingThoughtsViewController : BaseSkilDetailViewController

@property(nonatomic, weak)IBOutlet UITableView *tableView;

@property(nonatomic, strong) NSArray *thoughtsAndFeelings;


-(IBAction)newEntryClicked:(id)sender;
- (IBAction)viewEntriesClicked:(id)sender;

@end
