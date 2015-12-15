//
//  SamplerViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 14/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "HomeNewViewController.h"
#import "SamplerViewController.h"
#import "NookViewController.h"
#import "PlansViewController.h"


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
}

- (IBAction)NookButtonTapped:(id)sender {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    NookViewController *nookView = [storyboard instantiateViewControllerWithIdentifier:@"NookViewController"];
    [self.navigationController pushViewController:nookView animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
