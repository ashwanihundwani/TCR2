//
//  PleasantActivityViewController.h
//  TinnitusCoach
//
//  Created by Creospan on 28/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSkilDetailViewController.h"

@interface PleasantActivityViewController : BaseSkilDetailViewController
@property (weak, nonatomic) IBOutlet UIImageView *pleasantActivityImageView;
@property (weak, nonatomic) IBOutlet UIButton *learnMoreButton;
@property (weak, nonatomic) IBOutlet UIView *secondaryView;
@property (weak, nonatomic) IBOutlet UITableView *scheduleTableView;

@property (weak, nonatomic) IBOutlet UIButton *viewIntroButton;

@property(nonatomic, weak)IBOutlet UITableView *tableView;

@property(nonatomic, strong) NSArray *activties;

@end
