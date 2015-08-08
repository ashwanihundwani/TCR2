//
//  DeepBreathingViewController.h
//  TinnitusCoach
//
//  Created by Creospan on 18/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeepBreathingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *reminderSchedule;
 

@property (nonatomic,strong) DBManager *manager;
 

@end
