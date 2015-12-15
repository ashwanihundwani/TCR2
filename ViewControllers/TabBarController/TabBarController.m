//
//  TabBarController.m
//  TinnitusCoach
//
//  Created by Creospan on 4/13/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "TabBarController.h"
#import "HomeViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

+ (id)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TabBarController"];
    });
    
    return sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if([item.title isEqualToString:@"Sampler"]){
       [PersistenceStorage setInteger:1 andKey:@"TabBarButtonTapped"];
    }else if([item.title isEqualToString:@"Plans"]){
        [PersistenceStorage setInteger:2 andKey:@"TabBarButtonTapped"];
    }else if([item.title isEqualToString:@"Learning Nook"] || [item.title isEqualToString:@"Learn"] ){
        [PersistenceStorage setInteger:3 andKey:@"TabBarButtonTapped"];
    }else if([item.title isEqualToString:@"Support"]){
        [PersistenceStorage setInteger:4 andKey:@"TabBarButtonTapped"];
    }else if([item.title isEqualToString:@"Home"]){
        [PersistenceStorage setInteger:0 andKey:@"TabBarButtonTapped"];
    }else{
        [PersistenceStorage setInteger:-1 andKey:@"TabBarButtonTapped"];
    }
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
//
    
}



@end
