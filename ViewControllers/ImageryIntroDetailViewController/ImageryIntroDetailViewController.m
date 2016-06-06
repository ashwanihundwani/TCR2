//
//  SkillIntroductionViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 3/22/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "ImageryIntroDetailViewController.h"

@interface ImageryIntroDetailViewController ()<MYIntroductionDelegate>

@end

@implementation ImageryIntroDetailViewController

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
    
    
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"Intro3image1.png"] title: @"Why is \"Imagery\" helpful?" description:@"Imagery is imagining a calm and peaceful place. Imagining the sights, sounds, and smells of the place can help you relax. You can combine Imagery with Deep Breathing  to feel even more relaxed."];
    
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"Intro3image2.png"] title: @"How can  \"Imagery\" help me with my tinnitus?" description:@"Imagery can reduce the tension and stress caused by tinnitus. Using imagery won’t change your tinnitus, but it can help you relax. Being relaxed can help you cope with your tinnitus. "];
    
    MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"Intro3image3.png"] title: @"How do I do \"Imagery\"?" description:@"A video will show you how to do Imagery. After you watch the video you will have access to a timer that will help you practice on your own. "];
    
    MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(20, 0, self.view.bounds.size.width-40, 500) headerTexts:@[@"Why is \"Imagery\" helpful?", @"How can  \"Imagery\" help me with my tinnitus?", @"How do I do \"Imagery\"?"] panels:@[panel1, panel2, panel3] languageDirection:MYLanguageDirectionLeftToRight];
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
