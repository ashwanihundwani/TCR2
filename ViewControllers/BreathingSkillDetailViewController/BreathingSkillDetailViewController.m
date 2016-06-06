//
//  SkillDetailViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 3/22/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "BreathingIntroDetailViewController.h"
#import "BreathingSkillDetailViewController.h"
#import "NookDB.h"
#import "MBProgressHUD.h"

#import "SwiperViewController.h"
#import "IntroPageInfo.h"


@interface BreathingSkillDetailViewController ()

@property (nonatomic, strong) DBManager *dbManagerMySkills;

@end

@implementation BreathingSkillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.skillDict valueForKey:@"skillName"];
    if (![[PersistenceStorage getObjectForKey:@"shownBreathingIntro"] isEqual: @"OK"])
    {
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
    
    [PersistenceStorage setObject:@"OK" andKey:@"shownBreathingIntro"];

  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

-(IBAction)viewIntroductionAgainClicked:(id)sender{
    
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

-(void)writeToMySkills
{
    self.dbManagerMySkills = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    
    NSString *query = [NSString stringWithFormat:@"insert into MySkills ('planID', 'groupID', 'skillID', 'timeStamp') values ('%@', '%@', '%@', '%@')",[PersistenceStorage getObjectForKey:@"currentPlanID"], [self.skillDict valueForKey:@"groupID"], [self.skillDict valueForKey:@"ID"], [NSDate date]];
    
    BOOL isDone = [self.dbManagerMySkills executeQuery:query];
    if (isDone == YES)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"] ];
        
        hud.mode = MBProgressHUDModeCustomView;
        
        hud.labelText = @"Added Skill";
        
        [hud show:YES];
        [hud hide:YES afterDelay:1];
    }
    else{
        NSLog(@"Error");
    }
    [self writeAddedSkill];
    
}




-(void)writeAddedSkill{
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
    NSString *type = @"Plan";
    
    NSString *str = @"Modified Plan";
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,@"Added Skill",[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"situationName"],self.title,nil,nil,nil,nil,nil,nil,nil,nil];
    
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




-(IBAction)addSkillToPlan:(id)sender
{
    [self writeToMySkills];
    [self performSelector:@selector(navigateBacktoPlan) withObject:nil afterDelay:1.2];
    
}

-(void)navigateBacktoPlan{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3] animated:YES];
}

@end
