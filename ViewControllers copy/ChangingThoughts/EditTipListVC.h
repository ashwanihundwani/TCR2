//
//  EditTipListVC.h
//  TinnitusCoach
//
//  Created by Jiten on 02/05/15.
//  Copyright (c) 2015 Swipe Video Labs Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
@protocol EditRipsListDelegate<NSObject>
@optional
-(void)didSaveTips;
@end

@interface EditTipListVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableViewOutlet;
@property(weak,nonatomic)id <EditRipsListDelegate> delegate;
@end
