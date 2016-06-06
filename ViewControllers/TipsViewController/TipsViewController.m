//
//  GuidedMeditationViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 18/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "TipsViewController.h"
#import "MySleepTipsVC.h"
#import "TipsIntroDetailViewController.h"
#import "NookUsingSoundViewControllerOne.h"
#import "ScheduleViewController.h"
#import "NookTBS.h"
#import "DBManager.h"
#import <EventKitUI/EventKitUI.h>

#import "SwiperViewController.h"
#import "IntroPageInfo.h"


@interface TipsViewController ()
{NSArray *remindersArray;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) UISwitch *switch1;

@end

@implementation TipsViewController
@synthesize switch1;

-(NSString *)planText
{
    return [NSString stringWithFormat:@"Plan for %@ ",[PersistenceStorage getObjectForKey:@"planName"]];
}

-(NSString *)activityText{
    
    return [PersistenceStorage getObjectForKey:@"skillName"];
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.exercises = @[@"View My Sleep Tips"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.manager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [self.scrollView setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.scrollView setContentSize:CGSizeMake(320,600)];
    
    UISwitch *mySwitch = (UISwitch *)[self.view viewWithTag:669];
    UILabel *label = (UILabel *)[self.view viewWithTag:700];
    if ([[PersistenceStorage getObjectForKey:@"TipsActivated"]  isEqualToString:@"Yes"])
    {
        mySwitch.on = YES;
        label.text = @"Skill Reminder Activated";
        
    }else
    {
        mySwitch.on = NO;
        label.text = @"Activate Skill Reminder";
    }
    [self.tableView reloadData];
}
    

- (void) toggle1: (BOOL) state {
    if (state)
    {
        NSLog(@"Activating TBS reminder");
        
        // getting cuurent state of notificatio settins
        UIUserNotificationSettings* settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if(settings.types == UIUserNotificationTypeNone){
            NSLog(@"application not allowed for notification");
            // notification not enabled , set a calender entry
            EKEventStore *store = [EKEventStore new];
            //[store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) //{
            // if (!granted) { return; }
            EKEvent *event = [EKEvent eventWithEventStore:store];
            //event.title = self.name : @"concatenation with operators" ;
            NSDate *twoYearsFromNow = [NSDate dateWithTimeIntervalSinceNow:63113851];
            
            EKRecurrenceRule *recurrance;
            NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
            [comp setHour: 5];
            [comp setMinute: 00];
            [comp setSecond: 0];
            
            recurrance = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:1 end:[EKRecurrenceEnd recurrenceEndWithEndDate:twoYearsFromNow]];
            
            NSString *TC = @"Tinnitus Coach: SKILL  ";
            event.title = @" Tinnitus Coach - Tips for Better Sleep Skill";
            event.startDate = [[NSCalendar currentCalendar] dateFromComponents:comp]; //today
            event.endDate =   [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
            
            event.recurrenceRules=@[recurrance];
            
            event.calendar = [store defaultCalendarForNewEvents];
            
            NSError *err = nil;
            
            [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
            if(err == nil){
                NSString *savedEventId = event.eventIdentifier;  //save the event id if you want to access this later
                
                [PersistenceStorage setObject:savedEventId andKey:@"lastEventIdentifer"];  ///STORE to test it for deletion
                NSLog(@"%@", [PersistenceStorage getObjectForKey:@"lastEventIdentifer"]);
                NSString *queryClear = [NSString stringWithFormat:@"delete from MySkillReminders where SkillName = 'Tips for Better Sleep' and PlanName = '%@'",[Utils getValidSqlString:[PersistenceStorage getObjectForKey:@"planName"]]];
                NSString *query = [NSString stringWithFormat:@"insert into MySkillReminders ('ID','SkillName','ScheduledDate','CalendarEventID','PlanName') values(1,'%@','%@','%@','%@')",@"Tips for Better Sleep",[PersistenceStorage getObjectForKey:@"localScheduledDate"],[PersistenceStorage getObjectForKey:@"lastEventIdentifer"],[Utils getValidSqlString:[PersistenceStorage getObjectForKey:@"planName"]]];
                
                [self.manager executeQuery:queryClear];
                [self.manager executeQuery:query];
                [PersistenceStorage setObject:@"Yes" andKey:@"TipsActivated"];
                [self writeEnabledReminder];
            }
            
        }else {
            NSLog(@"application allowed for notification");
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [[NSDateComponents alloc] init];
            [components setDay: 3];
            [components setMonth: 7];
            [components setYear: 2012];
            [components setHour: 5];
            [components setMinute: 00];
            [components setSecond: 0];
            [calendar setTimeZone: [NSTimeZone defaultTimeZone]];
            NSDate *dateToFire = [calendar dateFromComponents:components];
            
            
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"dd/MM/yyyy"];
            
            
            NSString *str = [NSString stringWithFormat:@"%@",@"Tips for Sleep Feedback"];
            localNotification.alertBody = str;
            
            [localNotification setFireDate: dateToFire];
            [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
            [localNotification setRepeatInterval: kCFCalendarUnitDay];
            
            NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:[PersistenceStorage getObjectForKey:@"skillName"], @"Type",[PersistenceStorage getObjectForKey:@"planName"],@"PlanName", nil];
            localNotification.userInfo = infoDict;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSString *queryClear = [NSString stringWithFormat:@"delete from MySkillReminders where SkillName = 'Tips for Better Sleep' and PlanName = '%@'",[Utils getValidSqlString:[PersistenceStorage getObjectForKey:@"planName"]]];
            NSString *query = [NSString stringWithFormat:@"insert into MySkillReminders ('ID','SkillName','ScheduledDate','CalendarEventID','PlanName') values(1,'%@','%@','%@','%@')",@"Tips for Better Sleep",[PersistenceStorage getObjectForKey:@"localScheduledDate"],@"",[Utils getValidSqlString:[PersistenceStorage getObjectForKey:@"planName"]]];
            
            [self.manager executeQuery:queryClear];
            [self.manager executeQuery:query];
            
            [PersistenceStorage setObject:@"Yes" andKey:@"TipsActivated"];
            [self writeEnabledReminder];
            
        }
    }
    else
    {
        NSLog(@"DeActivating TBS reminder");
        //get the TBS events
        NSString* query =[NSString stringWithFormat:@"select * from MySkillReminders where SkillName = 'Tips for Better Sleep' and PlanName = '%@'", [Utils getValidSqlString:[PersistenceStorage getObjectForKey:@"planName"]]];
        
        NSArray* sleepReminderArray = [self.manager loadDataFromDB:query];
        for (NSDictionary* sleepRemiderDict in sleepReminderArray) {
            // check for calenderevent and cancel it
            NSString* calEventId = [sleepRemiderDict objectForKey:@"CalendarEventID"];
            if(calEventId != nil && calEventId.length > 0){
                [self removeEventFromCalender:calEventId];
            }
        }
        NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
        NSLog(@"notify array %@",notificationArray);
        
        for(UILocalNotification *notification in notificationArray){
            if ([notification.alertBody isEqualToString:@"Tips for Sleep Feedback"]) {
                NSLog(@"Found active TBS nottification , Cancelleing it");
                [[UIApplication sharedApplication] cancelLocalNotification:notification] ;
            }
        }
        NSString *queryClear = [NSString stringWithFormat:@"delete from MySkillReminders where SkillName = 'Tips for Better Sleep' and PlanName = '%@'", [Utils getValidSqlString:[PersistenceStorage getObjectForKey:@"planName"]]];
        [self.manager executeQuery:queryClear];
        [PersistenceStorage setObject:@"No" andKey:@"TipsActivated"];
        [self writeDeletedReminder];
        
    }
    [self.tableView reloadData];
    
}


-(void)removeEventFromCalender:(NSString*)eventID{
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) return;
        EKEvent* eventToRemove = [store eventWithIdentifier:eventID];
        if (eventToRemove) {
            NSError* err = nil;
            NSLog(@"Found calender TBS event , removing it");
            [store removeEvent:eventToRemove span:EKSpanFutureEvents commit:YES error:&err];
        }
    }
     
     ];
    
}


