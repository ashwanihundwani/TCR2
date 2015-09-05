//
//  WeeklyViewController.m
//  TinnitusCoach
//
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#define UN_SELECTED_IMAGE @"u630.png"
#define SELECTED_IMAGE @"u648.png"

#import "WeeklyViewController.h"
#import "FeedbackTableViewCell.h"
#import "EditTipsCell.h"
#import "MBProgressHUD.h"


@interface WeeklyViewController ()
{
    NSMutableArray *allSkillsArray,*categorizedSkills,*allMyPlanArray,*activeSkillsArray;
    BOOL firtTimeLoad;
    NSMutableArray *selectedSkills;
    NSMutableArray *feedbackArray;
    int maxNumberOfSkills,maxMyPlan;
    int currentPlanIndex;
    
}

@end

@implementation WeeklyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    allSkillsArray = [NSMutableArray new];
    allMyPlanArray = [NSMutableArray new];
    categorizedSkills = [NSMutableArray new];
    firtTimeLoad = YES;
    self.title = @"Weekly Reminder";
    
    selectedSkills = [NSMutableArray new];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.96078431 green:0.96078431 blue:0.96078431 alpha:1]];
    
    [self getAllSkillWithDetails];
    //[self.tableview setBackgroundColor:[UIColor redColor]];
    feedbackArray = [NSMutableArray new];
    currentPlanIndex = 0;
    self.previousBtn.hidden = YES;
    [self.tableview registerNib:[UINib nibWithNibName:@"FeedbackTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FeedbackCellIdentifier"];
    if(categorizedSkills != nil && categorizedSkills.count > 1){
        self.submittBtn.hidden = YES;
    }else{
        self.submittBtn.hidden = NO;
    }
    
    [self resetWeeklyReminderEventForFutureDate];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
}


-(void)resetWeeklyReminderEventForFutureDate{
    
    NSInteger dayDiff = [Utils getNumDaysToNextMonday];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay: [comp day] + dayDiff];
    [components setMonth: [comp month]];
    [components setYear: [comp year]];
    [components setHour: 4];
    [components setMinute: 45];
    [components setSecond: 0];
    [calendar setTimeZone: [NSTimeZone defaultTimeZone]];
    NSDate *dateToFire = [calendar dateFromComponents:components];
    if([dateToFire compare:[NSDate date]] == NSOrderedAscending){
        [components setDay: [comp day] + 7];
        dateToFire =  [calendar dateFromComponents:components];
    }
    
    NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for(UILocalNotification *notification in notificationArray){
        if ([notification.alertBody isEqualToString:@"Weekly Reminder"]) {
            // set the firedate
            NSLog(@"cancelling the previous notification");
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            break;
        }
    }
    //create a fresh one
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    
    
    NSString *str = [NSString stringWithFormat:@"%@",@"Weekly Reminder"];
    localNotification.alertBody = str;
    
    [localNotification setFireDate: dateToFire];
    [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
    [localNotification setRepeatInterval: NSWeekCalendarUnit];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}


#pragma mark Tableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    /*
     int numberOfSections = (maxNumberOfSkills * maxMyPlan) + maxMyPlan;
     return numberOfSections;
     */
    // let's keep at 1 for now
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    /*
     if (section % (maxNumberOfSkills + 1) == 0) {
     return 0;
     }
     
     int sectionForSkill = section - ((section) / (maxNumberOfSkills + 1) + 1);
     
     NSDictionary *skillDict = [allSkillsArray objectAtIndex:sectionForSkill];
     if ([selectedSkills containsObject:skillDict]) {
     if ([[allSkillsArray objectAtIndex:sectionForSkill] valueForKey:@"devices"] != nil) {
     NSArray *devicesArray = [[allSkillsArray objectAtIndex:sectionForSkill] valueForKey:@"devices"];
     
     
     return 2 + devicesArray.count;
     
     
     }
     return 1;
     
     }
     
     
     
     return 0;
     */
    if(categorizedSkills != nil && categorizedSkills.count > 0)
        return [[categorizedSkills objectAtIndex:currentPlanIndex] count];
    else
        return 0;
}




