//
//  SkillIntroductionViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 3/22/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "MeditationIntroDetailViewController.h"

@interface MeditationIntroDetailViewController ()<MYIntroductionDelegate>

@end

@implementation MeditationIntroDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showTour];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)viewWillAppear:(BOOL)animated
{[self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{[self.tabBarController.tabBar setHidden:NO];
}





- (void)showTour
{
     //STEP 1 Construct Panels
    self.navigationController.navigationBar.hidden=YES;
    //You may also add in a title for each panel
    
    
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"Intro4image1.png"] title: @"What is \"Guided Meditation\"?" description:@"In Guided Meditation, a voice leads you through ways to relax your body and mind. You can choose from five different exercises."];
    
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"Intro4image2.png"] title: @"What will I be doing in these exercises?" description:@"For three of these exercises you will focus on relaxing different parts of the body where you feel stress. The other two exercises focus on 'mindfulness'. Mindfulness means paying attention to the present moment."];
    
    MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(20, 0, self.view.bounds.size.width-40, 500) headerTexts:@[@"What is \"Guided Meditation\"?", @"What will I be doing in these exercises?"] panels:@[panel1, panel2] languageDirection:MYLanguageDirectionLeftToRight];
    [introductionView setBackgroundColor:[UIColor whiteColor]];
    [introductionView.BackgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [introductionView.HeaderImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [introductionView.HeaderLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [introductionView.HeaderView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [introductionView.PageControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [introductionView.SkipButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    //Set delegate to self for callbacks (optional)
    introductionView.delegate = self;
    
    //STEP 3: Show introduction view
    [introductionView showInView:self.view animateDuration:0.0];
}


-(void)introductionDidFinishWithType:(MYFinishType)finishType
{
    self.navigationController.navigationBar.hidden=NO;
    
    [self.navigationController popViewControllerAnimated:NO];
}


@end
