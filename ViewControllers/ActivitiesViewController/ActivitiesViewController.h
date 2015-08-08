//
//  ActivitiesViewController.h
//  TinnitusCoach
//
//  Created by Creospan on 28/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityCell.h"
#import "DBManager.h"
@interface ActivitiesViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *addActivityButton;
@property (weak, nonatomic) IBOutlet UITableView *activityTableView;
 
@property (nonatomic,strong) DBManager *manager;

- (IBAction)addActivityTapped:(id)sender;
@end
