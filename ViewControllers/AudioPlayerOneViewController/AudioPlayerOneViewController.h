//
//  ViewController.h
//  testAudioPanning
//
//  Created by Vikram Singh on 3/15/15.
//  Copyright (c) 2015 Vikram Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RatingsViewController.h"
@interface AudioPlayerOneViewController : UIViewController
{
    NSTimer *timer;
}


 @property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSString *videoURL;
@property (nonatomic,assign) audioPanning panning;
-(void)updateCounter:(NSTimer *)theTimer;

@end
