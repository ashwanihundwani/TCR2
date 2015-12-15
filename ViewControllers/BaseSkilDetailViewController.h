//
//  BaseSkilDetailViewController.h
//  TinnitusCoach
//
//  Created by Creospan on 13/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "MBProgressHUD.h"
#import "DeleteCormationManager.h"

@interface BaseSkilDetailViewController : UIViewController

@property(nonatomic, strong)NSString *relaxationActivity;


#pragma mark Abstract Methods
-(NSString *)activityText;
-(NSString *)planText;

@end
