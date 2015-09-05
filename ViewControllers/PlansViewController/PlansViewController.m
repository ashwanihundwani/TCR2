//
//  PlansViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 3/18/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "PlansViewController.h"
#import "AddNewPlanViewController.h"
#import "NewPlanSupportViewController.h"
#import "NewPlanAddedViewController.h"
#import "DeleteCormationManager.h"
#import "MBProgressHUD.h"
#import <EventKitUI/EventKitUI.h>
@interface PlansViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *userPlansArray, *calenderEventsArray, *sleepEventsArray;
}


@property (weak, nonatomic) IBOutlet UITableView *plansTableView;
@property (nonatomic, strong) DBManager *dbManagerMyPlans;
@property (nonatomic, strong) DBManager *dbManagerMySkills;

@property (weak, nonatomic) IBOutlet UIButton *addNewPlanBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerLabelHeightConst;
@end

@implementation PlansViewController

-(CGFloat)heightForIndexPath:(NSIndexPath *)indexPath
{
    CGFloat constant = 27;
    
    NSString *planName = [[userPlansArray objectAtIndex:indexPath.row] valueForKey:@"planName"];
    
    CGFloat labelHeight = [Utils heightForLabelForString:planName width:200 font:TITLE_LABEL_FONT];
    
    constant += labelHeight;
    
    return constant;

}

-(void)goToHome
{
    self.tabBarController.selectedIndex = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.plansTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    titleView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_1];
    
    titleLabel.font = pallete.secondObj;
    titleLabel.textColor = pallete.firstObj;
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //titleLabel.textColor = [UIColor colorWithHexValue:@"797979"];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"Plans";
    
    [titleView addSubview:titleLabel];
    
    self.navigationItem.titleView = titleView;
    
    UIImageView *backLabel = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 15, 20)];
    
    backLabel.image = [UIImage imageNamed:@"Active_Back-Arrow.png"];
    
    [Utils addTapGestureToView:backLabel target:self
                      selector:@selector(goToHome)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backLabel];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -8;
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, item, nil];
    
    UILabel *intro = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, 20)];
    
    intro.textAlignment = NSTextAlignmentRight;
    
    intro.text = @"Intro";
    
    pallete = [Utils getColorFontPair:eCFS_PALLETE_3];
    
    intro.font = pallete.secondObj;
    intro.textColor = pallete.firstObj;
    
    [Utils addTapGestureToView:intro target:self
                      selector:@selector(showIntroView)];
    
    item = [[UIBarButtonItem alloc]initWithCustomView:intro];
    
    negativeSpacer = [[UIBarButtonItem alloc]
                      initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                      target:nil action:nil];
    negativeSpacer.width = 22;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:item, negativeSpacer,nil];
    
    self.dbManagerMyPlans = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    
    self.dbManagerMySkills = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];

    
    if (![[PersistenceStorage getObjectForKey:@"shownPlansIntro"] isEqual: @"OK"])
        
    {
        
        
              [self showIntroView];
        
    }
    
    [PersistenceStorage setObject:@"OK" andKey:@"shownPlansIntro"];
    

    
    
    
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    
        [self writeVisitedPlans];
   
    [self.tabBarController.tabBar setHidden:NO];

    
   //  if ([[PersistenceStorage getObjectForKey:@"shownPlanIntro"] isEqual: @"YES"])
  //   {
//}
   //  else{
 //       [self showIntroView];
     //   [PersistenceStorage setObject:@"YES" andKey:@"shownPlanIntro"];
        
    
     }

        
    




-(void)viewWillAppear:(BOOL)animated
{    [self loadMyPlans];
    
    
 
    
    
}


