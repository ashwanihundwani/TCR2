//
//  SkillDetailViewController.m
//  TinnitusCoach
//
//  Created by Vikram Singh on 3/22/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "TipsSkillDetailViewController.h"
#import "TipsIntroDetailViewController.h"
#import "NookTBS.h"
#import "MBProgressHUD.h"

#import "SwiperViewController.h"
#import "IntroPageInfo.h"


@interface TipsSkillDetailViewController ()

@property (nonatomic, strong) DBManager *dbManagerMySkills;

@end

@implementation TipsSkillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.skillDict valueForKey:@"skillName"];
    // Do any additional setup after loading the view.
    
    if (![[PersistenceStorage getObjectForKey:@"shownTipsIntro"] isEqual: @"OK"])
        
    {
        
        
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
    
    [PersistenceStorage setObject:@"OK" andKey:@"shownTipsIntro"];
    
    
    

    
    
    
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
    
    IntroPageInfo *info = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro7image1.png"] title: @"How can \"Tips for Better Sleep\" help me cope with my Tinnitus?" description:@"Your tinnitus may seem worse when you are tired. When you get enough sleep, you are ready to handle problems, and you won’t get frustrated as easily. A good night’s sleep will give you energy to practice skills from this app."];
    
    [pageInfos addObject:info];
    
    IntroPageInfo *info2 = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro7image2.png"] title: @"What does \"Tips for Better Sleep\" involve?" description:@"Tips for Better Sleep is a list of things you can try to improve your sleep. You can select the tips you want to use and set a reminder. "];
    
    [pageInfos addObject:info2];
    
    SwiperViewController *swiper = [[SwiperViewController alloc]init];
    
    swiper.pageInfos = pageInfos;
    
    swiper.header = @"Welcome to Sleep Tips";
    
    [self.navigationController pushViewController:swiper animated:YES];
    
    /*
    TipsIntroDetailViewController *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TipsIntroDetailViewController"];
    [self.navigationController pushViewController:siv animated:YES];
     */

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

-(IBAction)addSkillToPlan:(id)sender
{
    [self writeToMySkills];
    [self performSelector:@selector(navigateBacktoPlan) withObject:nil afterDelay:1.2];
    
}

-(void)navigateBacktoPlan{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3] animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)writeAddedSkill{
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


@end
