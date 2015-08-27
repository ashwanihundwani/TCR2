//
//  NewPlanAddedViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 3/21/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//
#import "WeeklyViewController.h"

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
#import "DeleteCormationManager.h"
#import "MBProgressHUD.h"
#import <EventKitUI/EventKitUI.h>

@interface NewPlanAddedViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSMutableArray *skillListArray, *groupListArray;
    NSString* CalEventIDString;
    BOOL isTBSDeleted;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic, weak) IBOutlet UITableView *skillsListTableView;
@property (nonatomic, strong) DBManager *dbManagerMySkills;
@property (strong, nonatomic)UITextField *planNameTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addSkillBtnTopConst;
@end

@implementation NewPlanAddedViewController
-(UIView *)tableHeaderView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    
    UILabel *planNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 13, 276, 21)];
    
    planNameLabel.text = @"Plan Name:";
    
    planNameLabel.font = [Utils helveticaNueueMediumFontWithSize:17];
    
    view.backgroundColor = [Utils colorWithHexValue:@"EFEFF4"];
    
    [view addSubview:planNameLabel];
    
    self.planNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(22, planNameLabel.y + planNameLabel.height + 5, 276, 25)];
    
    self.planNameTextField.borderStyle = UITextBorderStyleNone;
    
    self.planNameTextField.font = [UIFont boldSystemFontOfSize:18];
    self.planNameTextField.textAlignment = NSTextAlignmentLeft;
    
    self.planNameTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, self.planNameTextField.frame.size.height)];
    
    self.planNameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.planNameTextField.delegate = self;
    
    self.planNameTextField.textColor = [UIColor grayColor];
    
    self.planNameTextField.backgroundColor = [Utils colorWithHexValue:@"EFEFF4"];
    
    self.planNameTextField.userInteractionEnabled = NO;
    
    self.planNameTextField.text = self.planName;
    
    [view addSubview:self.planNameTextField];
    
    NSString *query = [NSString stringWithFormat:@"select * from Plan_Skills where ID NOT IN (select skillID from MySkills where planID==%@) and ID NOT IN (select skillID from Skills_Situation where situationName=='%@') ",[PersistenceStorage getObjectForKey:@"currentPlanID"],[PersistenceStorage getObjectForKey:@"situationName"]];

    
    NSArray *array = [self.dbManagerMySkills loadDataFromDB:query];
    
    if(array.count <= 0)
    {
        
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(320 / 2 - 218 / 2, self.planNameTextField.y + self.planNameTextField.height + 10, 218, 40)];
        
        textLabel.text = @"All skills Added";
        
        textLabel.backgroundColor = [UIColor clearColor];
        
        textLabel.textAlignment = NSTextAlignmentCenter;
        
        textLabel.font = [UIFont boldSystemFontOfSize:17];
        
        [view addSubview:textLabel];
        
        view.height = textLabel.height + textLabel.y;
        
        return view;
        
    }
    
    else
    {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, self.planNameTextField.y + self.planNameTextField.height + 10, 276, 20)
                               ];
        
        if ([skillListArray count]==0)
        {
            titleLabel.numberOfLines = 1000;
            
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.text = @"You have no skills added to your plan. Please add at least one skill to proceed!";;
            
            Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_2];
            
            titleLabel.font = pallete.secondObj;
            titleLabel.textColor = pallete.firstObj;
            
            CGFloat height = [Utils heightForLabelForString:titleLabel.text width:276 font:pallete.secondObj];
            
            titleLabel.height = height;
            
            view.height += height;
        }
        else
        {
            //equivalent to hidden
            titleLabel.height = 0;
        }
        
        [view addSubview:titleLabel];
        
        UILabel *addButton = [[UILabel alloc]initWithFrame:CGRectMake(320 / 2 - 218 / 2, titleLabel.y+ titleLabel.height + 10, 218, 40)];
        
        addButton.layer.cornerRadius = 5;
        addButton.layer.masksToBounds = YES;
        addButton.font = [UIFont boldSystemFontOfSize:17];
        addButton.text = @"+ Add a New Skill to Plan";
        addButton.textAlignment = NSTextAlignmentCenter;
        addButton.textColor = [UIColor whiteColor];
        addButton.backgroundColor = [Utils colorWithHexValue:BUTTON_BLUE_COLOR_HEX_VALUE];
        
        [Utils addTapGestureToView:addButton target:self selector:@selector(addSkillToPlansClicked:)];
        
        [view addSubview:addButton];
        
        view.height = addButton.y + addButton.height + 10;
        
        return view;
    }
}

