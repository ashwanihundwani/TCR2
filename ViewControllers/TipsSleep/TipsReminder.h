//
//  MySleepTipsVC.h
//  TinnitusCoach
//
//  Created by Creospan on 02/05/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "EditTipListVC.h"


@interface TipsReminder : UIViewController<EditRipsListDelegate>

@property (nonatomic, strong) void (^dismissBlock)();


@end
