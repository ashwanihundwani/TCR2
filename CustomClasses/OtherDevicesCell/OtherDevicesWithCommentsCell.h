//
//  OtherDevicesWithCommentsCell.h
//  TinnitusCoach
//
//  Created by Creospan on 3/30/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddDeviceCaptureCommentsDelegate <NSObject>

@optional

-(void)captureDeviceComments:(UITableViewCell*)cell;

@end

@protocol OtherDevicesWithCommentsCellDelegate<NSObject>

-(void)didTapCheckBox:(id)sender;

@end

@interface OtherDevicesWithCommentsCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *commentsTextField;
@property (weak, nonatomic) id<AddDeviceCaptureCommentsDelegate> delegate;

@property (weak , nonatomic) id<OtherDevicesWithCommentsCellDelegate> checkDelegate;

@end
