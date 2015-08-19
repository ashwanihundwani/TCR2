//
//  NookViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 23/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "TipsReminder.h"
#import "WeeklyViewController.h"
#import "CTFPrevEntries.h"

#import "NookViewController.h"
#import "SoundsViewController.h"
#import "ImageryViewController.h"
#import "DeepBreathingViewController.h"
#import "GuidedMeditationViewController.h"
#import "NookUsingSoundViewController.h"
#import "SkillRatingsViewController.h"
#import "ScheduleViewController.h"
#import "CoundownTimerViewController.h"
#import "NookFAQ.h"
#import "NookCTF.h"
#import "NookUS.h"
#import "NookMGM.h"
#import "NookPA.h"
#import "NookTBS.h"
#import "NookImg.h"
#import "NookDB.h"
#import "NookRes.h"
#import "CTF01.h"
#import "CTF04.h"
#import "CTFSummary.h"


#import "EditTFListVC.h"





@interface NookViewController (){
    NSArray *LogArray;}

@property (nonatomic, strong) DBManager *manager;

@end

@implementation NookViewController

 


- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = @"Learning Nook";
  //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" "
//style:UIBarButtonItemStylePlain target:self   action:@selector(popToPlansView)];
   
   // self.navigationItem.title = @"New Title";
  [self.navigationItem.leftBarButtonItem setTitle:@"Back"];    // Do any additional setup after loading the view.
    
    
    NSLog(@"%@",[PersistenceStorage getObjectForKey:@"WRInitialized"]);
    
    
    
    
    
    
    
    [self setUpView];
 }

- (void)viewDidAppear:(BOOL)animated {
    self.title = @"Learning Nook";

    [self.tabBarController.tabBar setHidden:NO];
    
    
    
    
    [self writeVisitedNook];
}


- (void)viewDidDisappear:(BOOL)animated {
    self.title = @"Learning Nook";
    
  
}



-(void)setUpView{
    [self.faqsButton.layer setCornerRadius:7.5];
    [self.rsourcesButton.layer setCornerRadius:7.5];
    [self.meditationButton.layer setCornerRadius:7.5];
    [self.imageryButton.layer setCornerRadius:7.5];
    [self.pleasantButton.layer setCornerRadius:7.5];
    [self.tipsButton.layer setCornerRadius:7.5];
    [self.breathingButton.layer setCornerRadius:7.5];
    [self.soundButton.layer setCornerRadius:7.5];
    [self.changingThoughtsButton.layer setCornerRadius:7.5];
   
    //number of lines
    self.faqsButton.titleLabel.numberOfLines =0;
    self.rsourcesButton.titleLabel.numberOfLines =0;
    self.meditationButton.titleLabel.numberOfLines =0;
    self.imageryButton.titleLabel.numberOfLines =0;
    self.pleasantButton.titleLabel.numberOfLines =0;
    self.tipsButton.titleLabel.numberOfLines =0;
    self.breathingButton.titleLabel.numberOfLines =0;
    self.soundButton.titleLabel.numberOfLines =0;
    self.changingThoughtsButton.titleLabel.numberOfLines =0;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 

- (IBAction)soundTapped:(id)sender {
// WeeklyViewController *sound = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"WeeklyViewController"];
    NookUS *sound = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookUS"];
    
    
    [self.navigationController pushViewController:sound animated:YES];
    
 }
 - (IBAction)breathingTapped:(id)sender {
     NookDB *breathing = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookDB"];
     [self.navigationController pushViewController:breathing animated:YES];
}






- (IBAction)guidedTapped:(id)sender {
    NookMGM *guided = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                       
                       instantiateViewControllerWithIdentifier:@"NookMGM"];
    [self.navigationController pushViewController:guided animated:YES];
}



- (IBAction)resourcesTapped:(id)sender {
    NookRes *sound = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookRes"];
[self.navigationController pushViewController:sound animated:YES];
}
 - (IBAction)tipsTapped:(id)sender {
   NookTBS *breathing = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookTBS"];
     [self.navigationController pushViewController:breathing animated:YES];
 }


// -(IBAction)tipsTapped:(id)sender {
//    TipsReminder *breathing = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TipsReminder"];
//    [self.navigationController pushViewController:breathing animated:YES];
//}



- (IBAction)thoughtsTapped:(id)sender {
    NookCTF *guided = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                            
                            instantiateViewControllerWithIdentifier:@"NookCTF"];
    [self.navigationController pushViewController:guided animated:YES];
}



- (IBAction)FAQTapped:(id)sender {
    NookFAQ *breathing = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookFAQ"];
[self.navigationController pushViewController:breathing animated:YES];
}




- (IBAction)pleasantTapped:(id)sender {
    NookPA *guided = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                            
                            instantiateViewControllerWithIdentifier:@"NookPA"];
    [self.navigationController pushViewController:guided animated:YES];
}



- (IBAction)imageryTapped:(id)sender {
    NookImg *imagery = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookImg"];
    [self.navigationController pushViewController:imagery animated:YES];
}

-(void)writeVisitedNook{
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
    NSString *type = @"Navigation";
    
    NSString *str = @"Nook";
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,nil,str,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
   [PersistenceStorage setObject:finalStr andKey:@"SituationName"];

    
    
    self.manager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    
    
    
    NSString *query = [NSString stringWithFormat:@"select SituationName from MyPlans where ID=%@",[PersistenceStorage getObjectForKey:@"currentPlanID"]];

    
    if (LogArray!= nil) {
        LogArray = nil;
    }
    LogArray = [[NSArray alloc] initWithArray:[self.manager loadDataFromDB:query]];
    

    
 
    
    
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
    
    
    

    
    
    
    
    
}@end