-(CGFloat)heightForIndexPath:(NSIndexPath *)indexPath
{
    CGFloat constant = 27;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.groupID == %@",[[groupListArray objectAtIndex:indexPath.section]valueForKey:@"ID"]];
    NSArray *filteredArray = [skillListArray filteredArrayUsingPredicate:predicate];
    
    NSString *skillName = [[filteredArray objectAtIndex:indexPath.row] valueForKey:@"skillName"];
    
    
    CGFloat labelHeight = [Utils heightForLabelForString:skillName width:200 font:TITLE_LABEL_FONT];
    
    constant += labelHeight;
    
    return constant;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.planNameTextField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dbManagerMySkills = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    
    self.skillsListTableView.backgroundColor = [UIColor whiteColor];
    
    self.skillsListTableView.tableHeaderView = [self tableHeaderView];
    
    self.planNameTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, self.planNameTextField.frame.size.height)];
    
    self.planNameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.planNameTextField.textColor = [UIColor grayColor];
    
    self.skillsListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[AddNewPlanViewController class]]) {
        NewPlanSupportViewController *npsv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NewPlanSupportViewController"];
        
        [self.navigationController pushViewController:npsv animated:NO];
    }
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 230, 44)];
    
    titleView.backgroundColor = [Utils colorWithHexValue:NAV_BAR_BLACK_COLOR];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 230, 44)];
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_1];
    
    titleLabel.font = pallete.secondObj;
    titleLabel.textColor = pallete.firstObj;
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //titleLabel.textColor = [UIColor colorWithHexValue:@"797979"];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = self.planName;
    
    [titleView addSubview:titleLabel];
    
    self.navigationItem.titleView = titleView;
    
    UIImageView *backLabel = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 15, 20)];
    
    backLabel.image = [UIImage imageNamed:@"Active_Back-Arrow.png"];
    
    [Utils addTapGestureToView:backLabel target:self
                      selector:@selector(popToPlansView)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backLabel];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -8;
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, item, nil];
}


-(void)viewWillAppear:(BOOL)animated
{
    self.planNameTextField.text = [PersistenceStorage getObjectForKey:@"planName"];//self.planName;
    self.planName = [PersistenceStorage getObjectForKey:@"planName"];
    
     
    
  //  [PersistenceStorage setObject:pName andKey:@"planName"];

    NSLog(@"PLSN NAME %@",    [PersistenceStorage getObjectForKey:@"planName"]);
    
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


    self.skillsListTableView.tableHeaderView = [self tableHeaderView];
    
    
      // Get the results.
    if ([skillListArray count]==0)
    {
        
   
        [[self.view viewWithTag:10] setHidden:NO];
        self.addSkillBtnTopConst.constant = 197;
       // skillListArray = nil;
    }
    else
    {
        
        [[self.view viewWithTag:10] setHidden:YES];
        self.addSkillBtnTopConst.constant = 152;
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
    
    NSString *query = [NSString stringWithFormat:@"delete from MySkills where SkillID=%@ and planID = %ld",[skillDict valueForKey:@"ID"],(long)[PersistenceStorage getIntegerForKey:@"currentPlanID"]];
    
    NSString *query01 = [NSString stringWithFormat:@"delete from MyDevices where SkillID=%@ and planID = %ld",[skillDict valueForKey:@"ID"],(long)[PersistenceStorage getIntegerForKey:@"currentPlanID"]];
    

    
    
    NSString *query1 = [NSString stringWithFormat:@"delete from MySounds where SkillID=%@ and planID = %ld",[skillDict valueForKey:@"ID"],(long)[PersistenceStorage getIntegerForKey:@"currentPlanID"]];
    
    NSString *query1_1 = [NSString stringWithFormat:@"delete from MyOwnSounds where SkillID=%@ and planID = %ld",[skillDict valueForKey:@"ID"],(long)[PersistenceStorage getIntegerForKey:@"currentPlanID"]];
    
    NSString *query2 = [NSString stringWithFormat:@"delete from MyWebsites where SkillID=%@ and planID = %ld",[skillDict valueForKey:@"ID"],(long)[PersistenceStorage getIntegerForKey:@"currentPlanID"]];
    
    NSString *query3 = [NSString stringWithFormat:@"delete from MyActivities where SkillID=%@ and planID = %ld",[skillDict valueForKey:@"ID"],(long)[PersistenceStorage getIntegerForKey:@"currentPlanID"]];
    
    
    NSString *query4 = [NSString stringWithFormat:@"delete from MyReminders where SkillID=%@ and planID = %ld",[skillDict valueForKey:@"ID"],(long)[PersistenceStorage getIntegerForKey:@"currentPlanID"]];
    
    NSString *query4_1 = [NSString stringWithFormat:@"delete from MySkillReminders where SkillName=\"%@\" and PlanName = \"%@\"",[skillDict valueForKey:@"skillName"],self.planName];
    
    [self.dbManagerMySkills executeQuery:query01];
    [self.dbManagerMySkills executeQuery:query1];
    [self.dbManagerMySkills executeQuery:query1_1];
    [self.dbManagerMySkills executeQuery:query2];
    [self.dbManagerMySkills executeQuery:query3];
    [self.dbManagerMySkills executeQuery:query4];
    [self.dbManagerMySkills executeQuery:query4_1];
    
    
    BOOL isDone = [self.dbManagerMySkills executeQuery:query];
    if (isDone == YES)
    {
        NSLog(@"Success");
        
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"] ];
        
        hud.mode = MBProgressHUDModeCustomView;
        
        hud.labelText = @"Removed";
        
        [hud show:YES];
        [hud hide:YES afterDelay:1];

        
        
        
        
        
        
        block(YES);
    }
    else{
        NSLog(@"Error");
        block(NO);
        
    }
}


-(void)popToSkillsView
{
    NewPlanAddedViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"NewPlanAddedViewController"];
    
 
    [self.navigationController presentModalViewController:ratingsView animated:NO];}




