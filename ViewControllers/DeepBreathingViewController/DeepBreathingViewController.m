//
//  DeepBreathingViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 18/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "DeepBreathingViewController.h"
#import "BreathingIntroDetailViewController.h"
#import "AudioPanningViewController.h"
#import "VideoPlayerViewController.h"
#import "ScheduleViewController.h"
#import "SkillRatingsViewController.h"
#import "NookUsingSoundViewControllerOne.h"
#import "CoundownTimerViewController.h"
#import "NewPlanAddedViewController.h"
#import "NookDB.h"
#import <EventKitUI/EventKitUI.h>

#import "DBManager.h"
#import "MBProgressHUD.h"

#import "SwiperViewController.h"
#import "IntroPageInfo.h"



@interface DeepBreathingViewController ()
{NSArray *remindersArray;
    NSString* CalenderEventID;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) DBManager *dbManagerDeepBreathing;

@end

@implementation DeepBreathingViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.exercises = @[@"Video Introduction", @"Video lessons", @"Timer for Practice"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.manager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    
//    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 170, 44)];
//    
//    titleView.backgroundColor = [Utils colorWithHexValue:NAV_BAR_BLACK_COLOR];
//    
//    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 170, 25)];
//    
//    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_1];
//    
//    titleLabel.font = pallete.secondObj;
//    titleLabel.textColor = pallete.firstObj;
//    
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    
//    //titleLabel.textColor = [UIColor colorWithHexValue:@"797979"];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    // titleLabel.text = @"Add New Plan";
//    
//    titleLabel.text= [NSString stringWithFormat:@"Plan for %@ ",[PersistenceStorage getObjectForKey:@"planName"]];
//    titleLabel.adjustsFontSizeToFitWidth=YES;
//    titleLabel.minimumScaleFactor=0.5;
//    
//    UILabel *situationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 23, 170, 19)];
//    
//    pallete = [Utils getColorFontPair:eCFS_PALLETE_2];
//    
//    situationLabel.font = pallete.secondObj;
//    situationLabel.textColor = pallete.firstObj;
//    
//    situationLabel.textAlignment = NSTextAlignmentCenter;
//    
//    //titleLabel.textColor = [UIColor colorWithHexValue:@"797979"];
//    situationLabel.backgroundColor = [UIColor clearColor];
//    situationLabel.text = [PersistenceStorage getObjectForKey:@"skillName"];//@"Your Situation";
//    
//    [titleView addSubview:titleLabel];
//    [titleView addSubview:situationLabel];
//    
//    self.navigationItem.titleView = titleView;
    
 //   [self addLabel];
    
    // Do any additional setup after loading the view.
}

-(NSString *)planText
{
   return [NSString stringWithFormat:@"Plan for %@ ",[PersistenceStorage getObjectForKey:@"planName"]];
}

