//
//  FavoritesViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 28/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "FavoritesViewController.h"
#import "ScheduleViewController.h"
#import "DoingActivityViewController.h"
#import "ActivityRatingsViewController.h"
#import "MBProgressHUD.h"


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
#import "MBProgressHUD.h"


@interface FavoritesViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *favoritesArray;
    NSString *strAct;
    CGRect viewRect;
    CGRect tableRect;
    BOOL isLoad;
    
}

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Favorites";
    // Do any additional setup after loading the view.
    [self loadData];
    isLoad = YES;
    
}

-(void)viewWillAppear:(BOOL)animated{
    if(!isLoad){
        self.view.frame = viewRect;
        self.view.bounds = viewRect;
        self.favoriteTableView.frame = tableRect;
        self.favoriteTableView.bounds = CGRectMake(tableRect.origin.x, tableRect.origin.y-40, tableRect.size.width, tableRect.size.height);
        
    }else{
        isLoad = NO;
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    viewRect = self.view.frame;
    tableRect = self.favoriteTableView.frame;
    [self.view setNeedsDisplay];// = YES;
    
    if ([[PersistenceStorage getObjectForKey:@"Referer"] isEqual: @"DoingActivityVC"]) {
        ActivityRatingsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"ActivityRatingsViewController"];
        
        //ratingsView.skillSection = @"Sounds";
        //  ratingsView.skillDetail = self.name;
        
        //[self.navigationController pushViewController:ratingsView animated:YES];
        [self.navigationController presentModalViewController:ratingsView animated:YES];
    } else{
        
        [self loadData];
        
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
        
    }
    
    
    
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    //   NSString * theValue = [(UILabel*)[self viewWithTag:t200] text];
    
    
    
    
    if  ([buttonTitle isEqualToString:@"Repeat This Skill"]) {
        
        //PleasantActivityViewController *pa = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"PleasantActivityViewController"];
        //   audioPanning.url = [dict valueForKey:@"soundURL"];
        // audioPanning.name = [dict valueForKey:@"soundName"];
        // audioPanning.panning = audio;
        
        [self.navigationController popViewControllerAnimated:YES];
        
        //       [self.navigationController presentModalViewController:audioPanning animated:NO];
        
        
        
        
        
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
        svc.name = strAct;
        svc.activityText = strAct;
        [self.navigationController pushViewController:svc animated:YES];
    }
    
    
    
    
    
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    [self.favoriteTableView setDataSource:self];
    [self.favoriteTableView setDelegate:self];
    [self.favoriteTableView registerNib:[UINib nibWithNibName:@"FavoriteActivityCell" bundle:nil] forCellReuseIdentifier:@"FavoriteActivityCell"];
    self.manager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    // NSString *query = @" select Plan_Activities.activityName,Plan_Activities.ID From Plan_Activities inner join MyActivities on Plan_Activities.ID=MyActivities.activityID";
    
    
    //  NSString *query = @" select Plan_Activities.activityName,Plan_Activities.ID From Plan_Activities inner join MyActivities on Plan_Activities.ID=MyActivities.activityID";
    
    //    NSString *query = [NSString stringWithFormat:@"SELECT * FROM Plan_Activities  LEFT OUTER  JOIN myReminders ON Plan_Activities.ActivityName = MyReminders.ActName  where valueName IS '%@' order by  CreatedDate DESC",[PersistenceStorage getObjectForKey:@"valueName"]];
    
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM Plan_Activities  LEFT OUTER  JOIN myReminders ON Plan_Activities.ActivityName = MyReminders.ActName  inner join MyActivities on Plan_Activities.ID=MyActivities.activityID where MyActivities.planID = %@  order by  CreatedDate DESC",[PersistenceStorage getObjectForKey:@"currentPlanID"]];
    
    
    
    //  LEFT OUTER  JOIN myReminders ON Plan_Activities.ActivityName = MyReminders.ActName  where valueName IS '%@' order by  CreatedDate DESC",[PersistenceStorage getObjectForKey:@"valueName"]
    
    
    // Get the results.
    if (favoritesArray!= nil) {
        favoritesArray = nil;
    }
    favoritesArray = [[NSArray alloc] initWithArray:[self.manager loadDataFromDB:query]];
    // Reload the table view.
    
    
    NSLog(@"FAV ARRAY %@",favoritesArray);
    
    [self.favoriteTableView reloadData];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [favoritesArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [favoritesArray objectAtIndex:indexPath.row];
    
    FavoriteActivityCell *FavoriteActivityCell;
    if (FavoriteActivityCell==nil) {
        FavoriteActivityCell = [tableView dequeueReusableCellWithIdentifier:@"FavoriteActivityCell"];
        
    }
    // [activityCell setBackgroundColor:[UIColor redColor]];
    
    NSString *str = [dict valueForKey:@"activityName"];
    
    [FavoriteActivityCell.secondView setBackgroundColor:[UIColor whiteColor]];
    [FavoriteActivityCell.activityNameButton setTitle:str forState:UIControlStateNormal ] ;
    FavoriteActivityCell.activityNameButton.titleLabel.textColor = [UIColor blackColor];
    // FavoriteActivityCell.dateLabel.text =[dict valueForKey:@"ScheduledDate"];
    
    
    if ([[dict valueForKey:@"ScheduledDate"] length]>5)
        
    {
        FavoriteActivityCell.dateLabel.text =[dict valueForKey:@"ScheduledDate"];
    }
    else
    {
        FavoriteActivityCell.dateLabel.text =@"Not Scheduled";
    }
    
    
    
    
    FavoriteActivityCell.activityNameButton.titleLabel.numberOfLines = 1;
    FavoriteActivityCell.activityNameButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    FavoriteActivityCell.activityNameButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    [FavoriteActivityCell.activityNameButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [FavoriteActivityCell.removeFavoriteButton addTarget:self action:@selector(removeFromFavorites:) forControlEvents:UIControlEventTouchUpInside];
    FavoriteActivityCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return FavoriteActivityCell;
    
    
    
    
    
}


#pragma mark Button clicked
-(void)buttonTapped:(UIButton *)sender{
    
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.favoriteTableView];
    NSIndexPath *indexPath = [self.favoriteTableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        NSDictionary *dict = [favoritesArray objectAtIndex:indexPath.row];
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




//
//#pragma mark Button clicked
//-(void)buttonTapped:(UIButton *)sender{
//    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.favoriteTableView];
//    NSIndexPath *indexPath = [self.favoriteTableView indexPathForRowAtPoint:buttonPosition];
//    if (indexPath != nil)
//    {
//        NSDictionary *dict = [favoritesArray objectAtIndex:indexPath.row];
//        strAct = [dict valueForKey:@"activityName"];
//        [PersistenceStorage setObject:strAct andKey:@"activityName"];
//
//        NSLog(@"%@",strAct);
//
//        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:[dict valueForKey:@"activityName"] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Do Activity Now",@"Schedule Later", nil];
//        [sheet showInView:self.view];
//    }
//}
//



/*- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
 {
 //Get the name of the current pressed button
 NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
 
 //   NSString * theValue = [(UILabel*)[self viewWithTag:t200] text];
 
 
 
 
 
 
 if ([buttonTitle isEqualToString:@"Return Home"]) {
 [[self tabBarController] setSelectedIndex:0];
 
 }
 
 
 
 if ([buttonTitle isEqualToString:@"Do Activity Now"]) {
 DoingActivityViewController *svc1 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"DoingActivityViewController"];
 //[self.navigationController pushViewController:svc1 animated:YES];
 
 [self.navigationController presentModalViewController:svc1 animated:NO];
 }
 
 
 
 if ([buttonTitle isEqualToString:@"Schedule Later"]) {
 ScheduleViewController *svc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ScheduleViewController"];
 svc.name = strAct;
 [self.navigationController pushViewController:svc animated:YES];
 }
 
 
 
 
 
 
 
 
 }
 
 
 
 
 */


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        //       HomeViewController *svc1 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"HomeViewController"];
        //     [self.navigationController pushViewController:svc1 animated:YES];
        
        //  [self.navigationController pushViewController:viewControllerToPush animated:YES];
        //
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

#pragma mark activity button tapped


#pragma mark Add Favorite button
-(void)removeFromFavorites:(UIButton *)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.favoriteTableView];
    NSIndexPath *indexPath = [self.favoriteTableView indexPathForRowAtPoint:buttonPosition];
    
    
    if (indexPath != nil)
    {
        NSDictionary *dict = [favoritesArray objectAtIndex:indexPath.row];
        
        
        
        NSString *query = [NSString stringWithFormat:@"delete from  MyActivities where ActivityID = '%@'",[dict valueForKey:@"ID"]];
        
        // Execute the query.
        [self.manager executeQuery:query];
        [self.favoriteTableView reloadData];
        
        
        // If the query was successfully executed then pop the view controller.
        if (self.manager.affectedRows != 0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"] ];
            
            hud.mode = MBProgressHUDModeCustomView;
            
            hud.labelText = @"Removed";
            
            [hud show:YES];
            [hud hide:YES afterDelay:1];
            
            
        }
        else{
            NSLog(@"Could not execute the query.");
        }
        
    }
    [self loadData];
    
    
}







@end
