//
//  SamplerViewController.h
//  TinnitusCoach
//
//  Created by Creospan on 14/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageryTimerViewController : UIViewController {
    
    NSTimer *timer;
    IBOutlet UILabel *myCounterLabel1;
}

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSString *videoURL;
@property (nonatomic,assign) audioPanning panning;

@property (weak, nonatomic) IBOutlet UILabel *Label;
@property (weak, nonatomic) IBOutlet UIImageView *img;


@property (nonatomic, retain) UILabel *myCounterLabel;
-(void)updateCounter:(NSTimer *)theTimer;
//-(IBAction:(id)sender)countdownTimer;

@end



