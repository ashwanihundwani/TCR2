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
@property (nonatomic, strong) DBManager *manager;
@property (nonatomic, retain) UISwitch *switch1;

@end

@implementation TipsViewController
@synthesize switch1;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 170, 44)];
    
    titleView.backgroundColor = [Utils colorWithHexValue:NAV_BAR_BLACK_COLOR];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 170, 25)];
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_1];
    
    titleLabel.font = pallete.secondObj;
    titleLabel.textColor = pallete.firstObj;
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //titleLabel.textColor = [UIColor colorWithHexValue:@"797979"];
    titleLabel.backgroundColor = [UIColor clearColor];
    // titleLabel.text = @"Add New Plan";
    
    titleLabel.text= [NSString stringWithFormat:@"Plan for %@ ",[PersistenceStorage getObjectForKey:@"planName"]];
    titleLabel.adjustsFontSizeToFitWidth=YES;
    titleLabel.minimumScaleFactor=0.5;
    
    UILabel *situationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 23, 170, 19)];
    
    pallete = [Utils getColorFontPair:eCFS_PALLETE_2];
    
    situationLabel.font = pallete.secondObj;
    situationLabel.textColor = pallete.firstObj;
    
    situationLabel.textAlignment = NSTextAlignmentCenter;
    
    //titleLabel.textColor = [UIColor colorWithHexValue:@"797979"];
    situationLabel.backgroundColor = [UIColor clearColor];
    situationLabel.text = [PersistenceStorage getObjectForKey:@"skillName"];//@"Your Situation";
    
    [titleView addSubview:titleLabel];
    [titleView addSubview:situationLabel];
    
    self.navigationItem.titleView = titleView;
    
    
//    
//    
//    UIImageView *backLabel = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 15, 20)];
//    
//    backLabel.image = [UIImage imageNamed:@"Active_Back-Arrow.png"];
//    
//    [Utils addTapGestureToView:backLabel target:self
//                      selector:@selector(popToSkillsView)];
//    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backLabel];
//    
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
//                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                       target:nil action:nil];
//    negativeSpacer.width = -8;
//    
//    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, item, nil];
//    
//    
//    
//    

    
    
//    if (![[PersistenceStorage getObjectForKey:@"TipsInitialized"] isEqual: @"Yes"])
//        
//    {
//        
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components = [[NSDateComponents alloc] init];
//    [components setDay: 3];
//    [components setMonth: 7];
//    [components setYear: 2012];
//    [components setHour: 4];
//    [components setMinute: 45];
//    [components setSecond: 0];
//    [calendar setTimeZone: [NSTimeZone defaultTimeZone]];
//    NSDate *dateToFire = [calendar dateFromComponents:components];
//    
//    
//    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//    
//     NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"dd/MM/yyyy"];
//    
//    
//    NSString *str = [NSString stringWithFormat:@"%@",@"Tips for Sleep Feedback"];
//    localNotification.alertBody = str;
//    
//    [localNotification setFireDate: dateToFire];
//    [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
//    [localNotification setRepeatInterval: kCFCalendarUnitDay];
//    
//    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
//        [PersistenceStorage setObject:@"Yes" andKey:@"TipsInitialized"];
//
//    
// }
//    
    

    
    
    
    
       
    // Do any additional setup after loading the view.
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
}
    

- (IBAction) toggle1: (id) sender {
    
    UISwitch *mySwitch = (UISwitch *)[self.view viewWithTag:669];
     UILabel *label = (UILabel *)[self.view viewWithTag:700];
    if (mySwitch.on)
    {
        label.text= @"Skill Reminder Activated";
        
       
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
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        
        
        
        
//        
//        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
//        
//        NSDate *today = [NSDate date];
//        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//        [dateFormat setDateFormat:@"dd/MM/yyyy"];
//        
//        localNotification.fireDate = [[NSDate date]dateByAddingTimeInterval:60];
//        
//        
//        
//        NSString *str = [NSString stringWithFormat:@"%@",@"Tips for Sleep Feedback"];
//        localNotification.alertBody = str;
//        
//        NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"tipsNotification" forKey:@"UUID"];
//        localNotification.userInfo = infoDict;
//        localNotification.repeatInterval = NSMinuteCalendarUnit;
//
//        
//        
//        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
//        
//        
//        
        

        
        
        [PersistenceStorage setObject:@"Yes" andKey:@"TipsActivated"];
        
        
        [self writeEnabledReminder];
         
        

        
}
else
   {label.text= @"Activate Skill Reminder";
       
       
       NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
       NSLog(@"notify array %@",notificationArray);
       
       for(UILocalNotification *notification in notificationArray){
           if ([notification.alertBody isEqualToString:@"Tips for Sleep Feedback"]) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification] ;
           }
           
           
       }
       
       
       //NSArray *notificationArray1 = [[UIApplication sharedApplication] scheduledLocalNotifications];
      // NSLog(@"notify array  new %@",notificationArray1);

       
