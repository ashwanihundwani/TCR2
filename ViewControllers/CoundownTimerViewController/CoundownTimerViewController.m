//
//  SamplerViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 14/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//
#import <MediaPlayer/MediaPlayer.h>
#import "SkillRatingsViewController.h"
#import "CoundownTimerViewController.h"

#import "HomeNewViewController.h"
#import "SamplerViewController.h"
#import "NookViewController.h"
#import "PlansViewController.h"

#define NUMBER_OF_LOOPS -1
//#import "SupportViewController.h"
//@interface CountdownTimerViewController ()
//@end


@interface CountdownTimerViewController () <AVAudioPlayerDelegate>
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

@property(weak, nonatomic) IBOutlet UIView *playSoundView;
@property(weak, nonatomic) IBOutlet UIView *setTimerView;

@property(weak, nonatomic) IBOutlet UILabel *soundLabel;
@property(weak, nonatomic) IBOutlet UILabel *timerLabel;

@property(weak, nonatomic) IBOutlet UIButton *startButton;
@property(weak, nonatomic) IBOutlet UIButton *doneButton;

@property(weak, nonatomic)IBOutlet UIImageView *imageView;


@end

//@implementation AudioPlayerTwoViewController

@implementation CountdownTimerViewController

-(IBAction)onStart:(id)sender
{
    if([self.startButton.titleLabel.text isEqualToString:@"Start"])
    {
        [self countdownTimer:self];
        [self.startButton setTitle:@"Stop" forState:UIControlStateNormal];
        
    }
    else
    {
        [timer invalidate];
        timer = nil;
        [self.audioPlayer stop];
        
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
    }
}

-(IBAction)onDone:(id)sender
{
    [PersistenceStorage setObject:@"Timer" andKey:@"Referer"];
    [self dismissModalViewControllerAnimated:NO];
}

@synthesize myCounterLabel;


-(void)viewDidAppear:(BOOL)animated
{
    //  if (timer) {
    //   [timer invalidate];
    //timer = nil;
    
    
    [[self.view viewWithTag:220] setHidden:NO];
    [[self.view viewWithTag:77] setHidden:NO];
    
    [PersistenceStorage setObject:@300 andKey:@"timerDuration"];
    
    
    UILabel *firstLabel = (UILabel *)[self.view viewWithTag:77];
    [PersistenceStorage setObject:@"Babbling Brook" andKey:@"skillDetail2"];
    firstLabel.text = @"Babbling Brook";
    self.audioPlayer.numberOfLoops = NUMBER_OF_LOOPS;
    
    NSString *beasMonoPath  =[[NSBundle mainBundle]pathForResource:@"BabblingBrook.mp3"  ofType:nil];
    NSURL *url = [NSURL URLWithString:beasMonoPath];
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    
    
    
}






int hours, minutes, seconds;
int secondsLeft;


-(void)onPlaySound:(id)sender
{
    [self selectAudio:sender];
}

-(void)onTimer:(id)sender
{
    [self selectTime:self];
}



