//
//  NewPlanAddedViewController.m
//  TinnitusCoach
//
//  Created by Swipe Video Labs on 3/21/15.
//  Copyright (c) 2015 Swipe Video Labs Pvt Ltd. All rights reserved.
//

#import "NewPlanAddedViewController.h"
#import "NewPlanSupportViewController.h"
#import "AddNewPlanViewController.h"
#import "AddSkillsToPlanViewController.h"
#import "SoundActivitiesViewController.h"
#import "ImageryViewController.h"
#import "PleasantActivityViewController.h"
#import "DeepBreathingViewController.h"
#import "GuidedMeditationViewController.h"
#import "ChangingThoughtsViewController.h"
#import "TipsViewController.h"


@interface NewPlanAddedViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *skillListArray, *groupListArray;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic, weak) IBOutlet UITableView *skillsListTableView;
@property (nonatomic, strong) DBManager *dbManagerMySkills;
@property (weak, nonatomic) IBOutlet UITextField *planNameTextField;

@end

@implementation NewPlanAddedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Skills Plan";
    
    
    
    
    
    if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[AddNewPlanViewController class]]) {
        NewPlanSupportViewController *npsv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NewPlanSupportViewController"];
        
        [self.navigationController pushViewController:npsv animated:NO];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(popToPlansView)];
    
//    skillListArray = [NSArray arrayWithObjects:@{@"name":@"Sound Skill", @"subSkill":@[@"Using Sound"]}, @{@"name":@"Relaxation Skills", @"subSkill":@[@"Deep Breathing", @"Imagery"]}, @{@"name":@"Other Skills", @"subSkill":@[@"Other Guided Relaxation Exercises", @"Pleasant Activities",@"Changing Thoughts & Feelings",@"Tips for Better Sleep"]}, nil];
    
    self.dbManagerMySkills = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    

    self.planNameTextField.userInteractionEnabled = NO;
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    self.planNameTextField.text = self.planName;

    
    NSString * pName = self.planName;
    
    
    [PersistenceStorage setObject:pName andKey:@"planName"];

    
    
    [self loadMySkillsData];

}


/*
 
 TRIED SCROLLING
 -(void)viewDidAppear:(BOOL)animated
{
    
    
    [self.scrollView setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.scrollView setContentSize:CGSizeMake(320,800)];
}
*/



-(void)loadMySkillsData{
     NSString *query = [NSString stringWithFormat: @"select ID, groupID, skillName from Plan_Skills where ID IN (select skillID from MySkills where planID = %ld) ORDER BY groupID", (long)[PersistenceStorage getIntegerForKey:@"currentPlanID"]];
    
    
   //   NSString *query = [NSString stringWithFormat: @"select skillID from MySkills where planID = %ld", (long)[PersistenceStorage getIntegerForKey:@"currentPlanID"]];
    
    
    skillListArray = [[NSMutableArray alloc] initWithArray:[self.dbManagerMySkills loadDataFromDB:query]];

    
    
      // Get the results.
    if ([skillListArray count]==0)
    {
        
   
        [[self.view viewWithTag:10] setHidden:NO];
       // skillListArray = nil;
    }
    else
    {
        
        [[self.view viewWithTag:10] setHidden:YES];
    }
    
    
    [self loadGroupData];
    // Reload the table view.
    [self.skillsListTableView reloadData];
    


    
}







-(void)loadGroupData
{
    
    NSString *query = [NSString stringWithFormat:@"select ID, groupName from Skills_Group where ID IN (select groupID from MySkills where planID = %ld) GROUP BY ID, groupName", (long)[PersistenceStorage getIntegerForKey:@"currentPlanID"]];
    
    // Get the results.
    if (groupListArray!= nil) {
        groupListArray = nil;
    }
    groupListArray = [[NSMutableArray alloc] initWithArray:[self.dbManagerMySkills loadDataFromDB:query]];
    
    
}

