//
//  ActivitiesViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 28/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//
#import "SkillRatingsViewController.h"
#import "NookPA.h"
#import "PleasantActivityViewController.h"
#import "HomeViewController.h"
#import "DoingActivityViewController.h"
#import "ActivitiesViewController.h"
#import "ActivityRatingsViewController.h"
#import "AddActivityViewController.h"
#import "ScheduleViewController.h"
#import "NewPlanAddedViewController.h"
#import "DeleteCormationManager.h"
#import "MBProgressHUD.h"
#import <EventKit/EventKit.h>


@interface ActivitiesViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>{
    NSArray *activityArray;
    NSArray *favoritesArray;
    NSString *strAct;
    NSString* CalenderEventID;
}
@end

@implementation ActivitiesViewController
-(CGFloat)heightForIndexPath:(NSIndexPath *)indexPath
{
    CGFloat constant = 90;
    
    NSDictionary *dict = [activityArray objectAtIndex:indexPath.row];
    
    NSString *actName = [dict valueForKey:@"activityName"];
    
    CGFloat labelHeight = [Utils heightForLabelForString:actName width:229 font:TITLE_LABEL_FONT];
    
    constant += labelHeight;
    
    return constant;
    
}

-(void)onAddActivity:(id)sender
{
    [self addActivityTapped:self];
}

-(UIView *)tableHeaderView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 196)];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    
    backView.backgroundColor = [Utils colorWithHexValue:@"EFEFF4"];
    
    [view addSubview:backView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(22, 10, 276, 40)];
    
    NSString *string = [PersistenceStorage getObjectForKey:@"valueDescription"];
    
    string = [string stringByTrimmingCharactersInSet:
              [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    label.text = string;
    
    label.numberOfLines = 2;
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_2];
    
    label.textColor = pallete.firstObj;
    label.font = pallete.secondObj;
    
    [view addSubview:label];
    
    UILabel *activityLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 70, 180, 35)];
    
    activityLabel.textAlignment = NSTextAlignmentCenter;
    
    activityLabel.text= @"Add New Activity";
    
    
    activityLabel.textColor = [UIColor whiteColor];
    activityLabel.font = [UIFont boldSystemFontOfSize:15];
    activityLabel.layer.cornerRadius = 5;
    activityLabel.layer.masksToBounds = YES;
    
    activityLabel.backgroundColor = [Utils colorWithHexValue:@"007AFF"];
    
    [Utils addTapGestureToView:activityLabel target:self selector:@selector(onAddActivity:)];
    
    [view addSubview:activityLabel];
    
    UIView *topSeparator = [[UIView alloc]initWithFrame:CGRectMake(22, 110, 300, 1)];
    
    topSeparator.backgroundColor = [Utils colorWithHexValue:@"EEEEEE"];
    
    [view addSubview:topSeparator];
    
    UILabel *actLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 120, 200, 21)];
    
    actLabel.text = @"Activities";
    
    pallete = [Utils getColorFontPair:eCFS_PALLETE_3];
    
    actLabel.font = pallete.secondObj;
    
    actLabel.textColor = pallete.firstObj;
    
    [view addSubview:actLabel];
    
    UILabel *actLabelDesc = [[UILabel alloc]initWithFrame:CGRectMake(22, 145, 276, 40)];
    
    actLabelDesc.numberOfLines = 2;
    
    actLabelDesc.text = @"Schedule one of the activities below, or add a new activity to the list.";
    
    pallete = [Utils getColorFontPair:eCFS_PALLETE_4];
    
    actLabelDesc.font = pallete.secondObj;
    
    actLabelDesc.textColor = pallete.firstObj;
    
    [view addSubview:actLabelDesc];
    
    UIView *bottomSeparator = [[UIView alloc]initWithFrame:CGRectMake(22, 195, 300, 1)];
    
    bottomSeparator.backgroundColor = [Utils colorWithHexValue:@"EEEEEE"];
    
    [view addSubview:bottomSeparator];
    
    
    
    return view;
}

