//
//  ImageryViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 18/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "ImageryViewController.h"
#import "NookImg.h"

#import "ImageryTimerViewController.h"
#import "ScheduleViewController.h"
#import "SkillRatingsViewController.h"
#import "ImageryIntroDetailViewController.h"
#import "AudioPanningViewController.h"
#import "VideoPlayerViewController.h"
#import "HomeViewController.h"
#import "MBProgressHUD.h"
#import "FavoritesViewController.h"
#import "ValueAndActivitiesViewController.h"
#import "DBManager.h"
#import "NookUsingSoundViewControllerOne.h"
#import "NewPlanAddedViewController.h"

#import "CoundownTimerViewController.h"

#import <EventKit/EventKit.h>

#import "SwiperViewController.h"
#import "IntroPageInfo.h"


@interface ImageryViewController ()<UITableViewDataSource,UITableViewDelegate, ScheduleViewControllerDelegate>{
    NSArray *paArray;
NSArray *remindersArray;
    NSString* CalenderEventID;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ImageryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.exercises = @[@"Video Introduction", @"Video lessons", @"Timer for Practice"];
    
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
//   // titleLabel.text = @"Add New Plan";
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
    
    //UILabel *backLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 20)];
    
//    backLabel.text = @"Cancel";
    
 //   pallete = [Utils getColorFontPair:eCFS_PALLETE_3];
    
    //backLabel.font = pallete.secondObj;
  //  backLabel.textColor = pallete.firstObj;
    
//    [Utils addTapGestureToView:backLabel target:self
//                      selector:@selector(cancel)];
//    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backLabel];
//    
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
//                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                       target:nil action:nil];
//    negativeSpacer.width = -8;
//    
//    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, item, nil];
    
    
    self.manager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    
  
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
       
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
    
    
    
-(void)viewDidAppear:(BOOL)animated
{
    
    [self RefreshScheduleData];
    [self.scrollView setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.scrollView setContentSize:CGSizeMake(320,690)];
    
    
  //  SkillRatingsViewController
    
    
    NSLog([PersistenceStorage getObjectForKey:@"Referer"]);
    
    if ([[PersistenceStorage getObjectForKey:@"Referer"] isEqual: @"Timer"]) {
        SkillRatingsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"SkillRatingsViewController"];
        
        //ratingsView.skillSection = @"Sounds";
        //  ratingsView.skillDetail = self.name;
        
        //[self.navigationController pushViewController:ratingsView animated:YES];
        [self.navigationController presentModalViewController:ratingsView animated:YES];
    }
    
    
    if ([[PersistenceStorage getObjectForKey:@"Referer"] isEqual: @"VideoPlayerViewController"]) {
        SkillRatingsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"SkillRatingsViewController"];
        
        //ratingsView.skillSection = @"Sounds";
        //  ratingsView.skillDetail = self.name;
        