-(NSString *)activityText{
    
    return [PersistenceStorage getObjectForKey:@"skillName"];
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
-(void)RefreshScheduleData
{
    NSString *query = [NSString stringWithFormat:@"select * from MySkillReminders where SkillName = 'Deep Breathing' and PlanName = \'%@\'",[PersistenceStorage getObjectForKey:@"planName"]];
    
    
    
    
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

 
        
        
        // Search from back to get the last space character
        NSRange range= [strAct rangeOfString: @" " options: NSBackwardsSearch];
        
        // Take the first substring: from 0 to the space character
        NSString* strAct1= [strAct substringToIndex: range.location]; // @"this is a"

        
        
        
        label.text = strAct;
        
        
//        label.text = [PersistenceStorage getObjectForKey:@"ctf01text"];

        
        
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




-(void)viewWillAppear:(BOOL)animated
{[self RefreshScheduleData];}



-(void)viewDidAppear:(BOOL)animated
{
//    NSLog(@"%@",[PersistenceStorage getObjectForKey:@"shownBreathingIntro"]);
    
    [self RefreshScheduleData];
 //   NSString *query = [NSString stringWithFormat:@"select * from MySkillReminders where SkillName = '%@')", [PersistenceStorage getObjectForKey:@"skillName"]];
 
    
    
    [self.scrollView setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.scrollView setContentSize:CGSizeMake(320,680)];
    
    if ([[PersistenceStorage getObjectForKey:@"Referer"] isEqual: @"Timer"]) {
        SkillRatingsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"SkillRatingsViewController"];
        
        //ratingsView.skillSection = @"Sounds";
        //  ratingsView.skillDetail = self.name;
        
        //[self.navigationController pushViewController:ratingsView animated:YES];
        [self.navigationController presentModalViewController:ratingsView animated:YES];
    }

// if ([labelOne.text isEqual: @"One"] && [labelTwo.text isEqual: @"Two"])
     
     
     
//     if ([[PersistenceStorage getObjectForKey:@"Referer"] isEqual: @"VideoPlayerViewController"])  {
//        SkillRatingsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"SkillRatingsViewController"];
//        
//        //ratingsView.skillSection = @"Sounds";
//        //  ratingsView.skillDetail = self.name;
//        
//        //[self.navigationController pushViewController:ratingsView animated:YES];
//        [self.navigationController presentModalViewController:ratingsView animated:YES];
//    }

    
    
    
    if ([[PersistenceStorage getObjectForKey:@"Referer"] isEqual: @"SkillRatingsViewController"]) {
        NSString *actionSheetTitle = @"Where would you like to go now?"; //Action Sheet Title
        NSString *other00 = @"Schedule Skill Reminder"; //Action Sheet Button Titles

        NSString *other0 = @"Repeat This Skill"; //Action Sheet Button Titles
        NSString *other1 = @"Learn About This Skill";
        NSString *other2 = @"Try Another Skill";
        NSString *other3 = @"Return Home";
        //   NSString *other4 = @"Return Home";
        NSString *cancelTitle = @"Cancel";
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:actionSheetTitle
                                      delegate:self
                                      cancelButtonTitle:nil
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:other00, other0, other1, other2, other3, nil];
        
        [actionSheet showInView:self.view];
        
        
        
        
        [PersistenceStorage setObject:@"OK" andKey:@"Referer"];
        
    }
    
    
    [self.tableView reloadData];
    
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    //   NSString * theValue = [(UILabel*)[self viewWithTag:t200] text];
    
    
    
    
    if  ([buttonTitle isEqualToString:@"Repeat This Skill"]) {
        [PersistenceStorage setObject:nil andKey:@"skillDetail1"];

        [PersistenceStorage setObject:buttonTitle andKey:@"optionName"];
        
 
        
        
        [self writeClickedNextSteps];
        
        
        
    }
   
    if ([buttonTitle isEqualToString:@"Learn About This Skill"]) {
    
        [PersistenceStorage setObject:buttonTitle andKey:@"optionName"];
        [PersistenceStorage setObject:nil andKey:@"skillDetail1"];

        [self writeClickedNextSteps];
        NookDB *samplerView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookDB"];
        [self.navigationController pushViewController:samplerView animated:NO];
    }
    
    
    if ([buttonTitle isEqualToString:@"Try Another Skill"]) {
      
        [PersistenceStorage setObject:nil andKey:@"skillDetail1"];
        [PersistenceStorage setObject:buttonTitle andKey:@"optionName"];
        
        [self writeClickedNextSteps];
        

        NewPlanAddedViewController *samplerView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NewPlanAddedViewController"];
        [self.navigationController pushViewController:samplerView animated:YES];
        
    }
    
    if ([buttonTitle isEqualToString:@"Return Home"]) {
        [PersistenceStorage setObject:buttonTitle andKey:@"optionName"];
        [PersistenceStorage setObject:nil andKey:@"skillDetail1"];

        [self writeClickedNextSteps];
        

        
        [[self tabBarController] setSelectedIndex:0];
        
    }
    
    
    
    if ([buttonTitle isEqualToString:@"Do Activity Now"]) {
//DoingActivityViewController *svc1 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"DoingActivityViewController"];
        //[self.navigationController pushViewController:svc1 animated:YES];
        
    //    [self.navigationController presentModalViewController:svc1 animated:NO];
    }
    
    
    
    if ([buttonTitle isEqualToString:@"Schedule Skill Reminder"]) {
        
        
        UILabel *label = (UILabel *)[self.view viewWithTag:333];
        if (![label.text isEqualToString:@"No reminders"])
        {
        }
        
        else
        {
        
        [PersistenceStorage setObject:buttonTitle andKey:@"optionName"];
        
          
        [self writeClickedNextSteps];
        

        ScheduleViewController *svc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ScheduleViewController"];
        [self.navigationController pushViewController:svc animated:YES];
        }
        
            
    }
    
    
    
    
    
    
    
    
}






