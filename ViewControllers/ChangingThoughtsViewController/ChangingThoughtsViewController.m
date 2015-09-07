//
//  GuidedMeditationViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 18/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//
#import "CTFPrevEntries.h"
#import "ChangingThoughtsViewController.h"
#import "ThoughtsIntroDetailViewController.h"
#import "NookUsingSoundViewControllerOne.h"
#import "CTF01.h"
#import "SkillRatingsViewController.h"
#import "NookCTF.h"
 #import "DBManager.h"
#import "NewPlanAddedViewController.h"
#import "SwiperViewController.h"
#import "IntroPageInfo.h"


@interface ChangingThoughtsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong)DBManager *dbManager;

@end

@implementation ChangingThoughtsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.thoughtsAndFeelings = @[@"Add New Entry", @"Previous Entries"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    /*
 
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
    
    
    
    
    UIImageView *backLabel = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 15, 20)];
    
    backLabel.image = [UIImage imageNamed:@"Active_Back-Arrow.png"];
    
    [Utils addTapGestureToView:backLabel target:self
                      selector:@selector(popToSkillsView)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backLabel];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -8;
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, item, nil];
    
    */
    
    
    
    
    
    self.dbManager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    
    
    
    
    
// Do any additional setup after loading the view.
}



-(void)popToSkillsView
{
    [self.navigationController popViewControllerAnimated:YES];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    if(self.tabBarController.tabBar.hidden)
        [self.tabBarController.tabBar setHidden:NO];

}

-(void)viewDidAppear:(BOOL)animated
{
    
    NSLog(@"%@",[PersistenceStorage getObjectForKey:@"planName"]);

    
    [self.scrollView setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.scrollView setContentSize:CGSizeMake(320,550)];
    
    
    [PersistenceStorage setObject:[PersistenceStorage getObjectForKey:@"ctf01text"] andKey:@"ctf01textRating"];
    [PersistenceStorage setObject:[PersistenceStorage getObjectForKey:@"ctf02text"] andKey:@"ctf02textRating"];
    [PersistenceStorage setObject:[PersistenceStorage getObjectForKey:@"ctf03text"] andKey:@"ctf03textRating"];
    [PersistenceStorage setObject:[PersistenceStorage getObjectForKey:@"ctf04text"] andKey:@"ctf04textRating"];
    [PersistenceStorage setObject:[PersistenceStorage getObjectForKey:@"ctf05text"] andKey:@"ctf05textRating"];
    [PersistenceStorage setObject:[PersistenceStorage getObjectForKey:@"ctf06text"] andKey:@"ctf06textRating"];
    
    
    if ([[PersistenceStorage getObjectForKey:@"Referer"] isEqual: @"CTF"]) {
        SkillRatingsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"SkillRatingsViewController"];
        
        //ratingsView.skillSection = @"Sounds";
        //  ratingsView.skillDetail = self.name;
        
        //[self.navigationController pushViewController:ratingsView animated:YES];
        [self.navigationController presentModalViewController:ratingsView animated:YES];
    }
    
    
    
    
    
    if ([[PersistenceStorage getObjectForKey:@"Referer"] isEqual: @"SkillRatingsViewController"]) {
        NSString *actionSheetTitle = @"Where would you like to go now?"; //Action Sheet Title
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
                                      otherButtonTitles:other0, other1, other2, other3, nil];
        
        [actionSheet showInView:self.view];
        
        
        
        
        [PersistenceStorage setObject:@"OK" andKey:@"Referer"];
        
    }
    

    
    
    
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    
    [PersistenceStorage setObject:@"" andKey:@"ctf01text"];
    [PersistenceStorage setObject:@"" andKey:@"ctf02text"];
    [PersistenceStorage setObject:@"" andKey:@"ctf03text"];
    [PersistenceStorage setObject:@"" andKey:@"ctf04text"];
    [PersistenceStorage setObject:@"" andKey:@"ctf05text"];
    [PersistenceStorage setObject:@"" andKey:@"ctf06text"];
    
    
 
    
    
    
}



