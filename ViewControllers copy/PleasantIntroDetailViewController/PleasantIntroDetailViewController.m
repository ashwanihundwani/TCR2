//
//  SkillIntroductionViewController.m
//  TinnitusCoach
//
//  Created by Vikram Singh on 3/22/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "PleasantIntroDetailViewController.h"

@interface PleasantIntroDetailViewController ()<MYIntroductionDelegate>

@end

@implementation PleasantIntroDetailViewController

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
    
    
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"Intro5image1.png"] title: @"What is \"Pleasant Activities\"?" description:@"Working and doing chores are important. It is also important to do some things just because you enjoy them. Pleasant activities are activities you enjoy."];
    
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"Intro5image2.png"] title: @"How can \"Pleasant Activities\" help me?" description:@"Some people who are bothered by tinnitus start spending less time doing things they enjoy. This can make tinnitus problem feel even worse. Adding pleasant activities can help. Activities you enjoy can distract you from your tinnitus. They can also help you feel happier and more relaxed."];
    
    
    
    MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"Intro5image3.png"] title: @"What is \"values\"?" description:@"\Values\" are what is important to you. If you pick activities that fit with your values, you may feel like they add meaning to your life. With this skill you will choose pleasant activities that fit with your values. You will then schedule these activities on your calendar."];
    
    
    
    
    
    
    //STEP 2 Create IntroductionView
    
    
    /*A more customized version*/
    
    //    NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc] initWithString:@"Welcome to the Party !"];
    //    [string1 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [string1 length])];
    //
    //    NSMutableAttributedString * string2 = [[NSMutableAttributedString alloc] initWithString:@"X a Post"];
    //    [string2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [string2 length])];
    //
    //    NSMutableAttributedString * string3 = [[NSMutableAttributedString alloc] initWithString:@"Check Posts"];
    //    [string3 addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, [string3 length])];
    //
    //    NSMutableAttributedString * string4 = [[NSMutableAttributedString alloc] initWithString:@"Flag a Post"];
    //    [string4 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [string4 length])];
    
    MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(20, 0, self.view.bounds.size.width-40, 500) headerTexts:@[@"What is \"Pleasant Activities\"?", @"How can \"Pleasant Activities\" help me?", @"What is \"values\"?"] panels:@[panel1, panel2,panel3] languageDirection:MYLanguageDirectionLeftToRight];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
