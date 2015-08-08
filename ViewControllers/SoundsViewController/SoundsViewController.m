//
//  SoundsViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 22/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "SoundsViewController.h"

@interface SoundsViewController ()

@end

@implementation SoundsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated
{
    
    [self.tabBarController.tabBar setHidden:YES];
    

    
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
