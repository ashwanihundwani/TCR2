//
//  DeepBreathingViewController.m
//  TinnitusCoach
//
//  Created by Swipe Video Labs Pvt. Ltd. on 18/03/15.
//  Copyright (c) 2015 Swipe Video Labs Pvt. Ltd.. All rights reserved.
//

#import "CTF06New.h"

#import "ChangingThoughtsViewController.h"
#import "DeepBreathingViewController.h"
#import "BreathingIntroDetailViewController.h"
#import "AudioPanningViewController.h"
#import "VideoPlayerViewController.h"
#import "ScheduleViewController.h"
#import "SkillRatingsViewController.h"
#import "NookUsingSoundViewControllerOne.h"
#import "CoundownTimerViewController.h"
#import "NewPlanAddedViewController.h"
#import <EventKitUI/EventKitUI.h>
#import "CTF05.h"
#import "DBManager.h"
#import "MBProgressHUD.h"


@interface CTF06New ()
{    NSArray *emotionsArray;
    NSArray *emotionsArrayNew;

}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation CTF06New

- (void)viewDidLoad {

    [super viewDidLoad];
    
     self.dbManager = [[DBManager alloc] initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    [self setUpView];
    self.title = @"Add New Entry";
    
    self.EmotionsTableView.delegate = self;
    self.EmotionsTableView.dataSource = self;
 //   self.NewEmotionsTableView.delegate = self;
    self.NewEmotionsTableView.dataSource = self;

 //   [self addLabel];
    
    // Do any additional setup after loading the view.
}


-(void)viewDidAppear:(BOOL)animated
{
    [PersistenceStorage setObject:@"ctf06" andKey:@"ctfCategory"];
    [self setData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpView {


[self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTapped)];
[self.navigationItem setLeftBarButtonItem:barButton];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setData
{
    NSString *query = @"SELECT thoughtText,rating FROM My_TF where thoughtCategory = 'step3'";
   emotionsArray = [self.dbManager loadDataFromDB:query];
    NSLog(@"%@",emotionsArray);

    
    
    
    NSString *queryNew = @"SELECT thoughtText,rating FROM My_TF where thoughtCategory = 'step6'";
    emotionsArrayNew = [self.dbManager loadDataFromDB:queryNew];
    NSLog(@"''%@",emotionsArrayNew);
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 100:
            return [emotionsArray count];
            break;
        case 200:
            return [emotionsArrayNew count];
            break;
        default:
            return 1;
            break;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
            
            
        case 100:
        {
            
            static NSString *simpleTableIdentifier = @"SimpleTableCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
            }
            
            // NSMutableString *thoughtList =[NSMutableString stringWithString:@""];
            //[thoughtList appendString:[[emotionsArray objectAtIndex:indexPath.row] valueForKey:@"thoughtText"]];
            //  [thoughtList appendString:[[emotionsArray objectAtIndex:indexPath.row] valueForKey:@"rating"]];
            
            
            
            
            cell.textLabel.text = [[emotionsArray objectAtIndex:indexPath.row] valueForKey:@"thoughtText"];
            cell.detailTextLabel.text = [[emotionsArray objectAtIndex:indexPath.row] valueForKey:@"rating"];
            
            
            return cell;
            break;
        }
        case 200:
        {
            
            static NSString *simpleTableIdentifier = @"SimpleTableCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
            }
            
            // NSMutableString *thoughtList =[NSMutableString stringWithString:@""];
            //[thoughtList appendString:[[emotionsArray objectAtIndex:indexPath.row] valueForKey:@"thoughtText"]];
            //  [thoughtList appendString:[[emotionsArray objectAtIndex:indexPath.row] valueForKey:@"rating"]];
            
            
            
            
            cell.textLabel.text = [[emotionsArrayNew objectAtIndex:indexPath.row] valueForKey:@"thoughtText"];
            cell.detailTextLabel.text = [[emotionsArrayNew objectAtIndex:indexPath.row] valueForKey:@"rating"];
            
            
            return cell;
            break;
        }
        default:
        //    return nil;
            break;
    }
    return 0;
    
}

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section  {
 switch (section) {
 case 0:
 return @"Sounds";
 break;
 case 1:
 return @"Relaxation Exercises";
 break;
 default:
 return 0;
 break;
 }
 }*/




#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return 44.0f;
            break;
            
        case 1:
            return 105.0f;
            break;
            
        default:
            return 44.0f;
            break;
    }
}

