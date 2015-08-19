//
//  RatingsViewController.h
//  TinnitusCoach
//
//  Created by Creospan on 18/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPanningViewController.h"
#import "SamplerViewController.h"
#import "HomeViewController.h"

@interface SkillRatingsViewController : UIViewController
@property(nonatomic,strong) NSString *skillSection;
@property(nonatomic,strong) NSString *skillDetail;
@property(nonatomic,strong) NSString *ratingName;
@property(nonatomic, strong) NSDictionary *skillDict;

@end