-(void)goToSkillsHome
{

    NewPlanAddedViewController *npav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NewPlanAddedViewController"];
    
    
    [self.navigationController pushViewController:npav animated:NO];

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    //   NSString * theValue = [(UILabel*)[self viewWithTag:t200] text];
    
    
    
    
    if  ([buttonTitle isEqualToString:@"Repeat This Skill"]) {
        
        //     PleasantActivityViewController *pa = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"PleasantActivityViewController"];
        //   audioPanning.url = [dict valueForKey:@"soundURL"];
        // audioPanning.name = [dict valueForKey:@"soundName"];
        // audioPanning.panning = audio;
        
        //     [self.navigationController pushViewController:pa animated:YES];
        
        //       [self.navigationController presentModalViewController:audioPanning animated:NO];
        
        
        
        
        
    }
    if ([buttonTitle isEqualToString:@"Learn About This Skill"]) {
        NookCTF *samplerView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookCTF"];
        [self.navigationController pushViewController:samplerView animated:NO];
    }
    
    
    if ([buttonTitle isEqualToString:@"Try Another Skill"]) {
        NewPlanAddedViewController *samplerView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NewPlanAddedViewController"];
        [self.navigationController pushViewController:samplerView animated:YES];
        
    }
    
    if ([buttonTitle isEqualToString:@"Return Home"]) {
        [[self tabBarController] setSelectedIndex:0];
        
    }
    
    
    
    
    
    
    
    
    
    
}




-(IBAction)viewIntroductionAgainClicked:(id)sender{
    
    [self writeViewedIntroduction];
    
    NSMutableArray *pageInfos = [NSMutableArray array];
    
    IntroPageInfo *info = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro6image1.png"] title: @"What is \"Changing Thoughts and Feelings\" ?" description:@"Changing your thoughts can change how you feel. With this skill you learn common \"thought errors\" and how to correct them to feel better."];
    
    [pageInfos addObject:info];
    
    IntroPageInfo *info2 = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro6image2.png"] title: @"What are \"thought errors\" ?" description:@"Thoughts that are not helpful or unhealthy are called \"thought errors.\" Many people make thought errors that cause them to feel sad or upset. If you are aware of the most common thought errors, you can catch yourself and correct your thinking."];
    
    [pageInfos addObject:info2];
    
    IntroPageInfo *info3 = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro6image3.png"] title: @"How do thoughts affect my feelings?" description:@"Different thoughts about the same situation lead to different feelings. Imagine you are expecting guests for dinner, and they are late. If you think “it’s rude to be late,” then you might get angry. If you think “they could have been in an accident,” you might be worried."];
    
    [pageInfos addObject:info3];
    
    IntroPageInfo *info4 = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro6image4.png"] title: @"How can I change my negative feelings?" description:@"You may not be able to change events in your life, or your tinnitus. However, the way you think about events is under your control. Change your thoughts, and your feelings will change too. With this skill, you will learn aa step-by-step approach to changing thoughts."];
    
    [pageInfos addObject:info4];
    
    SwiperViewController *swiper = [[SwiperViewController alloc]init];
    
    swiper.pageInfos = pageInfos;
    
    swiper.header = @"Welcome to Changing Thoughts";
    
    [self.navigationController pushViewController:swiper animated:YES];
    
    /*
    ThoughtsIntroDetailViewController *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ThoughtsIntroDetailViewController"];
    [self.navigationController pushViewController:siv animated:YES];
     */
    
}

-(IBAction)learnMoreClicked:(id)sender{
    NookCTF *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookCTF"];
    [self.navigationController pushViewController:siv animated:YES];
    
}


- (IBAction)viewEntriesClicked:(id)sender {
    CTFPrevEntries *guided = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                              
                              instantiateViewControllerWithIdentifier:@"CTFPrevEntries"];
    [self.navigationController pushViewController:guided animated:YES];
}



-(IBAction)newEntryClicked:(id)sender{
    
    
    NSString *deleteQquery = [NSString stringWithFormat:@"delete from My_TF"];
    
    
    // Execute the query.
    [self.dbManager executeQuery:deleteQquery];
    
    CTF01 *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CTF01"];
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



@end
