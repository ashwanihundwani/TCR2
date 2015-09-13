//
//  PlansViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 3/18/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "PlansViewController.h"
#import "ActivitiesViewController.h"
#import "AddNewPlanViewController.h"
#import "DoingActivityViewController.h"
#import "ActivityRatingsViewController.h"
#import "NewPlanSupportViewController.h"
#import "NewPlanAddedViewController.h"
#import "MBProgressHUD.h"


@implementation DoingActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationBar.hidden = NO;
    //[self.navigationItem setHidesBackButton:YES];
    
    [self.tabBarController.tabBar setHidden:YES];
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    
    titleView.backgroundColor = [Utils colorWithHexValue:NAV_BAR_BLACK_COLOR];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 320, 44)];
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_1];
    
    titleLabel.font = pallete.secondObj;
    titleLabel.textColor = pallete.firstObj;
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //titleLabel.textColor = [UIColor colorWithHexValue:@"797979"];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"Current Activity";
    
    [titleView addSubview:titleLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, titleView.frame.size.height - 1, 320, 1)];
    
    line.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.098/255.0 alpha:0.22];;
    
    [titleView addSubview:line];
    
    [self.view addSubview:titleView];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    //        [self writeVisitedPlans];
    
    NSString *alertMsg = [NSString stringWithFormat:@"When you are done with the activity %@ tap on \"I am Done Now.\"\n\n Alternatively, you can cancel the current activity.",[PersistenceStorage getObjectForKey:@"activityName"]];
    UILabel *theText = (UILabel *)[self.view viewWithTag:100];
    
    theText.numberOfLines = 1000;
    
    self.textLabelHeightConst.constant = [Utils heightForLabelForString:alertMsg width:276 font:theText.font] + 10;
    
    
    theText.text = alertMsg;
    
}

- (IBAction)cancelActivityClicked:(id)sender {
    //  ActivitiesViewController *samplerView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ActivitiesViewController"];
    //  [self.navigationController pushViewController:samplerView animated:NO];}
    
    [PersistenceStorage setObject:@" " andKey:@"Referer"];
    
    [self.navigationController popViewControllerAnimated:NO];
    
    //[self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)doneActivityClicked:(id)sender {
    ActivityRatingsViewController *svc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ActivityRatingsViewController"];
 //   [self.navigationController pushViewController:svc animated:YES];
    [self dismissModalViewControllerAnimated:NO];
    
}





-(IBAction)doneButtonTapped:(id)sender
{
    
    /*    RatingsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"RatingsViewController"];
     ratingsView.skillSection = @"Sounds";
     ratingsView.skillDetail = self.name;
     
     //[self.navigationController pushViewController:ratingsView animated:YES];
     [self.navigationController presentModalViewController:ratingsView animated:YES];
     
     */
    [PersistenceStorage setObject:@"DoingActivityVC" andKey:@"Referer"];
    [self.navigationController popViewControllerAnimated:NO];
    
 //   [self.navigationController popViewControllerAnimated:YES];
    
    
}



/*
 - (IBAction)doneActivityClicked:(id)sender
 {
 ActivityRatingsViewController *samplerView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ActivityRatingsViewController"];
 [self.navigationController pushViewController:samplerView animated:NO];
 }
 // [self presentModalViewController:samplerView animated:YES];
 */

@end
