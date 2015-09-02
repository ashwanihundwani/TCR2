//
//  SkillDetailViewController.m
//  TinnitusCoach
//
//  Created by Vikram Singh on 3/22/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "SoundSkillDetailViewController.h"
#import "SoundIntroDetailViewController.h"
#import "NookUS.h"
#import "MBProgressHUD.h"


#import "SwiperViewController.h"
#import "IntroPageInfo.h"

@interface SoundSkillDetailViewController ()

@property (nonatomic, strong) DBManager *dbManagerMySkills;

@end

@implementation SoundSkillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.skillDict valueForKey:@"skillName"];

    if (![[PersistenceStorage getObjectForKey:@"shownSoundIntro"] isEqual: @"OK"])
        
    {
        
        
        NSMutableArray *pageInfos = [NSMutableArray array];
        
        {
            IntroPageInfo *info = [[IntroPageInfo alloc]init];
            
            info.title = USING_SOUND_INTRO_PAGE_TITLE_1;
            info.descriptionText = USING_SOUND_INTRO_PAGE_1;
            info.image = [UIImage imageNamed:@"Intro1image1.png"];
            
            [pageInfos addObject:info];
        }
        {
            IntroPageInfo *info = [[IntroPageInfo alloc]init];
            
            info.title = @"What can I expect from \"Using Sound\"?";
            info.descriptionText = @"Using sound when your tinnitus is bothering you will not change your tinnitus in any way. It can however have a big impact on how you feel.  As you experiment with sound, pay close attention to how each sound affects how you feel. Keep experimenting until you find sounds that are helpful.";
            info.image = [UIImage imageNamed:@"Intro1image2.png"];
            
            [pageInfos addObject:info];
        }
        {
            IntroPageInfo *info = [[IntroPageInfo alloc]init];
            
            info.title = @"What is special about \"Using Sound\"?";
            info.descriptionText = @"The sources of sounds that can be used for tinnitus are almost endless. Where does one even start? Tinnitus Coach contains sounds that are helpful for many people; however its main purpose is not to provide you with all of the sounds you will need. Instead, it guides you to discover sounds from various sources.";
            info.image = [UIImage imageNamed:@"Intro1image3.png"];
            
            [pageInfos addObject:info];
        }
        SwiperViewController *swiper = [[SwiperViewController alloc]init];
        
        swiper.pageInfos = pageInfos;
        
        swiper.header = @"Welcome to Using Sound";
        
        [self.navigationController pushViewController:swiper animated:YES];
        
    }
    
    [PersistenceStorage setObject:@"OK" andKey:@"shownSoundIntro"];


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
    
    /*
    SoundIntroDetailViewController *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SoundIntroDetailViewController"];
    [self.navigationController pushViewController:siv animated:YES];
     */
    
    NSMutableArray *pageInfos = [NSMutableArray array];
    
    {
        IntroPageInfo *info = [[IntroPageInfo alloc]init];
        
        info.title = USING_SOUND_INTRO_PAGE_TITLE_1;
        info.descriptionText = USING_SOUND_INTRO_PAGE_1;
        info.image = [UIImage imageNamed:@"Intro1image1.png"];
        
        [pageInfos addObject:info];
    }
    {
        IntroPageInfo *info = [[IntroPageInfo alloc]init];
        
        info.title = @"What can I expect from \"Using Sound\"?";
        info.descriptionText = @"Using sound when your tinnitus is bothering you will not change your tinnitus in any way. It can however have a big impact on how you feel.  As you experiment with sound, pay close attention to how each sound affects how you feel. Keep experimenting until you find sounds that are helpful.";
        info.image = [UIImage imageNamed:@"Intro1image2.png"];
        
        [pageInfos addObject:info];
    }
    {
        IntroPageInfo *info = [[IntroPageInfo alloc]init];
        
        info.title = @"What is special about \"Using Sound\"?";
        info.descriptionText = @"The sources of sounds that can be used for tinnitus are almost endless. Where does one even start? Tinnitus Coach contains sounds that are helpful for many people; however its main purpose is not to provide you with all of the sounds you will need. Instead, it guides you to discover sounds from various sources.";
        info.image = [UIImage imageNamed:@"Intro1image3.png"];
        
        [pageInfos addObject:info];
    }
    SwiperViewController *swiper = [[SwiperViewController alloc]init];
    
    swiper.pageInfos = pageInfos;
    
    swiper.header = @"Welcome to Using Sound";
    
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
    

-(IBAction)addSkillToPlan:(id)sender
{
    [self writeToMySkills];
    [self performSelector:@selector(navigateBacktoPlan) withObject:nil afterDelay:1.2];

}

-(void)navigateBacktoPlan{
   [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3] animated:YES];
}


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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
