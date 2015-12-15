//
//  IntroPageInfo.m
//  TinnitusCoach
//
//  Created by Creospan on 16/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "IntroPageInfo.h"

@implementation IntroPageInfo


-(id)initWithimage:(UIImage *)image title:(NSString *)title description:(NSString *)description
{
    self = [super init];
    
    self.title = title;
    self.descriptionText = description;
    self.image = image;
    
    return self;
}

@end