//       
//       UIApplication *app = [UIApplication sharedApplication];
//       NSArray *eventArray = [app scheduledLocalNotifications];
//       
//       NSLog(@"evenetArray  %@",eventArray);
//       
//       for (int i=0; i<[eventArray count]; i++)
//       {
//           UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
//           NSDictionary *userInfoCurrent = oneEvent.userInfo;
//           
//           NSLog(@"userInfo  %@",userInfoCurrent);
//
//           
//           NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"UUID"]];
//           if ([uid isEqualToString:@"tipsNotificaion"])
//           {
//               NSLog(@"CNCELLING");  //Cancelling local notification
//               [app cancelLocalNotification:oneEvent];
//               break;
//           }
//       }
//       
//       
//       
//       
       
       
       
       
       
       
       [PersistenceStorage setObject:@"No" andKey:@"TipsActivated"];
       [self writeDeletedReminder];

   }
    
 
}








//- (IBAction) toggleOnForSwitch3: (id) sender {
//    
//    if (switch3.on) resSwitch.on = YES;
//    else resSwitch.on = NO;
//    
//}



-(void)RefreshScheduleData
{
   // NSString *query = [NSString stringWithFormat:@"select * from MySkillReminders where SkillName = 'Tips for Better Sleep'"];
    
    NSString *query = [NSString stringWithFormat:@"select * from MySkillReminders where SkillName = 'Tips for Better Sleep' and PlanName = '%@'",[PersistenceStorage getObjectForKey:@"planName"]];
    
    self.manager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    remindersArray = [[NSArray alloc] initWithArray:[self.manager loadDataFromDB:query]];
    UILabel *label = (UILabel *)[self.view viewWithTag:333];
    UIButton *btnLabel1 = (UIButton *)[self.view viewWithTag:334];
    UIButton *btnLabel2 = (UIButton *)[self.view viewWithTag:335];
    
    [[self.view viewWithTag:3] setHidden:YES];
    
    if ([remindersArray count]== 1) {
        
        //label.text = @"Reminder set";
        
        NSDictionary *dict = [remindersArray objectAtIndex:0];
        NSString *strAct = [dict valueForKey:@"ScheduledDate"];
        
        
        
        label.text = strAct;
        
        
        [[self.view viewWithTag:334] setHidden:NO];
        [[self.view viewWithTag:335] setHidden:YES];
        //        btnLabel1.setHidden = YES;
        //      btnLabel2.setHidden = NO;
        
        
        
        
    }
    else
    {
        
        label.text = @"No reminders";
        //  btnLabel1.setHidden = NO;
        // btnLabel2.setHidden = YES;
        
        [[self.view viewWithTag:334] setHidden:YES];
        [[self.view viewWithTag:335] setHidden:NO];
        
    }
}



-(IBAction)goToScheduler:(id)sender
{
    ScheduleViewController *favc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ScheduleViewController"];
    [self.navigationController pushViewController:favc animated:YES];
}




- (IBAction)DeleteReminder:(id)sender {
    
//    NSString *query = [NSString stringWithFormat: @"select * from MySkillReminders where SkillName = 'Tips for Better Sleep'"];
    
    NSString *query = [NSString stringWithFormat:@"select * from MySkillReminders where SkillName = 'Tips for Better Sleep' and PlanName = '%@'",[PersistenceStorage getObjectForKey:@"planName"]];

    
    self.manager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    remindersArray = [[NSArray alloc] initWithArray:[self.manager loadDataFromDB:query]];
    
    
    if ([remindersArray count]== 1) {
        
        
        NSDictionary *dict = [remindersArray objectAtIndex:0];
        NSString *strAct = [dict valueForKey:@"CalendarEventID"];
        [PersistenceStorage setObject:strAct andKey:@"EventID"];
    }
    
    NSString *query1 = [NSString stringWithFormat:@"delete from MySkillReminders where SkillName = 'Tips for Better Sleep'"];
    
    
    
    
    
    [self.manager executeQuery:query1];
    
    [self RefreshScheduleData];
    
    
    
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) return;
        EKEvent* eventToRemove = [store eventWithIdentifier:[PersistenceStorage getObjectForKey:@"EventID"]];
        if (eventToRemove) {
            NSError* err = nil;
            //    [store removeEvent:eventToRemove span:EKSpanThisEvent commit:YES error:&err];
            [store removeEvent:eventToRemove span:EKSpanFutureEvents commit:YES error:&err];
            
            
            
            //            EKSpanFutureEvents
            
             
            
        }
        
        
        
    }
     
     
     
     ];
    
}







-(IBAction)viewIntroductionAgainClicked:(id)sender{
    [self writeViewedIntroduction];
    
    /*
    TipsIntroDetailViewController *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TipsIntroDetailViewController"];
    [self.navigationController pushViewController:siv animated:YES];
     */
    
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
