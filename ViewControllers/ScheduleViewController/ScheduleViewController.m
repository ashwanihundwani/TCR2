//
//  ScheduleViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 30/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//
#import "MBProgressHUD.h"
#import "ActivitiesViewController.h"

#import "ScheduleViewController.h"
#import <EventKitUI/EventKitUI.h>



@interface ScheduleViewController ()
{NSArray *remindersArray;
}





@property(nonatomic,strong) NSDate *startDate;
@property(nonatomic,strong) NSDate  *endDate;
@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add Event";
    // Do any additional setup after loading the view.
    [self setUpView];
}

-(void)setUpView{
    [self.datePicker setHidden:YES];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];
    self.navigationItem.rightBarButtonItem = doneButton;
    self.activityName.text = self.name;
    self.datePicker.minimumDate =[NSDate date];
}

- (void)viewDidDisappear:(BOOL)animated {


[PersistenceStorage setObject:@"No" andKey:@"showCancelActivityButton"];



}


- (void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
}



- (void)viewDidAppear:(BOOL)animated {
    
    NSLog(@"%@",[PersistenceStorage getObjectForKey:@"skillName"]);
    
    
    UILabel *tlabel = [self.view viewWithTag:555];

    
if (![[PersistenceStorage getObjectForKey:@"showCancelActivityButton"] isEqualToString:@"No"])
{
     tlabel.hidden = NO;

    
}
else
{
    tlabel.hidden  = YES;
}

    [PersistenceStorage setObject:@"No" andKey:@"showCancelActivityButton"];


}

- (IBAction)DeleteReminder:(id)sender {
    
    
    [self writeSkillReminderToggle:@"Turned Off Reminder"];

    
    NSString *query = [NSString stringWithFormat: @"select * from MyReminders where ActName = '%@'", [PersistenceStorage getObjectForKey:@"activityName"] ];
    
    
    
    NSString *queryClear = [NSString stringWithFormat:@"delete from MyReminders where ActName = '%@'",[PersistenceStorage getObjectForKey:@"activityName"]];
    
    //  NSString *queryDelete = [NSString stringWithFormat:@"delete from MyReminders where ActivityName = %ld", [PersistenceStorage getObjectForKey:@"activityName"] ];
    
    
    
    self.manager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    remindersArray = [[NSArray alloc] initWithArray:[self.manager loadDataFromDB:query]];
    
    
    if ([remindersArray count]== 1) {
        
        
        NSDictionary *dict = [remindersArray objectAtIndex:0];
        NSString *strAct = [dict valueForKey:@"CalendarEventID"];
        [PersistenceStorage setObject:strAct andKey:@"EventID"];
        
        
    }
    
    
    
    
    //clear notification
    
    NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSLog(@"notify array %@",notificationArray);
    
    for(UILocalNotification *notification in notificationArray){
        if ([notification.alertBody containsString:[PersistenceStorage getObjectForKey:@"activityName"]]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification] ;
        }
        
        
    }
    
    
    
    
    /*
     
     NSString *query = [NSString stringWithFormat: @"delete from MyReminders where ActivityName = %ld", [PersistenceStorage getObjectForKey:@"activityName"] ];
     
     
     BOOL isDone = [self.manager executeQuery:queryClear];
     if (isDone == YES)
     {
     
     
     
     
     
     
     //   [[planListArray objectAtIndex:indexPath.row] valueForKey:@"situationName"];
     
     
     
     
     }
     else{
     }
     
     
     
     if ([remindersArray count]== 1) {
     
     //label.text = @"Reminder set";
     
     NSDictionary *dict = [remindersArray objectAtIndex:0];
     NSString *strAct = [dict valueForKey:@"ScheduledDate"];
     
     
     
     
     
     
     
     
     
     
     
     
     */
    
    
    
    
    
    
    
    
    [self.manager executeQuery:queryClear];
    
    
    ActivitiesViewController *svc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ActivitiesViewController"];
    // [self.navigationController pushViewController:svc animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
    
    //    [self.manager executeQuery:queryClear];
    
    
}








