//
//  WeeklyViewController.h
//  TinnitusCoach
//
 //  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface WeeklyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
