//
//  WebsitesandAppsWithCommentsCell.h
//  TinnitusCoach
//
//  Created by Creospan on 3/30/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WebSiteCaptureCommentsDelegate <NSObject>

@optional

-(void)captureComments:(UITableViewCell*)cell;

@end

@protocol WebsitesandAppsWithCommentsCellDelegate<NSObject>

-(void)didTapCheckBox:(id)sender;

@end


@interface WebsitesandAppsWithCommentsCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *commentsTextField;
@property (weak, nonatomic) id<WebSiteCaptureCommentsDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeightConst;

@property (weak , nonatomic) id<WebsitesandAppsWithCommentsCellDelegate> checkDelegate;


@end
