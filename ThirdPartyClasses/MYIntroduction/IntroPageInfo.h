//
//  IntroPageInfo.h
//  TinnitusCoach
//
//  Created by Creospan on 16/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntroPageInfo : NSObject

@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *descriptionText;
@property(nonatomic, strong)UIImage *image;

-(id)initWithimage:(UIImage *)image title:(NSString *)title description:(NSString *)description;

-(id)initWithimage:(UIImage *)image
       description:(NSString *)description;

@end