-(void)RefreshScheduleData
{
    NSString *query = [NSString stringWithFormat:@"select * from MySkillReminders where SkillName = 'Tips for Better Sleep' and PlanName = '%@'",[Utils getValidSqlString:[PersistenceStorage getObjectForKey:@"planName"]]];
    self.manager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    remindersArray = [[NSArray alloc] initWithArray:[self.manager loadDataFromDB:query]];
    UILabel *label = (UILabel *)[self.view viewWithTag:333];
    UIButton *btnLabel1 = (UIButton *)[self.view viewWithTag:334];
    UIButton *btnLabel2 = (UIButton *)[self.view viewWithTag:335];
    [[self.view viewWithTag:3] setHidden:YES];
    if ([remindersArray count]== 1) {
        NSDictionary *dict = [remindersArray objectAtIndex:0];
        NSString *strAct = [dict valueForKey:@"ScheduledDate"];
        label.text = strAct;
        [[self.view viewWithTag:334] setHidden:NO];
        [[self.view viewWithTag:335] setHidden:YES];
    }
    else
    {
        label.text = @"No reminders";
        [[self.view viewWithTag:334] setHidden:YES];
        [[self.view viewWithTag:335] setHidden:NO];
        
    }
}



-(IBAction)goToScheduler:(id)sender
{
    ScheduleViewController *favc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ScheduleViewController"];
    
    favc.activityText = @"Try Sleep Tips";
    
    [self.navigationController pushViewController:favc animated:YES];
}




