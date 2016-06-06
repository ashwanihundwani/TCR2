//
//  SkillDetailViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 3/22/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "PleasantSkillDetailViewController.h"
#import "PleasantIntroDetailViewController.h"
#import "NookPA.h"
#import "MBProgressHUD.h"

#import "SwiperViewController.h"
#import "IntroPageInfo.h"


@interface PleasantSkillDetailViewController ()

@property (nonatomic, strong) DBManager *dbManagerMySkills;

@end

@implementation PleasantSkillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.skillDict valueForKey:@"skillName"];
    if (![[PersistenceStorage getObjectForKey:@"shownPleasantIntro"] isEqual: @"OK"])
    {
        NSMutableArray *pageInfos = [NSMutableArray array];
        
        IntroPageInfo *info = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro5image1.png"] title: P_A_PAGE1_TITLE description:@"Working and doing chores are important. It is also important to do some things just because you enjoy them. Pleasant activities are activities you enjoy."];
        
        [pageInfos addObject:info];
        
        IntroPageInfo *info2 = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro5image2.png"] title: @"How can \"Pleasant Activities\" help me?" description:P_A_INTRO_PAGE2];
        
        [pageInfos addObject:info2];
        
        IntroPageInfo *info3 = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro5image3.png"] title: P_A_PAGE3_TITLE description:P_A_INTRO_PAGE3];
        
        [pageInfos addObject:info3];
        
        SwiperViewController *swiper = [[SwiperViewController alloc]init];
        
        swiper.pageInfos = pageInfos;
        
        swiper.header = @"Welcome to Pleasant Activities";
        
        [self.navigationController pushViewController:swiper animated:YES];
        
    }
    
    [PersistenceStorage setObject:@"OK" andKey:@"shownPleasantIntro"];
    

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
    
    IntroPageInfo *info = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro5image1.png"] title: P_A_PAGE1_TITLE description:@"Working and doing chores are important. It is also important to do some things just because you enjoy them. Pleasant activities are activities you enjoy."];
    
    [pageInfos addObject:info];
    
    IntroPageInfo *info2 = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro5image2.png"] title: @"How can \"Pleasant Activities\" help me?" description:P_A_INTRO_PAGE2];
    
    [pageInfos addObject:info2];
    
    IntroPageInfo *info3 = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro5image3.png"] title: P_A_PAGE3_TITLE description:P_A_INTRO_PAGE3];
    
    [pageInfos addObject:info3];
    
    SwiperViewController *swiper = [[SwiperViewController alloc]init];
    
    swiper.pageInfos = pageInfos;
    
    swiper.header = @"Welcome to Pleasant Activities";
    
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
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,@"Added Skill",[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"sitName"],self.title,nil,nil,nil,nil,nil,nil,nil,nil];
    
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