/*

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"X" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
    
    
    switch (tableView.tag) {
            
            
        case 100:
        {
            
            static NSString *simpleTableIdentifier = @"SimpleTableCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
            }
            
            // NSMutableString *thoughtList =[NSMutableString stringWithString:@""];
            //[thoughtList appendString:[[emotionsArray objectAtIndex:indexPath.row] valueForKey:@"thoughtText"]];
            //  [thoughtList appendString:[[emotionsArray objectAtIndex:indexPath.row] valueForKey:@"rating"]];
            
            
            
            
            cell.textLabel.text = [[emotionsArray objectAtIndex:indexPath.row] valueForKey:@"thoughtText"];
            cell.detailTextLabel.text = [[emotionsArray objectAtIndex:indexPath.row] valueForKey:@"rating"];
            
            
            return cell;
            break;
        }
        case 200:
        {
            
            static NSString *simpleTableIdentifier = @"SimpleTableCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
            }
            
            // NSMutableString *thoughtList =[NSMutableString stringWithString:@""];
            //[thoughtList appendString:[[emotionsArray objectAtIndex:indexPath.row] valueForKey:@"thoughtText"]];
            //  [thoughtList appendString:[[emotionsArray objectAtIndex:indexPath.row] valueForKey:@"rating"]];
            
            
            
            
            cell.textLabel.text = [[emotionsArrayNew objectAtIndex:indexPath.row] valueForKey:@"thoughtText"];
            cell.detailTextLabel.text = [[emotionsArrayNew objectAtIndex:indexPath.row] valueForKey:@"rating"];
            
            
            return cell;
            break;
        }
        default:
            return nil;
            break;
    }
    
    
    
    
 
    
    
    
    return @[button]; //array with all the buttons you want. 1,2,3, etc...
}
 
 */

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // you need to implement this method too or nothing will work:
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES; //tableview must be editable or nothing will work...
}



- (void)cancelTapped  {
    ChangingThoughtsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"ChangingThoughtsViewController"];
    
    
    [self.navigationController pushViewController:ratingsView animated:YES];
}




 
- (IBAction)backButtonTapped:(id)sender {
    CTF05 *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"CTF05"];
    
    
    [self.navigationController pushViewController:ratingsView animated:YES];
    
    // Execute the query.
    //[self.manager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
 }




-(IBAction)goToScheduler:(id)sender
{
    ScheduleViewController *favc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ScheduleViewController"];
    [self.navigationController pushViewController:favc animated:YES];
}




-(void)viewWillAppear:(BOOL)animated
{//[self RefreshScheduleData];
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
        NookUsingSoundViewControllerOne *samplerView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookUsingSoundViewControllerOne"];
        [self.navigationController pushViewController:samplerView animated:NO];
    }
    
    
    if ([buttonTitle isEqualToString:@"Try Another Skill"]) {
        NewPlanAddedViewController *samplerView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NewPlanAddedViewController"];
        [self.navigationController pushViewController:samplerView animated:YES];
        
    }
    
    if ([buttonTitle isEqualToString:@"Return Home"]) {
        [[self tabBarController] setSelectedIndex:0];
        
    }
    
    
    
    if ([buttonTitle isEqualToString:@"Do Activity Now"]) {
//DoingActivityViewController *svc1 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"DoingActivityViewController"];
        //[self.navigationController pushViewController:svc1 animated:YES];
        
    //    [self.navigationController presentModalViewController:svc1 animated:NO];
    }
    
    
    
    if ([buttonTitle isEqualToString:@"Schedule Later"]) {
        ScheduleViewController *svc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ScheduleViewController"];
   //     svc.name = strAct;
        [self.navigationController pushViewController:svc animated:YES];
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
    
    
    
    
    BreathingIntroDetailViewController *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"BreathingIntroDetailViewController"];
    [self.navigationController pushViewController:siv animated:YES];
    
}


-(IBAction)learnMoreClicked:(id)sender{
    NookUsingSoundViewControllerOne *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookUsingSoundViewControllerOne"];
    [self.navigationController pushViewController:siv animated:YES];
    
}

- (IBAction)BreathingTimer:(id)sender {
    CountdownTimerViewController *guided = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                            
                                            instantiateViewControllerWithIdentifier:@"CountdownTimerViewController"];
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
    [PersistenceStorage setObject:@"Video Introduction" andKey:@"skillDetail1"];

    [self.navigationController presentModalViewController:audioPanning animated:NO];

    
//    [self.navigationController pushViewController:audioPanning animated:YES];
}






@end
