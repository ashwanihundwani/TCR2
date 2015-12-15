//
//  IntroPageView.m
//  TinnitusCoach
//
//  Created by Creospan on 16/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "IntroPageView.h"
#import "IntroPageInfo.h"

@implementation IntroPageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setPageInfo:(IntroPageInfo *)pageInfo
{
    self.titleLabel.text = pageInfo.title;
    self.descriptionLabel.text = pageInfo.descriptionText;
    
    if(!pageInfo.image)
    {
        self.imageHeightConst.constant = 0;
    }
    self.imageView.image = pageInfo.image;
}

@end
