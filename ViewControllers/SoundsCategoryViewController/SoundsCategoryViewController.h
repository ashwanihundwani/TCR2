//
//  SoundsCategoryViewController.h
//  TinnitusCoach
//
//  Created by Vikram Singh on 3/29/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoundsCategoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,MPMediaPickerControllerDelegate>
@property (nonatomic, strong) NSString *soundType;
@end