-(void)deleteSkillFromDB:(NSDictionary *)skillDict andCompletion:(void (^)(BOOL success))block
{
   // NSString *query = [NSString stringWithFormat:@"delete from MySkills where ID=%@ and planID = %ld",[skillDict valueForKey:@"ID"],(long)[PersistenceStorage getIntegerForKey:@"currentPlanID"]];
    
    NSString *query = [NSString stringWithFormat:@"delete from MySkills where SkillID=%@ and planID = %ld",[skillDict valueForKey:@"ID"],(long)[PersistenceStorage getIntegerForKey:@"currentPlanID"]];

    
    
 
    
    
    BOOL isDone = [self.dbManagerMySkills executeQuery:query];
    if (isDone == YES)
    {
        [self writeDeletedSkill];
        
        NSLog(@"Success");
        block(YES);
    }
    else{
        NSLog(@"Error");
        block(NO);
        
    }
}







-(void)writeDeletedSkill{
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
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,@"Removed Skill",[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"situationName"],[PersistenceStorage getObjectForKey:@"deleteSkillName"],nil,nil,nil,nil,nil];
    
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




 





-(void)popToPlansView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addSkillToPlansClicked:(id)sender
{
    AddSkillsToPlanViewController *astpv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier: @"AddSkillsToPlanViewController"];
    [self.navigationController pushViewController:astpv animated:NO];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [groupListArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.groupID == %@",[[groupListArray objectAtIndex:section] valueForKey:@"ID"]];
    NSArray *filteredArray = [skillListArray filteredArrayUsingPredicate:predicate];
    return [filteredArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    if (cell == nil) {
        cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.groupID == %@",[[groupListArray objectAtIndex:indexPath.section]valueForKey:@"ID"]];
    NSArray *filteredArray = [skillListArray filteredArrayUsingPredicate:predicate];
    
    cell.textLabel.text =[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"skillName"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 40.0)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 5.0, 300.0, 30.0)];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont boldSystemFontOfSize:12.0];
    label.text = [[groupListArray objectAtIndex:section] valueForKey:@"groupName"];
    [headerView addSubview:label];
    return headerView;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /* //ADDED BY ME
     if(indexPath.section ==1){
     
     PleasantActivityViewController *pav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"PleasantActivityViewController"];
     //     pav.skillName = [[skillListArray objectAtIndex:indexPath.row] valueForKey:@"name"];
     
     [self.navigationController pushViewController:pav animated:YES];
     }
     
     else
     
     {
     
     SoundActivitiesViewController *sav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SoundActivitiesViewController"];
     //sav.skillName = [[skillListArray objectAtIndex:indexPath.row] valueForKey:@"name"];
     [self.navigationController pushViewController:sav animated:YES];
     
     
     
     }
     
     
     */
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.groupID == %@",[[groupListArray objectAtIndex:indexPath.section]valueForKey:@"ID"]];
    NSArray *filteredArray = [skillListArray filteredArrayUsingPredicate:predicate];
    
 
    
    NSString * sName = [[filteredArray objectAtIndex:indexPath.row] valueForKey:@"skillName"];
    
    
    [PersistenceStorage setObject:sName andKey:@"skillName"];

    
    
    if ([[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"skillName"] isEqualToString:@"Using Sound"])
    {
        SoundActivitiesViewController *sav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SoundActivitiesViewController"];
        //sav.skillName = [[skillListArray objectAtIndex:indexPath.row] valueForKey:@"name"];
        [PersistenceStorage setObject:[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"ID"] andKey:@"currentSkillID"];
        [PersistenceStorage setObject:[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"groupID"] andKey:@"currentGroupID"];
        

        
        
        [self.navigationController pushViewController:sav animated:YES];
    }
    
    
    if ([[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"skillName"] isEqualToString:@"Imagery"])
    {
        ImageryViewController *iav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ImageryViewController"];
        //sav.skillName = [[skillListArray objectAtIndex:indexPath.row] valueForKey:@"name"];
        [PersistenceStorage setObject:[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"ID"] andKey:@"currentSkillID"];
        [PersistenceStorage setObject:[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"groupID"] andKey:@"currentGroupID"];
        [self.navigationController pushViewController:iav animated:YES];
    }
    
    
    
    
    if ([[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"ID"] isEqualToString:@"4"])
    {
        GuidedMeditationViewController *gav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GuidedMeditationViewController"];
        //sav.skillName = [[skillListArray objectAtIndex:indexPath.row] valueForKey:@"name"];
        [PersistenceStorage setObject:[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"ID"] andKey:@"currentSkillID"];
        [PersistenceStorage setObject:[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"groupID"] andKey:@"currentGroupID"];
        [self.navigationController pushViewController:gav animated:YES];
    }
    
    
    
    
    
    
    
    if ([[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"skillName"] isEqualToString:@"Deep Breathing"])
    {
        DeepBreathingViewController *dav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"DeepBreathingViewController"];
        //sav.skillName = [[skillListArray objectAtIndex:indexPath.row] valueForKey:@"name"];
        [PersistenceStorage setObject:[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"ID"] andKey:@"currentSkillID"];
        [PersistenceStorage setObject:[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"groupID"] andKey:@"currentGroupID"];
        [self.navigationController pushViewController:dav animated:YES];
    }
    
    
    
    
    if ([[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"ID"] isEqualToString:@"5"])
    {
        PleasantActivityViewController *pav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"PleasantActivityViewController"];
        //sav.skillName = [[skillListArray objectAtIndex:indexPath.row] valueForKey:@"name"];
        [PersistenceStorage setObject:[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"ID"] andKey:@"currentSkillID"];
        [PersistenceStorage setObject:[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"groupID"] andKey:@"currentGroupID"];
        [self.navigationController pushViewController:pav animated:YES];
    }
    
    
    
    
    
    
    if ([[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"skillName"] isEqualToString:@"Changing Thoughts & Feelings"])
    {
        ChangingThoughtsViewController *dav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ChangingThoughtsViewController"];
        //sav.skillName = [[skillListArray objectAtIndex:indexPath.row] valueForKey:@"name"];
        [PersistenceStorage setObject:[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"ID"] andKey:@"currentSkillID"];
        
        
        
        [PersistenceStorage setObject:[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"groupID"] andKey:@"currentGroupID"];
        [self.navigationController pushViewController:dav animated:YES];
    }
    
    
    
    if ([[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"skillName"] isEqualToString:@"Tips for Better Sleep"])
    {
        TipsViewController *dav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TipsViewController"];
        //sav.skillName = [[skillListArray objectAtIndex:indexPath.row] valueForKey:@"name"];
        [PersistenceStorage setObject:[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"ID"] andKey:@"currentSkillID"];
        [PersistenceStorage setObject:[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"groupID"] andKey:@"currentGroupID"];
        [self.navigationController pushViewController:dav animated:YES];
    }
    

    
    
    
    
    
    
}








