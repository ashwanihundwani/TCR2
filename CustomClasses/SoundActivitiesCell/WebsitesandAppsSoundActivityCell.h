//
//  WebsitesandAppsSoundActivityCell.h
//  TinnitusCoach
//
//  Created by Creospan   on 09/04/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebsitesandAppsSoundActivityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *websiteAppsImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *commentsTextField;
@property(nonatomic, strong)IBOutlet UIButton *deleteButton;
@end
