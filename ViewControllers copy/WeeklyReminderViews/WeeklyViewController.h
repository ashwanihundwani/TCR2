//
//  WeeklyViewController.h
//  TinnitusCoach
//
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "FeedbackTableViewCell.h"

@interface WeeklyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, FeedbackTableViewCellDelegae>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton* previousBtn;
@property (weak, nonatomic) IBOutlet UIButton* nextBtn;

-(IBAction)barButtonPressed:(id)sender;


@end
