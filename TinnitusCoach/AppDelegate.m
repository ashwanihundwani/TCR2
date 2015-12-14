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
#import "Utils.h"
#import "TipsReminder.h"
#import "TCNSURLProtocol.h"


@interface AppDelegate ()

@property(atomic, assign) BOOL isLaunchWithNotification;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [NSURLProtocol registerClass:[TCNSURLProtocol class]];
    // check if it is first time launch after app install
    if(![PersistenceStorage getBoolForKey:@"isTinnitusCoachAppFirstLaunchDone"]){
        [PersistenceStorage setBool:YES andKey:@"isTinnitusCoachAppFirstLaunchDone"];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    
    [self writeSystemLogLaunched];
    
   
  //  NSLog(@"00000 %@"[PersistenceStorage getObjectForKey:@"TipsActivated"]);
 
    sleep(3);
    
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
     
    
        
        
    }
    
   
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
   
    
    if ([localNotification.alertBody isEqualToString:@"Tips for Sleep Feedback"])
        
    {
        self.isLaunchWithNotification = YES;
        
        if ([[PersistenceStorage getObjectForKey:@"TipsActivated"] isEqual: @"Yes"])
            
        {
            [self showTipsReminderView:^() {
                
            }];
        
            [PersistenceStorage setObject:@"Yes" andKey:@"launchSleepTips"];
        }
        
    }
    
    else if ([localNotification.alertBody isEqualToString:@"Weekly Reminder"])
        
    {
        NSLog(@" app launch with weekly reminder");
        self.isLaunchWithNotification = YES;
        [self showMissedWeeklyReminderView];
        [PersistenceStorage setObject:@"Yes" andKey:@"launchWeeklyReminder"];

    }
    
    
    
    else if ([localNotification.alertBody length]>20)
        
    {
        self.isLaunchWithNotification = YES;
      //  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        UIAlertView *alert = [[UIAlertView alloc]   //show alert box with option to play or exit
                              initWithTitle: @"Running Skill"
                              message:localNotification.alertBody
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK",nil];
        
        
[alert show];
         
    }else{
        self.isLaunchWithNotification = NO;
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
    
    [PersistenceStorage setInteger:-1 andKey:@"HomeButtonTapped"];
    [PersistenceStorage setInteger:-1 andKey:@"TabBarButtonTapped"];
}


-(BOOL)tipsReminderExists
{
    DBManager *manager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
   
    
    NSString *queryForTips = @"select * from My_Tips";
    
    NSArray *allMyTips= [manager loadDataFromDB:queryForTips];
    
    if ([allMyTips count] == 0){
        return NO;
    }
    
        
   NSString *query =  @"select * from MySkillReminders where SkillName = 'Tips for Better Sleep'";

   return ([[manager loadDataFromDB:query] count] > 0)? true : false;

}

-(BOOL)shouldShowWR{
    
    
    NSDate *currentDate = [NSDate date];
    
    NSDate *savedDate = [PersistenceStorage getObjectForKey:@"WRSavedDate"];
    
    if(!savedDate){
        return TRUE;
    }
    
    NSDateComponents *currentComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitWeekday fromDate:currentDate];
    
    
    NSDateComponents *savedComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour fromDate:savedDate];
    
    if((currentComponents.weekday == 2) && (savedComponents.day < currentComponents.day))
    {
        return YES;
    }
    
    return NO;
}

