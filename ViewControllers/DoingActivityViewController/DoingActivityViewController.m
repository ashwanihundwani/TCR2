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
    [self.navigationItem setHidesBackButton:YES];

    self.title = @"Current Activity";
    }

-(void)viewWillAppear:(BOOL)animated
{
    
//        [self writeVisitedPlans];
   
    NSString *alertMsg = [NSString stringWithFormat:@"You are at the moment enaged with the activity '%@'. If you are finished, tap on “I’m Done Now” to provide some feedback. Alternatively, you can cancel the current activity.",[PersistenceStorage getObjectForKey:@"activityName"]];
    UILabel *theText = (UILabel *)[self.view viewWithTag:100];

    theText.text = alertMsg;

}

- (IBAction)cancelActivityClicked:(id)sender {
  //  ActivitiesViewController *samplerView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ActivitiesViewController"];
  //  [self.navigationController pushViewController:samplerView animated:NO];}
    
    [PersistenceStorage setObject:@" " andKey:@"Referer"];
    [self dismissModalViewControllerAnimated:NO];

    
    
//[self.navigationController popToRootViewControllerAnimated:YES];
}


 - (IBAction)doneActivityClicked:(id)sender {
        ActivityRatingsViewController *svc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ActivityRatingsViewController"];
         [self.navigationController pushViewController:svc animated:YES];
        
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
    [self dismissModalViewControllerAnimated:NO];
    
    
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