-(void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    titleView.backgroundColor = [Utils colorWithHexValue:NAV_BAR_BLACK_COLOR];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_1];
    
    titleLabel.font = pallete.secondObj;
    titleLabel.textColor = pallete.firstObj;
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //titleLabel.textColor = [UIColor colorWithHexValue:@"797979"];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = [PersistenceStorage getObjectForKey:@"valueName"];
    
    [titleView addSubview:titleLabel];
    
    self.navigationItem.titleView = titleView;
    
    UIImageView *backLabel = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 15, 20)];
    
    backLabel.image = [UIImage imageNamed:@"Active_Back-Arrow.png"];
    
    [Utils addTapGestureToView:backLabel target:self
                      selector:@selector(cancel)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backLabel];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -8;
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, item, nil];
    
    self.activityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.activityTableView.tableHeaderView = [self tableHeaderView];

}

-(void)setUpView{
    [self.activityTableView registerNib:[UINib nibWithNibName:@"ActivityCell" bundle:nil] forCellReuseIdentifier:@"ActivityCell"];
    [self.activityTableView setDataSource:self];
    [self.activityTableView setDelegate:self];
    //    [self.activityTableView setBackgroundColor:[UIColor lightGrayColor]];
    [self loadData];
}

-(void)loadData{
    self.manager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM Plan_Activities LEFT OUTER  JOIN myReminders ON Plan_Activities.ActivityName = MyReminders.ActName and MyReminders.PlanName = '%@' where valueName IS '%@' order by  CreatedDate DESC",[Utils getValidSqlString:[PersistenceStorage getObjectForKey:@"planName"]],[PersistenceStorage getObjectForKey:@"valueName"]];
    
    
    
    
    
    
    // Get the results.
    if (activityArray!= nil) {
        activityArray = nil;
    }
    activityArray = [[NSArray alloc] initWithArray:[self.manager loadDataFromDB:query]];
    
    
    NSString *queryFav = [NSString stringWithFormat:@"SELECT * FROM Plan_Activities  LEFT OUTER  JOIN myReminders ON Plan_Activities.ActivityName = MyReminders.ActName  inner join MyActivities on Plan_Activities.ID=MyActivities.activityID where MyActivities.planID = %@  order by  CreatedDate DESC",[PersistenceStorage getObjectForKey:@"currentPlanID"]];
    
    
    
    
    //  LEFT OUTER  JOIN myReminders ON Plan_Activities.ActivityName = MyReminders.ActName  where valueName IS '%@' order by  CreatedDate DESC",[PersistenceStorage getObjectForKey:@"valueName"]
    
    
    // Get the results.
    if (favoritesArray!= nil) {
        favoritesArray = nil;
    }
    favoritesArray = [[NSArray alloc] initWithArray:[self.manager loadDataFromDB:queryFav]];
    // Reload the table view.
    
    
    // NSLog(@"FAV ARRAY %@",favoritesArray);
    //   NSLog(@"FAV ARRAY %@",activityArray);
    
    // Reload the table view.
    [self.activityTableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self setUpView];
    
    //  [self.activityTableView reloadData];
    //[self loadData];
}






-(void)viewWillDisAppear:(BOOL)animated{
    
    
    
    
}


