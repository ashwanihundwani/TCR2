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

@interface ActivitiesViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>{
    NSArray *activityArray;
    NSArray *favoritesArray;
    NSString *strAct;
}
@end

@implementation ActivitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
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
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM Plan_Activities LEFT OUTER  JOIN myReminders ON Plan_Activities.ActivityName = MyReminders.ActName  where valueName IS '%@' order by  CreatedDate DESC",[PersistenceStorage getObjectForKey:@"valueName"]];

    
    
    
    
    
    // Get the results.
    if (activityArray!= nil) {
        activityArray = nil;
    }
    activityArray = [[NSArray alloc] initWithArray:[self.manager loadDataFromDB:query]];
    
    
    NSString *queryFav = [NSString stringWithFormat:@"SELECT * FROM Plan_Activities  LEFT OUTER  JOIN myReminders ON Plan_Activities.ActivityName = MyReminders.ActName  inner join MyActivities on Plan_Activities.ID=MyActivities.activityID order by  CreatedDate DESC"];
    
    
    
    
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
    
    
    

}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    //   NSString * theValue = [(UILabel*)[self viewWithTag:t200] text];
    
    
    
    
    if  ([buttonTitle isEqualToString:@"Repeat This Skill"]) {
        
        PleasantActivityViewController *pa = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"PleasantActivityViewController"];
        //   audioPanning.url = [dict valueForKey:@"soundURL"];
        // audioPanning.name = [dict valueForKey:@"soundName"];
        // audioPanning.panning = audio;
        
        [self.navigationController pushViewController:pa animated:YES];
        
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
        //[self.navigationController pushViewController:svc1 animated:YES];
        
        [self.navigationController presentModalViewController:svc1 animated:NO];
    }
    

    
    if ([buttonTitle isEqualToString:@"Schedule Activity"]) {
      //  [PersistenceStorage setObject:@"Yes" andKey:@"showCancelActivityButton"];
 ScheduleViewController *svc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ScheduleViewController"];
        svc.name = strAct;
        [self.navigationController pushViewController:svc animated:YES];
    }
    
    if ([buttonTitle isEqualToString:@"Cancel Scheduled Activity"]) {
        [PersistenceStorage setObject:@"Yes" andKey:@"showCancelActivityButton"];
  ScheduleViewController *svc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ScheduleViewController"];
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

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
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
    activityCell.activityNameButton.titleLabel.numberOfLines = 1;
    activityCell.activityNameButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    activityCell.activityNameButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    [activityCell.activityNameButton setTitle:[dict valueForKey:@"activityName"] forState:UIControlStateNormal];
    [activityCell.activityNameButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    if ([[dict valueForKey:@"ScheduledDate"] length]>5)
        
    {
        activityCell.dateLabel.text =[dict valueForKey:@"ScheduledDate"];
    }
    else
    {
        activityCell.dateLabel.text =@"Not Scheduled";
    }
    
    
    for (NSDictionary *tFavs in favoritesArray)
        if ([[tFavs valueForKey:@"activityName"] isEqualToString:[dict valueForKey:@"activityName"]])
        {
            [activityCell.favoriteButton setTitle:@"✓ Favorite" forState:UIControlStateNormal];
            activityCell.favoriteButton.backgroundColor = [UIColor grayColor];
            [activityCell.favoriteButton removeTarget:self action:@selector(addToFavorites:) forControlEvents:UIControlEventTouchUpInside];
            break;
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
    activityCell.initialImageView.layer.borderWidth = 0.2f;
    
    activityCell.secondView.backgroundColor = [UIColor whiteColor];
    //activityCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return activityCell;
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
            
            // Execute the query.
            [self.manager executeQuery:query];
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
        
        // Execute the query.
       [self.manager executeQuery:query];
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
-(void)buttonTapped:(UIButton *)sender{
    
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.activityTableView];
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
        
        
        
        NSString *query = [NSString stringWithFormat:@"insert into MyActivities (valueID,activityID,isFavourite,isSchedule,timeStamp,valueName,activityName) values(%i,%i,'%d',%i,'%@','%@','%@')",[PersistenceStorage getObjectForKey:@"valueID"],[[dict valueForKey:@"ID"] integerValue],1,YES,dateString,[PersistenceStorage getObjectForKey:@"valueName"],[PersistenceStorage getObjectForKey:@"activityName"]];
        
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


@end