- (void)viewDidLoad {
    
    
    
    
    [super viewDidLoad];
    
    [self.timerLabel setText:@"5 min"];
    self.imageView.image =  [UIImage imageNamed:@"BabblingBrook.png"];
    self.soundLabel.text = @"Babbling Brook";
    
    
    [[self.view viewWithTag:1] removeFromSuperview];
    [[self.view viewWithTag:2] removeFromSuperview];
    [[self.view viewWithTag:3] removeFromSuperview];
    [[self.view viewWithTag:77] removeFromSuperview];
    [[self.view viewWithTag:200] removeFromSuperview];
    
    [[self.view viewWithTag:1] setHidden:NO];
    
    [[self.view viewWithTag:2] setHidden:NO];
    
    [[self.view viewWithTag:3] setHidden:NO];
    [[self.view viewWithTag:220] setHidden:YES];
    
    [[self.view viewWithTag:77] setHidden:NO];
    
    self.navigationController.navigationBar.hidden = NO;
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    
    titleView.backgroundColor = [Utils colorWithHexValue:NAV_BAR_BLACK_COLOR];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 320, 44)];
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_1];
    
    titleLabel.font = pallete.secondObj;
    titleLabel.textColor = pallete.firstObj;
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //titleLabel.textColor = [UIColor colorWithHexValue:@"797979"];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = self.header;
    
    [titleView addSubview:titleLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, titleView.frame.size.height - 1, 320, 1)];
    
    line.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.098/255.0 alpha:0.22];;
    
    [titleView addSubview:line];
    
    [self.view addSubview:titleView];
    
    [Utils addTapGestureToView:self.setTimerView target:self selector:@selector(onTimer:)];
    
    [Utils addTapGestureToView:self.playSoundView target:self selector:@selector(onPlaySound:)];
    
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    
    
    self.audioPlayer.numberOfLoops = NUMBER_OF_LOOPS;
    
    NSString *beasMonoPath  =[[NSBundle mainBundle]pathForResource:@"BabblingBrook.mp3"  ofType:nil];
    NSURL *url = [NSURL URLWithString:beasMonoPath];
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [self.audioPlayer prepareToPlay];
    
}







- (void)updateCounter:(NSTimer *)theTimer
{
    // Create date from the elapsed time
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:self.startDate];
    if (timeInterval<0)
    {int ti = (int)(fabs(timeInterval));
        
        //NSInteger ti = (NSInteger)interval;
        NSInteger seconds = ti % 60;
        NSInteger minutes = (ti / 60) % 60;
        //   NSInteger hours = (ti / 3600);
        NSString *displayTime = [NSString stringWithFormat:@"%02ld:%02ld %@",  (long)minutes, (long)seconds,@"min" ] ;
        
        //    NSString *B = @" min";
        // self.startPointLabel.text = [NSString stringWithFormat:@"%@%@",A,B];
        
        
        
        
        self.timerLabel.text = displayTime;
        
    }
    else
    {
        self.timerLabel.text= @"00:00 min";
        [self.audioPlayer stop];
        [[self.view viewWithTag:77] setHidden:NO];
        
    }
}









- (IBAction)countdownTimer:(id)sender {
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    
    [[self.view viewWithTag:220] setHidden:YES];
    [[self.view viewWithTag:77] setHidden:NO];
    
    [[self.view viewWithTag:1] setHidden:YES];
    
    [[self.view viewWithTag:2] setHidden:YES];
    
    //  secondsLeft = hours = minutes = seconds = 0;
    
    NSString *tDuration = [PersistenceStorage getObjectForKey:@"timerDuration"];
    
    
    
    
    
    
    double tDurationDouble = [tDuration doubleValue];
    
    
    
    NSDate *currentDate1 = [NSDate date];
    self.startDate = [currentDate1 dateByAddingTimeInterval:tDurationDouble];
    
    self.audioPlayer.numberOfLoops = NUMBER_OF_LOOPS;
    
    
    NSInteger numberOfLoops = self.audioPlayer.numberOfLoops;
    
    NSLog(@"loops : %d", numberOfLoops);
    [self.audioPlayer play];
    
    [self updateCounter];
    
}





- (IBAction)selectAudio:(id)sender {
    NSString *actionSheetTitle = @"Play Sound"; //Action Sheet Title
    NSString *other0 = @"Babbling Brook"; //Action Sheet Button Titles
    NSString *other1 = @"Crackling Fire";
    NSString *other2 = @"Frogs";
    NSString *other3 = @"Ocean Waves";
    NSString *other4 = @"Pink Noise";
    
    
    
    NSString *cancelTitle = @"Cancel";
    UIActionSheet *actionSheetAudio = [[UIActionSheet alloc]
                                       initWithTitle:actionSheetTitle
                                       delegate:self
                                       cancelButtonTitle:cancelTitle
                                       destructiveButtonTitle:nil
                                       otherButtonTitles:other0, other1,other2,other3,other4, nil];
    
    
    
    [actionSheetAudio setTag:@1];
    
    [actionSheetAudio showInView:self.view];
}