-(void)viewDidAppear:(BOOL)animated{
    [self setUpView];
    //  [self.activityTableView reloadData];
    
    // [self loadData];
    
    // NSLog(@"Did appear");
    
    
    UILabel *firstLabel = (UILabel *)[self.view viewWithTag:200];
    
    firstLabel.text = [PersistenceStorage getObjectForKey:@"valueDescription"];
    
    
    
    self.title = [PersistenceStorage getObjectForKey:@"valueName"];
    if ([[PersistenceStorage getObjectForKey:@"Referer"] isEqual: @"DoingActivityVC"]) {
        ActivityRatingsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"ActivityRatingsViewController"];
        
        //ratingsView.skillSection = @"Sounds";
        //  ratingsView.skillDetail = self.name;
        
        //[self.navigationController pushViewController:ratingsView animated:YES];
        [self.navigationController presentModalViewController:ratingsView animated:YES];
    }
    
    
    if ([[PersistenceStorage getObjectForKey:@"Referer"] isEqual: @"ActivityRatingsVC"]) {
        NSString *actionSheetTitle = @"Where would you like to go now?"; //Action Sheet Title
        NSString *other0 = @"Repeat This Skill"; //Action Sheet Button Titles
        NSString *other1 = @"Learn About This Skill";
        NSString *other2 = @"Try Another Skill";
        NSString *other3 = @"Return Home";
        //   NSString *other4 = @"Return Home";
        NSString *cancelTitle = @"Cancel";
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:actionSheetTitle
                                      delegate:self
                                      cancelButtonTitle:nil
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:other0, other1, other2, other3, nil];
        
        [actionSheet showInView:self.view];
        
        
        
        
        [PersistenceStorage setObject:@"OK" andKey:@"Referer"];
        
    }
    
    if([PersistenceStorage getBoolForKey:@"NewUserDefinedActivityAdded"]){
        [PersistenceStorage setBool:NO andKey:@"NewUserDefinedActivityAdded"];
        //show hUD
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"] ];
        
        hud.mode = MBProgressHUDModeCustomView;
        
        hud.labelText = @"Added Activity";
        
        [hud show:YES];
        [hud hide:YES afterDelay:1];
    }
    
    
    
    
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    //   NSString * theValue = [(UILabel*)[self viewWithTag:t200] text];
    
    
    
    
    if  ([buttonTitle isEqualToString:@"Repeat This Skill"]) {
        
        PleasantActivityViewController *pa = nil;//[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"PleasantActivityViewController"];
        //   audioPanning.url = [dict valueForKey:@"soundURL"];
        // audioPanning.name = [dict valueForKey:@"soundName"];
        // audioPanning.panning = audio;
        for (UIViewController* controller in [self.navigationController viewControllers]) {
            if([controller isKindOfClass:[PleasantActivityViewController class]]){
                pa = (PleasantActivityViewController*)controller;
                break;
            }
        }
        if(pa != nil){
            [self.navigationController popToViewController:pa animated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    if ([buttonTitle isEqualToString:@"Learn About This Skill"]) {
        NookPA *samplerView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookPA"];
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
        DoingActivityViewController *svc1 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"DoingActivityViewController"];
        [self.navigationController pushViewController:svc1 animated:YES];
        
        //[self.navigationController presentModalViewController:svc1 animated:NO];
    }
    
    
    
    if ([buttonTitle isEqualToString:@"Schedule Activity"]) {
        //  [PersistenceStorage setObject:@"Yes" andKey:@"showCancelActivityButton"];
        ScheduleViewController *svc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ScheduleViewController"];
        svc.name = strAct;
        svc.activityText = strAct;
        [self.navigationController pushViewController:svc animated:YES];
    }
    
    if ([buttonTitle isEqualToString:@"Cancel Scheduled Activity"]) {
        [PersistenceStorage setObject:@"Yes" andKey:@"showCancelActivityButton"];
        ScheduleViewController *svc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ScheduleViewController"];
        
        svc.activityText = strAct;
        svc.name = strAct;
        [self.navigationController pushViewController:svc animated:YES];
    }
    
    
    
    
    
    
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [activityArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [activityArray objectAtIndex:indexPath.row];
    
    ActivityCell *activityCell;
    
    if (activityCell==nil) {
        activityCell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
        
    }
    activityCell.initialImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    activityCell.initialImageView.layer.borderWidth = 0.2f;
    activityCell.layer.borderColor = [UIColor grayColor].CGColor;
    activityCell.layer.borderWidth = 0.5f;
    [activityCell setBackgroundColor:[UIColor whiteColor]];
    activityCell.activityNameButton.numberOfLines = 1000;
    activityCell.activityNameButton.text = [dict valueForKey:@"activityName"];
    
    [Utils addTapGestureToView:activityCell.activityNameButton target:self selector:@selector(buttonTapped:)];
    
    if ([[dict valueForKey:@"ScheduledDate"] length]>5)
        
    {
        activityCell.dateLabel.text =[dict valueForKey:@"ScheduledDate"];
    }
    else
    {
        activityCell.dateLabel.text = @"Not Scheduled";
    }
    
    
    if ( [self isActivityFavorite:[dict valueForKey:@"activityName"]] )
    {
        [activityCell.favoriteButton setTitle:@"✓ Favorite" forState:UIControlStateNormal];
        activityCell.favoriteButton.backgroundColor = [UIColor grayColor];
        [activityCell.favoriteButton removeTarget:self action:@selector(addToFavorites:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [activityCell.favoriteButton setTitle:@"+ Favorite" forState:UIControlStateNormal];
        [activityCell.favoriteButton setBackgroundColor:[UIColor colorWithRed:0.0 green:0.47843137254901963 blue:1 alpha:1]];
        activityCell.favoriteButton.tintColor =[UIColor colorWithRed:0.0 green:0.47843137254901963 blue:1 alpha:1];
        [activityCell.favoriteButton addTarget:self action:@selector(addToFavorites:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    [activityCell.initialImageView setBackgroundColor:[UIColor whiteColor]];
    
    [activityCell.deleteButton addTarget:self action:@selector(onDelete:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *cantDel = [dict valueForKey:@"cantDelete"];
    
    if ([cantDel isEqual:@"1"])
    {
        
        [activityCell.deleteButton setHidden:YES];
        
    }
    else
    {
        [activityCell.deleteButton setHidden:NO];
    }
    activityCell.initialImageView.layer.borderWidth = 0.2f;
    
    activityCell.secondView.backgroundColor = [UIColor whiteColor];
    //activityCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return activityCell;
}


-(BOOL)isActivityFavorite:(NSString*) activityName{
    BOOL retVal = NO;
    for (NSDictionary *tFavs in favoritesArray){
        if([[tFavs valueForKey:@"activityName"] isEqualToString:activityName]){
            retVal = YES;
            break;
        }
    }
    return retVal;
}



-(void)refreshList
{
    [self.activityTableView reloadData];
    
}


-(void)onDelete:(id)sender

{
    DeleteCormationManager *manager = [DeleteCormationManager getInstance];
    
    [manager showAlertwithPositiveBlock:^(BOOL positive) {
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateString = [formatter stringFromDate:date];
        
        
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.activityTableView];
        NSIndexPath *indexPath = [self.activityTableView indexPathForRowAtPoint:buttonPosition];
        if (indexPath != nil)
        {
            NSDictionary *dict = [activityArray objectAtIndex:indexPath.row];
            
            
            
            NSString *query = [NSString stringWithFormat:@"delete from  Plan_Activities where ActivityName = '%@' and cantDelete is not 1",[dict valueForKey:@"activityName"]];
            NSString *queryFav = [NSString stringWithFormat:@"delete from  MyActivities where ActivityName = '%@' and skillID = %@ and planID = %@",[dict valueForKey:@"activityName"],[PersistenceStorage getObjectForKey:@"currentSkillID"], [PersistenceStorage getObjectForKey:@"currentPlanID"]];
            
            NSString *queryClear = [NSString stringWithFormat:@"delete from MyReminders where ActName = '%@' and PlanName = '%@' and SkillName = 'Pleasant Activities'",[dict valueForKey:@"activityName"],[Utils getValidSqlString:[PersistenceStorage getObjectForKey:@"planName"]]];
            // Execute the query.
            [self.manager executeQuery:query];
            if(self.manager.affectedRows > 0){
                //activity was deleted
                // lets delete it from favourite as well
                [self.manager executeQuery:queryFav];
                // get the calenderID
                CalenderEventID = [self eventPAExists:[dict valueForKey:@"activityName"]];
                if(CalenderEventID != nil){
                    [self removeEventFromCalender];
                }
                [self deleteExistingPAEventNotitfication:[dict valueForKey:@"activityName"]];
                
                // now delete the entry
                [self.manager executeQuery:queryClear];
            }
            //[self.activityTableView reloadData];
            
            // If the query was successfully executed then pop the view controller.
            //    if (self.manager.affectedRows != 0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"] ];
            
            hud.mode = MBProgressHUDModeCustomView;
            
            hud.labelText = @"Removed";
            
            [hud show:YES];
            [hud hide:YES afterDelay:1];
            
            
            
        }
        
        //  [self.activityTableView reloadData];
        
        
        [self loadData];
        
        
        
        
        
    } negativeBlock:^(BOOL negative) {
        
        //DO nothing
    }];
}




-(void)deleteActivity:(UIButton *)sender{
    
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:date];
    
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.activityTableView];
    NSIndexPath *indexPath = [self.activityTableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        NSDictionary *dict = [activityArray objectAtIndex:indexPath.row];
        
        
        
        NSString *query = [NSString stringWithFormat:@"delete from  Plan_Activities where ActivityName = '%@' and cantDelete is not 1",[dict valueForKey:@"activityName"]];
        NSString *queryFav = [NSString stringWithFormat:@"delete from  MyActivities where ActivityName = '%@' and skillID = %@ and planID = %@",[dict valueForKey:@"activityName"],[PersistenceStorage getObjectForKey:@"currentSkillID"], [PersistenceStorage getObjectForKey:@"currentPlanID"]];
        
        NSString *queryClear = [NSString stringWithFormat:@"delete from MyReminders where ActName = '%@' and PlanName = '%@' and SkillName = 'Pleasant Activities'",[dict valueForKey:@"activityName"],[Utils getValidSqlString:[PersistenceStorage getObjectForKey:@"planName"]]];
        
        // Execute the query.
        [self.manager executeQuery:query];
        if(self.manager.affectedRows > 0){
            //activity was deleted
            // lets delete it from favourite as well
            [self.manager executeQuery:queryFav];
            // get the calenderID
            CalenderEventID = [self eventPAExists:[dict valueForKey:@"activityName"]];
            if(CalenderEventID != nil){
                [self removeEventFromCalender];
            }
            [self deleteExistingPAEventNotitfication:[dict valueForKey:@"activityName"]];
            
            // now delete the entry
            [self.manager executeQuery:queryClear];
        }
        [self.activityTableView reloadData];
        
        // If the query was successfully executed then pop the view controller.
        //    if (self.manager.affectedRows != 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"] ];
        
        hud.mode = MBProgressHUDModeCustomView;
        
        hud.labelText = @"Removed";
        
        [hud show:YES];
        [hud hide:YES afterDelay:1];
        
        
        
    }
    
    //  [self.activityTableView reloadData];
    
    
    [self loadData];
    
    
}












#pragma mark Button clicked
-(void)buttonTapped:(id)sender{
    
    
    CGPoint buttonPosition = [[sender view] convertPoint:CGPointZero toView:self.activityTableView];
    NSIndexPath *indexPath = [self.activityTableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        NSDictionary *dict = [activityArray objectAtIndex:indexPath.row];
        strAct = [dict valueForKey:@"activityName"];
        [PersistenceStorage setObject:strAct andKey:@"activityName"];
        
        NSUInteger characterCount = [[dict valueForKey:@"ScheduledDate"] length];
        if (characterCount == 0)
            
        {
            
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:[dict valueForKey:@"activityName"] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Do Activity Now",@"Schedule Activity", nil];
            [sheet showInView:self.view];
        }
        else
        {
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:[dict valueForKey:@"activityName"] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Do Activity Now",@"Cancel Scheduled Activity", nil];
            [sheet showInView:self.view];
        }
        
        
    }
}






- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        HomeViewController *svc1 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"HomeViewController"];
        [self.navigationController pushViewController:svc1 animated:YES];
        
        //  [self.navigationController pushViewController:viewControllerToPush animated:YES];
        //
    }
}



#pragma mark UIActionSheetDelegate

#pragma mark Add to favorites method
-(void)addToFavorites:(UIButton *)sender{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:date];
    
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activity startAnimating];
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.activityTableView];
    NSIndexPath *indexPath = [self.activityTableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        NSDictionary *dict = [activityArray objectAtIndex:indexPath.row];
        
        
        
        NSString *query = [NSString stringWithFormat:@"insert into MyActivities (valueID,activityID,isFavourite,isSchedule,timeStamp,valueName,activityName,skillID,planID) values(%i,%ld,'%d',%i,'%@','%@','%@',%ld,%ld)",0,[[dict valueForKey:@"ID"] integerValue],1,YES,dateString,[dict valueForKey:@"valueName"],[dict valueForKey:@"activityName"],[PersistenceStorage getIntegerForKey:@"currentSkillID"],[PersistenceStorage getIntegerForKey:@"currentPlanID"]];
        
        // Execute the query.
        [self.manager executeQuery:query];
        
        // If the query was successfully executed then pop the view controller.
        if (self.manager.affectedRows != 0) {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.manager.affectedRows);
            
            
            if (self.manager.affectedRows != 0) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"] ];
                
                hud.mode = MBProgressHUDModeCustomView;
                
                hud.labelText = @"Added to Favorites";
                
                [hud show:YES];
                [hud hide:YES afterDelay:1];
                
                
            }
            else{
                NSLog(@"Could not execute the query.");
            }
            
            
            
            
            [activity stopAnimating];
            // Pop the view controller.
            NSString *queryFav = [NSString stringWithFormat:@"SELECT * FROM Plan_Activities  LEFT OUTER  JOIN myReminders ON Plan_Activities.ActivityName = MyReminders.ActName  inner join MyActivities on Plan_Activities.ID=MyActivities.activityID order by  CreatedDate DESC"];
            favoritesArray = [[NSArray alloc] initWithArray:[self.manager loadDataFromDB:queryFav]];
            [self.activityTableView reloadData];
        }
        else{
            NSLog(@"Could not execute the query.");
        }
        
    }
    
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"X" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        NSLog(@"Action to perform with Button 1");
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

