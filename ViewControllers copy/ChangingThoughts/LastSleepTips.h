//
//  LastSleepTips.h
//  TinnitusCoach
//
 //  Copyright (c) 2015 Swipe Video Labs Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LastSleepTips : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOutlet;
@property(nonatomic,strong)DBManager *dbManager;

@end
