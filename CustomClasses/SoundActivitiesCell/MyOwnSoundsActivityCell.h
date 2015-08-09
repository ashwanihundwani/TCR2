//
//  OtherDevicesSoundActivityCell.h
//  TinnitusCoach
//
//  Created by Creospan   on 09/04/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOwnSoundsActivityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *otherDevicesImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *commentsTextField;
@property (nonatomic, strong) UIButton *deleteButton;
@end
