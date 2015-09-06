//
//  NavigationTipsViewController.m
//  TinnitusCoach
//
//  Created by Vikram Singh on 3/21/15.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