-(UIView *)tableHeaderView
{
    if(userPlansArray.count == 3)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 15, 276, 20)
                               ];
        
        titleLabel.numberOfLines = 1000;
        
        titleLabel.backgroundColor = [UIColor clearColor];
        view.backgroundColor = [Utils colorWithHexValue:@"EFEFF4"];
        
        titleLabel.text = @"To add a new plan, first delete one of the existing three plans.";
        
        Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_2];
        
        titleLabel.font = pallete.secondObj;
        titleLabel.textColor = pallete.firstObj;
        
        CGFloat height = [Utils heightForLabelForString:titleLabel.text width:276 font:pallete.secondObj];
        
        titleLabel.height = height;
        
        view.height += height;
        
        [view addSubview:titleLabel];
        
        return view;
        
    }
    else
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 15, 276, 20)
                               ];
        
        titleLabel.numberOfLines = 1000;
        
        titleLabel.backgroundColor = [UIColor clearColor];
        view.backgroundColor = [Utils colorWithHexValue:@"EFEFF4"];
        
        titleLabel.text = @"You can add up to 3 plans.";
        
        Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_2];
        
        titleLabel.font = pallete.secondObj;
        titleLabel.textColor = pallete.firstObj;
        
        CGFloat height = [Utils heightForLabelForString:titleLabel.text width:276 font:pallete.secondObj];
        
        titleLabel.height = height;
        
        view.height += height;
        
        [view addSubview:titleLabel];
        
        UILabel *addButton = [[UILabel alloc]initWithFrame:CGRectMake(320 / 2 - 218 / 2, titleLabel.y+ titleLabel.height + 10, 218, 40)];
        
        addButton.layer.cornerRadius = 5;
        addButton.layer.masksToBounds = YES;
        addButton.font = [UIFont boldSystemFontOfSize:17];
        addButton.text = @"+ Add a New Plan";
        addButton.textAlignment = NSTextAlignmentCenter;
        addButton.textColor = [UIColor whiteColor];
        addButton.backgroundColor = [Utils colorWithHexValue:BUTTON_BLUE_COLOR_HEX_VALUE];
        
        [Utils addTapGestureToView:addButton target:self selector:@selector(addPlanButtonClicked:)];
        
        [view addSubview:addButton];
        
        view.height = addButton.y + addButton.height + 10;
        
        return view;
        
    }
}

-(void)loadMyPlans{
    NSString *query = @"select * from MyPlans";
    
    
    UILabel *firstLabel = (UILabel *)[self.view viewWithTag:100];
    

    
    // Get the results.
    if (userPlansArray!= nil) {
        userPlansArray = nil;
    }
    userPlansArray = [[NSMutableArray alloc] initWithArray:[self.dbManagerMyPlans loadDataFromDB:query]];
//    if ([userPlansArray count]==3) {
//        [self.addNewPlanBtn setUserInteractionEnabled:NO];
//        self.addNewPlanBtn.titleLabel.textColor = [UIColor grayColor];
// 
//            firstLabel.text = @"To add a new plan, first delete one of the existing three plans.";
//        [[self.view viewWithTag:3] setHidden:YES];
//    
//    }
//    else
//    {
//        firstLabel.text = @"You can add up to 3 plans.";
//        [[self.view viewWithTag:3] setHidden:NO];
//    }
    
        
 //
    
    self.plansTableView.tableHeaderView = [self tableHeaderView];
    
    // Reload the table view.
    [self.plansTableView reloadData];
}


-(void)goToHomeView
{
    [[Utils rootTabBarController] setSelectedIndex:0];
}

