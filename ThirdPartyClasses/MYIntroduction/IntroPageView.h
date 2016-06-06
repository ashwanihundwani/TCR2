//
//  IntroPageView.h
//  TinnitusCoach
//
//  Created by Creospan on 16/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IntroPageInfo;

@interface IntroPageView : UIView

@property(nonatomic, strong)IBOutlet UILabel *titleLabel;
@property(nonatomic, strong)IBOutlet UIImageView *imageView;
@property(nonatomic, strong)IBOutlet UILabel *descriptionLabel;

@property(nonatomic, strong)IBOutlet NSLayoutConstraint *titleHeightConst;
@property(nonatomic, strong)IBOutlet NSLayoutConstraint *imageHeightConst;

@property(nonatomic, strong)IntroPageInfo *pageInfo;

@end