-(void)popToPlansView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}







-(void)onDelete:(id)sender
{
    
    DeleteCormationManager *manager = [DeleteCormationManager getInstance];
    
    [manager showAlertwithPositiveBlock:^(BOOL positive) {
    
    
    UITableViewCell *cell = (UITableViewCell *)[[sender view] superview];
    
    NSIndexPath *indexPath = [self.skillsListTableView indexPathForCell:cell];
        NSLog(@"%@",skillListArray);
    
      //  [PersistenceStorage setObject:sName andKey:@"skillName"];

        [PersistenceStorage setObject:[[skillListArray objectAtIndex:indexPath.section]valueForKey:@"skillName"] andKey:@"deletingSkillName"];
//[PersistenceStorage setObject:[[skillListArray objectAtIndex:indexPath.section]valueForKey:@"planName"] andKey:@"planName"];
      //  [PersistenceStorage setObject:[[skillListArray objectAtIndex:indexPath.section]valueForKey:@"situationName"] andKey:@"situationName"];

        
        
        
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.groupID == %@",[[groupListArray objectAtIndex:indexPath.section]valueForKey:@"ID"]];
    NSArray *filteredArray = [skillListArray filteredArrayUsingPredicate:predicate];
        [self writeDeletedSkill];
        
     //before deleting lets fetch the calender even, if any
        NSString* reminderQuery = [NSString stringWithFormat:@"select CalendarEventID from MySkillReminders where SkillName = \"%@\" and  PlanName = \"%@\"",[[skillListArray objectAtIndex:indexPath.section]valueForKey:@"skillName"],self.planName ];
        NSArray* calenderEventsArray = [self.dbManagerMySkills loadDataFromDB:reminderQuery];
        if(calenderEventsArray.count > 0){
            CalEventIDString = [[calenderEventsArray objectAtIndex:0] valueForKey:@"CalendarEventID"];
        }
        if([[[skillListArray objectAtIndex:indexPath.section]valueForKey:@"skillName"]  isEqualToString:@"Tips for Better Sleep"]){
            isTBSDeleted = YES;
        }else{
            isTBSDeleted = NO;
        }
    [self deleteSkillFromDB:[filteredArray objectAtIndex:indexPath.row] andCompletion:^(BOOL success)
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
             //remove the corresponding calender events
             if(CalEventIDString != nil)
                 [self removeEventFromCalender:CalEventIDString];
             [self loadMySkillsData];
             if(isTBSDeleted)
                 [self checkAndDeleteTBSReminders];

             
         }
         
     }];
    } negativeBlock:^(BOOL negative) {
        
        //DO nothing
    }];

}

