//
//  GuidedMeditationViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 18/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "GuidedMeditationViewController.h"
#import "MeditationIntroDetailViewController.h"
#import "NookUsingSoundViewControllerOne.h"
#import "ScheduleViewController.h"
#import "NookMGM.h"
#import "SkillRatingsViewController.h"
#import "AudioPlayerTwoViewController.h"
#import "NewPlanAddedViewController.h"
#import <EventKitUI/EventKitUI.h>
#import "DBManager.h"


#import "SwiperViewController.h"
#import "IntroPageInfo.h"

@interface GuidedMeditationViewController ()<ScheduleViewControllerDelegate>
{NSArray *remindersArray;
    NSString* CalenderEventID;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation GuidedMeditationViewController

-(void)didTapDelete:(id)sender
{
    [self DeleteReminder:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view.
    
    self.exercises = @[@"Progressive Muscle Relaxation", @"Passive Muscle Relaxation", @"Body Scan", @"Mountain Stream Strategy", @"Mindful Breathing"];
    
    self.manager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
}

-(NSString *)planText
{
    return [NSString stringWithFormat:@"Plan for %@ ",[PersistenceStorage getObjectForKey:@"planName"]];
}

-(NSString *)activityText{
    
    return [PersistenceStorage getObjectForKey:@"skillName"];
}



-(void)popToSkillsView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
     [self RefreshScheduleData];
 
    [self.scrollView setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.scrollView setContentSize:CGSizeMake(320,800)];
    if ([[PersistenceStorage getObjectForKey:@"Referer"] isEqualToString:@"AudioPlayerTwoViewController"]) {
        SkillRatingsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"SkillRatingsViewController"];
        [self.navigationController presentModalViewController:ratingsView animated:YES];
    }
    
    if ([[PersistenceStorage getObjectForKey:@"Referer"] isEqualToString:@"SkillRatingsViewController"])
    {
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
    if  ([buttonTitle isEqualToString:@"Repeat This Skill"]) {
        [PersistenceStorage setObject:buttonTitle andKey:@"optionName"];
        [PersistenceStorage setObject:nil andKey:@"skillDetail1"];
        [self writeClickedNextSteps];
        
    }
    if ([buttonTitle isEqualToString:@"Learn About This Skill"]) {
        [PersistenceStorage setObject:buttonTitle andKey:@"optionName"];
        [PersistenceStorage setObject:nil andKey:@"skillDetail1"];
        [self writeClickedNextSteps];
        
        
        NookMGM *samplerView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookMGM"];
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
        
    }
    
    
    
    if ([buttonTitle isEqualToString:@"Schedule Skill Reminder"]) {
        UILabel *label = (UILabel *)[self.view viewWithTag:333];
        NSString *query = [NSString stringWithFormat: @"select * from MySkillReminders where SkillName = 'Guided Meditation' and PlanName = '%@'",[Utils getValidSqlString:[PersistenceStorage getObjectForKey:@"planName"]]];
        
        self.manager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
        
        NSArray *reminders = [[NSArray alloc] initWithArray:[self.manager loadDataFromDB:query]];
        
        NSDate *inputDate = nil;
        NSString *repeatText = nil;
        
        if(reminders.count > 0)
        {
            NSDictionary *item = [reminders firstObject];
            
            NSString *date = [item objectForKey:@"ScheduledDate"];
            
            NSArray  *compo = [date componentsSeparatedByString:@"\n"];
            
            if(compo.count > 1){
                date = [compo firstObject];
                repeatText = [compo lastObject];
            }
            
            inputDate = [Utils dateWithString:date inFormat:@"hh:mm a, MM/dd/yy"];
            
            
            [PersistenceStorage setObject:@"Yes" andKey:@"showCancelActivityButton"];
        }
        else{
            
            [PersistenceStorage setObject:@"No" andKey:@"showCancelActivityButton"];
        }
        
        
        [PersistenceStorage setObject:nil andKey:@"skillDetail1"];
        
        [self writeClickedNextSteps];
        
        ScheduleViewController *svc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ScheduleViewController"];
        svc.delegate= self;
        svc.inputDate = inputDate;
        
        svc.activityText = @"Try Guided Meditation";
        
        svc.repeatText = repeatText;
        [self.navigationController pushViewController:svc animated:YES];
    }
    

}

-(IBAction)viewIntroductionAgainClicked:(id)sender{
    
    [self writeViewedIntroduction];
    
    NSMutableArray *pageInfos = [NSMutableArray array];
    
    IntroPageInfo *info = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro4image1.png"] title: @"What is \"Guided Meditation\"?" description:@"In Guided Meditation, a voice leads you through ways to relax your body and mind. You can choose from five different exercises."];
    
