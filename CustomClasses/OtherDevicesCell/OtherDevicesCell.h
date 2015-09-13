//
//  OtherDevicesCell.h
//  TinnitusCoach
//
//  Created by Creospan on 3/30/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OtherDevicesCellDelegate <NSObject>

-(void)didTapCheckBox:(id)sender;

@end

@interface OtherDevicesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *checkView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property(nonatomic, weak)id<OtherDevicesCellDelegate> delegate;

@end
