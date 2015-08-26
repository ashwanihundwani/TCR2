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

@interface GuidedMeditationViewController ()
{NSArray *remindersArray;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) DBManager *manager;

@end

@implementation GuidedMeditationViewController

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
    
    
    
    
    
    // Do any additional setup after loading the view.
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
        
        //ratingsView.skillSection = @"Sounds";
        //  ratingsView.skillDetail = self.name;
        
        //[self.navigationController pushViewController:ratingsView animated:YES];
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
    
    
    
    
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    //   NSString * theValue = [(UILabel*)[self viewWithTag:t200] text];
    
 
    
    
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
        {  [PersistenceStorage setObject:nil andKey:@"skillDetail1"];
        
        [self writeClickedNextSteps];
        
   ScheduleViewController *svc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ScheduleViewController"];
        //     svc.name = strAct;
        [self.navigationController pushViewController:svc animated:YES];
        }
    }
    
    
    
    
    
    
    
    
}

-(IBAction)viewIntroductionAgainClicked:(id)sender{
    
    [self writeViewedIntroduction];
    
    /*
    MeditationIntroDetailViewController *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"MeditationIntroDetailViewController"];
    [self.navigationController pushViewController:siv animated:YES];
     */
    
    NSMutableArray *pageInfos = [NSMutableArray array];
    
    IntroPageInfo *info = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro4image1.png"] title: @"What is \"Guided Meditation\"?" description:@"In Guided Meditation, a voice leads you through ways to relax your body and mind. You can choose from five different exercises."];
    
    [pageInfos addObject:info];
    
    IntroPageInfo *info2 = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro4image2.png"] title: @"What will I be doing in these exercises?" description:@"For three of these exercises you will focus on relaxing different parts of the body where you feel stress. The other two exercises focus on 'mindfulness'. Mindfulness means paying attention to the present moment."];
    
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

    
//    [self.navigationController pushViewController:audioPanning animated:YES];
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
    NSString *query = [NSString stringWithFormat:@"select * from MySkillReminders where SkillName = 'Guided Meditation'"];
    
    
    
    
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
    
    NSString *query = [NSString stringWithFormat: @"select * from MySkillReminders where SkillName = 'Guided Meditation'"];
    
    
    self.manager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    remindersArray = [[NSArray alloc] initWithArray:[self.manager loadDataFromDB:query]];
    
    
    if ([remindersArray count]== 1) {
        
        
        NSDictionary *dict = [remindersArray objectAtIndex:0];
        NSString *strAct = [dict valueForKey:@"CalendarEventID"];
        [PersistenceStorage setObject:strAct andKey:@"EventID"];
    }
    
    NSString *query1 = [NSString stringWithFormat:@"delete from MySkillReminders where SkillName = 'Guided Meditation'"];
    
    [self.manager executeQuery:query1];
    
    
    
    //clear reminder
    
    
    NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSLog(@"notify array %@",notificationArray);
    
    for(UILocalNotification *notification in notificationArray){
        if ([notification.alertBody containsString:@"'Guided Meditation'"]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification] ;
        }
        
        
    }
    
    
    
    
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



@end