//strAct = [dict valueForKey:@"activityName"];
//[PersistenceStorage setObject:strAct andKey:@"activityName"];







// [self.audioPlayer play];




















- (IBAction)selectTime:(id)sender {
    
    
    
    NSString *actionSheetTitle = @"Select Time"; //Action Sheet Title
    NSString *other0 = @"5 min"; //Action Sheet Button Titles
    NSString *other1 = @"10 min";
    NSString *other2 = @"20 min";
    
    NSString *other3 = @"30 min";
    
    NSString *other4 = @"60 min";
    
    NSString *other5 = @"20 min";
    
    NSString *cancelTitle = @"Cancel";
    
    
    
    
    UIActionSheet *actionSheetTime = [[UIActionSheet alloc]
                                      initWithTitle:actionSheetTitle
                                      delegate:self
                                      cancelButtonTitle:cancelTitle
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:other0, other1,other2,other3,other4, nil];
    [actionSheetTime setTag:@2];
    
    [actionSheetTime showInView:self.view];
}



-(IBAction)doneButtonTapped:(id)sender
{
    [PersistenceStorage setObject:@"Timer" andKey:@"Referer"];
    [self dismissModalViewControllerAnimated:NO];
    
    
}




- (void)actionSheet:(UIActionSheet *)actionSheetTimer clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.timerLabel setText:@"5 min"];
    
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheetTimer buttonTitleAtIndex:buttonIndex];
    
    //   NSString * theValue = [(UILabel*)[self viewWithTag:t200] text];
    [PersistenceStorage setObject:@"Timer for Practice" andKey:@"skillDetail1"];
    
    if ([actionSheetTimer.title isEqualToString:@"Play Sound"]) {
        
        
        NSString *buttonTitle = [actionSheetTimer buttonTitleAtIndex:buttonIndex];
        
        [[self.view viewWithTag:77] setHidden:NO];
        
        
        if  ([buttonTitle isEqualToString:@"Babbling Brook"]) {
            
            self.soundLabel.text = @"Babbling Brook";
            self.audioPlayer.numberOfLoops = NUMBER_OF_LOOPS;
            
            //
            UILabel *firstLabel = (UILabel *)[self.view viewWithTag:77];
            firstLabel.text = @"Babbling Brook";
            [self.imageView setImage:[UIImage imageNamed: @"BabblingBrook.png"]];
            NSString *beasMonoPath  =[[NSBundle mainBundle]pathForResource:@"BabblingBrook.mp3"  ofType:nil];
            NSURL *url = [NSURL URLWithString:beasMonoPath];
            self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
            [PersistenceStorage setObject:@"Babbling Brook" andKey:@"skillDetail2"];
            
        }
        
        
        
        if  ([buttonTitle isEqualToString:@"Crackling Fire"]) {
            
            self.soundLabel.text = @"Crackling Fire";
            self.audioPlayer.numberOfLoops = NUMBER_OF_LOOPS;
            
            //
            UILabel *firstLabel = (UILabel *)[self.view viewWithTag:77];
            firstLabel.text = @"Crackling Fire";
            [self.imageView setImage:[UIImage imageNamed: @"Fire.png"]];
            
            NSString *beasMonoPath  =[[NSBundle mainBundle]pathForResource:@"CracklingFire.mp3"  ofType:nil];
            NSURL *url = [NSURL URLWithString:beasMonoPath];
            self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
            [PersistenceStorage setObject:@"Crackling Fire" andKey:@"skillDetail2"];
            
        }
        
        
        
        
        
        if  ([buttonTitle isEqualToString:@"Frogs"]) {
            
            self.soundLabel.text = @"Frogs";
            
            self.audioPlayer.numberOfLoops = NUMBER_OF_LOOPS;
            
            //
            UILabel *firstLabel = (UILabel *)[self.view viewWithTag:77];
            firstLabel.text = @"Frogs";
            [self.imageView setImage:[UIImage imageNamed: @"Frogs.png"]];
            
            NSString *beasMonoPath  =[[NSBundle mainBundle]pathForResource:@"frog.mp3"  ofType:nil];
            NSURL *url = [NSURL URLWithString:beasMonoPath];
            self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
            [PersistenceStorage setObject:@"Frogs" andKey:@"skillDetail2"];
        }
        
        
        
        if  ([buttonTitle isEqualToString:@"Ocean Waves"]) {
            
            self.soundLabel.text = @"Ocean Waves";
            
            self.audioPlayer.numberOfLoops = NUMBER_OF_LOOPS;
            
            //
            UILabel *firstLabel = (UILabel *)[self.view viewWithTag:77];
            firstLabel.text = @"Ocean Waves";
            [self.imageView setImage:[UIImage imageNamed: @"Ocean.png"]];
            
            NSString *beasMonoPath  =[[NSBundle mainBundle]pathForResource:@"OceanWaves.mp3"  ofType:nil];
            NSURL *url = [NSURL URLWithString:beasMonoPath];
            self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
            [PersistenceStorage setObject:@"Ocean Waves" andKey:@"skillDetail2"];
            
        }
        
        
        
        if  ([buttonTitle isEqualToString:@"Pink Noise"]) {
            
            self.soundLabel.text = @"Pink Noise";
            self.audioPlayer.numberOfLoops = NUMBER_OF_LOOPS;
            
            //
            UILabel *firstLabel = (UILabel *)[self.view viewWithTag:77];
            firstLabel.text = @"Pink Noise";
            [self.imageView setImage:[UIImage imageNamed: @"PinkNoise.png"]];
            
            NSString *beasMonoPath  =[[NSBundle mainBundle]pathForResource:@"PinkNoise.mp3"  ofType:nil];
            NSURL *url = [NSURL URLWithString:beasMonoPath];
            self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
            [PersistenceStorage setObject:@"Pink Noise" andKey:@"skillDetail2"];
            
        }
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    if (actionSheetTimer.title == @"Select Time") {
        
        
        
        if  ([buttonTitle isEqualToString:@"5 min"]) {
            
            [PersistenceStorage setObject:@300 andKey:@"timerDuration"];
            self.timerLabel.text= @"05:00 min";
            
            // secondsLeft1 = [PersistenceStorage getObjectForKey:@"timerDuration"];
        }
        
        
        
        if  ([buttonTitle isEqualToString:@"10 min"]) {
            
            [PersistenceStorage setObject:@600 andKey:@"timerDuration"];
            self.timerLabel.text= @"10:00 min";
            
            // secondsLeft1 = [PersistenceStorage getObjectForKey:@"timerDuration"];
        }
        
        
        
        
        
        if  ([buttonTitle isEqualToString:@"20 min"]) {
            
            [PersistenceStorage setObject:@1200 andKey:@"timerDuration"];
            self.timerLabel.text= @"20:00 min";
            
            // secondsLeft1 = [PersistenceStorage getObjectForKey:@"timerDuration"];
        }
        
        
        
        if  ([buttonTitle isEqualToString:@"30 min"]) {
            
            [PersistenceStorage setObject:@1800 andKey:@"timerDuration"];
            self.timerLabel.text= @"30:00 min";
            
            // secondsLeft1 = [PersistenceStorage getObjectForKey:@"timerDuration"];
        }
        
        
        if  ([buttonTitle isEqualToString:@"60 min"]) {
            
            [PersistenceStorage setObject:@3600 andKey:@"timerDuration"];
            self.timerLabel.text= @"60:00 min";
            
            // secondsLeft1 = [PersistenceStorage getObjectForKey:@"timerDuration"];
        }
        
        
        
        
        
        
        //  if (!buttonIndex== 6)
        
        //{
        
        
        //    [[self.view viewWithTag:1] setHidden:YES];
        // [[self.view viewWithTag:2] setHidden:YES];
        
        //  [[self.view viewWithTag:3] setHidden:YES];
        // [[self.view viewWithTag:77] setHidden:NO];
        [[self.view viewWithTag:220] setHidden:NO];
        
        //    }
    }
    
    
    [self.audioPlayer stop];
    [timer invalidate];
    timer = nil;
    
    [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
}




-(void)movieFinishedCallback:(NSNotification*)aNotification {
    // [self dismissMoviePlayerViewControllerAnimated];
    NSLog(@"%@",aNotification);
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
    
    [[self.view viewWithTag:1] setHidden:NO];
    
    [[self.view viewWithTag:2] setHidden:NO];
    
    [[self.view viewWithTag:3] setHidden:NO];
    [[self.view viewWithTag:220] setHidden:YES];
    
    
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
    [[self.view viewWithTag:77] setHidden:YES];
    [self writeTimerSoundSelected];

    //  secondsLeft = @0;
    SkillRatingsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"SkillRatingsViewController"];
    ratingsView.skillSection = @"Sounds";
    ratingsView.skillDetail = self.name;
    [self.navigationController pushViewController:ratingsView animated:YES];
}

