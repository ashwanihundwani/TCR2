//
//  SamplerViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 14/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "HomeViewController.h"
#import "SamplerViewController.h"
#import "NookViewController.h"
#import "PlansViewController.h"
#import "ThoughtsIntroDetailViewController.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>




//@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestAccessToEvents];
    [self.parentViewController.navigationController popToRootViewControllerAnimated:YES];
    
    
    
    
    
    if (![[PersistenceStorage getObjectForKey:@"WRInitialized"] isEqual: @"Yes"])
        
    {     NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setDay: 22];
        [components setMonth: 6];
        [components setYear: 2015];
        [components setHour: 4];
        [components setMinute: 45];
        [components setSecond: 0];
        [calendar setTimeZone: [NSTimeZone defaultTimeZone]];
        NSDate *dateToFire = [calendar dateFromComponents:components];
        
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        
        
        NSString *str = [NSString stringWithFormat:@"%@",@"Weekly Reminder"];
        localNotification.alertBody = str;
        
        [localNotification setFireDate: dateToFire];
        [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
        [localNotification setRepeatInterval: NSWeekCalendarUnit];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        [PersistenceStorage setObject:@"Yes" andKey:@"WRInitialized"];
    }
    
    
    

    
    
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"Tab bar: did select tab %@", item.title);
}

-(void)requestAccessToEvents{  //Create the Event Store
    EKEventStore *eventStore = [[EKEventStore alloc]init];
    
    //Check if iOS6 or later is installed on user's device *******************
    if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        
        //Request the access to the Calendar
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted,NSError* error){
            
            //Access not granted-------------
            if(!granted){
                NSString *message = @"Tinnitus Coach can't access your calendar! Check your privacy settings.";
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Calendar not Available"
                                                                   message:message
                                                                  delegate:self
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil,nil];
                //Show an alert message!
                //UIKit needs every change to be done in the main queue
                dispatch_async(dispatch_get_main_queue(), ^{
                    [alertView show];
                }
                               );
                
                //Access granted------------------
            }else{
                
                //Create the event and set the Label message
                NSString *labelText;
                
                //Event created
                          }
        }];
    }
    
    //Device prior to iOS 6.0  *********************************************
    else{
     }}
              
-(void)setUpViews{
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    //  [self setUpViews];
}


-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%@",[PersistenceStorage getObjectForKey:@"launchSleepTips"]);
  //  [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    if([[PersistenceStorage getObjectForKey:@"launchSleepTips"] isEqualToString:@"Yes"])
        
    {
        
        UIStoryboard *storyBoard = [ UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *mySleepsViewCotroller = [storyBoard instantiateViewControllerWithIdentifier:@"TipsReminder"];
        UIWindow *currentWindow = [[UIApplication sharedApplication].windows firstObject];
        [currentWindow.rootViewController presentViewController:mySleepsViewCotroller animated:YES completion:nil];
        
        [PersistenceStorage setObject:@"No" andKey:@"launchSleepTips"];
        
        
    }
    
    
    
    if([[PersistenceStorage getObjectForKey:@"launchWeeklyReminder"] isEqualToString:@"Yes"])
    
    {
        
                UIStoryboard *storyBoard = [ UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *mySleepsViewCotroller = [storyBoard instantiateViewControllerWithIdentifier:@"WeeklyViewController"];
                UIWindow *currentWindow = [[UIApplication sharedApplication].windows firstObject];
                [currentWindow.rootViewController presentViewController:mySleepsViewCotroller animated:YES completion:nil];
        
        [PersistenceStorage setObject:@"No" andKey:@"launchWeeklyReminder"];
        
        
    }
    
    
    
    
    
    
}



- (IBAction)SamplerButtonTapped:(id)sender {
    [[self tabBarController] setSelectedIndex:1];
  
    
//    
//    
//    UIStoryboard *storyBoard = [ UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *mySleepsViewCotroller = [storyBoard instantiateViewControllerWithIdentifier:@"TipsReminder"];
//    UIWindow *currentWindow = [[UIApplication sharedApplication].windows firstObject];
//    [currentWindow.rootViewController presentViewController:mySleepsViewCotroller animated:YES completion:nil];
    
    
    
    
    
}
- (IBAction)PlansButtonTapped:(id)sender {
    [[self tabBarController] setSelectedIndex:2];
    
    
}

- (IBAction)NookButtonTapped:(id)sender {
    
    [[self tabBarController] setSelectedIndex:3];
    
    
    
    
    
}

- (IBAction)SupportButtonTapped:(id)sender {
    [[self tabBarController] setSelectedIndex:4];
    
}










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
