//
//  ViewController.m
//  testAudioPanning
//
//  Created by Vikram Singh on 3/15/15.
//  Copyright (c) 2015 Vikram Singh. All rights reserved.
//

#import "AudioPanningViewController.h"
#import "AudioPlayerOneViewController.h"
#import "SkillRatingsViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface AudioPlayerOneViewController () <AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UISlider *audioSeekSlider;
@property (weak, nonatomic) IBOutlet UILabel *endPointLabel;
@property (weak, nonatomic) IBOutlet UILabel *startPointLabel;
@property (nonatomic, strong)AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UILabel *soundNameLabel;

@property (nonatomic, strong) NSTimer *updateCounter;
@property (strong, nonatomic) NSDate *startDate; // Stores the date of the click on the start button *

@property (nonatomic, strong) NSTimer *updateTimer;


 @property (nonatomic,strong ) MPMoviePlayerController *videoPlayer;
@property (weak, nonatomic) IBOutlet UISlider *volumeSeekSlider;
@property (weak, nonatomic) IBOutlet UISlider *panSeekSlider;
 
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
//From the sounds array
@property(weak, nonatomic) IBOutlet UIView *viewForControl;

@end

@implementation AudioPlayerOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"Sound Player";
    // Do any additional setup after loading the view, typically from a nib.
   // self.tintColor= [UIColor purpleColor];
    [self createAndDisplayMPVolumeView];
[self initializeAudioPlayerWith:@"rain.mp3"];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];

    
    NSError *sessionError = nil;
//    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    
    
    [self.audioPlayer setVolume:1.0];
    
   
//     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.videoPlayer.moviePlayer];
}



-(void) createAndDisplayMPVolumeView

{
    
    // Create a simple holding UIView and give it a frame
    
    UIView *volumeHolder = [[UIView alloc] initWithFrame: CGRectMake(64, 474, 195, 25)];
    
    
    
    // set the UIView backgroundColor to clear.
    
    [volumeHolder setBackgroundColor: [UIColor clearColor]];
    
    
    
    // add the holding view as a subView of the main view
    
    [self.view addSubview: volumeHolder];
    
    
    
    // Create an instance of MPVolumeView and give it a frame
    
    MPVolumeView *myVolumeView = [[MPVolumeView alloc] initWithFrame: volumeHolder.bounds];
    
    
    
    // Add myVolumeView as a subView of the volumeHolder
    
    [volumeHolder addSubview: myVolumeView];
    
}





-(IBAction)doneButtonTapped:(id)sender
{
    
    [PersistenceStorage setObject:@"AudioPlayerOneViewController" andKey:@"Referer"];
    [self dismissModalViewControllerAnimated:NO];
    
    
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [PersistenceStorage setObject:@0 andKey:@"timerDuration"];
    [self.tabBarController.tabBar setHidden:YES] ;
    
self.navigationItem.hidesBackButton = YES;
        self.soundNameLabel.text = [PersistenceStorage getObjectForKey:@"USsoundName"];
    if (self.panning == audio ) {
        self.soundNameLabel.hidden = NO;
        self.videoPlayer.view.hidden = YES;
    }
    else
    {
        self.soundNameLabel.hidden = YES;
        self.videoPlayer.view.hidden = NO;

    }
}

//done button
-(void)doneTapped{
    SkillRatingsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"SkillRatingsViewController"];
    ratingsView.skillSection = @"Sounds";
    ratingsView.skillDetail = self.name;
    [self.navigationController pushViewController:ratingsView animated:YES];
}


-(void)initializeAudioPlayerWith:(NSString *)fileName
{
    
    
    
    NSString *beasMonoPath  =[[NSBundle mainBundle]pathForResource:[PersistenceStorage getObjectForKey:@"USsoundURL"]  ofType:nil];
    
    NSURL *url = [NSURL URLWithString:beasMonoPath];
    
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    
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
    UILabel *firstLabel = (UILabel *)[self.view viewWithTag:555];

    firstLabel.text = @"Infinitely";

    self.audioSeekSlider.minimumValue = 0;
    self.audioSeekSlider.maximumValue = self.audioPlayer.duration;
    
    [self.audioPlayer setVolume:self.volumeSeekSlider.value];
    [self.audioPlayer setPan:self.panSeekSlider.value];
//    [self.audioPlayer play];
    [self playSoundTapped:nil];
    
 


}


