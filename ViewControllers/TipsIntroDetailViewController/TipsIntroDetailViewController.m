//
//  SkillIntroductionViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 3/22/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "TipsIntroDetailViewController.h"

@interface TipsIntroDetailViewController ()<MYIntroductionDelegate>

@end

@implementation TipsIntroDetailViewController

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
{
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)showTour
{
     //STEP 1 Construct Panels
    self.navigationController.navigationBar.hidden=YES;
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"Intro7image1.png"] title: @"How can \"Tips for Better Sleep\" help me cope with my Tinnitus?" description:@"Your tinnitus may seem worse when you are tired. When you get enough sleep, you are ready to handle problems, and you won’t get frustrated as easily. A good night’s sleep will give you energy to practice skills from this app."];
    
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"Intro7image2.png"] title: @"What does \"Tips for Better Sleep\" involve?" description:@"Tips for Better Sleep is a list of things you can try to improve your sleep. You can select the tips you want to use and set a reminder. "];
    
    MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(20, 0, self.view.bounds.size.width-40, 500) headerTexts:@[@"How can \"Tips for Better Sleep\" help me cope with my Tinnitus?", @"What does \"Tips for Better Sleep\" involve?"] panels:@[panel1, panel2] languageDirection:MYLanguageDirectionLeftToRight];
    
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