//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//
//    if(section = _tableview.numberOfSections)
//    {
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
//
//        view.backgroundColor = [Utils colorWithHexValue:NAV_BAR_BLACK_COLOR];
//        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height - 1, 320, 1)];
//
//        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
//
//        line1.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.098/255.0 alpha:0.22];;
//
//        line2.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.098/255.0 alpha:0.22];;
//
//        [view addSubview:line1];
//        [view addSubview:line2];
//
//        return view;
//    }
//
//    return nil;
//}
//




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    /*
     if (indexPath.row == 0) {
     
     
     static NSString *feedbackCellIdentifier = @"FeedbackCellIdentifier";
     FeedbackTableViewCell *cell = (FeedbackTableViewCell *)[tableView dequeueReusableCellWithIdentifier:feedbackCellIdentifier];
     if(cell == nil)
     {
     NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"FeedbackTableViewCell" owner:nil options:nil];
     cell = [nibs lastObject];
     [cell.contentView setBackgroundColor:[UIColor lightGrayColor]];
     cell.contentView.layer.cornerRadius = 5;
     cell.contentView.layer.masksToBounds = YES;
     
     
     }
     
     [cell.noatallButton setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
     [cell.alittleButton setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
     [cell.moderatelyButton setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
     [cell.veryMuchButton setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
     [cell.extremelyButton setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
     //        [cell.noatallButton setBackgroundImage:[UIImage imageNamed:@"selectedCircle1"] forState:UIControlStateSelected];
     //        [cell.alittleButton setBackgroundImage:[UIImage imageNamed:@"selectedCircle1"] forState:UIControlStateSelected];
     //        [cell.moderatelyButton setBackgroundImage:[UIImage imageNamed:@"selectedCircle1"] forState:UIControlStateSelected];
     //        [cell.veryMuchButton setBackgroundImage:[UIImage imageNamed:@"selectedCircle1"] forState:UIControlStateSelected];
     //        [cell.extremelyButton setBackgroundImage:[UIImage imageNamed:@"selectedCircle1"] forState:UIControlStateSelected];
     
     [cell.noatallButton setTag:indexPath.section];
     [cell.alittleButton setTag:indexPath.section];
     [cell.moderatelyButton setTag:indexPath.section];
     [cell.veryMuchButton setTag:indexPath.section];
     [cell.extremelyButton setTag:indexPath.section];
     
     [cell.noatallButton addTarget:self action:@selector(noatallButtonAction:) forControlEvents:UIControlEventTouchUpInside];
     [cell.alittleButton addTarget:self action:@selector(alittleButtonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
     [cell.moderatelyButton addTarget:self action:@selector(moderatelyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
     [cell.veryMuchButton addTarget:self action:@selector(veryMuchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
     [cell.extremelyButton addTarget:self action:@selector(extremelyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
     
     int sectionForSkill = indexPath.section - ((indexPath.section) / (maxNumberOfSkills + 1) + 1);
     
     //    NSDictionary *skilDict = [allSkillsArray objectAtIndex:sectionForSkill];
     
     
     NSDictionary *skilDict = [allSkillsArray objectAtIndex:indexPath.section];
     
     
     //  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.skillID=%@",[skilDict valueForKey:@"skillID"]];
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF =%@",@"skillID"];
     NSArray *filteredArray = [feedbackArray filteredArrayUsingPredicate:predicate];
     NSLog(@"FILEERD %@",[skilDict valueForKey:@"skillID"]);
     
     if (filteredArray.count > 0) {
     NSMutableArray *fDict = [filteredArray objectAtIndex:0];
     
     int rating = [[fDict valueForKey:@"rating"] intValue];
     
     NSLog(@"RATINGGG %d",rating);
     
     
     switch (rating) {
     case 1:
     {
     [cell.noatallButton setBackgroundImage:[UIImage imageNamed:@"selectedCircle"] forState:UIControlStateNormal];
     break;
     }
     case 2:
     {
     [cell.alittleButton setBackgroundImage:[UIImage imageNamed:@"selectedCircle"] forState:UIControlStateNormal];
     break;
     }
     case 3:
     {
     [cell.moderatelyButton setBackgroundImage:[UIImage imageNamed:@"selectedCircle"] forState:UIControlStateNormal];
     break;
     }
     case 4:
     {
     
     [cell.veryMuchButton setBackgroundImage:[UIImage imageNamed:@"selectedCircle"] forState:UIControlStateNormal];
     break;
     }
     case 5:
     {
     [cell.extremelyButton setBackgroundImage:[UIImage imageNamed:@"selectedCircle"] forState:UIControlStateNormal];
     break;
     }
     
     default:
     break;
     }
     }
     
     return cell;
     
     
     }
     else
     {
     static NSString *cellIdentifier = @"CellIdentifier";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     if(cell == nil)
     {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
     //    cell.contentView.backgroundColor = [UIColor lightGrayColor];
     
     
     }
     
     
     
     if (indexPath.row == 1) {
     cell.textLabel.text = @"This plan has these devices";
     
     }
     else
     {
     int sectionForSkill = indexPath.section - ((indexPath.section) / (maxNumberOfSkills + 1) + 1);
     
     
     NSArray *devicesArray = [[allSkillsArray objectAtIndex:sectionForSkill] valueForKey:@"devices"];
     NSDictionary *deviceDict = [ devicesArray objectAtIndex:indexPath.row-2];
     cell.textLabel.text = [deviceDict valueForKey:@"deviceName"];
     cell.textLabel.font = [UIFont systemFontOfSize:13.0];
     cell.contentView.backgroundColor = [UIColor grayColor];
     
     }
     
     return cell;
     
     }
     
     
     
     return nil;
     
     */
    
    static NSString *feedbackCellIdentifier = @"FeedbackCellIdentifier";
    FeedbackTableViewCell *cell = (FeedbackTableViewCell *)[tableView dequeueReusableCellWithIdentifier:feedbackCellIdentifier];
    if(cell == nil)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"FeedbackTableViewCell" owner:nil options:nil];
        cell = [nibs firstObject];
        [cell.contentView setBackgroundColor:[UIColor greenColor]];
        cell.contentView.layer.cornerRadius = 5;
        //cell.contentView.layer.masksToBounds = YES;
        
        
    }
    // reinitialize this cell
    [cell reInitialize];
    // get the current item from array
    NSDictionary* skill = [[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:indexPath.row];
    cell.skillNameLabel.text = [skill valueForKey:@"skillName"];
    UIFont* boldFont = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    cell.skillNameLabel.font = boldFont;
    // check if skill is added in current plan
    if([self isSkilladdedToPlan:skill]){
        //skill is added to plan
        // let's enable the review process
        cell.itemSelectorBtn.hidden = NO;
        cell.itemSelctorBtnImage.hidden = NO;
        // further check if this has been already selected
        if([self isSkillAlreadySelected:skill]){
            [cell.itemSelctorBtnImage  setImage:[UIImage imageNamed:SELECTED_IMAGE]];
            //show the expanded view
            cell.secondaryView.hidden = NO;
            cell.secondaryView.userInteractionEnabled = YES;
            cell.delegate = self;
            // lets show the correct color of the selcted indiccator
            //cell.feedbackTableView.hidden =YES;
            switch ([[skill valueForKey:@"rating"] intValue]) {
                case 1:
                {
                    [cell.noatallButton setBackgroundImage:[UIImage imageNamed:@"selectedCircle"] forState:UIControlStateNormal];
                    break;
                }
                case 2:
                {
                    [cell.alittleButton setBackgroundImage:[UIImage imageNamed:@"selectedCircle"] forState:UIControlStateNormal];
                    break;
                }
                case 3:
                {
                    [cell.moderatelyButton setBackgroundImage:[UIImage imageNamed:@"selectedCircle"] forState:UIControlStateNormal];
                    break;
                }
                case 4:
                {
                    
                    [cell.veryMuchButton setBackgroundImage:[UIImage imageNamed:@"selectedCircle"] forState:UIControlStateNormal];
                    break;
                }
                case 5:
                {
                    [cell.extremelyButton setBackgroundImage:[UIImage imageNamed:@"selectedCircle"] forState:UIControlStateNormal];
                    break;
                }
                default:
                    break;
            }
            
            //now check for devices also
            NSArray *devicesArray = [skill valueForKey:@"devices"];
            NSArray *websitesArray = [skill valueForKey:@"websitesAndApps"];
            if(devicesArray.count > 0 || websitesArray.count > 0){
                cell.feedbackTableView.hidden = NO;
                cell.feedbackTableView.tag = indexPath.row;
                [cell.feedbackTableView reloadData];
            }else{
                cell.feedbackTableView.hidden = YES;
            }
            
        }else{
            // skill is not selected.
            [cell.itemSelctorBtnImage  setImage:[UIImage imageNamed:UN_SELECTED_IMAGE]];
            
        }
        cell.itemSelectorBtn.tag = indexPath.row;
        // add selector for itemselector
        [cell.itemSelectorBtn addTarget:self action:@selector(onClickToggleCategory:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        // skill not added
        // let it be unselcted
        // nothing to do.
        
        
    }
    
    
    
    return cell;
}

-(BOOL)isSkilladdedToPlan:(NSDictionary*) skill{
    NSPredicate* predicateForSKill = [NSPredicate predicateWithFormat:@"self.skillID = %@ AND self.planID = %@",[skill valueForKey:@"skillID"],[[allMyPlanArray objectAtIndex:currentPlanIndex] valueForKey:@"ID"]];
    NSArray *SkillAndPlanArray = [ activeSkillsArray filteredArrayUsingPredicate:predicateForSKill];
    return SkillAndPlanArray.count > 0 ? YES:NO;
}

-(BOOL)isSkillAlreadySelected:(NSDictionary*) skill{
    NSPredicate* predicateForSKill = [NSPredicate predicateWithFormat:@"self.skillID = %@ AND self.planID = %@",[skill valueForKey:@"skillID"],[[allMyPlanArray objectAtIndex:currentPlanIndex] valueForKey:@"ID"]];
    NSArray *SkillAndPlanArray = [ selectedSkills filteredArrayUsingPredicate:predicateForSKill];
    return SkillAndPlanArray.count > 0 ? YES:NO;
}

-(int)getRatingForSKill:(NSDictionary*)skill{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF =%@",@"skillID"];
    NSArray *filteredArray = [feedbackArray filteredArrayUsingPredicate:predicate];
    
    if (filteredArray.count > 0) {
        NSMutableArray *fDict = [filteredArray objectAtIndex:0];
        
        return [[fDict valueForKey:@"rating"] intValue];
    }else{
        return -1;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* skill = [[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:indexPath.row];
    if([selectedSkills containsObject:skill]){
        NSInteger baseHeight = 180;
        NSInteger deviceCount = [(NSArray*)[skill objectForKey:@"devices"] count];
        NSInteger websitesCount = [(NSArray*)[skill objectForKey:@"websitesAndApps"] count];
        if(deviceCount > 0 ){
            baseHeight += 40; // header height
            baseHeight += (deviceCount*40);
            //return 315;
        }
        if(websitesCount > 0){
            baseHeight += 40; // header height
            baseHeight += (websitesCount*40);
        }
        NSLog(@"returning height as %ld for index:%ld", baseHeight, indexPath.row);
        return baseHeight;
    }else{
        NSLog(@"returning height as 60 for index:%ld", indexPath.row);
        return 60;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{   /*
     if (section%(maxNumberOfSkills+1) == 0) {
     
     UILabel *planTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableview.frame.size.width, 44)];
     [planTitle setBackgroundColor:[UIColor lightGrayColor]];
     planTitle.numberOfLines = 1;
     planTitle.textAlignment = NSTextAlignmentCenter;
     planTitle.textColor = [UIColor whiteColor];
     planTitle.font = [UIFont boldSystemFontOfSize:16];
     NSDictionary *planDict = [ allMyPlanArray objectAtIndex:(section + 1)/(maxNumberOfSkills)];
     
     NSString *tStr = [@"Plan for " stringByAppendingFormat:@"%@", [planDict valueForKey:@"planName"]];
     
     planTitle.text = tStr;
     
     
     
     
     
     return planTitle;
     }
     
     
     
     NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"EditTipsCell" owner:nil options:nil];
     EditTipsCell *cell = [nibs lastObject];
     [cell.btnToggleCategory addTarget:self action:@selector(onClickToggleCategory:) forControlEvents:UIControlEventTouchUpInside];
     [cell.btnToggleCategory setTag:section];
     [cell.imgCategory setHidden:YES];
     [cell.contentView setBackgroundColor:[UIColor whiteColor]];
     
     int sectionForSkill = section - ((section) / (maxNumberOfSkills + 1) + 1);
     
     //  NSDictionary *skillDict = [allSkillsArray objectAtIndex:section];
     
     
     NSDictionary *skillDict = [allSkillsArray objectAtIndex:sectionForSkill];
     cell.lblTitle.text = [skillDict valueForKey:@"skillName"];
     
     cell.lblTitle.font = [UIFont systemFontOfSize:16.0f];
     if (![activeSkillsArray containsObject:skillDict]) {
     //   [cell.btnToggleCategory setBackgroundImage:[UIImage imageNamed:UN_SELECTED_IMAGE] forState:UIControlStateNormal];
     
     
     
     
     cell.btnToggleCategory.hidden=YES;
     cell.lblTitle.alpha=.3;
     //  [cell setAlpha:0.4];
     //      cell.btnToggleCategory.alpha=0;
     
     }
     else
     {
     //     [cell.btnToggleCategory setBackgroundImage:[UIImage imageNamed:SELECTED_IMAGE] forState:UIControlStateNormal];
     cell.btnToggleCategory.hidden=NO;
     cell.lblTitle.font = [UIFont boldSystemFontOfSize:16.0f];
     // cell.btnToggleCategory.alpha=1;
     
     
     if (![selectedSkills containsObject:skillDict]) {
     
     
     [cell.btnToggleCategory setBackgroundImage:[UIImage imageNamed:UN_SELECTED_IMAGE] forState:UIControlStateNormal];}
     else
     {
     [cell.btnToggleCategory setBackgroundImage:[UIImage imageNamed:SELECTED_IMAGE] forState:UIControlStateNormal];}
     
     
     }
     
     
     //  [cell setAlpha:1.0];
     
     
     //[cell.btnToggleCategory setBackgroundImage:[UIImage imageNamed:SELECTED_IMAGE] forState:UIControlStateNormal];
     
     
     
     
     return cell.contentView;
     
     
     
     
     */
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 320, 40)];
    label.backgroundColor = [UIColor grayColor];
    if (allMyPlanArray != nil && allMyPlanArray.count > 0) {
        label.text = [NSString stringWithFormat:@"Plan for %@",[[allMyPlanArray objectAtIndex:currentPlanIndex] objectForKey:@"planName"]];
        label.textAlignment = NSTextAlignmentCenter;
    }else{
        label.text = @"";
    }
    return label;
    
}


-(void)onClickToggleCategory:(UIButton *)sender
{
    NSInteger index = sender.tag;
    NSLog(@"ALLSKILL array %@",allSkillsArray);
    NSLog(@"section %ld",sender.tag);
    
    NSDictionary *skillDict = [[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:index];
    
    if ([selectedSkills containsObject:skillDict]) {
        
        
        [selectedSkills removeObject:skillDict];
    }
    else
    {
        
        [selectedSkills addObject:skillDict];
    }
    
    [self.tableview reloadData];
    
    
}

#pragma mark get all data

-(void)getAllSkillWithDetails
{
    
    NSString *queryForAllSkill = @"select * from Plan_skills";
    DBManager *dbManager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    
    
    NSArray *staticAllSkillsArray = [NSArray arrayWithArray:[dbManager loadDataFromDB:queryForAllSkill]];
    
    
    maxNumberOfSkills = (int)[staticAllSkillsArray count];
    
    
    
    NSString *queryForUsedDivecsInPlan = @"select * from MyDevices";
    
    NSArray *allPlanedDevices = [NSArray arrayWithArray:[dbManager loadDataFromDB:queryForUsedDivecsInPlan]];
    
    NSString *queryForUsedWebsites = @"select * from MyWebsites";
    
    NSArray *allPlannedWebsites = [NSArray arrayWithArray:[dbManager loadDataFromDB:queryForUsedWebsites]];
    
    NSMutableArray *sortedData = [NSMutableArray new];
    
    NSString *queryForMyPlan = @"SELECT * FROM MyPlans";
    
    NSArray *allMyPlan = [NSArray arrayWithArray:[dbManager loadDataFromDB:queryForMyPlan]];
    
    
    NSString *queryForMySkills = @"SELECT * FROM MySkills";
    
    NSArray *allMySkills = [NSArray arrayWithArray:[dbManager loadDataFromDB:queryForMySkills]];
    
    
    
    
    NSLog(@"ALLMYPLAN%@",allMyPlan);
    NSLog(@"STATIC SKILLS%@",staticAllSkillsArray);
    NSLog(@"LLMY SKILLS%@",allMySkills);
    
    
    
    
    
    [allMyPlanArray removeAllObjects];
    if(allMyPlan.count > 0)
        [allMyPlanArray addObjectsFromArray:allMyPlan];
    
    
    maxMyPlan = (int)[allMyPlanArray count];
    
    for (NSDictionary *myPlanRecord in allMyPlan)
    {
        
        for (NSDictionary *planSkillsRescord in staticAllSkillsArray)
        {
            NSMutableDictionary *skillDetails = [NSMutableDictionary new];
            [skillDetails setValue:[planSkillsRescord valueForKey:@"ID"] forKey:@"skillID"];
            [skillDetails setValue:[planSkillsRescord valueForKey:@"skillName"] forKey:@"skillName"];
            [skillDetails setValue:[myPlanRecord valueForKey:@"ID"] forKey:@"planID"];
            [skillDetails setValue:[myPlanRecord valueForKey:@"planName"] forKey:@"planName"];
            [skillDetails setValue:[myPlanRecord valueForKey:@"situationName"] forKey:@"situationName"];
            
            [skillDetails setValue:@"None" forKey:@"rating"];
            
            NSPredicate *predicateForFindDevices = [NSPredicate predicateWithFormat:@"self.skillID = %@ AND self.planID = %@",[planSkillsRescord valueForKey:@"ID"],[myPlanRecord valueForKey:@"ID"]];
            NSArray *respectiveDevicesForSkillAndPlanArray = [ allPlanedDevices filteredArrayUsingPredicate:predicateForFindDevices];
            NSArray *respectiveWebsitesForSkillAndPlanArray = [allPlannedWebsites filteredArrayUsingPredicate:predicateForFindDevices];
            
            NSMutableArray *usedDevicesArray = [NSMutableArray new];
            
            NSString *queryForPlanDevices = @"select * from Plan_Devices";
            
            
            NSArray *planDevicesArray = [dbManager loadDataFromDB:queryForPlanDevices];
            for (NSDictionary *usedDevicesRecord in respectiveDevicesForSkillAndPlanArray)
            {
                
                NSPredicate *predicateForGetDeviceInfo = [NSPredicate predicateWithFormat:@"self.ID = %@",[usedDevicesRecord valueForKey:@"deviceID"]];
                NSDictionary *deviceInfoDict = [[ planDevicesArray filteredArrayUsingPredicate:predicateForGetDeviceInfo] firstObject];
                if (deviceInfoDict != nil)
                {
                    
                    NSMutableDictionary *deviceDict = [NSMutableDictionary new];
                    [deviceDict setValue:[deviceInfoDict valueForKey:@"ID"] forKey:@"deviceID"];
                    [deviceDict setValue:[deviceInfoDict valueForKey:@"deviceName"] forKey:@"deviceName"];
                    [usedDevicesArray addObject:deviceDict];
                }
                
                
                
            }
            
            if (usedDevicesArray.count > 0) {
                
                [skillDetails setValue:usedDevicesArray forKey:@"devices"];
                
            }
            // now check for websites
            NSMutableArray *usedWebsitesArray = [NSMutableArray new];
            NSString* qeryForWebsites = @"select * from Plan_Website_Apps";
            NSArray *planWebsitesArray = [dbManager loadDataFromDB:qeryForWebsites];
            for (NSDictionary *usedWebsiteRecord in respectiveWebsitesForSkillAndPlanArray)
            {
                
                NSPredicate *predicateForGetWebsiteInfo = [NSPredicate predicateWithFormat:@"self.ID = %@",[usedWebsiteRecord valueForKey:@"websiteID"]];
                NSDictionary *websiteInfoDict = [[ planWebsitesArray filteredArrayUsingPredicate:predicateForGetWebsiteInfo] firstObject];
                if (websiteInfoDict != nil)
                {
                    
                    NSMutableDictionary *websiteDict = [NSMutableDictionary new];
                    [websiteDict setValue:[websiteInfoDict valueForKey:@"ID"] forKey:@"websiteID"];
                    [websiteDict setValue:[websiteInfoDict valueForKey:@"waName"] forKey:@"waName"];
                    [usedWebsitesArray addObject:websiteDict];
                }
                
                
                
            }
            if (usedWebsitesArray.count > 0) {
                
                [skillDetails setValue:usedWebsitesArray forKey:@"websitesAndApps"];
                
            }
            
            //    if ([[skillDetails objectAtIn] valueForKey:@"title"])
            
            [sortedData addObject:skillDetails];  // here is where you filter
            
        }
        
    }
    
    //    NSString *query = @"select  distinct DM.skillID,PS.skillName,DM.deviceID,PD.deviceName from MyDevices as DM,Plan_skills as PS,Plan_Devices as PD where DM.skillID=PS.ID and DM.deviceID=PD.ID";
    //    NSArray *resultArray = [dbManager loadDataFromDB:query];
    //
    [allSkillsArray removeAllObjects];
    [allSkillsArray addObjectsFromArray:sortedData];
    
    // NSLog(@"THI IS ThE DATA TO RECREATE %@",allSkillsArray);
    
    activeSkillsArray = [[NSMutableArray alloc] init];
    [activeSkillsArray removeAllObjects];
    
    for (NSDictionary *mySkillDict in allMySkills)
    {
        for (NSDictionary *allSkillDict in allSkillsArray)
        {
            if ([[mySkillDict valueForKey:@"skillID"] isEqual:[allSkillDict valueForKey:@"skillID"]] && [[mySkillDict valueForKey:@"planID"] isEqual:[allSkillDict valueForKey:@"planID"]])
            {
                //  NSLog(@"MYSKILLDICT %@",[mySkillDict valueForKey:@"skillID"]);
                NSLog(@"ALLSKILLDICT %@",allSkillDict);//[allSkillDict valueForKey:@"skillID"]);
                //  }
                
                //    if ([mySkillDict valueForKey:@"planID"]  == [allSkillDict valueForKey:@"planID"]) //&& [mySkillDict valueForKey:@"skillID"]  == [allSkillDict valueForKey:@"skillID"])
                //     {
                
                [activeSkillsArray addObject:allSkillDict];
                
                
                //   }
                
                
                
            }
            
        }
    }
    
    //categorize the selected skills as per plan
    [categorizedSkills removeAllObjects];
    for (NSDictionary *myPlanRecord in allMyPlan){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.planID = %@",[myPlanRecord valueForKey:@"ID"]];
        NSArray* array = [activeSkillsArray filteredArrayUsingPredicate:predicate];
        [categorizedSkills addObject:array];
    }
    
    //  [allSkillsArray removeAllObjects];
    //  allSkillsArray = activeSkillsArray;
    
    NSLog(@"%@",allSkillsArray);
    
    [_tableview reloadData];
}






#pragma mark feedback button action

-(void)noatallButtonAction:(NSInteger)index
{
    
    //NSInteger index = pressedButton.tag;
    
    NSMutableDictionary *skilDict = [[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:index];
    /*
     NSMutableDictionary *newfDict = [NSMutableDictionary new];
     
     [newfDict setValue:[skilDict valueForKey:@"skillName"] forKey:@"skillName"];
     [newfDict setValue:@"1" forKey:@"rating"];
     [newfDict setValue:[skilDict valueForKey:@"planName"] forKey:@"planName"];
     [newfDict setValue:[skilDict valueForKey:@"situationName"] forKey:@"situationName"];
     */
    if(![feedbackArray containsObject:skilDict]){
        [feedbackArray addObject:skilDict];
    }
    [skilDict setObject:@"1" forKey:@"rating"];
    
    for(NSMutableDictionary *dict in selectedSkills){
        if([[dict objectForKey:@"planName"] isEqual:[skilDict valueForKey:@"planName"]] && [[dict objectForKey:@"skillName"] isEqual:[skilDict valueForKey:@"skillName"]] && [[dict objectForKey:@"situationName"] isEqual:[skilDict valueForKey:@"situationName"]] ) {
            [dict setObject:@"1" forKey:@"rating"];
        }
    }
    
    //    NSLog(@"FBARRAY   %@",section);
    
    
    [self.tableview reloadData];
    
    
    /* UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Tinnitus Coach"  message:@"You rated 'not at all' for this skill" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
     // [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
     [alertView show];
     
     */
    
    
}
-(void)alittleButtonButtonAction:(NSInteger)index
{
    //NSInteger index = pressedButton.tag;
    // int sectionForSkill = section - ((section) / (maxNumberOfSkills + 1) + 1);
    
    NSMutableDictionary *skilDict = [[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:index];
    /*
     NSMutableDictionary *newfDict = [NSMutableDictionary new];
     
     [newfDict setValue:[skilDict valueForKey:@"skillName"] forKey:@"skillName"];
     [newfDict setValue:@"2" forKey:@"rating"];
     [newfDict setValue:[skilDict valueForKey:@"planName"] forKey:@"planName"];
     [newfDict setValue:[skilDict valueForKey:@"situationName"] forKey:@"situationName"];
     */
    if(![feedbackArray containsObject:skilDict]){
        [feedbackArray addObject:skilDict];
    }
    [skilDict setObject:@"2" forKey:@"rating"];
    
    
    for(NSMutableDictionary *dict in selectedSkills){
        if([[dict objectForKey:@"planName"] isEqual:[skilDict valueForKey:@"planName"]] && [[dict objectForKey:@"skillName"] isEqual:[skilDict valueForKey:@"skillName"]] && [[dict objectForKey:@"situationName"] isEqual:[skilDict valueForKey:@"situationName"]] ) {
            [dict setObject:@"2" forKey:@"rating"];
        }
    }
    
    [self.tableview reloadData];
    /*  UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Tinnitus Coach"  message:@"You rated 'a little' for this skill" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
     // [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
     [alertView show];
     */
}
-(void)moderatelyButtonAction:(NSInteger)index
{
    //NSInteger index = pressedButton.tag;
    //int sectionForSkill = section - ((section) / (maxNumberOfSkills + 1) + 1);
    
    NSMutableDictionary *skilDict = [[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:index];
    /*
     NSMutableDictionary *newfDict = [NSMutableDictionary new];
     
     [newfDict setValue:[skilDict valueForKey:@"skillName"] forKey:@"skillName"];
     [newfDict setValue:@"3" forKey:@"rating"];
     [newfDict setValue:[skilDict valueForKey:@"planName"] forKey:@"planName"];
     [newfDict setValue:[skilDict valueForKey:@"situationName"] forKey:@"situationName"];
     */
    if(![feedbackArray containsObject:skilDict]){
        [feedbackArray addObject:skilDict];
    }
    [skilDict setObject:@"3" forKey:@"rating"];
    
    
    for(NSMutableDictionary *dict in selectedSkills){
        if([[dict objectForKey:@"planName"] isEqual:[skilDict valueForKey:@"planName"]] && [[dict objectForKey:@"skillName"] isEqual:[skilDict valueForKey:@"skillName"]] && [[dict objectForKey:@"situationName"] isEqual:[skilDict valueForKey:@"situationName"]] ) {
            [dict setObject:@"3" forKey:@"rating"];
        }
    }
    
    [self.tableview reloadData];
    
    /*  UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Tinnitus Coach"  message:@"You rated 'moderately' for this skill" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
     // [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
     [alertView show];
     */
}
-(void)extremelyButtonAction:(NSInteger)index
{
    //NSInteger index = pressedButton.tag;
    // int sectionForSkill = section - ((section) / (maxNumberOfSkills + 1) + 1);
    
    NSMutableDictionary *skilDict = [[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:index];
    
    /*   NSMutableDictionary *newfDict = [NSMutableDictionary new];
     
     [newfDict setValue:[skilDict valueForKey:@"skillName"] forKey:@"skillName"];
     [newfDict setValue:@"5" forKey:@"rating"];
     [newfDict setValue:[skilDict valueForKey:@"planName"] forKey:@"planName"];
     [newfDict setValue:[skilDict valueForKey:@"situationName"] forKey:@"situationName"];
     */
    if(![feedbackArray containsObject:skilDict]){
        [feedbackArray addObject:skilDict];
    }
    [skilDict setObject:@"5" forKey:@"rating"];
    
    
    for(NSMutableDictionary *dict in selectedSkills){
        if([[dict objectForKey:@"planName"] isEqual:[skilDict valueForKey:@"planName"]] && [[dict objectForKey:@"skillName"] isEqual:[skilDict valueForKey:@"skillName"]] && [[dict objectForKey:@"situationName"] isEqual:[skilDict valueForKey:@"situationName"]] ) {
            [dict setObject:@"5" forKey:@"rating"];
        }
    }
    
    [self.tableview reloadData];
    
    /* UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Tinnitus Coach"  message:@"You rated 'exteremely' for this skill" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
     // [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
     [alertView show];
     */
}
-(void)veryMuchButtonAction:(NSInteger)index
{
    //NSInteger index = pressedButton.tag;
    //int sectionForSkill = section - ((section) / (maxNumberOfSkills + 1) + 1);
    
    NSMutableDictionary *skilDict = [[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:index];
    
    /*   NSMutableDictionary *newfDict = [NSMutableDictionary new];
     
     [newfDict setValue:[skilDict valueForKey:@"skillName"] forKey:@"skillName"];
     [newfDict setValue:@"4" forKey:@"rating"];
     [newfDict setValue:[skilDict valueForKey:@"planName"] forKey:@"planName"];
     [newfDict setValue:[skilDict valueForKey:@"situationName"] forKey:@"situationName"];
     */
    if(![feedbackArray containsObject:skilDict]){
        [feedbackArray addObject:skilDict];
    }
    [skilDict setObject:@"4" forKey:@"rating"];
    
    
    for(NSMutableDictionary *dict in selectedSkills){
        if([[dict objectForKey:@"planName"] isEqual:[skilDict valueForKey:@"planName"]] && [[dict objectForKey:@"skillName"] isEqual:[skilDict valueForKey:@"skillName"]] && [[dict objectForKey:@"situationName"] isEqual:[skilDict valueForKey:@"situationName"]] ) {
            [dict setObject:@"4" forKey:@"rating"];
        }
    }
    
    [self.tableview reloadData];
    /*  UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Tinnitus Coach"  message:@"You rated 'very much' for this skill" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
     // [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
     [alertView show];
     */
}

- (IBAction)cancelTapped:(id)sender {
    
    
    for (NSDictionary *myskills in selectedSkills) {
        NSString *sName = [myskills valueForKey:@"skillName"];
        NSString  *pName = [myskills valueForKey:@"planName"];
        NSString  *sitName = [myskills valueForKey:@"situationName"];
        
        NSString  *rating = [myskills valueForKey:@"rating"];
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
        NSString *type = @"Weekly Reminder";
        
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"/:,"];
        //    s = [[s componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @"|"];
        
        
        
        NSString *str = @"Provided Rating";
        NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,pName,sitName,sName,nil,nil,nil,nil,nil,nil,rating,@""];
        
        NSLog(@"%@",finalStr);
        
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //    NSLog(@"%@",sName);
    //}
    
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        //
        //        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"] ];
        //
        //        hud.mode = MBProgressHUDModeCustomView;
        //
        //        hud.labelText = @"Thanks for the feedback!";
        //
        //        [hud show:YES];
        //        [hud hide:YES afterDelay:1];
        //
        //
        
        //        UIStoryboard *storyBoard = [ UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        UIViewController *mySleepsViewCotroller = [storyBoard instantiateViewControllerWithIdentifier:@"SkillRatingsViewController"];
        //        UIWindow *currentWindow = [[UIApplication sharedApplication].windows firstObject];
        //        [currentWindow.rootViewController presentViewController:mySleepsViewCotroller animated:YES completion:nil];
        
        
        //        UIStoryboard *storyBoard = [ UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        UIViewController *mySleepsViewCotroller = [storyBoard instantiateViewControllerWithIdentifier:@"TipsReminder"];
        //        UIWindow *currentWindow = [[UIApplication sharedApplication].windows firstObject];
        //        [currentWindow.rootViewController presentViewController:mySleepsViewCotroller animated:YES completion:nil];
        
        
        
        
    }];
}


-(IBAction)barButtonPressed:(id)sender{
    NSInteger btnIndex = ((UIView*)sender).tag;
    NSLog(@"bar btn pressed with sender:%@  tag: %ld", sender, btnIndex);
    switch (btnIndex) {
        case 1001:
            [self showPreviousPlan];
            break;
        case 1002:
            [self showNextPlan];
        default:
            break;
    }
    
}

-(void)showPreviousPlan{
    if(currentPlanIndex > 0){
        if(currentPlanIndex == maxMyPlan-1)
            self.nextBtn.hidden = NO;
        currentPlanIndex--;
        if(currentPlanIndex == 0)
            self.previousBtn.hidden = YES;
        self.submittBtn.hidden = YES;
        [self.tableview reloadData];
    }
    
    
}

-(void)showNextPlan{
    if(currentPlanIndex < maxMyPlan-1){
        if(currentPlanIndex == 0){
            self.previousBtn.hidden = NO;
        }
        currentPlanIndex++;
        if(currentPlanIndex == maxMyPlan -1){
            self.nextBtn.hidden = YES;
            self.submittBtn.hidden = NO;
        }else{
            self.submittBtn.hidden = YES;
        }
        [self.tableview reloadData];
    }
}


#pragma mark -

- (CGFloat)feeedbackTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}

- (UIView *)feeedbackTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 320, 30)];
    label.backgroundColor = [UIColor lightGrayColor];
    NSDictionary* skillDict = [[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:tableView.tag];
    NSInteger deviceCount = [(NSArray*)[skillDict objectForKey:@"devices"] count];
    //NSInteger websitesCount = [(NSArray*)[skillDict objectForKey:@"websitesAndApps"] count];
    if(deviceCount > 0){
        if(section == 0){
            label.text = @"This plan has these devices";
            
        }else{
            label.text = @"This plan has these websites";
        }
    }else{
        label.text = @"This plan has these websites";
    }
    
    return label;
}

-(NSString *)feedbackTableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"This plan has these devices";
    }else{
        return @"This plan has these websites";
    }
    
}

- (void)feeedbackTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (NSInteger)feeedbackTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //get the current skill
    NSDictionary* skillDict = [[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:tableView.tag];
    NSArray* deviceArray = [skillDict objectForKey:@"devices"];
    NSArray* websiteArray = [skillDict objectForKey:@"websitesAndApps"];
    if(deviceArray.count > 0){
        if(section == 0){
            return deviceArray.count;
        }else if(section == 1){
            return websiteArray.count;
        }else{
            return 0;
        }
    }else{
        return  websiteArray.count;
    }
    
}



- (NSInteger)numberOfSectionsInFeeedbackTableView:(UITableView *)tableView{
    //get the current skill
    int sectionCount = 0;
    NSDictionary* skillDict = [[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:tableView.tag];
    NSArray* deviceArray = [skillDict objectForKey:@"devices"];
    NSArray* websitesArray = [skillDict objectForKey:@"websitesAndApps"];
    sectionCount = deviceArray.count > 0 ? sectionCount+1 : sectionCount;
    sectionCount = websitesArray.count > 0 ? sectionCount +1 : sectionCount;
    return sectionCount;
}

- (UITableViewCell *)feeedbackTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"devicefeedbackcell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"devicefeedbackcell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.890625 green:0.890625 blue:0.890625 alpha:1.0];
        cell.contentView.layer.masksToBounds = YES;
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSDictionary* skillDict = [[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:tableView.tag];
    NSArray* deviceArray = [skillDict objectForKey:@"devices"];
    NSArray* websiteArray = [skillDict objectForKey:@"websitesAndApps"];
    if(deviceArray.count > 0){
        if(section == 0){
            cell.textLabel.text = [[deviceArray objectAtIndex:indexPath.row] valueForKey:@"deviceName"];
        }else{
            cell.textLabel.text = [[websiteArray objectAtIndex:row] valueForKey:@"waName"];
        }
    }else{
        cell.textLabel.text = [[websiteArray objectAtIndex:row] valueForKey:@"waName"];
    }
    
    return cell;
}

-(void)itemClickedForRating:(NSInteger)ratingIndex inCell:(id)cell{
    NSIndexPath* indexPath = [self.tableview indexPathForCell:(UITableViewCell *)cell];
    switch (ratingIndex) {
        case 101:
            [self noatallButtonAction:indexPath.row];
            break;
        case 102:
            [self alittleButtonButtonAction:indexPath.row];
            break;
        case 103:
            [self moderatelyButtonAction:indexPath.row];
            break;
        case 104:
            [self veryMuchButtonAction:indexPath.row];
            break;
        case 105:
            [self extremelyButtonAction:indexPath.row];
            break;
        default:
            break;
    }
    
    
}

@end
