//
//  SupportViewController.h
//  TinnitusCoach
//
//  Created by Jiten on 25/04/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactListViewController.h"
@interface SupportViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,ContactSelectedProtocol>

@property (weak, nonatomic) IBOutlet UITableView *supportTableView;
@end