-(BOOL)dateChangedForTipsReminder{
    
    NSDate *currentDate = [NSDate date];
    
    NSDate *savedDate = [PersistenceStorage getObjectForKey:@"tipsReminderDate"];
    
    NSDateComponents *currentComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour fromDate:currentDate];
    
    
    NSDateComponents *savedComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour fromDate:savedDate];
    
    return (savedComponents.day != currentComponents.day);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    BOOL tipsRemShowing = FALSE;
    BOOL tipsReminderExists = [self tipsReminderExists];
    
    if([PersistenceStorage getObjectForKey:@"tipsReminderDate"]){
        
        BOOL dateChanged = [self dateChangedForTipsReminder];
        if(dateChanged){
            
            [PersistenceStorage setBool:NO andKey:@"shownTipsReminderToday"];
        }
    }
    
    if(tipsReminderExists
       && ![PersistenceStorage getBoolForKey:@"shownTipsReminderToday"]){
        
        tipsRemShowing = TRUE;
        [self showTipsReminderView:^(){
            
            
            //[self showWeeklyReminderView];
            
            NSArray *notificationArray = [application scheduledLocalNotifications];
            
            for(UILocalNotification *notification in notificationArray){
                NSLog(@"notification with alert : %@ firedate: %@ and repeatInterval:%ld", notification.alertBody, notification.fireDate, notification.repeatInterval);
                if([notification.alertBody isEqualToString:@"Weekly Reminder"] ){
                    // get the fire date a
                    if([[NSDate date] compare:notification.fireDate] == NSOrderedAscending){
                        // positive case nothing to do
                        NSLog(@"weekly reminder scheduled for:%@ ",notification.fireDate);
                    }else{
                        // missed reminder
                        // lets force show weekly reminder
                        NSLog(@"Detected missed WR notification, Launching WR ");
                        if(!self.isLaunchWithNotification)
                            [self showWeeklyReminderView];
                    }
                    break;
                }
                
            }
            
            
        }];
        
        [PersistenceStorage setBool:YES andKey:@"shownTipsReminderToday"];
        [PersistenceStorage setObject:[NSDate date] andKey:@"tipsReminderDate"];
    }

 //   [self showTipsReminderView];
    
    //display the sheduled notification
    NSArray *notificationArray = [application scheduledLocalNotifications];
    
    for(UILocalNotification *notification in notificationArray){
        NSLog(@"notification with alert : %@ firedate: %@ and repeatInterval:%ld", notification.alertBody, notification.fireDate, notification.repeatInterval);
        if([notification.alertBody isEqualToString:@"Weekly Reminder"] ){
            // get the fire date a
            if([[NSDate date] compare:notification.fireDate] == NSOrderedAscending){
                // positive case nothing to do
                NSLog(@"weekly reminder scheduled for:%@ ",notification.fireDate);
            }else{
                // missed reminder
                // lets force show weekly reminder
                NSLog(@"Detected missed WR notification, Launching WR ");
                if(!self.isLaunchWithNotification && !tipsRemShowing)
                    [self showMissedWeeklyReminderView];
            }
            break;
        }
        
    }

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
 
    NSLog(@"*****app didReceiveLocalNotification ****** ");
    
        UIApplicationState state = [application applicationState];
   
   

    if ([notification.alertBody isEqualToString:@"Tips for Sleep Feedback"])

    {
 
    if ([[PersistenceStorage getObjectForKey:@"TipsActivated"] isEqual: @"Yes"])
        
    {

        [self showTipsReminderView:^(){
        
        
        }];}
    
    }
    
    
    else if ([notification.alertBody isEqualToString:@"Weekly Reminder"])
        
    {
        
        
        [self showMissedWeeklyReminderView];
        
        
        
        
        
        
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




-(void)showTipsReminderView:(void (^)())block
{
    
    UIStoryboard *storyBoard = [ UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TipsReminder *mySleepsViewCotroller = [storyBoard instantiateViewControllerWithIdentifier:@"TipsReminder"];
    
    mySleepsViewCotroller.dismissBlock = block;
    
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows firstObject];
   
    [currentWindow.rootViewController presentViewController:mySleepsViewCotroller animated:YES completion:nil];
    
}


-(void)showWeeklyReminderView
{
    NSLog(@" In showWeeklyReminderView");
    if([self shouldShowWR]){
        NSLog(@"WeeklyReminderView should be shown");
        [PersistenceStorage setObject:[NSDate date] andKey:@"WRSavedDate"];
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
        UIStoryboard *storyBoard = [ UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *WeeklyReminder = [storyBoard instantiateViewControllerWithIdentifier:@"WeeklyViewController"];
        UIWindow *currentWindow = [[UIApplication sharedApplication].windows firstObject];
        [currentWindow.rootViewController presentViewController:WeeklyReminder animated:YES completion:nil];
    }
    
}

-(void)showMissedWeeklyReminderView
{
    NSLog(@" In showMissedWeeklyReminderView");
    [PersistenceStorage setObject:[NSDate date] andKey:@"WRSavedDate"];
    
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
