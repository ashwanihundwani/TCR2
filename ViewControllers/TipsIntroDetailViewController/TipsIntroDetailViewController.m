//
//  SkillIntroductionViewController.m
//  TinnitusCoach
//
//  Created by Vikram Singh on 3/22/15.
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
{[self.tabBarController.tabBar setHidden:NO];
}





- (void)showTour
{
     //STEP 1 Construct Panels
    self.navigationController.navigationBar.hidden=YES;
    //You may also add in a title for each panel
    
    
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"Intro7image1.png"] title: @"How can \"Tips for Better Sleep\" help me cope with my Tinnitus?" description:@"Your tinnitus may seem worse when you are tired. When you get enough sleep, you are ready to handle problems, and you won’t get frustrated as easily. A good night’s sleep will give you energy to practice skills from this app."];
    
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"Intro7image2.png"] title: @"What does \"Tips for Better Sleep\" involve?" description:@"Tips for Better Sleep is a list of things you can try to improve your sleep. You can select the tips you want to use and set a reminder. "];
    
//MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"Intro2Image2.png"] title: @"How do I do \"Deep Breathing\"?" description:@"A video is included with instructions on how to do Deep Breathing. After yoy watch the video, a timer is provided to help you practice on your own."];
    
    
    
    
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