-(void)deletePlanFromDB:(NSDictionary *)planDict andCompletion:(void (^)(BOOL success))block
{
    NSString* planID = [planDict objectForKey:@"ID"];
    NSString* planName = [planDict objectForKey:@"planName"];
    NSLog(@"Deleting object with plan ID:%@ and planName:%@",planID, planName);
    NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    
//    VIKRAM 2 Sept 2015
    
// Make the list of skills separated by | and insert into SkillDetail3
    // This is inserted in the row. Refer writeDeletedPlan
    
    
    NSString *querySkills = [NSString stringWithFormat: @"select skillName from Plan_Skills Inner JOIN MySkills on MySkills.SkillID = Plan_Skills.ID where MySkills.PlanID = %@",planID];
 
    
    NSArray* skillArr = [self.dbManagerMySkills loadDataFromDB:querySkills];
    
    
    NSMutableString *skillString =[NSMutableString stringWithString:@""];
    
    
    for(int i= 0 ;i<[skillArr count];i++)
    {
        
        
        [skillString appendString:[[skillArr objectAtIndex:i] valueForKey:@"skillName"]];
        [skillString appendString:@"|"];
        
        
    }
    
    if ([skillString length] > 0) {
        NSString *outPut = skillString;
        outPut = [outPut substringToIndex:[outPut length] - 1];
        NSLog(@"%@",outPut);
        [PersistenceStorage setObject:outPut andKey:@"skillDetail3"];
        
        
    }
    
    
    for(UILocalNotification *notification in notificationArray){
       // if ([notification.alertBody containsString:@"'Imagery'"])
            
        if ([[notification.userInfo valueForKey:@"PlanName"] isEqualToString:planName] && ![[notification.userInfo valueForKey:@"Type"] isEqualToString:@"Tips for Better Sleep"])
        {
            NSLog(@"cancelling notification for plan:%@ and skill:%@",planName,[notification.userInfo valueForKey:@"Type"] );
            [[UIApplication sharedApplication] cancelLocalNotification:notification] ;
        }
        
        
    }
    
    NSString *query01 = [NSString stringWithFormat:@"delete from MyPlans where ID=%@",planID];
    
           NSString *query2 = [NSString stringWithFormat:@"delete from MySounds where planID = '%@'",planID];
    
            NSString *query2_1 = [NSString stringWithFormat:@"delete from MyOwnSounds where planID = '%@'",planID];
   
    
    NSString *query02 = [NSString stringWithFormat:@"delete from MySkills where planID = '%@'",planID];
    
     
    //   NSString *query2 = [NSString stringWithFormat:@"delete from MySounds where planID = '%@'",];
    
    NSString *query5 = [NSString stringWithFormat:@"delete from MyWebsites where planID = '%@'",planID];
    
    
    NSString *query3 = [NSString stringWithFormat:@"delete from MyReminders where PlanName = '%@'",planName];
    
    NSString *query4 = [NSString stringWithFormat:@"delete from MySkillReminders where PlanName = '%@' and SkillName != 'Tips for Better Sleep' ",planName];
    
    NSString *query4_1 = [NSString stringWithFormat:@"delete from MySkillReminders where SkillName = 'Tips for Better Sleep' "];
    
    NSString *query6 = [NSString stringWithFormat:@"delete from MyActivities where planID = '%@'",planID];
    
    
    NSString *query7 = [NSString stringWithFormat:@"delete from My_Tips where planID = %@",planID];
    
    NSString *query8 = [NSString stringWithFormat:@"delete from My_Contacts "];
    NSString *query9 = [NSString stringWithFormat:@"delete from MyDevices where planID = '%@'",planID];
    NSString *query10 = [NSString stringWithFormat:@"delete from My_TF_Set where planID = '%@'",planID];

                        [self.dbManagerMyPlans executeQuery:query02];
                        [self.dbManagerMyPlans executeQuery:query2];
                        [self.dbManagerMyPlans executeQuery:query2_1];
                        [self.dbManagerMyPlans executeQuery:query3];
                        [self.dbManagerMyPlans executeQuery:query4];
                        [self.dbManagerMyPlans executeQuery:query5];
                        [self.dbManagerMyPlans executeQuery:query6];
                        [self.dbManagerMyPlans executeQuery:query7];
                     //   [self.dbManagerMyPlans executeQuery:query8];
                        [self.dbManagerMyPlans executeQuery:query9];
                        [self.dbManagerMyPlans executeQuery:query10];

    
    NSString* queryforTBS = @"select * from MySkills where skillID = 7";
    NSArray* TBSArray = [self.dbManagerMyPlans loadDataFromDB:queryforTBS];
    if (TBSArray.count == 0) {
        [self.dbManagerMyPlans executeQuery:query4_1];
    }
    
    BOOL isDone = [self.dbManagerMyPlans executeQuery:query01];
    if (isDone == YES)
    {
        [self writeDeletedPlan];

        NSLog(@"Success");
        block(YES);
    }
    else{
        NSLog(@"Error");
        block(NO);
        
    }
    
       [self loadMyPlans];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"] ];
    
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.labelText = @"Removed";
    
    [hud show:YES];
    [hud hide:YES afterDelay:1];

    
    
    
    
    
    
    
    

       }


-(NSString *)getPlanIDForName:(NSString *)planName
{
    NSString *query = [NSString stringWithFormat: @"select ID from MyPlans where planName == '%@'", planName];
    
    NSString *planID = [[[self.dbManagerMyPlans loadDataFromDB:query]objectAtIndex:0] valueForKey:@"ID"];
   

    
    
    return planID;
    
}

-(void)showIntroView
{
    [self writeViewedIntroduction];
    NewPlanSupportViewController *npsv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NewPlanSupportViewController"];
    
    [self.navigationController pushViewController:npsv animated:NO];
}

//-(void)onDelete:(id)sender
//{
//    NSInteger tag = [[sender view] tag];
//    
//    [self deletePlanFromDB:[userPlansArray objectAtIndex:tag] andCompletion:^(BOOL success)
//     {
//         if (success) {
//             
//             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
//             [userPlansArray removeObjectAtIndex:tag];
//             
//             [self.plansTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
//             [self.plansTableView reloadData];
//             
//             
//         }
//         
//     }];
//}

-(void)onDelete:(id)sender

