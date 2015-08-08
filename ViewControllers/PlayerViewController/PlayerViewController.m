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
//        videoPlayer = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:path]];
//        [self presentViewController:videoPlayer animated:YES completion:^{
//            
//        }];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