        //[self.navigationController pushViewController:ratingsView animated:YES];
        [self.navigationController presentModalViewController:ratingsView animated:YES];
    }
    
    
    
    
    
    if ([[PersistenceStorage getObjectForKey:@"Referer"] isEqual:@"SkillRatingsViewController"]) {
        NSString *actionSheetTitle = @"Where would you like to go now?"; //Action Sheet Title
         NSString *other00 = @"Schedule Skill Reminder";
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

-(void)didTapDelete:(id)sender
{
    [self DeleteReminder:self];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    //   NSString * theValue = [(UILabel*)[self viewWithTag:t200] text];
    
  //  [PersistenceStorage setObject:nil andKey:@"skillDetail1"];

    
    
    if  ([buttonTitle isEqualToString:@"Repeat This Skill"]) {
        
        [PersistenceStorage setObject:nil andKey:@"skillDetail1"];

        [PersistenceStorage setObject:buttonTitle andKey:@"optionName"];
        
        [self writeClickedNextSteps];
        
        
        
        
        
    }
    if ([buttonTitle isEqualToString:@"Learn About This Skill"]) {
        [PersistenceStorage setObject:nil andKey:@"skillDetail1"];

        [PersistenceStorage setObject:buttonTitle andKey:@"optionName"];
        
        [self writeClickedNextSteps];
        

        NookImg *samplerView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookImg"];
        [self.navigationController pushViewController:samplerView animated:NO];
    }
    
    
    if ([buttonTitle isEqualToString:@"Try Another Skill"]) {
        [PersistenceStorage setObject:buttonTitle andKey:@"optionName"];
        [PersistenceStorage setObject:nil andKey:@"skillDetail1"];

        [self writeClickedNextSteps];
        

        NewPlanAddedViewController *samplerView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NewPlanAddedViewController"];
        [self.navigationController pushViewController:samplerView animated:YES];

        
    }
    
    if ([buttonTitle isEqualToString:@"Return Home"]) {
        [PersistenceStorage setObject:nil andKey:@"skillDetail1"];

        [PersistenceStorage setObject:buttonTitle andKey:@"optionName"];
        
        [self writeClickedNextSteps];
        

        [[self tabBarController] setSelectedIndex:0];
        
    }
    
    
    
    if ([buttonTitle isEqualToString:@"Do Activity Now"]) {
        
        [PersistenceStorage setObject:buttonTitle andKey:@"optionName"];
        
        [self writeClickedNextSteps];
        

        
        //DoingActivityViewController *svc1 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"DoingActivityViewController"];
        //[self.navigationController pushViewController:svc1 animated:YES];
        
        //    [self.navigationController presentModalViewController:svc1 animated:NO];
    }
    
    
    
    if ([buttonTitle isEqualToString:@"Schedule Skill Reminder"]) {
        
        [PersistenceStorage setObject:buttonTitle andKey:@"optionName"];
        
        UILabel *label = (UILabel *)[self.view viewWithTag:333];
        //        if (![label.text isEqualToString:@"No reminders"])
        //        {
        //        }
        //
        //        else
        //        {
        //
        
        NSString *query = [NSString stringWithFormat: @"select * from MySkillReminders where SkillName = 'Imagery' and PlanName = \'%@\'",[PersistenceStorage getObjectForKey:@"planName"]];
        
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

//        UILabel *label = (UILabel *)[self.view viewWithTag:333];
//        if (![label.text isEqualToString:@"No reminders"])
//        {
//        }
        
//        else
//        {
        [self writeClickedNextSteps];
        

        
        ScheduleViewController *svc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ScheduleViewController"];
        
        svc.activityText = @"Try Imagery";
        
            svc.delegate = self;
        
        svc.repeatText = repeatText;
        svc.inputDate = inputDate;
        
        [self.navigationController pushViewController:svc animated:YES];
        //}
    }
    
    
    
    
    
    
    
    
}
    
-(void)viewDidDisappear:(BOOL)animated
{
 }


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



/*-(IBAction)viewIntroductionAgainClicked:(id)sender{
    ImageryIntroDetailViewController *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ImageryIntroDetailViewController"];
    [self.navigationController pushViewController:siv animated:YES];
    
}
*/



- (IBAction)BreathingTimer:(id)sender {

    CountdownTimerViewController *guided = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                            
                                            instantiateViewControllerWithIdentifier:@"CountdownTimerViewController"];
    
    guided.header = @"Imagery Timer";
    
    guided.image = [UIImage imageNamed:@"2DeepBreathing.png"];
    
    [self.navigationController presentModalViewController:guided animated:YES];

    
}




