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
#import "Utils.h"



//@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    
    titleView.backgroundColor = [Utils colorWithHexValue:NAV_BAR_BLACK_COLOR];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 320, 64)];
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_1];
    
    titleLabel.font = pallete.secondObj;
    titleLabel.textColor = pallete.firstObj;
    
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //titleLabel.textColor = [UIColor colorWithHexValue:@"797979"];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"Tinnitus Coach";
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, titleView.frame.size.height - 1, 320, 1)];
    
    line.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.098/255.0 alpha:0.22];;
    
    [titleView addSubview:line];
    
    [titleView addSubview:titleLabel];
    
    [self.view addSubview:titleView];
    [self.parentViewController.navigationController popToRootViewControllerAnimated:YES];

    [self requestAccessToEvents];
    [self.parentViewController.navigationController popToRootViewControllerAnimated:YES];
    
    
    
    
    
    if (![[PersistenceStorage getObjectForKey:@"WRInitialized"] isEqual: @"Yes"])
        
    {
        
        NSInteger dayDiff = [Utils getNumDaysToNextMonday];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setDay: [comp day] + dayDiff];
        [components setMonth: [comp month]];
        [components setYear: [comp year]];
        [components setHour: 4];
        [components setMinute: 45];
        [components setSecond: 0];
        [calendar setTimeZone: [NSTimeZone defaultTimeZone]];
        NSDate *dateToFire = [calendar dateFromComponents:components];
        if([dateToFire compare:[NSDate date]] == NSOrderedAscending){
            [components setDay: [comp day] + 7];
            dateToFire =  [calendar dateFromComponents:components];
        }
        
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
    [PersistenceStorage setInteger:1 andKey:@"HomeButtonTapped"];
    [[self tabBarController] setSelectedIndex:1];
  
    
//    
//    
//    UIStoryboard *storyBoard = [ UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *mySleepsViewCotroller = [storyBoard instantiateViewControllerWithIdentifier:@"TipsReminder"];
//    UIWindow *currentWindow = [[UIApplication sharedApplication].windows firstObject];
//    [currentWindow.rootViewController presentViewController:mySleepsViewCotroller animated:YES completion:nil];
    
    
    
    
    
}
- (IBAction)PlansButtonTapped:(id)sender {
    [PersistenceStorage setInteger:2 andKey:@"HomeButtonTapped"];
    [[self tabBarController] setSelectedIndex:2];
}

- (IBAction)NookButtonTapped:(id)sender {
    [PersistenceStorage setInteger:3 andKey:@"HomeButtonTapped"];
    [[self tabBarController] setSelectedIndex:3];
    
    
}

- (IBAction)SupportButtonTapped:(id)sender {
    if ([PersistenceStorage getBoolForKey:@"debugWR"]) {
        UIStoryboard *storyBoard = [ UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *WeeklyReminder = [storyBoard instantiateViewControllerWithIdentifier:@"WeeklyViewController"];
        UIWindow *currentWindow = [[UIApplication sharedApplication].windows firstObject];
        [currentWindow.rootViewController presentViewController:WeeklyReminder animated:YES completion:nil];
        
    }else{
        [PersistenceStorage setInteger:4 andKey:@"HomeButtonTapped"];
        [[self tabBarController] setSelectedIndex:4];
    }
//    UIStoryboard *storyBoard = [ UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *mySleepsViewCotroller = [storyBoard instantiateViewControllerWithIdentifier:@"WeeklyViewController"];
//    UIWindow *currentWindow = [[UIApplication sharedApplication].windows firstObject];
//    [currentWindow.rootViewController presentViewController:mySleepsViewCotroller animated:YES completion:nil];
//    



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
