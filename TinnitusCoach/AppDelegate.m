//
//  AppDelegate.m
//  TinnitusCoach
//
//  Created by Creospan on 13/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"

#import "HomeNewViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
       [self writeSystemLogLaunched];
    
   
  //  NSLog(@"00000 %@"[PersistenceStorage getObjectForKey:@"TipsActivated"]);
 
    sleep(3);
    
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
     
    
        
        
    }
    
   
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
   
    
    if ([localNotification.alertBody isEqualToString:@"Tips for Sleep Feedback"])
        
    {
        
        if ([[PersistenceStorage getObjectForKey:@"TipsActivated"] isEqual: @"Yes"])
            
        {
            [self showTipsReminderView];
        
            [PersistenceStorage setObject:@"Yes" andKey:@"launchSleepTips"];

        
        
        
        }
        
    }
    
    else if ([localNotification.alertBody isEqualToString:@"Weekly Reminder"])
        
    {
        
        
        [self showWeeklyReminderView];
        [PersistenceStorage setObject:@"Yes" andKey:@"launchWeeklyReminder"];

        
        
            
            
           
    }
    
    
    
    else if ([localNotification.alertBody length]>20)
        
    {
      //  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        UIAlertView *alert = [[UIAlertView alloc]   //show alert box with option to play or exit
                              initWithTitle: @"Running Skill"
                              message:localNotification.alertBody
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK",nil];
        
        
[alert show];
         
    }
 
    
    return YES;
    
    
    
    }


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
[UIApplication sharedApplication].applicationIconBadgeNumber = 0;

 //   [self showTipsReminderView];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [self writeSystemLogExit];
    
    
    
    
    
    
}




-(void)writeSystemLogExit{
  //  NSURL *path = [self getUrlOfFiles:@"TinnitusCoachUsageData.csv"];
    
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
    NSString *type = @"System";
  
    NSString *str = @"App Exited";
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil];
     
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

-(void)writeSystemLogLaunched{
    //  NSURL *path = [self getUrlOfFiles:@"TinnitusCoachUsageData.csv"];
    
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
    NSString *type = @"System";
    
    NSString *str = @"App Launched";
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil];
    
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



/*
 
 UIApplication *app = [UIApplication sharedApplication];
 NSArray *eventArray = [app scheduledLocalNotifications];
 for (int i=0; i<[eventArray count]; i++)
 {
 UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
 NSDictionary *userInfoCurrent = oneEvent.userInfo;
 NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"uid"]];
 if ([uid isEqualToString:uidtodelete])
 {
 //Cancelling local notification
 [app cancelLocalNotification:oneEvent];
 break;
 }
 }
 
 
 */



-(void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
 
    
    
        UIApplicationState state = [application applicationState];
   
   

    if ([notification.alertBody isEqualToString:@"Tips for Sleep Feedback"])

    {
 
    if ([[PersistenceStorage getObjectForKey:@"TipsActivated"] isEqual: @"Yes"])
        
    {

        [self showTipsReminderView];}
    
    }
    
    
    else if ([notification.alertBody isEqualToString:@"Weekly Reminder"])
        
    {
        
        
        [self showWeeklyReminderView];
        
        
        
        
        
        
    }

    
    
    
    
    else //if ([notification.alertBody length]>20)
    
    {
                        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            UIAlertView *alert = [[UIAlertView alloc]   //show alert box with option to play or exit
                                                initWithTitle: @"Running Skill"
                                               message:notification.alertBody
                                                 delegate:self
                                                cancelButtonTitle:nil
                                                otherButtonTitles:@"OK",nil];
        
        
        [PersistenceStorage setObject:notification.alertBody andKey:@"skillDetail1"];

        [self writeLogNotification];

        NSLog(@"NAMEooMM   %@",notification.userInfo );

    //    NSLog(@"NAMEMM   %@",notification.userInfo valueForKey:@"Type"] );
        
        NSLog(@"NAMEMM   %@",[notification.userInfo valueForKey:@"Type"] );
        
        [alert show];
     
        
       

    }
        
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    NSLog(@"%@",title);
  
    if([title isEqualToString:@"Button 1"])
    {
        NSLog(@"Button 1 was selected.");
    }
    else if([title isEqualToString:@"Button 2"])
    {
        NSLog(@"Button 2 was selected.");
    }
    else if([title isEqualToString:@"Button 3"])
    {
        NSLog(@"Button 3 was selected.");
    }
}




-(void)showTipsReminderView
{
    
    UIStoryboard *storyBoard = [ UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mySleepsViewCotroller = [storyBoard instantiateViewControllerWithIdentifier:@"TipsReminder"];
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows firstObject];
    [currentWindow.rootViewController presentViewController:mySleepsViewCotroller animated:YES completion:nil];
    
}


-(void)showWeeklyReminderView
{
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    UIStoryboard *storyBoard = [ UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *WeeklyReminder = [storyBoard instantiateViewControllerWithIdentifier:@"WeeklyViewController"];
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows firstObject];
    [currentWindow.rootViewController presentViewController:WeeklyReminder animated:YES completion:nil];
    
}







- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
    
    
    
    
}


-(void)writeLogNotification
{
    
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
    NSString *type = @"Reminder";
    NSString *str = @"System Triggered Reminder";
    
    NSString *s=[PersistenceStorage getObjectForKey:@"skillDetail1"];
    

NSString *filter1= [s stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    NSString * newString = [filter1 stringByReplacingOccurrencesOfString:@"," withString:@"|"];
    
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,nil,nil,nil,newString,nil,nil,nil,nil,nil,nil,nil];
    
    [PersistenceStorage setObject:nil andKey:@"skillDetail1"];
    
    
    
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





@end