{
    DeleteCormationManager *manager = [DeleteCormationManager getInstance];
    
    [manager showAlertwithPositiveBlock:^(BOOL positive) {
        
        NSInteger tag = [[sender view] tag];
        
        
        
        
        
        
        
        
        
        [PersistenceStorage setObject:[[userPlansArray objectAtIndex:tag] valueForKey:@"planName"] andKey:@"deletingPlanName"];
        [PersistenceStorage setObject:[[userPlansArray objectAtIndex:tag] valueForKey:@"situationName"] andKey:@"deletingSituationName"];

         NSString* reminderQuery = [NSString stringWithFormat:@"select CalendarEventID from MySkillReminders where PlanName = \"%@\"",[[userPlansArray objectAtIndex:tag] valueForKey:@"planName"]  ];
        NSString* sleepReminderQuery = @"select CalendarEventID from MySkillReminders where SkillName = 'Tips for Better Sleep'";
        NSArray* caleventsArray = [self.dbManagerMyPlans loadDataFromDB:reminderQuery];
        if(caleventsArray.count > 0){
            calenderEventsArray = [[NSMutableArray alloc]init];
            [calenderEventsArray addObjectsFromArray:caleventsArray];
        }else{
            calenderEventsArray = nil;
        }
        NSArray* sleepArray = [self.dbManagerMyPlans loadDataFromDB:sleepReminderQuery];
        if(sleepArray.count > 0){
            sleepEventsArray = [[NSMutableArray alloc]init];
            [sleepEventsArray addObjectsFromArray:sleepArray];
        }else{
            sleepEventsArray = nil;
        }
        if(calenderEventsArray != nil && sleepEventsArray != nil)
            [calenderEventsArray removeObjectsInArray:sleepEventsArray];
        //get the activities reminders
        reminderQuery = [NSString stringWithFormat:@"select CalendarEventID from MyReminders where PlanName = \"%@\"",[[userPlansArray objectAtIndex:tag] valueForKey:@"planName"]];
        NSArray* arr2 = [self.dbManagerMyPlans loadDataFromDB:reminderQuery];
        if(arr2.count > 0){
            if(calenderEventsArray){
                [calenderEventsArray addObjectsFromArray:arr2];
                
            }else{
                calenderEventsArray = [[NSMutableArray alloc] init];
                [calenderEventsArray addObjectsFromArray:arr2];
            }
        }
        [self deletePlanFromDB:[userPlansArray objectAtIndex:tag] andCompletion:^(BOOL success)
         {
             if (success) {
                 
                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
                 [userPlansArray removeObjectAtIndex:tag];
                 [self.plansTableView reloadData];
                 [self removeEventsFromCalender];
                 [self checkAndDeleteTBSReminders];
                 
             }
             
         }];
        
        
    } negativeBlock:^(BOOL negative) {
        
        //DO nothing
    }];
}


-(void)removeEventsFromCalender{
    
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) return;
        NSMutableArray* eventList = [[NSMutableArray alloc] initWithCapacity:calenderEventsArray.count];
        for (NSDictionary* eventDict in calenderEventsArray) {
            NSString* calEventID = [eventDict valueForKey:@"CalendarEventID"];
            EKEvent* eventToRemove = [store eventWithIdentifier:calEventID];
            if(eventToRemove != nil)
                [eventList addObject:eventToRemove];
        }
        
        for (EKEvent* eventToRemove in eventList) {
            NSError* err = nil;
            [store removeEvent:eventToRemove span:EKSpanFutureEvents commit:YES error:&err];
            if(err != nil){
                NSLog(@"Error in deletining event from calender:%@", [eventToRemove description]);
            }
        }
    }
     
     ];
}

-(void)checkAndDeleteTBSReminders{
    //check if no TBS is left in DB
    NSString* queryforTBS = @"select * from MySkills where skillID = 7";
    NSArray* TBSArray = [self.dbManagerMyPlans loadDataFromDB:queryforTBS];
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
        
        // remove calender events if any
        EKEventStore *store = [[EKEventStore alloc] init];
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (!granted) return;
            NSMutableArray* eventList = [[NSMutableArray alloc] initWithCapacity:calenderEventsArray.count];
            for (NSDictionary* eventDict in sleepEventsArray) {
                NSString* calEventID = [eventDict valueForKey:@"CalendarEventID"];
                if (calEventID.length == 0) {
                    continue;
                }
                EKEvent* eventToRemove = [store eventWithIdentifier:calEventID];
                if(eventToRemove != nil)
                    [eventList addObject:eventToRemove];
            }
            
            for (EKEvent* eventToRemove in eventList) {
                NSError* err = nil;
                [store removeEvent:eventToRemove span:EKSpanFutureEvents commit:YES error:&err];
                if(err != nil){
                    NSLog(@"Error in deletining event from calender:%@", [eventToRemove description]);
                }
            }
        }
         
         ];
    }
}

