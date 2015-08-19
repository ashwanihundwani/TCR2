//
//  ViewController.m
//  testAudioPanning
//
//  Created by Vikram Singh on 3/15/15.
//  Copyright (c) 2015 Vikram Singh. All rights reserved.
//

#import "SamplerVideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface SamplerVideoViewController () <AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UISlider *audioSeekSlider;
@property (weak, nonatomic) IBOutlet UILabel *endPointLabel;
@property (weak, nonatomic) IBOutlet UILabel *startPointLabel;
@property (nonatomic, strong)AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UILabel *soundNameLabel;

@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic,strong ) MPMoviePlayerController *videoPlayer;
@property (weak, nonatomic) IBOutlet UISlider *volumeSeekSlider;
@property (weak, nonatomic) IBOutlet UISlider *panSeekSlider;
 
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
//From the sounds array
@property(weak, nonatomic) IBOutlet UIView *viewForControl;

@end

@implementation SamplerVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"Sound Player";
    // Do any additional setup after loading the view, typically from a nib.
   // self.tintColor= [UIColor purpleColor];
    
  //  [self initializeAudioPlayerWith:@"rain.mp3"];
    
    
//    NSError *sessionError = nil;
//    [[AVAudioSession sharedInstance] setDelegate:self];
    //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    
    
    
    
    
   
   //  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(movieFinishedCallback:)name:MPMoviePlayerPlaybackDidFinishNotification object:self.videoPlayer.moviePlayer];
    
    
    
    if ([[PersistenceStorage getObjectForKey:@"exerciseName"] isEqual:  @"Circling to Sleep"]) {
        self.videoURL=@"CirclingToSleep.mp3";

    }
    
    
    
    if ([[PersistenceStorage getObjectForKey:@"exerciseName"] isEqual:  @"Deep Breathing"]) {
        self.videoURL=@"DeepBreathingLesson.mp4";

    }
    
    
    
    if ([[PersistenceStorage getObjectForKey:@"exerciseName"] isEqual:  @"Imagery"]) {
        self.videoURL=@"ImageryLesson.mp4";
    }
    
    
    
    
    
    
    NSString *str = [[NSBundle mainBundle]pathForResource:self.videoURL ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:
                  str];
    self.videoPlayer.shouldAutoplay = YES;
    
    self.videoPlayer = [[MPMoviePlayerController alloc]
                        initWithContentURL:url];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(playbackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.videoPlayer];
    
    
    
    self.videoPlayer.movieSourceType = MPMovieSourceTypeFile;
    
    // self.videoPlayer.view.frame = CGRectMake(25, self.viewForControl.frame.origin.y + self.viewForControl.frame.size.height +30, self.view.bounds.size.width-45, 120);
    
    
    self.videoPlayer.view.frame = CGRectMake(0,80,320,485);
    
    //   self.videoPlayer.view.frame = CGRectMake(5, self.viewForControl.frame.origin.y-150 + self.viewForControl.frame.size.height +30, self.view.bounds.size.width-15, 400);
    
    [self.view addSubview:self.videoPlayer.view];
    self.audioSeekSlider.minimumValue = 0;
    self.audioSeekSlider.maximumValue = self.videoPlayer.duration;
    
    
   [self.videoPlayer setControlStyle:MPMovieControlStyleDefault];
    
    
    [self.videoPlayer prepareToPlay];
    
    
}



-(void)movieFinishedCallback:(NSNotification*)aNotification {
    // [self dismissMoviePlayerViewControllerAnimated];
     NSNumber *reason = [aNotification.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    if ([reason intValue] == MPMovieFinishReasonUserExited) {
        RatingsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"RatingsViewController"];
        ratingsView.skillSection = @"Sounds";
        ratingsView.skillDetail = @"Frog";
        [self presentViewController:ratingsView animated:YES completion:^{
            
        }];
        
    }
}



-(void) viewDidAppear:(BOOL)animated
{        [self.videoPlayer play];
}





-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES] ;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneTapped)];
  //  self.navigationItem.rightBarButtonItems = @[doneButton];
    //self.navigationItem.rightBarButtonItem = doneButton;
     self.navigationItem.rightBarButtonItem = doneButton;
self.navigationItem.hidesBackButton = YES;
        self.soundNameLabel.text = self.name;
    if (self.panning == audio ) {
        self.soundNameLabel.hidden = NO;
        self.videoPlayer.view.hidden = YES;
    }else{
        self.soundNameLabel.hidden = YES;
        self.videoPlayer.view.hidden = NO;

    }
}

//done button
-(void)doneTapped{
    RatingsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"RatingsViewController"];
    ratingsView.skillSection = @"Sounds";
    ratingsView.skillDetail = self.name;
    [self.navigationController pushViewController:ratingsView animated:YES];
}


-(IBAction)doneButtonTapped:(id)sender
{
    /*    RatingsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"RatingsViewController"];
     ratingsView.skillSection = @"Sounds";
     ratingsView.skillDetail = self.name;
     
     //[self.navigationController pushViewController:ratingsView animated:YES];
     [self.navigationController presentModalViewController:ratingsView animated:YES];
     
     */
    [PersistenceStorage setObject:@"SamplerVideoVC" andKey:@"Referer"];
    [self dismissModalViewControllerAnimated:NO];
    
    
}