//NSString *query = [NSString stringWithFormat:@"select * from MyPlans"];
 //   activityArray = [[NSArray alloc] initWithArray:[self.manager loadDataFromDB:query]];

    


//   .. id obj = [remindersArray objectAtIndex:0];
    

    
    
    
    
 
       // **_statusText**.text = [NSString stringWithFormat:@"%@ button pressed.", title];
    
    // [self performSelectorOnMainThread:@selector(reminderSchedule:) withObject:@"yourString" waitUntilDone:YES];

   // [self.reminderSchedule setText:@"labelText"];
    // [reminderSchedule.text setStringValue:[NSString stringWithFormat:@"%.2f",alt]];
    
 //   reminderSchedule.text = @" is not limited.";
   //[self.reminderSchedule performSelectorOnMainThread : @ selector(setText : ) withObject:str waitUntilDone:YES];


/*(void)addLabel{
  
    UILabel *reminderSchedule = [[UILabel alloc]initWithFrame:
                       CGRectMake(20, 200, 280, 80)];
    reminderSchedule.numberOfLines = 0;
    reminderSchedule.textColor = [UIColor blueColor];
    reminderSchedule.backgroundColor = [UIColor clearColor];
 //   reminderSchedule.textAlignment = UITextAlignmentCenter;
    reminderSchedule.text = @"This is a sample text\n of multiple lines.here number of lines is not limited.";
 [self.view addSubview:reminderSchedule];
    reminderSchedule.clearsContextBeforeDrawing = YES;
    reminderSchedule.text =@"ddd";
    [self.scrollView setContentSize:CGSizeMake(320,1200)];

}
*/







-(IBAction)viewIntroductionAgainClicked:(id)sender{
//[self.reminderSchedule removeFromSuperview];
  // self.reminderSchedule.text = @"asjasasdasd";
    
    [self writeViewedIntroduction];
    
    
    /*
    BreathingIntroDetailViewController *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"BreathingIntroDetailViewController"];
    [self.navigationController pushViewController:siv animated:YES];
     */
    
    NSMutableArray *pageInfos = [NSMutableArray array];
    
    IntroPageInfo *info = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro2image1.png"] title: @"Why is \"Deep Breathing\" helpful?" description:DEEP_BREATHING_INTRO_PAGE1_TEXT];
    
    [pageInfos addObject:info];
    
    IntroPageInfo *info2 = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro2image2.png"] title: @"How can  \"Deep Breathing\" help me with my tinnitus?" description:DEEP_BREATHING_INTRO_PAGE2_TEXT];
    
    [pageInfos addObject:info2];
    IntroPageInfo *info3 = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro2image3.png"] title: @"How do I do \"Deep Breathing\"?" description:DEEP_BREATHING_INTRO_PAGE3_TEXT];
    
    [pageInfos addObject:info3];
    
    SwiperViewController *swiper = [[SwiperViewController alloc]init];
    
    swiper.pageInfos = pageInfos;
    
    swiper.header = @"Welcome to Deep Breathing";
    
    [self.navigationController pushViewController:swiper animated:YES];
}


-(IBAction)learnMoreClicked:(id)sender{
    NookDB *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookDB"];
    [self.navigationController pushViewController:siv animated:YES];
    
}


- (IBAction)BreathingTimer:(id)sender {
    CountdownTimerViewController *guided = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                            
                                            instantiateViewControllerWithIdentifier:@"CountdownTimerViewController"];
    
    guided.header = @"Deep Breathing Timer";
    
    guided.image = [UIImage imageNamed:@"2DeepBreathing.png"];
    
    [self.navigationController presentModalViewController:guided animated:YES];
    
 
    
}



