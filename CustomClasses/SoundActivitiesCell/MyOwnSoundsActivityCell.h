//
//  OtherDevicesSoundActivityCell.h
//  TinnitusCoach
//
//  Created by Creospan   on 09/04/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SoundsActivityCell.h"

@interface MyOwnSoundsActivityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *otherDevicesImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *commentsTextField;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) id<SoundActivityCellDelegate> delegate;

-(IBAction)onDeletePressed:(id)sender;
@end
