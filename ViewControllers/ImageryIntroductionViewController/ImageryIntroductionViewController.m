//
//  SkillIntroductionViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 3/22/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "ImageryIntroductionViewController.h"

@interface ImageryIntroductionViewController ()<MYIntroductionDelegate>

@end

@implementation ImageryIntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![[PersistenceStorage getObjectForKey:@"shownImageryIntro"] isEqual: @"OK"])
    {
        ImageryIntroductionViewController *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"BreathingIntroDetailViewController"];
        [self.navigationController pushViewController:siv animated:YES];
        
    }
    
    [PersistenceStorage setObject:@"OK" andKey:@"shownImageryIntro"];

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
    NSLog(@"SHOW TOUR");
    //STEP 1 Construct Panels
    self.navigationController.navigationBar.hidden=YES;
    //You may also add in a title for each panel
    
    
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"Intro3image1.png"] title: @"Why is \"Imagery\" helpful?" description:@"Using Sound will guide you to find sounds that can help when your tinnitus is bothering you. You will learn to:\n\n•     Brainstorm ideas for sounds that will help.\n•     Make a plan for trying specific sounds.\n•     Use the plan when your tinnitus is bothersome.\n•     Pay attention to how sounds makes you feel.\n•     Change your plan as you learn which sounds are helpful and which are not"];
    
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"Intro3image2.png"] title: @"How can  \"Imagery\" help me with my tinnitus?" description:@"Using sound when your tinnitus is bothering you will not change your tinnitus in any way. It can however have a big impact on how you feel.  As you experiment with sound, pay close attention to how each sound affects how you feel. Keep experimenting until you find sounds that are helpful."];
    
    MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"Intro3image2.png"] title: @"How do I do \"Imagery\"?" description:@"A video will show you how to do Imagery. After you watch the video, you will have access to a timer that will help you practice on your own."];

    
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
