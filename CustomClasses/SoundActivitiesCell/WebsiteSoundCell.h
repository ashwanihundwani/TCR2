//
//  WebsiteSoundCell.h
//  TinnitusCoach
//
//  Created by Ashwani Hundwani on 14/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSoundCell.h"
@class WebsiteSoundInfo;


@protocol WebsiteSoundCellDelegate<BaseSoundCellDelegate>

@end

@interface WebsiteSoundCell : BaseSoundCell

@property(nonatomic, strong)IBOutlet UITextField *tagField;

@property(nonatomic, strong)IBOutlet UILabel *descriptionLabel;

@property(nonatomic, strong)IBOutlet NSLayoutConstraint *titleHeightConst;

@property(nonatomic, weak)id<WebsiteSoundCellDelegate> webDelegate;

-(void)setSoundInfo:(WebsiteSoundInfo *)soundInfo;

@end