-(IBAction)viewIntroductionAgainClicked:(id)sender{

    [self writeViewedIntroduction];
    
    /*
    ImageryIntroDetailViewController *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ImageryIntroDetailViewController"];
    [self.navigationController pushViewController:siv animated:YES];
     */
    
    NSMutableArray *pageInfos = [NSMutableArray array];
    
    IntroPageInfo *info = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro3image1.png"] title: @"Why is \"Imagery\" helpful?" description:@"Imagery is imagining a calm and peaceful place. Imagining the sights, sounds, and smells of the place can help you relax. You can combine Imagery with Deep Breathing  to feel even more relaxed."];
    
    [pageInfos addObject:info];
    
    IntroPageInfo *info2 = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro3image2.png"] title: @"How can  \"Imagery\" help me with my tinnitus?" description:@"Imagery can reduce the tension and stress caused by tinnitus. Using imagery won’t change your tinnitus, but it can help you relax. Being relaxed can help you cope with your tinnitus. "];
    
    [pageInfos addObject:info2];
    IntroPageInfo *info3 = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro3image3.png"] title: @"How do I do \"Imagery\"?" description:@"A video will show you how to do Imagery. After you watch the video you will have access to a timer that will help you practice on your own. "];
    
    [pageInfos addObject:info3];
    
    SwiperViewController *swiper = [[SwiperViewController alloc]init];
    
    swiper.pageInfos = pageInfos;
    
    swiper.header = @"Welcome to Imagery";
    
    [self.navigationController pushViewController:swiper animated:YES];
    
}

-(IBAction)learnMoreClicked:(id)sender{
         NookImg *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookImg"];
        [self.navigationController pushViewController:siv animated:YES];

    }


- (IBAction)PlayAudiowwOne:(id)sender {
 
AudioPanningViewController *audioPanning = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AudioPanningViewController"];
audioPanning.url = @"frog.mp3";
audioPanning.name = @"Something";
audioPanning.panning = audio;

[self.navigationController pushViewController:audioPanning animated:YES];
}


- (IBAction)PlayVideoTwo:(id)sender {
    
    VideoPlayerViewController *audioPanning = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
audioPanning.panning = video;
audioPanning.videoURL = @"ImageryLesson.mp4";
    [PersistenceStorage setObject:@"Video Lesson" andKey:@"skillDetail1"];

    
    
    
[self.navigationController presentModalViewController:audioPanning animated:NO];}



- (IBAction)PlayVideoOne:(id)sender {
    
    VideoPlayerViewController *audioPanning = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
    audioPanning.panning = video;
    audioPanning.videoURL = @"imagery.mp4";
    [PersistenceStorage setObject:@"Watched Video Introduction" andKey:@"skillDetail1"];

    [self.navigationController presentModalViewController:audioPanning animated:NO];
    
}







-(void)RefreshScheduleData
{
   // NSString *query = [NSString stringWithFormat:@"select * from MySkillReminders where SkillName = 'Imagery'"];
    

    NSString *query = [NSString stringWithFormat:@"select * from MySkillReminders where SkillName = 'Imagery' and PlanName = '%@'",[PersistenceStorage getObjectForKey:@"planName"]];

    
    self.manager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    remindersArray = [[NSArray alloc] initWithArray:[self.manager loadDataFromDB:query]];
    UILabel *label = (UILabel *)[self.view viewWithTag:333];
    UIButton *btnLabel1 = (UIButton *)[self.view viewWithTag:334];
    UIButton *btnLabel2 = (UIButton *)[self.view viewWithTag:335];
        NSLog(@"REMIDBERS ARRY IMAGERY %@",remindersArray);
    [[self.view viewWithTag:3] setHidden:YES];
    
    
    if (![[PersistenceStorage getObjectForKey:@"shownImageryIntro"] isEqual: @"OK"])
        
    {
        
        //  [self viewIntroductionAgainClicked];
        
        ImageryIntroDetailViewController *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ImageryIntroDetailViewController"];
        [self.navigationController pushViewController:siv animated:YES];
        
    }
    
    [PersistenceStorage setObject:@"OK" andKey:@"shownImageryIntro"];
    
    
    
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
    
    favc.activityText = @"Try Imagery";
    favc.delegate = self;
    [self.navigationController pushViewController:favc animated:YES];
}




- (IBAction)DeleteReminder:(id)sender {
    NSString *queryClear = [NSString stringWithFormat:@"delete from MySkillReminders where SkillName = 'Imagery' and PlanName = '%@'",[PersistenceStorage getObjectForKey:@"planName"]];
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