- (IBAction)addActivityTapped:(id)sender {
    AddActivityViewController *addvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AddActivityViewController"];
    
    //UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:addvc];
    // nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //[self presentViewController:nav animated:YES completion:^{
    
    // }];
    
    [self.navigationController presentModalViewController:addvc animated:YES];
    
    
    
    
    //    AddActivityViewController *controller = [[AddActivityViewController alloc] init];
    //    controller.onCompletion = ^(id result) {
    //        [self setUpView]
    //        [self dismissViewControllerAnimated:YES completion:nil];
}


/*
 
 - (IBAction)addActivityTapped:(id)sender {
 AddActivityViewController *addvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AddActivityViewController"];
 
 //UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:addvc];
 // nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
 //[self presentViewController:nav animated:YES completion:^{
 
 // }];
 
 [self.navigationController presentModalViewController:addvc animated:YES];
 
 
 
 }
 */
-(NSString*)eventPAExists:(NSString*)activityName{
    //check for the Event
    //get the skill first
    NSString* calEvent = nil;
    NSString* reminderQuery = [NSString stringWithFormat:@"select CalendarEventID from MyReminders where SkillName = \"%@\" and PlanName = '%@' and ActName = '%@'",[PersistenceStorage getObjectForKey:@"skillName"],[Utils getValidSqlString:[PersistenceStorage getObjectForKey:@"planName"]],activityName];
    NSArray* calenderEventsArray = [NSArray arrayWithArray:[self.manager loadDataFromDB:reminderQuery]];
    if(calenderEventsArray != nil && calenderEventsArray.count > 0){
        //get the calender event and return it back for rescheduling
        calEvent = [[calenderEventsArray objectAtIndex:0] objectForKey:@"CalendarEventID"];
        
    }
    return calEvent;
}

-(void)removeEventFromCalender{
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) return;
        NSError* err = nil;
        EKEvent* eventToRemove = [store eventWithIdentifier:CalenderEventID];
        [store removeEvent:eventToRemove span:EKSpanFutureEvents commit:YES error:&err];
        if(err != nil){
            NSLog(@"Error in deletining event from calender:%@", [eventToRemove description]);
        }
    }
     
     
     ];
    
}

-(void)deleteExistingPAEventNotitfication:(NSString*)activityName{
    NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSString* skillName = [PersistenceStorage getObjectForKey:@"skillName"];
    NSString* planName = [PersistenceStorage getObjectForKey:@"planName"];
    for(UILocalNotification *notification in notificationArray){
        if ([[notification.userInfo valueForKey:@"PlanName"] isEqualToString:planName] && [[notification.userInfo valueForKey:@"Type"] isEqualToString:skillName] && [[notification.userInfo valueForKey:@"Activity"] isEqualToString:activityName]) {
            NSLog(@"Cancelling local notification for skill:%@ in Plan:%@  Activity: %@" , skillName, planName,activityName);
            [[UIApplication sharedApplication] cancelLocalNotification:notification] ;
            break;
        }
        
    }
    
}

@end
