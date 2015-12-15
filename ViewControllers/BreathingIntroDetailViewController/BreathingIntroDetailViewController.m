//
//  SkillIntroductionViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 3/22/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "BreathingIntroDetailViewController.h"

@interface BreathingIntroDetailViewController ()<MYIntroductionDelegate>

@end

@implementation BreathingIntroDetailViewController

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
    //You may also add in a title for each panel
    
    
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"Intro2image1.png"] title: @"Why is \"Deep Breathing\" helpful?" description:@"Deep Breathing is a special way to breathe that helps you relax. When people as stressed, their breathing is often shallow and rapid. Breathing deeply tells the body to relax. It counteracts the stress response. You can combine Deep Breathing with Imagery to feel even more relaxed."];
    
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"Intro2image2.png"] title: @"How can  \"Deep Breathing\" help me with my tinnitus?" description:@"Deep Breathing can reduce tension and stress caused by tinnitus. Using Deep Breathingwon't change your tinnitus but it can help you relax. Being relaxed can help you cope with your tinnitus."];
    
    MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"Intro2image3.png"] title: @"How do I do \"Deep Breathing\"?" description:@"A video is included with instructions on how to do Deep Breathing. After yoy watch the video, a timer is provided to help you practice on your own."];
    
    MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(20, 0, self.view.bounds.size.width-40, 500) headerTexts:@[@"Why is \"Deep Breathing\" helpful?", @"How can  \"Deep Breathing\" help me with my tinnitus?", @"How do I do \"Deep Breathing\"?"] panels:@[panel1, panel2, panel3] languageDirection:MYLanguageDirectionLeftToRight];
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
