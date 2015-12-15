//
//  ViewController.h
//  testAudioPanning
//
//  Created by Creospan on 3/15/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RatingsViewController.h"
@interface AudioPlayerTwoViewController : UIViewController

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSString *videoURL;
@property (nonatomic,assign) audioPanning panning;

@end