#pragma mark DoneClicked
-(void)doneClicked{
    
    
if (self.datePicker.hidden==0)
{

    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    
    
    
    
    NSString * schDate = [formatter stringFromDate:self.datePicker.date];
    
    
    [PersistenceStorage setObject:schDate andKey:@"localScheduledDate"];
    

    self.manager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    
    NSLog(@"%@",      [PersistenceStorage getObjectForKey:@"skillName"]);
    
    //[button.controlName isEqualToString:controlName]
    
    if ([[PersistenceStorage getObjectForKey:@"skillName"] isEqualToString:@"Pleasant Activities"]
        
        && ![[PersistenceStorage getObjectForKey:@"showCancelActivityButton"] isEqualToString:@"Yes"])
    
    {
        
        

        NSString * schDate = self.startDate;
        
     //   localScheduledDate
        
      //  [PersistenceStorage setObject:schDate andKey:@"localScheduledDate"];
        
      //  [PersistenceStorage setObject:schDate andKey:@"scheduledDate"];

        UIButton *repeatLabel = (UIButton *)[self.view viewWithTag:355];
        
        NSString *buttonTitle =repeatLabel.currentTitle;
        
        
        
        EKEventStore *store = [EKEventStore new];
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (!granted) { return; }
            EKEvent *event = [EKEvent eventWithEventStore:store];
            //event.title = self.name : @"concatenation with operators" ;
            NSDate *twoYearsFromNow = [NSDate dateWithTimeIntervalSinceNow:63113851];
            
            
            
            EKRecurrenceRule *recurrance;
            NSDateComponents *comp = [[NSDateComponents alloc]init];
            
            // The application actually allows multiple combinations of reminder periods and expiry for contacts - I've
            // only included the 2 week reminder here for simplicity
            [comp setYear:0];
            [comp setMonth:0];
            [comp setDay:14];
            //Recurr every 2weeks
            //  recurrance = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:1 end:[EKRecurrenceEnd recurrenceEndWithEndDate:twoYearsFromNow]];
            
            //     EKRecurrenceRule *rule = [[EKRecurrenceRule alloc] init:EKRecurrenceFrequencyDaily interval:1 end:nil];
            
            
            
            
            if  ([buttonTitle isEqualToString:@"Daily"]) {
                recurrance = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:1 end:[EKRecurrenceEnd recurrenceEndWithEndDate:twoYearsFromNow]];
                
            }
            if ([buttonTitle isEqualToString:@"Weekly"]) {
                recurrance = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:1 end:[EKRecurrenceEnd recurrenceEndWithEndDate:twoYearsFromNow]];
                
            }
            
            if ([buttonTitle isEqualToString:@"None"]) {
                recurrance = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyYearly interval:1 end:[EKRecurrenceEnd recurrenceEndWithEndDate:twoYearsFromNow]];
                
                
            }
            
            
            
            
            
            
            
            NSString *TC = @"  Tinnitus Coach: ";
            event.title = [TC stringByAppendingString:self.name];
            //NSLog(@"%@",  event.title );
            event.startDate = self.startDate ;//[NSDate date]; //today
            event.endDate =  self.endDate;  //event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
            
            event.recurrenceRules=@[recurrance];
            
            event.calendar = [store defaultCalendarForNewEvents];
            //  event.recurrenceRules = recurrance;
            
            
            NSError *err = nil;
            
            
            
            
            [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
            //      [store saveEvent:event span:EKSpanFutureEvents commit:YES error:&err];
            NSString *savedEventId = event.eventIdentifier;  //save the event id if you want to access this later
            
            [PersistenceStorage setObject:savedEventId andKey:@"lastEventIdentifer"];  ///STORE to test it for deletion
            NSLog(@"%@", [PersistenceStorage getObjectForKey:@"lastEventIdentifer"]);
            
            
            NSString *queryClear = [NSString stringWithFormat:@"delete from MyReminders where ActName = '%@'",[PersistenceStorage getObjectForKey:@"activityName"]];
            
            
            NSString *query = [NSString stringWithFormat:@"insert into MyReminders ('ID','ActName','ScheduledDate','CalendarEventID','PlanName','SkillName') values(1,'%@','%@','%@','%@','Pleasant Activities')",[PersistenceStorage getObjectForKey:@"activityName"],[PersistenceStorage getObjectForKey:@"localScheduledDate"],[PersistenceStorage getObjectForKey:@"lastEventIdentifer"],[PersistenceStorage getObjectForKey:@"planName"]];
            
            
            
            
            
            
            //      NSString *query = [NSString stringWithFormat:@"insert into MyReminders ('ID','ActName','ScheduledDate') values(1,'%@','%@' )",[PersistenceStorage getObjectForKey:@"activityName"],[PersistenceStorage getObjectForKey:@"scheduledDate"]];
            
            
            
            
            NSLog(@"%@", query);
            
            // Execute the query.
            [self.manager executeQuery:queryClear];
            [self.manager executeQuery:query];
            
            
            
        }];
        
        // Schedule the notification
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = self.startDate ;
        NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"\nThe '",[PersistenceStorage getObjectForKey:@"activityName"],@"' pleasant activity is scheduled now in '",[PersistenceStorage getObjectForKey:@"planName"],@"' plan.\n\n You can access and run this activity from this plan. In the plan, look for the skill 'Pleasant Activities' and the list of values: ",[PersistenceStorage getObjectForKey:@"valueName"]];
        localNotification.alertBody =  str;
        NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Pleasant Activities", @"Type", [PersistenceStorage getObjectForKey:@"planName"],@"PlanName",self.name,@"Activity",nil];
        localNotification.userInfo = infoDict;//[NSMutableDictionary dictionaryWithObject:@"targetURL" forKey:@"Test"];

        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"] ];
        
        hud.mode = MBProgressHUDModeCustomView;
        
        hud.labelText = @"Scheduled Reminder";
        
        [hud show:YES];
        [hud hide:YES afterDelay:1];
        
        
        [self writeSkillReminderToggle:@"On"];
        
        
        
        
    }
    
    if ([[PersistenceStorage getObjectForKey:@"skillName"] isEqualToString:@"Imagery"]){
        
        NSString * schDate = self.startDate;
        
        
        
        [PersistenceStorage setObject:schDate andKey:@"scheduledDate"];
        
        
        UIButton *repeatLabel = (UIButton *)[self.view viewWithTag:355];
        
        NSString *buttonTitle =repeatLabel.currentTitle;
        NSLog(@"%@", buttonTitle);
        
        
        
        EKEventStore *store = [EKEventStore new];
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (!granted) { return; }
            EKEvent *event = [EKEvent eventWithEventStore:store];
            //event.title = self.name : @"concatenation with operators" ;
            NSDate *twoYearsFromNow = [NSDate dateWithTimeIntervalSinceNow:63113851];
            
            
            
            EKRecurrenceRule *recurrance;
            NSDateComponents *comp = [[NSDateComponents alloc]init];
            
            
            [comp setYear:0];
            [comp setMonth:0];
            [comp setDay:14];
            
            
            
            if  ([buttonTitle isEqualToString:@"Daily"]) {
                recurrance = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:1 end:[EKRecurrenceEnd recurrenceEndWithEndDate:twoYearsFromNow]];
                
            }
            if ([buttonTitle isEqualToString:@"Weekly"]) {
                recurrance = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:1 end:[EKRecurrenceEnd recurrenceEndWithEndDate:twoYearsFromNow]];
                
            }
            
            if ([buttonTitle isEqualToString:@"None"]) {
                recurrance = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyYearly interval:1 end:[EKRecurrenceEnd recurrenceEndWithEndDate:twoYearsFromNow]];
                
                
            }
            
            
            
            NSString *TC = @"Tinnitus Coach: SKILL  ";
                   
            
            event.title = @"  Tinnitus Coach - Imagery Skill";///[TC stringByAppendingString:self.name];

            
            event.startDate = self.startDate ;//[NSDate date]; //today
            event.endDate =  self.endDate;  //event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
            
            event.recurrenceRules=@[recurrance];
            
            event.calendar = [store defaultCalendarForNewEvents];
            
            
            
            NSError *err = nil;
            
            
            
            
            [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
            NSString *savedEventId = event.eventIdentifier;  //save the event id if you want to access this later
            
            [PersistenceStorage setObject:savedEventId andKey:@"lastEventIdentifer"];  ///STORE to test it for deletion
            NSLog(@"%@", [PersistenceStorage getObjectForKey:@"lastEventIdentifer"]);
            
            
            NSString *queryClear = [NSString stringWithFormat:@"delete from MySkillReminders where SkillName = 'Imagery' and PlanName = '%@'",[PersistenceStorage getObjectForKey:@"planName"]];
            
            NSString *dateWithRepeat = [PersistenceStorage getObjectForKey:@"localScheduledDate"];
            
            if([repeatLabel.titleLabel.text isEqualToString:@"Daily"] ||
               [repeatLabel.titleLabel.text isEqualToString:@"Weekly"])
            {
                dateWithRepeat = [[[PersistenceStorage getObjectForKey:@"localScheduledDate"] stringByAppendingString:@"\n"] stringByAppendingString:repeatLabel.titleLabel.text];
            }
            
            NSString *query = [NSString stringWithFormat:@"insert into MySkillReminders ('ID','SkillName','ScheduledDate','CalendarEventID','PlanName') values(1,'%@','%@','%@','%@' )",@"Imagery",dateWithRepeat,[PersistenceStorage getObjectForKey:@"lastEventIdentifer"],[PersistenceStorage getObjectForKey:@"planName"]];
            
            [self.manager executeQuery:queryClear];
            [self.manager executeQuery:query];
            
            
            
        }];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = self.startDate ;
        NSString *str = [NSString stringWithFormat:@"%@%@%@",@"\nThe 'Imagery' skill is scheduled now in '",[PersistenceStorage getObjectForKey:@"planName"],@"' plan.\n\n You can access and run this skill from this plan."];
        localNotification.alertBody =  str;
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Imagery", @"Type", [PersistenceStorage getObjectForKey:@"planName"],@"PlanName",nil];
        localNotification.userInfo = infoDict;
        
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        
        [self writeSkillReminder:@"On"];
        
        
    }
    
    
    
    
    if ([[PersistenceStorage getObjectForKey:@"skillName"] isEqualToString:@"Guided Meditation"]){
        
        NSString * schDate = self.startDate;
        
        
        
        [PersistenceStorage setObject:schDate andKey:@"scheduledDate"];
        
        
        UIButton *repeatLabel = (UIButton *)[self.view viewWithTag:355];
        
        NSString *buttonTitle =repeatLabel.currentTitle;
        NSLog(@"%@", buttonTitle);
        
        
        
        EKEventStore *store = [EKEventStore new];
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (!granted) { return; }
            EKEvent *event = [EKEvent eventWithEventStore:store];
            NSDate *twoYearsFromNow = [NSDate dateWithTimeIntervalSinceNow:63113851];
            
            
            
            EKRecurrenceRule *recurrance;
            NSDateComponents *comp = [[NSDateComponents alloc]init];
            
            
            [comp setYear:0];
            [comp setMonth:0];
            [comp setDay:14];
            
            
            
            if  ([buttonTitle isEqualToString:@"Daily"]) {
                recurrance = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:1 end:[EKRecurrenceEnd recurrenceEndWithEndDate:twoYearsFromNow]];
                
            }
            if ([buttonTitle isEqualToString:@"Weekly"]) {
                recurrance = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:1 end:[EKRecurrenceEnd recurrenceEndWithEndDate:twoYearsFromNow]];
                
            }
            
            if ([buttonTitle isEqualToString:@"None"]) {
                recurrance = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyYearly interval:1 end:[EKRecurrenceEnd recurrenceEndWithEndDate:twoYearsFromNow]];
                
                
            }
            
            
            
            NSString *TC = @"Tinnitus Coach: SKILL  ";
            event.title = @"  Tinnitus Coach - Guided Meditation Skill";///[TC stringByAppendingString:self.name];
            //NSLog(@"%@",  event.title );
            event.startDate = self.startDate ;//[NSDate date]; //today
            event.endDate =  self.endDate;  //event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
            
            event.recurrenceRules=@[recurrance];
            
            event.calendar = [store defaultCalendarForNewEvents];
            
            
            
            NSError *err = nil;
            
            
            
            
            [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
            //      [store saveEvent:event span:EKSpanFutureEvents commit:YES error:&err];
            NSString *savedEventId = event.eventIdentifier;  //save the event id if you want to access this later
            
            [PersistenceStorage setObject:savedEventId andKey:@"lastEventIdentifer"];  ///STORE to test it for deletion
            NSLog(@"%@", [PersistenceStorage getObjectForKey:@"lastEventIdentifer"]);
            
            NSString *dateWithRepeat = [PersistenceStorage getObjectForKey:@"localScheduledDate"];
            
            if([repeatLabel.titleLabel.text isEqualToString:@"Daily"] ||
               [repeatLabel.titleLabel.text isEqualToString:@"Weekly"])
            {
                dateWithRepeat = [[[PersistenceStorage getObjectForKey:@"localScheduledDate"] stringByAppendingString:@"\n"] stringByAppendingString:repeatLabel.titleLabel.text];
            }

            
            NSString *queryClear = [NSString stringWithFormat:@"delete from MySkillReminders where SkillName = 'Guided Meditation' and PlanName = '%@'",[PersistenceStorage getObjectForKey:@"planName"]];;
            
            
            NSString *query = [NSString stringWithFormat:@"insert into MySkillReminders ('ID','SkillName','ScheduledDate','CalendarEventID','PlanName') values(1,'%@','%@','%@','%@')",@"Guided Meditation",dateWithRepeat,[PersistenceStorage getObjectForKey:@"lastEventIdentifer"],[PersistenceStorage getObjectForKey:@"planName"]];
            
            [self.manager executeQuery:queryClear];
            [self.manager executeQuery:query];
            
            
            
        }];
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = self.startDate ;
        NSString *str = [NSString stringWithFormat:@"%@%@%@",@"\nThe 'Guided Meditation' skill is scheduled now in '",[PersistenceStorage getObjectForKey:@"planName"],@"' plan.\n\n You can access and run this skill from this plan."];
        localNotification.alertBody =  str;
        
        
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Guided Meditation",@"Type", [PersistenceStorage getObjectForKey:@"planName"],@"PlanName",nil];
        localNotification.userInfo = infoDict;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        [self writeSkillReminder:@"On"];
        
    }
    
    
    
    
    if ([[PersistenceStorage getObjectForKey:@"skillName"] isEqualToString:@"Tips for Better Sleep"]){
        
        NSString * schDate = self.startDate;
        
        
        
        [PersistenceStorage setObject:schDate andKey:@"scheduledDate"];
        
        
        UIButton *repeatLabel = (UIButton *)[self.view viewWithTag:355];
        
        NSString *buttonTitle =repeatLabel.currentTitle;
        NSLog(@"%@", buttonTitle);
        
        
        
        EKEventStore *store = [EKEventStore new];
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (!granted) { return; }
            EKEvent *event = [EKEvent eventWithEventStore:store];
            //event.title = self.name : @"concatenation with operators" ;
            NSDate *twoYearsFromNow = [NSDate dateWithTimeIntervalSinceNow:63113851];
            
            
            
            EKRecurrenceRule *recurrance;
            NSDateComponents *comp = [[NSDateComponents alloc]init];
            
            
            [comp setYear:0];
            [comp setMonth:0];
            [comp setDay:14];
            
            
            
            if  ([buttonTitle isEqualToString:@"Daily"]) {
                recurrance = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:1 end:[EKRecurrenceEnd recurrenceEndWithEndDate:twoYearsFromNow]];
                
            }
            if ([buttonTitle isEqualToString:@"Weekly"]) {
                recurrance = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:1 end:[EKRecurrenceEnd recurrenceEndWithEndDate:twoYearsFromNow]];
                
            }
            
            if ([buttonTitle isEqualToString:@"None"]) {
                recurrance = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyYearly interval:1 end:[EKRecurrenceEnd recurrenceEndWithEndDate:twoYearsFromNow]];
                
                
            }
            
            
            
            NSString *TC = @"Tinnitus Coach: SKILL  ";
            event.title = @" Tinnitus Coach - Tips for Better Sleep Skill";///[TC stringByAppendingString:self.name];
            //NSLog(@"%@",  event.title );
            event.startDate = self.startDate ;//[NSDate date]; //today
            event.endDate =  self.endDate;  //event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
            
            event.recurrenceRules=@[recurrance];
            
            event.calendar = [store defaultCalendarForNewEvents];
            
            
            
            NSError *err = nil;
            
            
            
            
            [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
            //      [store saveEvent:event span:EKSpanFutureEvents commit:YES error:&err];
            NSString *savedEventId = event.eventIdentifier;  //save the event id if you want to access this later
            
            [PersistenceStorage setObject:savedEventId andKey:@"lastEventIdentifer"];  ///STORE to test it for deletion
            NSLog(@"%@", [PersistenceStorage getObjectForKey:@"lastEventIdentifer"]);
            
            
            NSString *queryClear = [NSString stringWithFormat:@"delete from MySkillReminders where SkillName = 'Tips for Better Sleep' and PlanName = '%@'",[PersistenceStorage getObjectForKey:@"planName"]];
            
            
            NSString *query = [NSString stringWithFormat:@"insert into MySkillReminders ('ID','SkillName','ScheduledDate','CalendarEventID','PlanName') values(1,'%@','%@','%@','%@')",@"Tips for Better Sleep",[PersistenceStorage getObjectForKey:@"localScheduledDate"],[PersistenceStorage getObjectForKey:@"lastEventIdentifer"],[PersistenceStorage getObjectForKey:@"planName"]];
            
            [self.manager executeQuery:queryClear];
            [self.manager executeQuery:query];
            
            
            
        }];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = self.startDate ;
        NSString *str = [NSString stringWithFormat:@"%@%@%@",@"\nThe 'Tips for Better Sleep' skill is scheduled now in '",[PersistenceStorage getObjectForKey:@"planName"],@"' plan.\n\n You can access and run this skill from this plan."];
        localNotification.alertBody =  str;
        
        
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
    }
    
    
    
    
    
    
    
    if ([[PersistenceStorage getObjectForKey:@"skillName"] isEqualToString:@"Deep Breathing"]){
        
        NSString * schDate = self.startDate;
        
        
        
        [PersistenceStorage setObject:schDate andKey:@"scheduledDate"];
        
        
        UIButton *repeatLabel = (UIButton *)[self.view viewWithTag:355];
        
        NSString *buttonTitle =repeatLabel.currentTitle;
        NSLog(@"%@", buttonTitle);
        
        
        
        EKEventStore *store = [EKEventStore new];
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (!granted) { return; }
            EKEvent *event = [EKEvent eventWithEventStore:store];
            //event.title = self.name : @"concatenation with operators" ;
            NSDate *twoYearsFromNow = [NSDate dateWithTimeIntervalSinceNow:63113851];
            
            
            
            EKRecurrenceRule *recurrance;
            NSDateComponents *comp = [[NSDateComponents alloc]init];
            
            
            [comp setYear:0];
            [comp setMonth:0];
            [comp setDay:14];
            
            
            
            if  ([buttonTitle isEqualToString:@"Daily"]) {
                recurrance = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:1 end:[EKRecurrenceEnd recurrenceEndWithEndDate:twoYearsFromNow]];
                
            }
            if ([buttonTitle isEqualToString:@"Weekly"]) {
                recurrance = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:1 end:[EKRecurrenceEnd recurrenceEndWithEndDate:twoYearsFromNow]];
                
            }
            
            if ([buttonTitle isEqualToString:@"None"]) {
                recurrance = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyYearly interval:1 end:[EKRecurrenceEnd recurrenceEndWithEndDate:twoYearsFromNow]];
                
                
            }
            
            
            
            NSString *TC = @"Tinnitus Coach: SKILL  ";
            event.title = @"  Tinnitus Coach - Deep Breathing Skill";///[TC stringByAppendingString:self.name];
            //NSLog(@"%@",  event.title );
            event.startDate = self.startDate ;//[NSDate date]; //today
            event.endDate =  self.endDate;  //event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
            
            event.recurrenceRules=@[recurrance];
            
            event.calendar = [store defaultCalendarForNewEvents];
            
            
            
            NSError *err = nil;
            
            
            
            
            [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
            if(err != nil) {
                NSLog(@"Error in saving:%@:",[err localizedDescription]);
            }
            //      [store saveEvent:event span:EKSpanFutureEvents commit:YES error:&err];
            NSString *savedEventId = event.eventIdentifier;  //save the event id if you want to access this later
            
            [PersistenceStorage setObject:savedEventId andKey:@"lastEventIdentifer"];  ///STORE to test it for deletion
            NSLog(@"%@", [PersistenceStorage getObjectForKey:@"lastEventIdentifer"]);
            
            NSString *dateWithRepeat = [PersistenceStorage getObjectForKey:@"localScheduledDate"];
            
            if([repeatLabel.titleLabel.text isEqualToString:@"Daily"] ||
               [repeatLabel.titleLabel.text isEqualToString:@"Weekly"])
            {
                dateWithRepeat = [[[PersistenceStorage getObjectForKey:@"localScheduledDate"] stringByAppendingString:@"\n"] stringByAppendingString:repeatLabel.titleLabel.text];
            }
            
            
            NSString *queryClear = [NSString stringWithFormat:@"delete from MySkillReminders where SkillName = 'Deep Breathing' and PlanName = '%@'",[PersistenceStorage getObjectForKey:@"planName"]];
            
            
            NSString *query = [NSString stringWithFormat:@"insert into MySkillReminders ('ID','SkillName','ScheduledDate','CalendarEventID','PlanName') values(1,'%@','%@','%@','%@')",@"Deep Breathing",dateWithRepeat,[PersistenceStorage getObjectForKey:@"lastEventIdentifer"],[PersistenceStorage getObjectForKey:@"planName"]];
            
            [self.manager executeQuery:queryClear];
            [self.manager executeQuery:query];
            
            
            
        }];
        
        
        // Schedule the notification
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = self.startDate ;
        NSString *str = [NSString stringWithFormat:@"%@%@%@",@"\nThe 'Deep Breathing' skill is scheduled now in '",[PersistenceStorage getObjectForKey:@"planName"],@"' plan.\n\n You can access and run this skill from this plan."];
        localNotification.alertBody =  str;
        
        
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        
        NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Deep Breathing", @"Type",[PersistenceStorage getObjectForKey:@"planName"],@"PlanName", nil];
        localNotification.userInfo = infoDict;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        [self writeSkillReminder:@"On"];

    }
    
    
    
}
    
    //[self dismissModalViewControllerAnimated:YES];
    
    
    [self.navigationController popViewControllerAnimated:YES];

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