- (IBAction)DeleteReminder:(id)sender {
    NSString *query = [NSString stringWithFormat:@"select * from MySkillReminders where SkillName = 'Tips for Better Sleep' and PlanName = '%@'",[Utils getValidSqlString:[PersistenceStorage getObjectForKey:@"planName"]]];
    self.manager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    remindersArray = [[NSArray alloc] initWithArray:[self.manager loadDataFromDB:query]];
    if ([remindersArray count]== 1) {
        NSDictionary *dict = [remindersArray objectAtIndex:0];
        NSString *strAct = [dict valueForKey:@"CalendarEventID"];
        [PersistenceStorage setObject:strAct andKey:@"EventID"];
    }
    NSString *query1 = [NSString stringWithFormat:@"delete from MySkillReminders where SkillName = 'Tips for Better Sleep' and PlanName='%@'", [Utils getValidSqlString:[PersistenceStorage getObjectForKey:@"planName"]]];
    [self.manager executeQuery:query1];
    [self RefreshScheduleData];
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) return;
        EKEvent* eventToRemove = [store eventWithIdentifier:[PersistenceStorage getObjectForKey:@"EventID"]];
        if (eventToRemove) {
            NSError* err = nil;
            [store removeEvent:eventToRemove span:EKSpanFutureEvents commit:YES error:&err];
        }
        
        
    }];
    
}







-(IBAction)viewIntroductionAgainClicked:(id)sender{
    [self writeViewedIntroduction];
    NSMutableArray *pageInfos = [NSMutableArray array];
    
    IntroPageInfo *info = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro7image1.png"] title: @"How can \"Tips for Better Sleep\" help me cope with my Tinnitus?" description:@"Your tinnitus may seem worse when you are tired. When you get enough sleep, you are ready to handle problems, and you won’t get frustrated as easily. A good night’s sleep will give you energy to practice skills from this app."];
    
    [pageInfos addObject:info];
    
    IntroPageInfo *info2 = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro7image2.png"] title: @"What does \"Tips for Better Sleep\" involve?" description:@"Tips for Better Sleep is a list of things you can try to improve your sleep. You can select the tips you want to use and set a reminder. "];
    
    [pageInfos addObject:info2];
    
    SwiperViewController *swiper = [[SwiperViewController alloc]init];
    
    swiper.pageInfos = pageInfos;
    
    swiper.header = @"Welcome to Sleep Tips";
    
    [self.navigationController pushViewController:swiper animated:YES];
    
}

-(IBAction)learnMoreClicked:(id)sender{
    NookTBS *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookTBS"];
    [self.navigationController pushViewController:siv animated:YES];
    
}


 -(IBAction)openMySleepTipsVC:(id)sender{
    MySleepTipsVC *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"MySleepTipsVC"];
    [self.navigationController pushViewController:siv animated:YES];
 }


-(void)writeViewedIntroduction{
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
    NSString *type = @"Skill";
    NSString *optionName = [PersistenceStorage getObjectForKey:@"optionName"];
    NSString *str = @"Watched Skill Introduction";
    
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"situationName"],[PersistenceStorage getObjectForKey:@"skillName"],nil,nil,nil,nil,nil,nil,nil,nil];
    
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


-(void)writeEnabledReminder
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
    NSString *optionName = [PersistenceStorage getObjectForKey:@"optionName"];
    NSString *str = @"Turned On Reminder";
    
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"situationName"],[PersistenceStorage getObjectForKey:@"skillName"],nil,nil,nil,nil,nil,nil,nil,nil];
    
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



-(void)writeDeletedReminder
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
    NSString *optionName = [PersistenceStorage getObjectForKey:@"optionName"];
    NSString *str = @"Turned Off Reminder";
    
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"situationName"],[PersistenceStorage getObjectForKey:@"skillName"],nil,nil,nil,nil,nil,nil,nil,nil];
    
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