-(void)playVideo{
   /* if (self.videoPlayer.playbackState == MPMoviePlaybackStateStopped) {
     
        
    NSString *str = [[NSBundle mainBundle]pathForResource:self.videoURL ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:
                  str];
    self.videoPlayer.shouldAutoplay = YES;

   self.videoPlayer = [[MPMoviePlayerController alloc]
                                           initWithContentURL:url];

        
[[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(playbackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.videoPlayer];
        
        
        
        self.videoPlayer.movieSourceType = MPMovieSourceTypeFile;

   // self.videoPlayer.view.frame = CGRectMake(25, self.viewForControl.frame.origin.y + self.viewForControl.frame.size.height +30, self.view.bounds.size.width-45, 120);
        
        
        self.videoPlayer.view.frame = CGRectMake(0,125,320,453);
      
       //   self.videoPlayer.view.frame = CGRectMake(5, self.viewForControl.frame.origin.y-150 + self.viewForControl.frame.size.height +30, self.view.bounds.size.width-15, 400);
        
    [self.view addSubview:self.videoPlayer.view];
        self.audioSeekSlider.minimumValue = 0;
        self.audioSeekSlider.maximumValue = self.videoPlayer.duration;

    // Set shouldAutoplay to YES
        
   // [self.videoPlayer movieControlMode:MPMovieControlModeDefault];

    //    [self.videoPlayer setControlStyle:MPMovieControlStyleNone];
        
        
     [self.videoPlayer setControlStyle:MPMovieControlStyleFullscreen];

        
        [self.videoPlayer prepareToPlay];
        [self.videoPlayer play];
        
        
       
        
    }

else{
*/
    [self.videoPlayer play];

}





- (void)playbackDidFinish:(NSNotification*)aNotification
{
    // Obtain the reason why the movie playback finished
    NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    // Dismiss the view controller ONLY when the reason is not "playback ended"
    if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
    {
        MPMoviePlayerController *moviePlayer = [aNotification object];
        
        // Remove this class from the observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
        
        // Dismiss the view controller
        [self dismissViewControllerAnimated:YES completion:nil];
    }

    RatingsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"RatingsViewController"];
    ratingsView.skillSection = @"Sounds";
    ratingsView.skillDetail = self.name;
    [self.navigationController pushViewController:ratingsView animated:YES];

    
    
}







-(void)initializeAudioPlayerWith:(NSString *)fileName
{
    NSString *beasMonoPath  =[[NSBundle mainBundle]pathForResource:self.url  ofType:nil];
    
    NSURL *url = [NSURL URLWithString:beasMonoPath];
    
 //   self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    
    [self.audioPlayer setDelegate:self];
    [self.audioPlayer prepareToPlay];
    
    NSTimeInterval theTimeInterval = self.audioPlayer.duration;
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    // Create the NSDates
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];
    // Get conversion to hours, minutes, seconds
    unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    NSLog(@"%02ld:%02ld:%02ld", (long)[breakdownInfo hour], (long)[breakdownInfo minute], (long)[breakdownInfo second]);
    
    self.endPointLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)[breakdownInfo hour], (long)[breakdownInfo minute], (long)[breakdownInfo second]];
    
    self.startPointLabel.text = [NSString stringWithFormat:@"00:00:00"];
    
    self.audioSeekSlider.value = 0;
    self.audioPlayer.numberOfLoops = -1;
    self.audioSeekSlider.minimumValue = 0;
    self.audioSeekSlider.maximumValue = self.audioPlayer.duration;
    
    [self.audioPlayer setVolume:self.volumeSeekSlider.value];
    [self.audioPlayer setPan:self.panSeekSlider.value];
    

}


- (IBAction)playSoundTapped:(id)sender
{
    // When button is tapped, play sound
    if (self.panning == video) {
        if (self.videoPlayer.playbackState == MPMoviePlaybackStatePlaying) {
            [self.videoPlayer pause];
            [self.playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
            self.updateTimer = nil;
            
        }
        else
        {
            [self.videoPlayer play];
            [self playVideo];
            [self.playPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
            self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateCurrentTime) userInfo:self.videoPlayer repeats:YES];
            
        }
        
    }else{
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer pause];
        [self.playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
        self.updateTimer = nil;

    }
    else
    {
        [self.audioPlayer play];
        [self.playPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateCurrentTime) userInfo:self.audioPlayer repeats:YES];

    }
    }
}

-(void)updateCurrentTimeForPlayer:(AVAudioPlayer *)p
{
    self.startPointLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", (int)p.currentTime / 3600, (int)p.currentTime / 60, (int)p.currentTime % 60, nil];
    self.audioSeekSlider.value = p.currentTime;
}

- (void)updateCurrentTime
{
    [self updateCurrentTimeForPlayer:self.audioPlayer];
}

-(IBAction)panSeekSliderValueChanged:(id)sender
{
    if (self.panning == audio) {

    [self.audioPlayer setPan:self.panSeekSlider.value];
    }else{
    }
}

-(IBAction)volumeSeekSliderValueChanged:(id)sender
{
    if (self.panning == audio) {
        [self.audioPlayer setVolume:self.volumeSeekSlider.value];

    }else{
    }
}


- (IBAction)sliderChanged:(id)sender {
    // Fast skip the music when user scroll the UISlider
    [self.videoPlayer stop];
    [self.videoPlayer setCurrentPlaybackTime:self.audioSeekSlider.value];
    [self.videoPlayer prepareToPlay];
    [self.videoPlayer play];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.audioPlayer stop]; // Or pause
    [self.videoPlayer stop];
}

@end