-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"X" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                   /* {
                                        [self deletePlanFromDB:[skillListArray objectAtIndex:indexPath.row] andCompletion:^(BOOL success)
                                         {
                                             if (success) {
                                                 [skillListArray removeObjectAtIndex:indexPath.row];
                                                 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.groupID == %@",[[groupListArray objectAtIndex:indexPath.section]valueForKey:@"ID"]];
                                                 NSArray *filteredArray = [skillListArray filteredArrayUsingPredicate:predicate];
                                                 if ([filteredArray count]<=0) {
                                                     [groupListArray removeObjectAtIndex:indexPath.section];
                                                     [self.skillsListTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
                                                 }
                                                 else
                                                 {
                                                     [self.skillsListTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
                                                 }
                                                 [self.skillsListTableView reloadData];
                                                 
                                             }
                                             
                                         }];  */
                                    
                                    
                                    {
                                       
                                        [PersistenceStorage setObject: [[skillListArray objectAtIndex:indexPath.row] valueForKey:@"skillName"] andKey:@"deleteSkillName"];
  ;
                                        
                                        [self deleteSkillFromDB:[skillListArray objectAtIndex:indexPath.row] andCompletion:^(BOOL success)
                                         {
                                             if (success) {
                                        
                                                /* [skillListArray removeObjectAtIndex:indexPath.row];
                                                 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.groupID == %@",[[groupListArray objectAtIndex:indexPath.section]valueForKey:@"ID"]];
                                                 NSArray *filteredArray = [skillListArray filteredArrayUsingPredicate:predicate];
                                                 if ([filteredArray count]<=0) {
                                                     [groupListArray removeObjectAtIndex:indexPath.section];
                                                     [self.skillsListTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
                                                 }
                                                 else
                                                 {
                                                     [self.skillsListTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
                                                 }
                                                 [self.skillsListTableView reloadData];*/
                                                 [self loadMySkillsData];

                                             }
                                             
                                         }];

                                    
                                    
                                    
                                    
                                    
                                    }];
    button.backgroundColor = [UIColor redColor]; //arbitrary color
    
    
    return @[button];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    // you need to implement this method too or nothing will work:
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