-(void)playVideo{
    if (self.videoPlayer.playbackState == MPMoviePlaybackStateStopped) {
        
        
        NSString *str = [[NSBundle mainBundle]pathForResource:self.videoURL ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:
                      str];
        
        
        self.videoPlayer.shouldAutoplay = YES;
        
        self.videoPlayer = [[MPMoviePlayerController alloc]
                            initWithContentURL:url];
        self.videoPlayer.movieSourceType = MPMovieSourceTypeFile;
        
        // self.videoPlayer.view.frame = CGRectMake(25, self.viewForControl.frame.origin.y + self.viewForControl.frame.size.height +30, self.view.bounds.size.width-45, 120);
        
        
        
        
        self.videoPlayer.view.frame = CGRectMake(5, self.viewForControl.frame.origin.y-150 + self.viewForControl.frame.size.height +30, self.view.bounds.size.width-15, 400);
        
        [self.view addSubview:self.videoPlayer.view];
        self.audioSeekSlider.minimumValue = 0;
        self.audioSeekSlider.maximumValue = self.videoPlayer.duration;
        
        // Set shouldAutoplay to YES
        [self.videoPlayer prepareToPlay];
        [self.videoPlayer play];
        
        
        
        
    }
    
    else{
        
        [self.videoPlayer play];
        
    }
}