- (IBAction)startButtonTapped:(id)sender {
    [self.datePicker setHidden:NO];
    [self.datePicker addTarget:self
                        action:@selector(setDatePickerTime:)
              forControlEvents:UIControlEventValueChanged];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MMM dd,yyy hh:mm a"];
    
    NSString *title = [outputFormatter stringFromDate:self.datePicker.date];
    self.startDate = self.datePicker.date;
 
    
    
    [self.startButton setTitle:title forState:UIControlStateNormal];
    self.endDate = [[NSDate alloc]initWithTimeInterval:3600 sinceDate:self.datePicker.date];
    NSString *endTitle = [outputFormatter stringFromDate:self.endDate ];
    [self.endButton setTitle:endTitle forState:UIControlStateNormal];
}



- (IBAction)repeatButtonTapped:(id)sender {
    NSString *actionSheetTitle = @"Repeat this event in your Calendar?"; //Action Sheet Title
    NSString *other0 = @"None"; //Action Sheet Button Titles
    NSString *other1 = @"Daily";
    NSString *other2 = @"Weekly";
    NSString *cancelTitle = @"Cancel";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other0, other1, other2, nil];
    [actionSheet showInView:self.view];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    //   NSString * theValue = [(UILabel*)[self viewWithTag:t200] text];
    
    
    UIButton *repeatLabel = (UIButton *)[self.view viewWithTag:355];
    if  ([buttonTitle isEqualToString:@"Daily"]) {
        
    
        
        //
        /*  UILabel *firstLabel = (UILabel *)[self.view viewWithTag:555];
         firstLabel.text = @"Daily";
         
         [self.activityNameButton setTitle:[dict valueForKey:@"activityName"] forState:UIControlStateNormal];
         */
        [repeatLabel setTitle:@"Daily" forState:UIControlStateNormal];
        //    [self.repeatLabel setTitle:@"Daily"];
    }
    if ([buttonTitle isEqualToString:@"Weekly"]) {
        /*       UILabel *firstLabel = (UILabel *)[self.view viewWithTag:555];
         firstLabel.text = @"Weekly";*/
        
        //      [self.repeatLabel setTitle:@"Weekly"];
        [repeatLabel setTitle:@"Weekly" forState:UIControlStateNormal];
        
        
    }
    
    if ([buttonTitle isEqualToString:@"None"]) {
        /*UILabel *firstLabel = (UILabel *)[self.view viewWithTag:555];
         firstLabel.text = @"None";*/
        [repeatLabel setTitle:@"None" forState:UIControlStateNormal];
        
        //[self.repeatLabel setTitle:@"None"];
        
        
    }
    
}





