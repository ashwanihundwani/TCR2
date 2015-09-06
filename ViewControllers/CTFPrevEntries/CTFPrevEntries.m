//
//  AddSkillsToPlanViewController.m
//  TinnitusCoach
//
//  Created by Vikram Singh on 3/22/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//
#import "CTFPrevEntries.h"
#import "CTFSummary.h"
#import "AddSkillsToPlanViewController.h"
#import "SkillDetailViewController.h"
#import "ImagerySkillDetailViewController.h"
#import "TipsSkillDetailViewController.h"
#import "SoundSkillDetailViewController.h"
#import "BreathingSkillDetailViewController.h"
#import "MeditationSkillDetailViewController.h"
#import "ThoughtsSkillDetailViewController.h"
#import "PleasantSkillDetailViewController.h"




@interface CTFPrevEntries ()
{
    NSArray *CTFListArray;
    NSArray *EntryArray;
}
@property (nonatomic, strong) IBOutlet UITableView *CTFListTableView;
@property (nonatomic, strong) DBManager *dbManagerCTFList;

@end

@implementation CTFPrevEntries

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Previous Entries";
    // skillListArray = [NSArray arrayWithObjects:@{@"name":@"Using Sound", @"description":@"Listening to sound can reduce your stress and help you cope with your tinnitus."}, @{@"name":@"Deep Breathing", @"description":@"This breathing exercise can reduce your stress and help you cope with your tinnitus."}, @{@"name":@"Imagery", @"description":@"Imagining a peaceful place can reduce your stress and help you cope with your tinnitus."}, @{@"name":@"Guided Meditation", @"description":@"Try several other guided relaxation exercises."}, @{@"name":@"Pleasant Activities", @"description":@"Make a list of activities that will help you take your mind off of tinnitus."}, @{@"name":@"Changing Thoughts & Feelings", @"description":@"Changing the way you think about tinnitus can improve how you feel."}, @{@"name":@"Tips for Better Sleeping", @"description":@"Following these suggestions can help you sleep better."}, nil];
    
    self.dbManagerCTFList = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    
    [self loadCTFList];
    
    // Do any additional setup after loading the view.
}



- (void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
}



-(void)loadCTFList{
    // NSString *query = [NSString stringWithFormat:@"select * from Plan_Skills where ID NOT IN (select skillID from MySkills where planID==%@) and ID NOT IN (select skillID from Skills_Situation where situationID==%@) ",[PersistenceStorage getObjectForKey:@"currentPlanID"],@"2"]; //[PersistenceStorage getObjectForKey:@"currentSituationID"];
    
    
    NSString *query = [NSString stringWithFormat:@"select * from my_TF_Set where planID= '%@' order by datetimeSeconds DESC LIMIT 100",[PersistenceStorage getObjectForKey:@"currentPlanID"]];
    
    
    
    
    
    
    // Get the results.
    if (CTFListArray!= nil) {
        CTFListArray = nil;
    }
    CTFListArray = [[NSArray alloc] initWithArray:[self.dbManagerCTFList loadDataFromDB:query]];
    NSLog(@"%@",CTFListArray);
    
    // Reload the table view.
    [self.CTFListTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [CTFListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    if (cell == nil) {
        cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text =[[CTFListArray objectAtIndex:indexPath.row] valueForKey:@"situationDescription"];
    
    cell.detailTextLabel.text = [[CTFListArray objectAtIndex:indexPath.row] valueForKey:@"dateTime"];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.numberOfLines = 0;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    
    
    
    
    
    
    return cell;
    
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //  cell.textLabel.text =[[skillListArray objectAtIndex:indexPath.row] valueForKey:@"skillName"];
    NSString *entryID = [[CTFListArray objectAtIndex:indexPath.row] valueForKey:@"ID"];
    
    
    NSString *getEntryData = [NSString stringWithFormat: @"select * from my_TF_Set where ID ='%@'", entryID];
    
    EntryArray = [[NSArray alloc] initWithArray:[self.dbManagerCTFList loadDataFromDB:getEntryData]];
       [PersistenceStorage setObject: [[CTFListArray objectAtIndex:indexPath.row] valueForKey:@"dateTime"] andKey:@"entryDateTime"];

    
    [PersistenceStorage setObject:@"preventries" andKey:@"summaryReferer"];

    CTFSummary *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"CTFSummary"];


    
    [PersistenceStorage setObject: [[CTFListArray objectAtIndex:indexPath.row] valueForKey:@"situationDescription"] andKey:@"ctf01text"];

    [PersistenceStorage setObject: [[CTFListArray objectAtIndex:indexPath.row] valueForKey:@"thoughtDescription"] andKey:@"ctf02text"];

    [PersistenceStorage setObject: [[CTFListArray objectAtIndex:indexPath.row] valueForKey:@"emotionsList"] andKey:@"ctf03text"];
    [PersistenceStorage setObject: [[CTFListArray objectAtIndex:indexPath.row] valueForKey:@"thoughtError"] andKey:@"ctf04text"];
    [PersistenceStorage setObject: [[CTFListArray objectAtIndex:indexPath.row] valueForKey:@"newThought"] andKey:@"ctf05text"];

    [PersistenceStorage setObject: [[CTFListArray objectAtIndex:indexPath.row] valueForKey:@"newEmotionsList"] andKey:@"ctf06text"];

 [self.navigationController pushViewController:ratingsView animated:YES];
    
    
    
//    NSString *getEntryData = [NSString stringWithFormat:@"select * from my_TF_Set where ID ='"r by datetimeSeconds DESC LIMIT 100"];
//
//                              [PersistenceStorage setObject:@"ctf06" andKey:@"ctf06text"];
//
//                              
//                              
//                              
//                              %@','%@', '%@', '%@','%@','%@')",
//                              [PersistenceStorage getObjectForKey:@"ctf01text"],
//                              [PersistenceStorage getObjectForKey:@"ctf02text"],
//                              [PersistenceStorage getObjectForKey:@"ctf03text"],
//                              [PersistenceStorage getObjectForKey:@"ctf04text"],
//                              [PersistenceStorage getObjectForKey:@"ctf05text"],
//                              [PersistenceStorage getObjectForKey:@"ctf06text"],
//                              
//                              
//    
//    NSLog(@"%@",tSkillName);
//  
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}


/*
 -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 SkillDetailViewController *sdv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SkillDetailViewController"];
 sdv.skillDict = [skillListArray objectAtIndex:indexPath.row];
 [self.navigationController pushViewController:sdv animated:YES];
 
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
