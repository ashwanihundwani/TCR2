//
//  SamplerViewController.h
//  TinnitusCoach
//
//  Created by Creospan on 14/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SamplerCustomCell.h"
#import "DeepBreathingViewController.h"
#import "GuidedMeditationViewController.h"
#import "ImageryViewController.h"
@interface SamplerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *samplerTableView;
@property (nonatomic, strong) DBManager *dbManagerForSound;
@property (nonatomic, strong) DBManager *dbManagerForVideo;
@property (nonatomic, weak)IBOutlet UILabel *headerLabel;


@end
