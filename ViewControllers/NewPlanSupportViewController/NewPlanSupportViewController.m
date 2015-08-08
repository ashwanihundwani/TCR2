//
//  NewPlanSupportViewController.m
//  TinnitusCoach
//
//  Created by Vikram Singh on 3/21/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "NewPlanSupportViewController.h"
#import "NavigationTipsViewController.h"

@interface NewPlanSupportViewController ()<MYIntroductionDelegate>

@end

@implementation NewPlanSupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showTour];
    NavigationTipsViewController *ntv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NavigationTipsViewController"];
    [self.navigationController presentViewController:ntv animated:YES completion:nil];

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




-(void)showTour{
    
    //STEP 1 Construct Panels
    self.navigationController.navigationBar.hidden=YES;
    //You may also add in a title for each panel
    
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithTitle:@"What is a \"plan\"?" description:@"A \"plan\" describes what you will do when your tinnitus is bothering you. Your tinnitus can bother you in different situations. You will first identify a bothersome situation you want to work on. \n\n Then you will make a plan specific to that situation. This app will help you make each plan that you would like to try. Then, when your tinnitus is bothering you can use your plan for that situation. "];
    
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithTitle:@"How will making and using plans help me with my tinnitus?" description:@"Several coping skills can be used to help you feel better when your tinnitus is bothering you. When you make a plan, you will first see a list of coping skills. \n\n If you see a skill you would like to learn, you can add it to your plan. When you use your plan, the app will teach you how to use each skill on your plan. As you practice skills, you will learn which are helpful for you."];
    
    
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
    
    MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(20, 0, self.view.bounds.size.width-40, 500) headerTexts:@[@"What is a \"plan\"?", @"How will making and using plans help me with my tinnitus?"] panels:@[panel1, panel2] languageDirection:MYLanguageDirectionLeftToRight];
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
