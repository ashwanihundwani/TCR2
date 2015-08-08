//
//  WebsitesandAppsViewController.h
//  TinnitusCoach
//
//  Created by Vikram Singh on 3/30/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebsitesandAppsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSString *soundType;
- (IBAction)addTapped:(id)sender;
- (IBAction)cancelTapped:(id)sender;

@end