-(void)setDatePickerTime:(id)sender
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MMM dd,yyy hh:mm a"];
    
    NSString *title = [outputFormatter stringFromDate:self.datePicker.date];
    self.startDate = self.datePicker.date;
    
    [self.startButton setTitle:title forState:UIControlStateNormal];
    //end date
    self.endDate = [[NSDate alloc]initWithTimeInterval:3600 sinceDate:self.datePicker.date];
    NSString *endTitle = [outputFormatter stringFromDate:self.endDate ];
    [self.endButton setTitle:endTitle forState:UIControlStateNormal];
}





- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"Ignore"
                                              otherButtonTitles:@"Run"];
        [alert show];
    }
    
    
    NSString *NotificationValue = [notification.userInfo objectForKey:@"name"];        //objectForKey:TheKeyNameYouUsed
    
    
    
    
    
    
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}



-(void)writeSkillReminderToggle:theMode

{
    
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
    NSString *type = @"Reminder";
    NSString *str;

    
    if ([theMode isEqualToString:@"On"])
    {
        str = @"Turned On Reminder";}
    else
    {  str = @"Turned Off Reminder";}
    

    
    
    NSString * strippedActivityName = [[PersistenceStorage getObjectForKey:@"activityName"] stringByReplacingOccurrencesOfString:@"," withString:@"|"];

    
    
//if ([[PersistenceStorage getObjectForKey:@"skillName"] isEqualToString:@"Pleasant Activities" ])
//{

NSString *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"situationName"],[PersistenceStorage getObjectForKey:@"skillName"],[PersistenceStorage getObjectForKey:@"valueName"],strippedActivityName,nil,nil,nil,nil,nil,nil];
    
//}
//
//else
//
//{
//    
//    NSString *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,theMode,nil,[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"situationName"],[PersistenceStorage getObjectForKey:@"skillName"],nil,nil,nil,nil,nil,nil,nil,nil];
//}





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




-(void)writeSkillReminder:theMode

{
    
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
    NSString *type = @"Reminder";
    NSString *str;
    
    if ([theMode isEqualToString:@"Off"])
    {
 str = @"Turned Off Reminder";}
    else
    {  str = @"Turned On Reminder";}
    
    
   
    
        NSString *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"situationName"],[PersistenceStorage getObjectForKey:@"skillName"],nil,nil,nil,nil,nil,nil,nil,nil];
    
    

    
    
    
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