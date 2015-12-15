//
//  PlayerViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 14/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController (){
    AVAudioPlayer *audioPlayer;
    MPMoviePlayerViewController *videoPlayer;
}

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.video) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"sampleVideo" ofType:@"mp4"];
        videoPlayer = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:path]];
        [self presentMoviePlayerViewControllerAnimated:videoPlayer];
    }else{
        NSString *path = [[NSBundle mainBundle]pathForResource:@"sampleAudio" ofType:@"mp3"];
        audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:path] error:NULL];
        [audioPlayer play];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