    [pageInfos addObject:info];
    
    IntroPageInfo *info2 = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro4image2.png"] title: @"What will I be doing in these exercises?" description:G_M_INTRO_PAGE_2];
    
    [pageInfos addObject:info2];
    
    SwiperViewController *swiper = [[SwiperViewController alloc]init];
    
    swiper.pageInfos = pageInfos;
    
    swiper.header = @"Welcome to Guided Meditation";
    
    [self.navigationController pushViewController:swiper animated:YES];
    
}


-(IBAction)learnMoreClicked:(id)sender{
    NookMGM *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookMGM"];
    [self.navigationController pushViewController:siv animated:YES];
    
}

- (IBAction)PlayAudioTwo:(id)sender {
    
    AudioPlayerTwoViewController *audioPanning = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AudioPlayerTwoViewController"];
    audioPanning.url = @"2PassiveMuscleRelaxation.mp3";
    audioPanning.name = @"Passive Muscle Relaxation";
    audioPanning.panning = audio;
    [PersistenceStorage setObject:@"Passive Muscle Relaxation" andKey:@"skillDetail1"];

    [self.navigationController presentModalViewController:audioPanning animated:YES];

}

- (IBAction)PlayAudioOne:(id)sender {
    
    AudioPlayerTwoViewController *audioPanning = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AudioPlayerTwoViewController"];
    audioPanning.url = @"1ProgressiveMuscleRelaxation.mp3";
    audioPanning.name = @"Progressive Muscle Relaxation";
    audioPanning.panning = audio;
    [PersistenceStorage setObject:@"Progressive Muscle Relaxation" andKey:@"skillDetail1"];

    [self.navigationController presentModalViewController:audioPanning animated:YES];
}


- (IBAction)PlayAudioThree:(id)sender {
    
    AudioPlayerTwoViewController *audioPanning = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AudioPlayerTwoViewController"];
    audioPanning.url = @"3BodyScan.mp3";
    audioPanning.name = @"Body Scan";
    audioPanning.panning = audio;
    [PersistenceStorage setObject:@"Body Scan" andKey:@"skillDetail1"];

    
    [self.navigationController presentModalViewController:audioPanning animated:YES];
}


- (IBAction)PlayAudioFour:(id)sender {
    
    AudioPlayerTwoViewController *audioPanning = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AudioPlayerTwoViewController"];
    audioPanning.url = @"4MountainStreamImagery.mp3";
    audioPanning.name = @"Mountain Stream Imagery";
    audioPanning.panning = audio;
    [PersistenceStorage setObject:@"Mountain Stream Imagery" andKey:@"skillDetail1"];
    
    [self.navigationController presentModalViewController:audioPanning animated:YES];
}


- (IBAction)PlayAudioFive:(id)sender {
    
    AudioPlayerTwoViewController *audioPanning = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AudioPlayerTwoViewController"];
    audioPanning.url = @"5MindfulBreathing.mp3";
    audioPanning.name = @"Mindful Breathing";
    audioPanning.panning = audio;
    [PersistenceStorage setObject:@"Mindful Breathing" andKey:@"skillDetail1"];
    
    
    [self.navigationController presentModalViewController:audioPanning animated:YES];
}




-(void)RefreshScheduleData
{
    NSString *query = [NSString stringWithFormat: @"select * from MySkillReminders where SkillName = 'Guided Meditation' and PlanName = '%@'",[Utils getValidSqlString:[PersistenceStorage getObjectForKey:@"planName"]]];
    
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
    
    favc.activityText = @"Try Guided Meditation";
    favc.delegate = self;
    [self.navigationController pushViewController:favc animated:YES];
}




- (IBAction)DeleteReminder:(id)sender {
    NSString *queryClear = [NSString stringWithFormat:@"delete from MySkillReminders where SkillName = 'Guided Meditation' and PlanName = '%@'",[Utils getValidSqlString:[PersistenceStorage getObjectForKey:@"planName"]]];
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
    NSString* reminderQuery = [NSString stringWithFormat:@"select CalendarEventID from MySkillReminders where SkillName = \"%@\" and  PlanName = '%@'",[PersistenceStorage getObjectForKey:@"skillName"],[Utils getValidSqlString:[PersistenceStorage getObjectForKey:@"planName"]]];
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
