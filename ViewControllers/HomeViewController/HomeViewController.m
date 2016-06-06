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
#import "TipsReminder.h"

@interface HomeViewController()

@property(nonatomic)BOOL firstLoad;

@end


//@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firstLoad = TRUE;
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    
    titleView.backgroundColor = [Utils colorWithHexValue:NAV_BAR_BLACK_COLOR];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 320, 64)];
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_1];
    
    titleLabel.font = pallete.secondObj;
    titleLabel.textColor = pallete.firstObj;
    titleLabel.textAlignment = NSTextAlignmentCenter;
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

-(void)writeHomeVisited{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentTXTPath = [documentsDirectory stringByAppendingPathComponent:@"TinnitusCoachUsageData.csv"];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM/dd/yy";
    NSString *dateString = [dateFormatter stringFromDate: date];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"HH:mm:ss";
    NSString *timeString = [timeFormatter stringFromDate: date];
    NSString *type = @"Navigation";
    NSString *str = @"Home";
    NSString * navMethod = @"";
    if([PersistenceStorage getIntegerForKey:@"HomeButtonTapped"] == self.tabBarController.selectedIndex ){
        navMethod = @"Navigated from Home Screen";
        [PersistenceStorage setInteger:-1 andKey:@"HomeButtonTapped"];
    }else if([PersistenceStorage getIntegerForKey:@"TabBarButtonTapped"] == self.tabBarController.selectedIndex){
        navMethod = @"Navigated from Nav Bar";
        [PersistenceStorage setInteger:-1 andKey:@"TabBarButtonTapped"];
    }else{
        navMethod = nil;
        return;
    }
    NSLog(@"navigation method is:%@ and parent controller is: %@ and isMovingToParentViewController is:%@", navMethod, [[self parentViewController] class], [[self presentingViewController] class]);
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,navMethod,str,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:documentTXTPath])
    {
        [finalStr writeToFile:documentTXTPath atomically:YES];
    }
    else
    {
        NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:documentTXTPath];
        [myHandle seekToEndOfFile];
        [myHandle writeData:[finalStr dataUsingEncoding:NSUTF8StringEncoding]];
        
    }

}

-(void)showTipsReminderView:(void (^)())block{
    
    UIStoryboard *storyBoard = [ UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TipsReminder *mySleepsViewCotroller = [storyBoard instantiateViewControllerWithIdentifier:@"TipsReminder"];
    
    mySleepsViewCotroller.dismissBlock = block;
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows firstObject];
    [currentWindow.rootViewController presentViewController:mySleepsViewCotroller animated:YES completion:nil];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    if(!self.firstLoad){
        
        [self writeHomeVisited];
        
    }
    self.firstLoad = FALSE;
    
    if([[PersistenceStorage getObjectForKey:@"launchSleepTips"] isEqualToString:@"Yes"])
    {
        [self showTipsReminderView:^{
            
        }];
        
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

}


- (IBAction)PlansButtonTapped:(id)sender {
    [PersistenceStorage setInteger:2 andKey:@"HomeButtonTapped"];
    [[self tabBarController] setSelectedIndex:2];
}

- (IBAction)NookButtonTapped:(id)sender {
    if ([PersistenceStorage getBoolForKey:@"debugWR"]) {
        [self showTipsReminderView:^{
        
            
        }];
        
    }else{
        [PersistenceStorage setInteger:3 andKey:@"HomeButtonTapped"];
        [[self tabBarController] setSelectedIndex:3];
    }
    
    
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

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
