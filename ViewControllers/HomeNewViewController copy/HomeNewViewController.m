//
//  SamplerViewController.m
//  TinnitusCoach
//
//  Created by Swipe Video Labs Pvt. Ltd. on 14/03/15.
//  Copyright (c) 2015 Swipe Video Labs Pvt. Ltd.. All rights reserved.
//

#import "HomeNewViewController.h"
#import "SamplerViewController.h"
#import "NookViewController.h"
#import "PlansViewController.h"
//#import "SupportViewController.h"

@interface HomeNewViewController ()
{
 }


@end

@implementation HomeNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    
 }


-(void)setUpViews{
  
}

-(void)viewWillAppear:(BOOL)animated{
    //[super viewWillAppear:animated];
  //  [self setUpViews];
}






- (IBAction)SamplerButtonTapped:(id)sender {
    SamplerViewController *sampler = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SamplerViewController"];
    [self.navigationController pushViewController:sampler animated:YES];
        NSLog(@"SAMP");
}
- (IBAction)PlansButtonTapped:(id)sender {
    
    
    PlansViewController* viewController = [[PlansViewController alloc] init];
    
    [self.navigationController pushViewController:viewController animated:YES];
    
//[viewController release];
    
    
    
  //  PlansViewController *plans = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] //instantiateViewControllerWithIdentifier:@"PlansViewController"];
//    [self.navigationController pushViewController:plans animated:YES];
        NSLog(@"PLAN");
    
    
}

- (IBAction)NookButtonTapped:(id)sender {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    NookViewController *nookView = [storyboard instantiateViewControllerWithIdentifier:@"NookViewController"];
    [self.navigationController pushViewController:nookView animated:YES];
    
    
    
    
    
    
    
 //   NookViewController *nook = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NookViewController"];
  //  [self.navigationController pushViewController:nook animated:YES];
        NSLog(@"NOOK");
}

// - (IBAction)SupportButtonTapped:(id)sender {
//     ImageryViewController *imagery = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ImageryViewController"];
 //    [self.navigationController pushViewController:imagery animated:YES];
// }










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