-(void)removeEventFromCalender:(NSString*)eventID{
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) return;
        EKEvent* eventToRemove = [store eventWithIdentifier:eventID];
        if (eventToRemove) {
            NSError* err = nil;
            //    [store removeEvent:eventToRemove span:EKSpanThisEvent commit:YES error:&err];
            [store removeEvent:eventToRemove span:EKSpanFutureEvents commit:YES error:&err];
            if(err == nil){
                CalEventIDString = nil;
            }
        }
    }
     
     ];
    
}

-(void)checkAndDeleteTBSReminders{
    //check if no TBS is left in DB
    NSString* queryforTBS = @"select * from MySkills where skillID = 7";
    NSArray* TBSArray = [self.dbManagerMySkills loadDataFromDB:queryforTBS];
    if (TBSArray.count == 0) {
        [PersistenceStorage setObject:@"No" andKey:@"TipsActivated"];
        // remove the reminders if any
        NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
        for(UILocalNotification *notification in notificationArray){
            if ([notification.alertBody isEqualToString:@"Tips for Sleep Feedback"]) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification] ;
                 NSLog(@"!!!!!!!!!!!!TBS notifocation Cancelled!!!!!!!!!!!!!!!");
            }
            
            
        }

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)weeklyTapped:(id)sender
{
    WeeklyViewController *week = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier: @"WeeklyViewController"];

    
//[self.navigationController presentModalViewController:week animated:YES];
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
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,@"Removed Skill",[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"situationName"],[PersistenceStorage getObjectForKey:@"deletingSkillName"],nil,nil,nil,nil,nil,nil,nil,nil];
    
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
        UIImageView *accessory = [[UIImageView alloc]initWithFrame:CGRectMake(286, 15, 13, 13)];
        
        [accessory setImage:[UIImage imageNamed:@"Active_Next-Arrow.png"]];
        
        [cell addSubview:accessory];
        
        UIImageView *deleteButton = [[UIImageView alloc]initWithFrame:CGRectMake(13, 8, 27, 27)];
        
        [deleteButton setImage:[UIImage imageNamed:@"Active_Trash_Button.png"]];
        
        deleteButton.tag = indexPath.row;
        
        [Utils addTapGestureToView:deleteButton target:self selector:@selector(onDelete:)];
        
        [cell addSubview:deleteButton];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(55 , 11, 210, 20)];
        
        titleLabel.tag = 1007;
        
        Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_4];
        
        titleLabel.font = pallete.secondObj;
        titleLabel.textColor = pallete.firstObj;
        
        
        titleLabel.adjustsFontSizeToFitWidth = YES;
        
        
        
        
        [cell addSubview:titleLabel];
        
        UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(55, 44, 298, 1)];
        
        separator.backgroundColor = [Utils colorWithHexValue:@"EEEEEE"];
        
        [cell addSubview:separator];
        
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.groupID == %@",[[groupListArray objectAtIndex:indexPath.section]valueForKey:@"ID"]];
    NSArray *filteredArray = [skillListArray filteredArrayUsingPredicate:predicate];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1007];
    
    titleLabel.text =[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"skillName"];
    
    return cell;
    
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self heightForIndexPath:indexPath];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 56.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *videoHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 56.0)];
    
    videoHeaderView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 24.0, 200.0, 20.0)];
    label.text = [[groupListArray objectAtIndex:section] valueForKey:@"groupName"];
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_3];
    label.font = pallete.secondObj;
    label.textColor = pallete.firstObj;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(20, videoHeaderView.frame.size.height - 1, 300, 1)];
    
    line.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.098/255.0 alpha:0.22];;
    
    [videoHeaderView addSubview:line];
    
    [videoHeaderView addSubview:label];
    return videoHeaderView;

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if(section != tableView.numberOfSections - 1)
        return 10;
    else
        return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if(section != tableView.numberOfSections - 1)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
        
        view.backgroundColor = [Utils colorWithHexValue:NAV_BAR_BLACK_COLOR];
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height - 1, 320, 1)];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
        
        line1.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.098/255.0 alpha:0.22];;
        
        line2.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.098/255.0 alpha:0.22];;
        
        [view addSubview:line1];
        [view addSubview:line2];
        
        return view;
    }
    
    return nil;
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
    return NO;
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
