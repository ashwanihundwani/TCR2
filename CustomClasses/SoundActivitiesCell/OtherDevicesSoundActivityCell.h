//
//  OtherDevicesSoundActivityCell.h
//  TinnitusCoach
//
//  Created by Creospan   on 09/04/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundsActivityCell.h"

@interface OtherDevicesSoundActivityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *otherDevicesImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *commentsTextField;
@property(nonatomic, strong)IBOutlet UIButton *infoImageView;
@property(nonatomic, strong)IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) id<SoundActivityCellDelegate> delegate;

-(IBAction)onDeletePressed:(id)sender;

@end