-(void)initializeAudioPlayerWith:(NSString *)fileName
{
    NSString *beasMonoPath  =[[NSBundle mainBundle]pathForResource:self.url  ofType:nil];
    
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
    
    
    
    
    NSString *A = [NSString stringWithFormat:@"00:00"];;
    NSString *B = @" min";
    self.startPointLabel.text = [NSString stringWithFormat:@"%@%@",A,B];
    
    
    
    self.audioSeekSlider.value = 0;
    self.audioPlayer.numberOfLoops = NUMBER_OF_LOOPS;
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
    [self.audioPlayer stop];
    [self.audioPlayer setCurrentTime:self.audioSeekSlider.value];
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidDisappear:(BOOL)animated


{
    
    timer = nil;
    
    [timer invalidate];
    
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    timer = nil;
    
    [timer invalidate];
    
    
    [self.audioPlayer stop]; // Or pause
    [self.videoPlayer stop];
}



-(void)writeTimerSoundSelected
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentTXTPath = [documentsDirectory stringByAppendingPathComponent:@"TinnitusCoachUsageData.csv"];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM/dd/yy";
    NSString *dateString = [dateFormatter stringFromDate: date];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"HH:mm:ss";
    NSString *timeString = [timeFormatter stringFromDate: date];
    NSString *type = @"Skill";
    NSString *str = @"Provided a Rating";
    
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"situationName"],[PersistenceStorage getObjectForKey:@"skillName"],@"Timer for Practice",[PersistenceStorage getObjectForKey:@"skillDetail2"],nil,nil,nil,nil,nil,nil];
    
    NSLog(@"%@",finalStr);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:documentTXTPath])
    {
        [finalStr writeToFile:documentTXTPath atomically:YES];
    }
    else
    {
        NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:documentTXTPath];
        [myHandle seekToEndOfFile];
        [myHandle writeData:[finalStr dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
}









@end



