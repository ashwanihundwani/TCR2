//
//  ImageryViewController.h
//  TinnitusCoach
//
//  Created by Creospan on 18/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSkilDetailViewController.h"

@interface ImageryViewController : BaseSkilDetailViewController


@property (weak, nonatomic) IBOutlet UIImageView *pleasantActivityImageView;
@property (weak, nonatomic) IBOutlet UIButton *learnMoreButton;
@property (weak, nonatomic) IBOutlet UIView *secondaryView;
@property (weak, nonatomic) IBOutlet UITableView *scheduleTableView;

@property (nonatomic,strong) DBManager *manager;

@property (weak, nonatomic) IBOutlet UIButton *viewIntroButton;

@property(nonatomic, strong)NSArray *exercises;

@property(weak, nonatomic)IBOutlet UITableView *tableView;

@end
