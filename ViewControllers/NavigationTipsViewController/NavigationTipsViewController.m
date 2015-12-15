//
//  NavigationTipsViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 3/21/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "NavigationTipsViewController.h"

@interface NavigationTipsViewController ()

@end

@implementation NavigationTipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [Utils addSwipeGestureToView:self.view target:self selector:@selector(understoodButtonClicked:)];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)understoodButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
