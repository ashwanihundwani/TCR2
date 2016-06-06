//
//  OtherDevicesViewController.h
//  TinnitusCoach
//
//  Created by Creospan on 3/30/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OtherDevicesWithCommentsCell.h"

@interface OtherDevicesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, AddDeviceCaptureCommentsDelegate>
@property (nonatomic, strong) NSString *soundType;

@end
