//
//  DeepBreathingViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 18/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "CTF06New.h"

#import "ChangingThoughtsViewController.h"
#import "DeepBreathingViewController.h"
#import "BreathingIntroDetailViewController.h"
#import "AudioPanningViewController.h"
#import "VideoPlayerViewController.h"
#import "ScheduleViewController.h"
#import "SkillRatingsViewController.h"
#import "NookUsingSoundViewControllerOne.h"
#import "CoundownTimerViewController.h"
#import "NewPlanAddedViewController.h"
#import <EventKitUI/EventKitUI.h>
#import "CTF05.h"
#import "DBManager.h"
#import "MBProgressHUD.h"


@interface CTF06New ()
{
    NSArray *emotionsArray;
    NSArray *emotionsArrayNew;

}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation CTF06New

- (void)viewDidLoad {

    [super viewDidLoad];
     self.dbManager = [[DBManager alloc] initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    [self setUpView];
    self.title = @"Add New Entry";
}


-(void)viewDidAppear:(BOOL)animated
{
    [PersistenceStorage setObject:@"ctf06" andKey:@"ctfCategory"];
    [self setData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
}



- (void)setUpView {


[self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTapped)];
[self.navigationItem setLeftBarButtonItem:barButton];

}


-(void)setData
{
    NSString *query = @"SELECT thoughtText,rating FROM My_TF where thoughtCategory = 'step3'";
   emotionsArray = [self.dbManager loadDataFromDB:query];

    NSString *queryNew = @"SELECT thoughtText,rating FROM My_TF where thoughtCategory = 'step6'";
    emotionsArrayNew = [self.dbManager loadDataFromDB:queryNew];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
         return 1; // The number of sections in table1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    NSString *query = @"SELECT thoughtText,rating FROM My_TF where thoughtCategory = 'step3'";
    emotionsArray = [self.dbManager loadDataFromDB:query];
    NSString *queryNew = @"SELECT thoughtText,rating FROM My_TF where thoughtCategory = 'step6'";
    emotionsArrayNew = [self.dbManager loadDataFromDB:queryNew];
    if(tableView == self.EmotionsTableView)
        return [emotionsArray count];
    else
        return [emotionsArrayNew count];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    static NSString *CellIdentifier = @"Cell";
    NSString *query = @"SELECT thoughtText,rating FROM My_TF where thoughtCategory = 'step3'";
    emotionsArray = [self.dbManager loadDataFromDB:query];
    NSString *queryNew = @"SELECT thoughtText,rating FROM My_TF where thoughtCategory = 'step6'";
    emotionsArrayNew = [self.dbManager loadDataFromDB:queryNew];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    if(tableView == self.EmotionsTableView){
        
        cell.textLabel.text =  [[emotionsArray objectAtIndex:indexPath.row] valueForKey:@"thoughtText"];
    }
    else if(tableView == self.NewEmotionsTableView){
        cell.textLabel.text = [emotionsArrayNew objectAtIndex:indexPath.row];
    }
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
}


- (void)cancelTapped  {
    for (UIViewController* vc in self.navigationController.viewControllers) {
        if([vc isKindOfClass:[ChangingThoughtsViewController class]]){
            [self.navigationController popToViewController:vc animated:YES];
        }
    }

}




 
- (IBAction)backButtonTapped:(id)sender {
    CTF05 *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"CTF05"];
    [self.navigationController pushViewController:ratingsView animated:YES];

 }




-(IBAction)goToScheduler:(id)sender
{
    ScheduleViewController *favc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ScheduleViewController"];
    [self.navigationController pushViewController:favc animated:YES];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if  ([buttonTitle isEqualToString:@"Repeat This Skill"]) {

    }
    if ([buttonTitle isEqualToString:@"Learn About This Skill"]) {
        NookUsingSoundViewControllerOne *samplerView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookUsingSoundViewControllerOne"];
        [self.navigationController pushViewController:samplerView animated:NO];
    }
    
    
    if ([buttonTitle isEqualToString:@"Try Another Skill"]) {
        NewPlanAddedViewController *samplerView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NewPlanAddedViewController"];
        [self.navigationController pushViewController:samplerView animated:YES];
        
    }
    
    if ([buttonTitle isEqualToString:@"Return Home"]) {
        [[self tabBarController] setSelectedIndex:0];
        
    }
    
    if ([buttonTitle isEqualToString:@"Do Activity Now"]) {

    }
    
    
    
    if ([buttonTitle isEqualToString:@"Schedule Later"]) {
        ScheduleViewController *svc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ScheduleViewController"];
        [self.navigationController pushViewController:svc animated:YES];
    }
    
    
}



-(IBAction)viewIntroductionAgainClicked:(id)sender{
    BreathingIntroDetailViewController *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"BreathingIntroDetailViewController"];
    [self.navigationController pushViewController:siv animated:YES];
    
}


-(IBAction)learnMoreClicked:(id)sender{
    NookUsingSoundViewControllerOne *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookUsingSoundViewControllerOne"];
    [self.navigationController pushViewController:siv animated:YES];
    
}

- (IBAction)BreathingTimer:(id)sender {
    CountdownTimerViewController *guided = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                            
                                            instantiateViewControllerWithIdentifier:@"CountdownTimerViewController"];
    [self.navigationController presentModalViewController:guided animated:YES];
    
 
    
}



- (IBAction)PlayAudioOne:(id)sender {
    
    AudioPanningViewController *audioPanning = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AudioPanningViewController"];
    audioPanning.url = @"frog.mp3";
    audioPanning.name = @"Something   ";
    audioPanning.panning = audio;
    
 
    [self.navigationController pushViewController:audioPanning animated:YES];
}


- (IBAction)PlayVideoOne:(id)sender {
    
    VideoPlayerViewController *audioPanning = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
    audioPanning.panning = video;
    audioPanning.videoURL = @"DeepBreathingLesson.mp4";
    [PersistenceStorage setObject:@"Video Lesson" andKey:@"skillDetail1"];

    [self.navigationController presentModalViewController:audioPanning animated:NO];

}



- (IBAction)PlayVideoTwo:(id)sender {
    
    VideoPlayerViewController *audioPanning = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
    audioPanning.panning = video;
    audioPanning.videoURL = @"deep_breathing.mp4";
    [PersistenceStorage setObject:@"Video Introduction" andKey:@"skillDetail1"];

    [self.navigationController presentModalViewController:audioPanning animated:NO];

}






@end