-(BOOL)isSleepEvent:(NSString*)eventID{
    BOOL retVal = NO;
    for (NSDictionary* sleepDict in sleepEventsArray) {
        if([eventID isEqualToString:[sleepDict valueForKey:@"CalendarEventID"]]){
            retVal = YES;
            break;
        }
    }
    return retVal;
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
    return [userPlansArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    if (cell == nil) {
        cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        UIImageView *accessory = [[UIImageView alloc]initWithFrame:CGRectMake(286, 15, 13, 13)];
        
        [accessory setImage:[UIImage imageNamed:@"Active_Next-Arrow.png"]];
        
        [cell addSubview:accessory];
        
        UIImageView *deleteButton = [[UIImageView alloc]initWithFrame:CGRectMake(13, 8, 27, 27)];
        
        [deleteButton setImage:[UIImage imageNamed:@"Active_Trash_Button.png"]];
        
        deleteButton.tag = indexPath.row;
        
        [Utils addTapGestureToView:deleteButton target:self selector:@selector(onDelete:)];
        
        [cell addSubview:deleteButton];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(55 , 11, 200, 20)];
        
        titleLabel.numberOfLines = 10;
        
        titleLabel.tag = 1007;
        
        Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_4];
        
        titleLabel.font = pallete.secondObj;
        titleLabel.textColor = pallete.firstObj;
        
        [cell addSubview:titleLabel];
        
        UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(55, 44, 298, 1)];
        
        separator.tag = 345;
        separator.backgroundColor = [Utils colorWithHexValue:@"EEEEEE"];
        
        [cell addSubview:separator];
        
        
    }
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1007];
    
    NSString *planName = [[userPlansArray objectAtIndex:indexPath.row] valueForKey:@"planName"];
    
    CGFloat labelHeight = [Utils heightForLabelForString:planName width:200 font:TITLE_LABEL_FONT];
    
    
    titleLabel.height = labelHeight;
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    titleLabel.text =[[userPlansArray objectAtIndex:indexPath.row] valueForKey:@"planName"];
    
    UIView *separator = [cell viewWithTag:345];
    
    CGFloat height = [self heightForIndexPath:indexPath];
    
    separator.y = height - 1;
    
    return cell;
    
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self heightForIndexPath:indexPath];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{ 
    NewPlanAddedViewController *npav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NewPlanAddedViewController"];
    
    npav.planName = [[userPlansArray objectAtIndex:indexPath.row] valueForKey:@"planName"];
    NSString *sitName = [[userPlansArray objectAtIndex:indexPath.row] valueForKey:@"situationName"];

    [PersistenceStorage setObject:[self getPlanIDForName:npav.planName] andKey:@"currentPlanID"];
 
    [PersistenceStorage setObject:sitName andKey:@"situationName"];

      [PersistenceStorage setObject:[[userPlansArray objectAtIndex:indexPath.row] valueForKey:@"planName"] andKey:@"planName"];
    
    
    
     [self.navigationController pushViewController:npav animated:YES];
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"X" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(userPlansArray.count > 0)
    return 56;
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *videoHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 56.0)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 24.0, 200.0, 20.0)];
    label.text = @"Use a Plan";
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_3];
    label.font = pallete.secondObj;
    label.textColor = pallete.firstObj;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(20, videoHeaderView.frame.size.height - 1, 300, 1)];
    
    line.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.098/255.0 alpha:0.22];;
    
    [videoHeaderView addSubview:line];
    
    [videoHeaderView addSubview:label];
    return videoHeaderView;
}



-(void)writeDeletedPlan{
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
    
    NSString *str = @"Removed Plan";
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,[PersistenceStorage getObjectForKey:@"deletingPlanName"],[PersistenceStorage getObjectForKey:@"deletingSituationName"],nil,[PersistenceStorage getObjectForKey:@"skillDetail3"],nil,nil,nil,nil,nil,nil,nil];
    
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







#pragma mark - Button Click Events

- (IBAction)addPlanButtonClicked:(id)sender {
    if ([userPlansArray count]<3) {
        AddNewPlanViewController *anpv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AddNewPlanViewController"];
        [self.navigationController pushViewController:anpv animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tinnitus Coach" message:@"You cannot add more than 3 plans" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)writeVisitedPlans{
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
    
    NSString *str = @"Plans";
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil];
    
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



-(void)writeViewedIntroduction{
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
    
    NSString *str = @"Watched the Plan Introduction";
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil];
    
    
    
    
    
    
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