- (void)actionSheet:(UIActionSheet *)actionSheetTimer clickedButtonAtIndex:(NSInteger)buttonIndex
{
    timer = nil;
    
     NSString *buttonTitle = [actionSheetTimer buttonTitleAtIndex:buttonIndex];
    UILabel *firstLabel = (UILabel *)[self.view viewWithTag:555];
    

    self.audioSeekSlider.value = 0;

    [self.audioPlayer setCurrentTime:0];
    
    if ([actionSheetTimer.title isEqualToString:@"Select Time"]) {
        
        self.audioPlayer.numberOfLoops = -1;

        
        
        if  ([buttonTitle isEqualToString:@"Infinitely"]) {
            
            [PersistenceStorage setObject:@600000 andKey:@"timerDuration"];
            firstLabel.text = @"Infinitely";
            
            
            // secondsLeft1 = [PersistenceStorage getObjectForKey:@"timerDuration"];
        }
        

        if  ([buttonTitle isEqualToString:@"Once"]) {
            self.audioPlayer.numberOfLoops = 0;

            [PersistenceStorage setObject:@60 andKey:@"timerDuration"];
            firstLabel.text = @"Once";
            
            
            // secondsLeft1 = [PersistenceStorage getObjectForKey:@"timerDuration"];
        }
        

        
        
        if  ([buttonTitle isEqualToString:@"1 min"]) {
            
            [PersistenceStorage setObject:@60 andKey:@"timerDuration"];
            firstLabel.text = @"1 min";
            
            
            // secondsLeft1 = [PersistenceStorage getObjectForKey:@"timerDuration"];
        }
        
        
        
        if  ([buttonTitle isEqualToString:@"5 min"]) {
            
            [PersistenceStorage setObject:@300 andKey:@"timerDuration"];
            firstLabel.text= @"05:00 min";
            
            
            // secondsLeft1 = [PersistenceStorage getObjectForKey:@"timerDuration"];
        }

        
        
        if  ([buttonTitle isEqualToString:@"15 min"]) {
            
            [PersistenceStorage setObject:@900 andKey:@"timerDuration"];
            firstLabel.text= @"05:00 min";
            
            
            // secondsLeft1 = [PersistenceStorage getObjectForKey:@"timerDuration"];
        }

        
        
        if  ([buttonTitle isEqualToString:@"20 min"]) {
            
            [PersistenceStorage setObject:@1200 andKey:@"timerDuration"];
            firstLabel.text= @"20:00 min";
            
            
            // secondsLeft1 = [PersistenceStorage getObjectForKey:@"timerDuration"];
        }
        
        
        
        if  ([buttonTitle isEqualToString:@"30 min"]) {
            
            [PersistenceStorage setObject:@1800 andKey:@"timerDuration"];
            firstLabel.text= @"30:00 min";
            
            
            // secondsLeft1 = [PersistenceStorage getObjectForKey:@"timerDuration"];
        }
        
        
        
        if  ([buttonTitle isEqualToString:@"1 hour"]) {
            
            [PersistenceStorage setObject:@3600 andKey:@"timerDuration"];
            firstLabel.text= @"60:00 min";

            
            
            
            
            
            
            // secondsLeft1 = [PersistenceStorage getObjectForKey:@"timerDuration"];
        }
        
        
        
        
      

        }
            if  ([buttonTitle isEqualToString:@"3 hours"]) {
            
                [PersistenceStorage setObject:@10800 andKey:@"timerDuration"];
                firstLabel.text= @"3 hours";

            }
                if  ([buttonTitle isEqualToString:@"6 hours"]) {
                    
                    [PersistenceStorage setObject:@21600 andKey:@"timerDuration"];
                    firstLabel.text= @"6 hours";

                }
                    if  ([buttonTitle isEqualToString:@"9 hours"]) {
                        
                        [PersistenceStorage setObject:@32400 andKey:@"timerDuration"];
                        firstLabel.text= @"9 hours";

                    }
        
        [self countdownTimer:nil];

        
        [[self.view viewWithTag:220] setHidden:NO];
        
        
        
        
        
        // }
        
        
    }



- (IBAction)countdownTimer:(id)sender {
    
    
    
    NSString *tDuration = [PersistenceStorage getObjectForKey:@"timerDuration"];
    
    
    double tDurationDouble = [tDuration doubleValue];
    
    
    
    NSDate *currentDate1 = [NSDate date];
    self.startDate = [currentDate1 dateByAddingTimeInterval:tDurationDouble];
    
    
    [self.audioPlayer play];
    
    [self updateCounter];
    
}

- (void)updateCounter:(NSTimer *)theTimer
{
    // Create date from the elapsed time
    
    UILabel *firstLabel = (UILabel *)[self.view viewWithTag:555];

    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:self.startDate];
  //  NSLog(@"TIMER INTERAL %@",timeInterval);

    
    if (![firstLabel.text isEqualToString:@"Once"] && ![firstLabel.text isEqualToString:@"Infinitely"] )
    
    {
 
    
    
    if ([[PersistenceStorage getObjectForKey:@"timerDuration"] intValue] > 10)
    {
    if (timeInterval<0)
    {int ti = (int)(fabs(timeInterval));
        
         NSInteger seconds = ti % 60;
        NSInteger minutes = (ti / 60) % 60;
        NSInteger hours = (ti / 3600);
        
         NSString *displayTime = [NSString stringWithFormat:@"%02ld:%02ld:%02ld %@",  (long)hours,(long)minutes, (long)seconds,@"min" ] ;
        
        
        firstLabel.text = displayTime;
      //  NSLog(@"DISPLAY TIME %@",timeInterval);

    }
    else
    {
        NSLog(@"%@",[PersistenceStorage getObjectForKey:@"timerDuration"]);
        firstLabel.text= @"Ended Timed Playback";
        [self.audioPlayer stop];
        [[self.view viewWithTag:77] setHidden:NO];
        
    }
    }
        
    }
    
        
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
//[self playVideo];
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
    [self.audioPlayer stop];
    [self.audioPlayer setCurrentTime:self.audioSeekSlider.value];
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)replayButtonTapped:(id)sender {
    NSString *actionSheetTitle = @"Select Time"; //Action Sheet Title
    NSString *other0 = @"Once"; //Action Sheet Button Titles
    NSString *other1 = @"Infinitely";
    NSString *other2 = @"1 min";
    NSString *other3 = @"5 min";
    NSString *other4 = @"15 min";
    NSString *other5 = @"20 min";
    NSString *other6 = @"30 min";
    NSString *other7 = @"1 hour";
    NSString *other8 = @"3 hours";
    NSString *other9 = @"6 hours";
    NSString *other10 = @"9 hours";
    
    
 
    NSString *cancelTitle = @"Cancel";
    UIActionSheet *actionSheetTimer = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other0, other1, other2, other3, other4,other5, other6,other7, other8,other9, other10, nil];
    [actionSheetTimer showInView:self.view];
}










- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    timer = nil;
    
    [timer invalidate];

    [self.audioPlayer stop]; // Or pause
    [self.videoPlayer stop];
}

@end
