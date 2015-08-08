//
//  AddSkillsToPlanViewController.m
//  TinnitusCoach
//
//  Created by Vikram Singh on 3/22/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "AddSkillsToPlanViewController.h"
#import "SkillDetailViewController.h"
#import "ImagerySkillDetailViewController.h"
#import "TipsSkillDetailViewController.h"
#import "SoundSkillDetailViewController.h"
#import "BreathingSkillDetailViewController.h"
#import "MeditationSkillDetailViewController.h"
#import "ThoughtsSkillDetailViewController.h"
#import "PleasantSkillDetailViewController.h"




@interface AddSkillsToPlanViewController ()
{
    NSArray *skillListArray;
}
@property (nonatomic, strong) IBOutlet UITableView *skillsTableView;
@property (nonatomic, strong) DBManager *dbManagerSkillList;

@end

@implementation AddSkillsToPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Add Skills To Plan";
  // skillListArray = [NSArray arrayWithObjects:@{@"name":@"Using Sound", @"description":@"Listening to sound can reduce your stress and help you cope with your tinnitus."}, @{@"name":@"Deep Breathing", @"description":@"This breathing exercise can reduce your stress and help you cope with your tinnitus."}, @{@"name":@"Imagery", @"description":@"Imagining a peaceful place can reduce your stress and help you cope with your tinnitus."}, @{@"name":@"Guided Meditation", @"description":@"Try several other guided relaxation exercises."}, @{@"name":@"Pleasant Activities", @"description":@"Make a list of activities that will help you take your mind off of tinnitus."}, @{@"name":@"Changing Thoughts & Feelings", @"description":@"Changing the way you think about tinnitus can improve how you feel."}, @{@"name":@"Tips for Better Sleeping", @"description":@"Following these suggestions can help you sleep better."}, nil];

    self.dbManagerSkillList = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    
    [self loadPlanSkills];
    
    // Do any additional setup after loading the view.
}

-(void)loadPlanSkills{
   // NSString *query = [NSString stringWithFormat:@"select * from Plan_Skills where ID NOT IN (select skillID from MySkills where planID==%@) and ID NOT IN (select skillID from Skills_Situation where situationID==%@) ",[PersistenceStorage getObjectForKey:@"currentPlanID"],@"2"]; //[PersistenceStorage getObjectForKey:@"currentSituationID"];
    
    
    NSString *query = [NSString stringWithFormat:@"select * from Plan_Skills where ID NOT IN (select skillID from MySkills where planID==%@) and ID NOT IN (select skillID from Skills_Situation where situationName=='%@') ",[PersistenceStorage getObjectForKey:@"currentPlanID"],[PersistenceStorage getObjectForKey:@"situationName"]];

    
 

    
    
    // Get the results.
    if (skillListArray!= nil) {
        skillListArray = nil;
    }
    skillListArray = [[NSArray alloc] initWithArray:[self.dbManagerSkillList loadDataFromDB:query]];
 
    // Reload the table view.
    [self.skillsTableView reloadData];
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
    return [skillListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    if (cell == nil) {
        cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text =[[skillListArray objectAtIndex:indexPath.row] valueForKey:@"skillName"];
    
    cell.detailTextLabel.text = [[skillListArray objectAtIndex:indexPath.row] valueForKey:@"skillDetail"];
    cell.detailTextLabel.textColor = [UIColor grayColor];
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
    NSString *tSkillName = [[skillListArray objectAtIndex:indexPath.row] valueForKey:@"skillName"];
     
    
    if ([tSkillName isEqualToString:@"Guided Meditation"])
    {
        MeditationSkillDetailViewController *dav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"MeditationSkillDetailViewController"];
       dav.skillDict = [skillListArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:dav animated:YES];
    }
    
    
    
    if ([tSkillName isEqualToString:@"Deep Breathing"])
    {
        BreathingSkillDetailViewController *dav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"BreathingSkillDetailViewController"];
         dav.skillDict = [skillListArray objectAtIndex:indexPath.row];[self.navigationController pushViewController:dav animated:YES];
    }
    
    if ([tSkillName isEqualToString:@"Pleasant Activities"])
    {
        PleasantSkillDetailViewController *dav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"PleasantSkillDetailViewController"];
         dav.skillDict = [skillListArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:dav animated:YES];
    }
    
    if ([tSkillName isEqualToString:@"Using Sound"])
    {
       SoundSkillDetailViewController *dav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SoundSkillDetailViewController"];
         dav.skillDict = [skillListArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:dav animated:YES];
    }
    
    if ([tSkillName isEqualToString:@"Imagery"])
    {
        ImagerySkillDetailViewController *dav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ImagerySkillDetailViewController"];
         dav.skillDict = [skillListArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:dav animated:YES];
    }
    
    
    
    
    if ([tSkillName isEqualToString:@"Changing Thoughts & Feelings"])
    {
        ThoughtsSkillDetailViewController *dav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ThoughtsSkillDetailViewController"];
        dav.skillDict = [skillListArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:dav animated:YES];
    }
    
    
    
    if ([tSkillName isEqualToString:@"Tips for Better Sleep"])
    {
        TipsSkillDetailViewController *dav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TipsSkillDetailViewController"];
        dav.skillDict = [skillListArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:dav animated:YES];
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
  
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
