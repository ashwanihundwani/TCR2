//
//  WebsitesandAppsCell.h
//  TinnitusCoach
//
//  Created by Creospan on 3/30/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WebsitesandAppsCellDelegate<NSObject>

-(void)didTapCheckBox:(id)sender;

@end

@interface WebsitesandAppsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeightConst;
@property (weak, nonatomic) IBOutlet UIView *checkView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property(nonatomic, weak)id<WebsitesandAppsCellDelegate> delegate;


@end