- (IBAction)PlayAudioOne:(id)sender {
    
    AudioPanningViewController *audioPanning = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AudioPanningViewController"];
    audioPanning.url = @"frog.mp3";
    audioPanning.name = @"Something   ";
    audioPanning.panning = audio;
    
 
    [self.navigationController pushViewController:audioPanning animated:YES];
}


- (IBAction)PlayVideoOne:(id)sender {
    
    VideoPlayerViewController *audioPanning = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
    audioPanning.panning = video;
    audioPanning.videoURL = @"DeepBreathingLesson.mp4";
    [PersistenceStorage setObject:@"Video Lesson" andKey:@"skillDetail1"];

    [self.navigationController presentModalViewController:audioPanning animated:NO];

    
//    [self.navigationController pushViewController:audioPanning animated:YES];
}



- (IBAction)PlayVideoTwo:(id)sender {
    
    VideoPlayerViewController *audioPanning = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
    audioPanning.panning = video;
    audioPanning.videoURL = @"deep_breathing.mp4";
    [PersistenceStorage setObject:@"Watched Video Introduction" andKey:@"skillDetail1"];

    [self.navigationController presentModalViewController:audioPanning animated:NO];

    
//    [self.navigationController pushViewController:audioPanning animated:YES];
}




- (IBAction)DeleteReminder:(id)sender {
    NSString *queryClear = [NSString stringWithFormat:@"delete from MySkillReminders where SkillName = 'Deep Breathing' and PlanName = '%@'",[PersistenceStorage getObjectForKey:@"planName"]];
    CalenderEventID = [self eventExists];
    if(CalenderEventID != nil){
        [self removeEventFromCalender];
    }
    // now delete notification
    [self deleteExistingEventNotitfication];
    [self.manager executeQuery:queryClear];
    [self RefreshScheduleData];
    [self writeDeletedReminder];
    
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

-(void)writeClickedNextSteps
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
    NSString *type = @"Skill";
    NSString *optionName = [PersistenceStorage getObjectForKey:@"optionName"];
    NSString *str = @"Selected a Next Steps Option";
    
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,optionName,[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"situationName"],[PersistenceStorage getObjectForKey:@"skillName"],[PersistenceStorage getObjectForKey:@"skillDetail1"],nil,nil,nil,nil,nil,nil,nil];
    
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

-(NSString*)eventExists{
    //check for the Event
    //get the skill first
    NSString* calEvent = nil;
    NSString* reminderQuery = [NSString stringWithFormat:@"select CalendarEventID from MySkillReminders where SkillName = \"%@\" and  PlanName = \"%@\"",[PersistenceStorage getObjectForKey:@"skillName"],[PersistenceStorage getObjectForKey:@"planName"]];
    NSArray* calenderEventsArray = [NSArray arrayWithArray:[self.manager loadDataFromDB:reminderQuery]];
    if(calenderEventsArray != nil && calenderEventsArray.count > 0){
        //get the calender event and return it back for rescheduling
        calEvent = [[calenderEventsArray objectAtIndex:0] objectForKey:@"CalendarEventID"];
        
    }
    return calEvent;
}

-(void)removeEventFromCalender{
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) return;
        NSError* err = nil;
        EKEvent* eventToRemove = [store eventWithIdentifier:CalenderEventID];
        [store removeEvent:eventToRemove span:EKSpanFutureEvents commit:YES error:&err];
        if(err != nil){
            NSLog(@"Error in deletining event from calender:%@", [eventToRemove description]);
        }
    }
     
     
     ];
    
}

-(void)deleteExistingEventNotitfication{
    NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSString* skillName = [PersistenceStorage getObjectForKey:@"skillName"];
    NSString* planName = [PersistenceStorage getObjectForKey:@"planName"];
    for(UILocalNotification *notification in notificationArray){
        if ([[notification.userInfo valueForKey:@"PlanName"] isEqualToString:planName] && [[notification.userInfo valueForKey:@"Type"] isEqualToString:skillName]) {
            NSLog(@"Cancelling local notification for skill:%@ in Plan:%@", skillName, planName);
            [[UIApplication sharedApplication] cancelLocalNotification:notification] ;
            break;
        }
        
    }
    
}



@end
