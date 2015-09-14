//
//  WeeklyViewController.h
//  TinnitusCoach
//
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "FeedbackTableViewCell.h"
#import "SkillFeedbackCell.h"
#import "UsingSoundFeedbackCell.h"

@interface WeeklyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UsingSoundTableViewDelegate, SkillFeedbackCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton* previousBtn;
@property (weak, nonatomic) IBOutlet UIButton* nextBtn;
@property (weak, nonatomic) IBOutlet UIButton* submittBtn;


-(IBAction)barButtonPressed:(id)sender;


@end
