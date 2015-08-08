//
//  LastSleepTips.h
//  TinnitusCoach
//
 //  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LastSleepTips : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOutlet;
@property(nonatomic,strong)DBManager *dbManager;

@end
