//
//  WeeklyViewController.m
//  TinnitusCoach
//
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#define UN_SELECTED_IMAGE @""
#define SELECTED_IMAGE @"Selected_CheckBox.png"

#import "WeeklyViewController.h"
#import "FeedbackTableViewCell.h"
#import "EditTipsCell.h"
#import "MBProgressHUD.h"
#import "FeedbackDeviceTableViewCell.h"


@interface WeeklyViewController ()
{
    NSMutableArray *allSkillsArray,*categorizedSkills,*allMyPlanArray,*activeSkillsArray;
    BOOL firtTimeLoad;
    NSMutableArray *selectedSkills;
    NSMutableArray *feedbackArray;
    NSMutableArray *selectedDeviceArray;
    NSMutableArray *feedbackDeviceArray;
    int maxNumberOfSkills,maxMyPlan;
    int currentPlanIndex;
    
}


@property(nonatomic, strong)UILabel *submitLabel;


@end

@implementation WeeklyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    
    titleView.backgroundColor = [Utils colorWithHexValue:NAV_BAR_BLACK_COLOR];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 320, 24)];
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_1];
    
    titleLabel.font = pallete.secondObj;
    titleLabel.textColor = pallete.firstObj;
    
    UILabel *submitLabel = [[UILabel alloc]initWithFrame:CGRectMake(230, 30, 70, 24)];
    
    [Utils addTapGestureToView:submitLabel target:self selector:@selector(cancelTapped:)];
    
    submitLabel.textAlignment = NSTextAlignmentRight;
    
    submitLabel.text = @"Submit";
    
    submitLabel.textColor = [Utils colorWithHexValue:BUTTON_BLUE_COLOR_HEX_VALUE];
    
    submitLabel.hidden = true;
    
    self.submitLabel = submitLabel;
    
    [titleView addSubview:submitLabel];
    
    [titleView addSubview:titleLabel];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //titleLabel.textColor = [UIColor colorWithHexValue:@"797979"];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"Weekly Reminder";
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, titleView.frame.size.height - 1, 320, 1)];
    
    line.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.098/255.0 alpha:0.22];;
    
    [titleView addSubview:line];
    
    [self.view addSubview:titleView];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 65, 320, 64)];
    
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 64)];
    
    pallete = [Utils getColorFontPair:eCFS_PALLETE_2];
    
    headerLabel.text = @"Select the skills you used in your plans in the past week. To change your list of skills for the upcoming week, visit the \"Plans\" section.";
    
    headerLabel.numberOfLines = 10;
    
    headerLabel.font = pallete.secondObj;
    headerLabel.textColor = pallete.firstObj;
    headerLabel.backgroundColor = [UIColor clearColor];
    
    headerView.backgroundColor = [Utils colorWithHexValue:@"EFEFF4"];
    
    [headerView addSubview:headerLabel];
    
    [self.view addSubview:headerView];
    
    // Do any additional setup after loading the view.
    allSkillsArray = [NSMutableArray new];
    allMyPlanArray = [NSMutableArray new];
    categorizedSkills = [NSMutableArray new];
    
    firtTimeLoad = YES;
    //self.title = @"Weekly Reminder";
    
    selectedSkills = [NSMutableArray new];
    selectedDeviceArray = [NSMutableArray new];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //[self.view setBackgroundColor:[UIColor colorWithRed:0.96078431 green:0.96078431 blue:0.96078431 alpha:1]];
    
    [self getAllSkillWithDetails];
    //[self.tableview setBackgroundColor:[UIColor redColor]];
    feedbackArray = [NSMutableArray new];
    currentPlanIndex = 0;
    self.previousBtn.hidden = YES;
    [self.tableview registerNib:[UINib nibWithNibName:@"SkillFeedbackCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SkillFeedbackCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"UsingSoundFeedbackCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UsingSoundFeedbackCell"];
    if(categorizedSkills != nil && categorizedSkills.count > 1){
        self.submitLabel.hidden = YES;
    }else{
        self.submitLabel.hidden = NO;
    }
    if(categorizedSkills != nil && categorizedSkills.count ==1){
        self.nextBtn.hidden = YES;
        [self.topleftconstraint setConstant:130];
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
    UITableViewCell* cell = nil;
    // get the current item from array
    NSDictionary* skill = [[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:indexPath.row];
    if ([[skill valueForKey:@"skillName"] isEqualToString:@"Using Sound"]) {
        static NSString *feedbackCellIdentifier = @"UsingSoundFeedbackCell";
        cell = [tableView dequeueReusableCellWithIdentifier:feedbackCellIdentifier];
        if(cell == nil)
        {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"UsingSoundFeedbackCell" owner:nil options:nil];
            cell = [nibs firstObject];
            [cell.contentView setBackgroundColor:[UIColor greenColor]];
            cell.contentView.layer.cornerRadius = 5;
            //cell.contentView.layer.masksToBounds = YES;
            
            
        }
        [self initUsingSoundCell:(UsingSoundFeedbackCell*)cell ForSkill:skill atRow:indexPath.row];
    }else{
        static NSString *feedbackCellIdentifier = @"SkillFeedbackCell";
        cell = [tableView dequeueReusableCellWithIdentifier:feedbackCellIdentifier];
        if(cell == nil)
        {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"SkillFeedbackCell" owner:nil options:nil];
            cell = [nibs firstObject];
            [cell.contentView setBackgroundColor:[UIColor greenColor]];
            cell.contentView.layer.cornerRadius = 5;
            //cell.contentView.layer.masksToBounds = YES;
        }
        [self initSkillFeedbackCell:(SkillFeedbackCell*)cell ForSkill:skill atRow:indexPath.row];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor brownColor]];
    return cell;
}

-(void)initSkillFeedbackCell:(SkillFeedbackCell*)cell ForSkill:(NSDictionary*)skill atRow:(NSInteger)row{
    // reinitialize this cell
    [cell reInitialize];
    cell.skillNameLabel.text = [skill valueForKey:@"skillName"];
    //    UIFont* boldFont = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    //    cell.skillNameLabel.font = boldFont;
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
                    [cell fillbutton:cell.noatallButton];
                    break;
                }
                case 2:
                {
                    //[cell.alittleButton setBackgroundImage:[UIImage imageNamed:@"selectedCircle"] forState:UIControlStateNormal];
                    [cell fillbutton:cell.alittleButton];
                    
                    break;
                }
                case 3:
                {
                    [cell fillbutton:cell.moderatelyButton];
                    //[cell.moderatelyButton setBackgroundImage:[UIImage imageNamed:@"selectedCircle"] forState:UIControlStateNormal];
                    break;
                }
                case 4:
                {
                    [cell fillbutton:cell.veryMuchButton];
                    //[cell.veryMuchButton setBackgroundImage:[UIImage imageNamed:@"selectedCircle"] forState:UIControlStateNormal];
                    break;
                }
                case 5:
                {
                    [cell fillbutton:cell.extremelyButton];
                    //[cell.extremelyButton setBackgroundImage:[UIImage imageNamed:@"selectedCircle"] forState:UIControlStateNormal];
                    break;
                }
                default:
                    break;
            }
            
        }else{
            // skill is not selected.
            [cell.itemSelctorBtnImage  setImage:[UIImage imageNamed:UN_SELECTED_IMAGE]];
            
        }
        cell.itemSelectorBtn.tag = row;
        // add selector for itemselector
        [cell.itemSelectorBtn addTarget:self action:@selector(onClickToggleCategory:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        // skill not added
        // let it be unselcted
        // nothing to do.
    }
    
}

-(void)initUsingSoundCell:(UsingSoundFeedbackCell*)cell ForSkill:(NSDictionary*)skill atRow:(NSInteger)row{
    // reinitialize this cell
    [cell reInitialize];
    cell.skillNameLabel.text = [skill valueForKey:@"skillName"];
    if([self isSkilladdedToPlan:skill]){
        //skill is added to plan
        // let's enable the review process
        cell.itemSelectorBtn.hidden = NO;
        cell.itemSelctorBtnImage.hidden = NO;
        // further check if this has been already selected
        if([self isSkillAlreadySelected:skill]){
            [cell.itemSelctorBtnImage  setImage:[UIImage imageNamed:SELECTED_IMAGE]];
            cell.usingSoundTableView.hidden = NO;
            cell.usingSoundTableView.scrollEnabled = NO;
            cell.usingSoundTableView.tag = (10000 + row);
            [cell.usingSoundTableView reloadData];

        }else{
            // skill is not selected.
            [cell.itemSelctorBtnImage  setImage:[UIImage imageNamed:UN_SELECTED_IMAGE]];
        }
        cell.itemSelectorBtn.tag = row;
        // add selector for itemselector
        [cell.itemSelectorBtn addTarget:self action:@selector(onClickToggleCategory:) forControlEvents:UIControlEventTouchUpInside];
        cell.delegate = self;
    }
    
        
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
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* skill = [[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:indexPath.row];
    if([[skill valueForKey:@"skillName"] isEqualToString:@"Using Sound"]){
        if([selectedSkills containsObject:skill]){
            NSInteger baseHeight = 200 + 55;
            NSArray* deviceArray= (NSArray*)[skill objectForKey:@"devices"];
            NSArray* websiteArray = (NSArray*)[skill objectForKey:@"websitesAndApps"];
            if ([[skill valueForKey:@"group1"] isEqualToString:@"YES"]){
                baseHeight = baseHeight +180;
                if(deviceArray.count > 0)
                    baseHeight = baseHeight + 40*deviceArray.count;
                else
                   baseHeight = baseHeight + 40*websiteArray.count;
            }
            if(deviceArray.count > 0)
                baseHeight = baseHeight + 50;
            if ([[skill valueForKey:@"group2"] isEqualToString:@"YES"]){
                baseHeight = baseHeight +180;
                baseHeight = baseHeight + 40*websiteArray.count;
                //baseHeight = websiteArray.count > 0 ? baseHeight + 50:baseHeight;
            }
            if(websiteArray.count > 0)
                baseHeight = baseHeight + 50;
            NSLog(@"returning height as %ld for index:%ld", baseHeight, indexPath.row);
            return baseHeight;
        }else{
            NSLog(@"returning height as 60 for index:%ld", indexPath.row);
            return 60;
        }

    }else{
        if([selectedSkills containsObject:skill]){
            return 190;
        }else{
            return 60;
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 320, 40)];
    label.backgroundColor = [Utils colorWithHexValue:@"EEEEEE"];
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
    [self reloadAllInnerTableViews];
    
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
    
    [self performSelector:@selector(dismissSelf) withObject:nil afterDelay:1.2];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"] ];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"Thanks for the feedback!";
    [hud show:YES];
    [hud hide:YES afterDelay:1];
    
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
        NSString *str = @"Provided Rating";
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if(![sName isEqualToString:@"Using Sound"]){
           NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,pName,sitName,sName,nil,nil,nil,nil,nil,nil,rating,@""];
            NSLog(@"%@",finalStr);
            
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

        }else{
            // using sound skill
            BOOL isSoundLoggable = NO;
            BOOL isDeviceLoggable = NO;
            BOOL isWebLoggable = NO;
            //get the sound rating
            NSString* soundRating = nil;
            NSArray* deviceArray = [myskills objectForKey:@"devices"];
            NSArray* websiteArray = [myskills objectForKey:@"websitesAndApps"];
            if([[myskills valueForKey:@"group0"] isEqualToString:@"YES"]){
                soundRating = [myskills valueForKey:@"group0rating"];
                isSoundLoggable = YES;
            }
            // get devices rating
            NSString* deviceRating = nil;
            NSString* webRating = nil;
            if([[myskills valueForKey:@"group1"] isEqualToString:@"YES"]){
                if(deviceArray.count > 0){
                    deviceRating = [myskills valueForKey:@"group1rating"];
                    isDeviceLoggable = YES;
                }else{
                    webRating = [myskills valueForKey:@"group1rating"];
                    isWebLoggable = YES;
                }
            }
            // get websites and apps rating
            if([[myskills valueForKey:@"group2"] isEqualToString:@"YES"]){
                webRating = [myskills valueForKey:@"group2rating"];
                isWebLoggable = YES;
            }
            // now check for the devices and websites
            NSMutableString* selectedDeviceNames = [[NSMutableString alloc] init];
            NSMutableString* selectedWebNames = [[NSMutableString alloc] init];

            for (NSDictionary* deviceDict in deviceArray) {
                if([[deviceDict valueForKey:@"selected"] isEqualToString:@"YES"]){
                    [selectedDeviceNames appendString:@"("];
                    [selectedDeviceNames appendString:[deviceDict valueForKey:@"deviceName"]];
                    [selectedDeviceNames appendString:@") "];
                }
            }
            
            for (NSDictionary* webDict in websiteArray) {
                if([[webDict valueForKey:@"selected"] isEqualToString:@"YES"]){
                    [selectedWebNames appendString:@"("];
                    [selectedWebNames appendString:[webDict valueForKey:@"waName"]];
                    [selectedWebNames appendString:@") "];
                }
            }
            NSMutableArray* combinedStringArray = [[NSMutableArray alloc] init];
            // create sound log string
            NSString* soundLogString = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,pName,sitName,sName,@"Tinnitus Coach Sounds and My Own Sounds",nil,nil,nil,nil,nil,soundRating,@""];
            if(isSoundLoggable)
                [combinedStringArray addObject:soundLogString];
            //create device log string
            NSString* deviceLogString = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,pName,sitName,sName,@"Devices",selectedDeviceNames,nil,nil,nil,nil,deviceRating,@""];
            if(isDeviceLoggable)
                [combinedStringArray addObject:deviceLogString];
            //create website log string
            NSString* webLogString = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,pName,sitName,sName,@"Websites & Apps",selectedWebNames,nil,nil,nil,nil,webRating,@""];
            if(isWebLoggable)
                [combinedStringArray addObject:webLogString];
            
            for (NSString* str in combinedStringArray) {
                if(![fileManager fileExistsAtPath:documentTXTPath])
                {
                    [str writeToFile:documentTXTPath atomically:YES];
                }
                else
                {
                    NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:documentTXTPath];
                    [myHandle seekToEndOfFile];
                    [myHandle writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
                    
                }
                
            }

            
        }
        
        
        

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //    NSLog(@"%@",sName);
    //}
    
    
    
    //[self dismissViewControllerAnimated:YES completion:^{
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
        
        
        
        
   // }];
}

-(void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:^{}];
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
        [self.tableview reloadData];
        [self reloadAllInnerTableViews];
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
            self.submitLabel.hidden = NO;
        }else{
            self.submitLabel.hidden = YES;
        }
        [self.tableview reloadData];
        [self reloadAllInnerTableViews];
    }
}

-(void)reloadAllInnerTableViews{
    for (int section = 0; section < [self.tableview numberOfSections]; section++) {
        for (int row = 0; row < [self.tableview numberOfRowsInSection:section]; row++) {
            NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:section];
            UITableViewCell* cell = [self.tableview cellForRowAtIndexPath:cellPath];
            if([cell isKindOfClass:[UsingSoundFeedbackCell class]]){
                [((UsingSoundFeedbackCell*)cell).usingSoundTableView reloadData];
            }
        }
    }

}


#pragma mark -

- (CGFloat)feeedbackTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath inUsingSound:(id)cell{
    
    return 40;
}
    


- (UIView *)feeedbackTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section inUsingSound:(id)cell{

        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, 290, 30)];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    label.numberOfLines = 2;
    label.textColor = [Utils colorWithHexValue:BUTTON_BLUE_COLOR_HEX_VALUE];
    NSIndexPath* cellIndexPath = [self.tableview indexPathForCell:cell];
    //get the current skill
    NSDictionary* skillDict = [[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:cellIndexPath.row];
    NSArray* deviceArray = [skillDict objectForKey:@"devices"];
        if(tableView.tag == 1001){
            if(deviceArray.count > 0)
                label.text = @"Which devices did you use?";
            else
                label.text = @"Which websites & apps did you use?";
            
        }else if(tableView.tag == 1002){
            label.text = @"Which websites & apps did you use?";
        }

    [view addSubview:label];
    
    return view;
 
}

-(NSString *)feedbackTableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section inUsingSound:(id)cell{
    NSIndexPath* cellIndexPath = [self.tableview indexPathForCell:cell];
    //get the current skill
    NSDictionary* skillDict = [[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:cellIndexPath.row];
    NSArray* deviceArray = [skillDict objectForKey:@"devices"];
    if(tableView.tag == 1001){
        if(deviceArray.count > 0)
            return @"Which devices did you use?";
        else
           return @"Which websites & apps did you use?";
    }else if(tableView.tag ==1002){
        return @"Which websites & apps did you use?";
    }else{
        return @"Hello there";
    }
  
}

- (void)feeedbackTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath inUsingSound:(id)cell{
    
}


- (NSInteger)feeedbackTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section inUsingSound:(id)cell{
    NSInteger index = tableView.tag;
    NSLog(@"feedback cell index: %ld", tableView.tag);
    NSIndexPath* cellIndexPath = [self.tableview indexPathForCell:cell];
    //get the current skill
    NSDictionary* skillDict = [[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:cellIndexPath.row];
    NSArray* deviceArray = [skillDict objectForKey:@"devices"];
    NSArray* websiteArray = [skillDict objectForKey:@"websitesAndApps"];
        if(tableView.tag == 1001){
            if(deviceArray.count > 0){
                return deviceArray.count;
            }else{
               return websiteArray.count;
            }
            
        }else if(tableView.tag == 1002){
            return websiteArray.count;
        }else{
            return 0;
        }


}



- (NSInteger)numberOfSectionsInFeeedbackTableView:(UITableView *)tableView inUsingSound:(id)cell{
    return 1;
}

- (UITableViewCell *)feeedbackTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath inUsingSound:(id)usingSoundCell{
    
    static NSString *feedbackCellIdentifier = @"FeedbackDeviceCellIdentifier";
    FeedbackDeviceTableViewCell *cell = (FeedbackDeviceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:feedbackCellIdentifier];
    if(cell == nil)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"FeedbackDeviceTableViewCell" owner:nil options:nil];
        cell = [nibs firstObject];
        // [cell.contentView setBackgroundColor:[UIColor greenColor]];
        cell.contentView.layer.cornerRadius = 5;
        //cell.contentView.layer.masksToBounds = YES;
        
        
    }
    // reinitialize this cell
    [cell reInitialize];
    NSIndexPath* cellIndexPath = [self.tableview indexPathForCell:usingSoundCell];
    //get the current skill
    NSDictionary* skillDict = [[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:cellIndexPath.row];
    NSArray* deviceArray = [skillDict objectForKey:@"devices"];
    NSArray* websiteArray = [skillDict objectForKey:@"websitesAndApps"];
    NSDictionary* deviceDict = nil;
        if(tableView.tag == 1001){
            if(deviceArray.count > 0){
                deviceDict = [deviceArray objectAtIndex:indexPath.row];
                cell.skillNameLabel.text = [deviceDict valueForKey:@"deviceName"];
            }else{
                deviceDict = [websiteArray objectAtIndex:indexPath.row];
                cell.skillNameLabel.text = [deviceDict valueForKey:@"waName"];
            }
        }else{
            deviceDict = [websiteArray objectAtIndex:indexPath.row];
            cell.skillNameLabel.text = [deviceDict valueForKey:@"waName"];
        }
    
    cell.itemSelectorBtn.hidden = NO;
    cell.itemSelctorBtnImage.hidden = NO;
    // further check if this has been already selected
    if([[deviceDict valueForKey:@"selected"] isEqualToString:@"YES"]){
        [cell.itemSelctorBtnImage  setImage:[UIImage imageNamed:SELECTED_IMAGE]];
        //show the expanded view
        cell.secondaryView.hidden = YES;
        cell.secondaryView.userInteractionEnabled = NO;
        // lets show the correct color of the selcted indiccator
        //cell.feedbackTableView.hidden =YES;
    }else{
        // skill is not selected.
        [cell.itemSelctorBtnImage  setImage:[UIImage imageNamed:UN_SELECTED_IMAGE]];
        
    }
    cell.itemSelectorBtn.tag = indexPath.row;
    // add selector for itemselector
   // [cell.itemSelectorBtn addTarget:self action:@selector(onClickToggleDeviceCategory:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor redColor]];
    return cell;
}

-(void)itemClickedForRating:(NSInteger)ratingIndex inCell:(id)cell inUsingSound:(id)usCell{
    NSIndexPath* indexPath = [self.tableview indexPathForCell:usCell];
    NSIndexPath* groupIndexPath = [((UsingSoundFeedbackCell*)usCell).usingSoundTableView indexPathForCell:cell];
    //get the skill
    //get the skill item
    NSMutableDictionary *skillDict = [[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:indexPath.row];
    // select group if not already
    NSString* key = [NSString stringWithFormat:@"group%ld",groupIndexPath.row];
    [skillDict setValue:@"YES" forKey:key];
    key = [NSString stringWithFormat:@"group%ldrating",groupIndexPath.row];
    switch (ratingIndex) {
        case 101:
            [skillDict setValue:@"1" forKey:key];
            break;
        case 102:
            [skillDict setValue:@"2" forKey:key];
            break;
        case 103:
            [skillDict setValue:@"3" forKey:key];
            break;
        case 104:
            [skillDict setValue:@"4" forKey:key];
            break;
        case 105:
            [skillDict setValue:@"5" forKey:key];
            break;
        default:
            break;
    }
    
    [self.tableview reloadData];
    
}

-(void)deviceItemClickedForRating:(NSInteger)rating :(NSIndexPath *)deviceIndexPath inCell:(id)cell inUsingSound:(id)usCell{
    // get the main cell indexpath
    NSIndexPath* indexPath = [self.tableview indexPathForCell:usCell];
    //get the skill item
    NSMutableDictionary *skillDict = [[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:indexPath.row];
    if(![selectedSkills containsObject:skillDict]){
        [selectedSkills addObject:skillDict];
    }

    NSIndexPath* groupIndexPath = [((UsingSoundFeedbackCell*)usCell).usingSoundTableView indexPathForCell:cell];
    // select the group
    NSString* key = [NSString stringWithFormat:@"group%ld",groupIndexPath.row];
    [skillDict setValue:@"YES" forKey:key];
    NSArray* deviceArray = nil;
    switch (groupIndexPath.row) {
        case 1:{
            deviceArray = [skillDict objectForKey:@"devices"];
            if(deviceArray.count == 0)
                deviceArray = [skillDict objectForKey:@"websitesAndApps"];
        }
            break;
        case 2:
            deviceArray = [skillDict objectForKey:@"websitesAndApps"];
            break;
        default:
            break;
    }
    if(deviceArray.count > 0){
        
        NSMutableDictionary* deviceDict = [deviceArray objectAtIndex:deviceIndexPath.row];
        if([[deviceDict valueForKey:@"selected"] isEqualToString:@"YES"]){
            [deviceDict setValue:@"NO" forKey:@"selected"];
 
        }else{
            [deviceDict setValue:@"YES" forKey:@"selected"];

        }
    }
    [((FeedbackTableViewCell*)cell).feedbackTableView reloadData];
    [self.tableview reloadData];
}


-(void)onClickToggleDeviceCategory:(UIButton *)sender
{
    FeedbackDeviceTableViewCell* deviceCell = (FeedbackDeviceTableViewCell*)[self getDeviceCellView:sender];
    FeedbackTableViewCell* cell = (FeedbackTableViewCell*)[self getCellView:deviceCell];
    NSIndexPath* deviceIndexPath = [cell.feedbackTableView indexPathForCell:deviceCell];
    NSIndexPath* cellIndexPath = [self.tableview indexPathForCell:cell];
    NSDictionary* skillDict = [[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:cellIndexPath.row];
    NSArray* deviceArray = [skillDict objectForKey:@"devices"];
    NSArray* websiteArray = [skillDict objectForKey:@"websitesAndApps"];
    
    if(deviceArray.count > 0){
        if(deviceIndexPath.section == 0){
            // add or remove the device to selected
            NSDictionary* deviceDict = [deviceArray objectAtIndex:deviceIndexPath.row];
            if([selectedDeviceArray containsObject:deviceDict]){
                [selectedDeviceArray removeObject:deviceDict];
            }else{
                [selectedDeviceArray addObject:deviceDict];
            }
            
        }else{
            // add or remove website
            NSDictionary* deviceDict = [websiteArray objectAtIndex:deviceIndexPath.row];
            if([selectedDeviceArray containsObject:deviceDict]){
                [selectedDeviceArray removeObject:deviceDict];
            }else{
                [selectedDeviceArray addObject:deviceDict];
            }
        }
    }else{
        // add  or remve website
        NSDictionary* deviceDict = [websiteArray objectAtIndex:deviceIndexPath.row];
        if([selectedDeviceArray containsObject:deviceDict]){
            [selectedDeviceArray removeObject:deviceDict];
        }else{
            [selectedDeviceArray addObject:deviceDict];
        }

    }
    [cell.feedbackTableView reloadData];
    [self.tableview reloadData];
}

-(UIView*)getCellView:(id)view{
    
    while (view && [view isKindOfClass:[FeedbackTableViewCell class]] == NO) {
        view = [view superview];
    }
    
    FeedbackTableViewCell *FbCView = (FeedbackTableViewCell *)view;
    return FbCView;
}

-(UIView*)getDeviceCellView:(id)view{
    
    while (view && [view isKindOfClass:[FeedbackDeviceTableViewCell class]] == NO) {
        view = [view superview];
    }
    
    FeedbackDeviceTableViewCell *FbCView = (FeedbackDeviceTableViewCell *)view;
    return FbCView;
}


#pragma mark - UsingSoundTableViewDelegate

- (UITableViewCell *)usingSoundTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath inUsingSound:(id)usCell{
    
    static NSString *feedbackCellIdentifier = @"FeedbackCellIdentifier";
    FeedbackTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:feedbackCellIdentifier];
    if(cell == nil)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"FeedbackCellIdentifier" owner:nil options:nil];
        cell = [nibs firstObject];
        [cell.contentView setBackgroundColor:[UIColor greenColor]];
        cell.contentView.layer.cornerRadius = 5;
        //cell.contentView.layer.masksToBounds = YES;
        
        
    }
    [cell reInitialize];
    cell.skillNameLabel.font = [UIFont systemFontOfSize:15];
    cell.skillNameLabel.numberOfLines = 2;
    cell.skillNameLabel.textColor = [Utils colorWithHexValue:BUTTON_BLUE_COLOR_HEX_VALUE];
    NSIndexPath* cellIndexPath = [self.tableview indexPathForCell:usCell];
    NSDictionary* skill = nil;
    skill = [[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:cellIndexPath.row];
    NSString* key = [NSString stringWithFormat:@"group%ld",indexPath.row];
    NSArray *devicesArray = [skill valueForKey:@"devices"];
    NSArray *websitesArray = [skill valueForKey:@"websitesAndApps"];
    switch (indexPath.row) {
        case 0:
            cell.skillNameLabel.text = @"Tinnitus Coach Sounds & My Own Sounds";
            break;
        case 1:{
            if(devicesArray.count > 0){
               cell.skillNameLabel.text = @"Devices";
            }else{
              cell.skillNameLabel.text = @"Websites & Apps";
            }
        }
            break;
        case 2:
            cell.skillNameLabel.text = @"Websites & Apps";
            break;
        default:
            cell.skillNameLabel.text = @"";
            break;
    }
    cell.itemSelectorBtn.hidden = NO;
    cell.itemSelctorBtnImage.hidden = NO;
    //show the expanded view
/*    if(indexPath.row == 0){
        cell.secondaryView.hidden = NO;
        cell.secondaryView.userInteractionEnabled = YES;
    }else{
        cell.secondaryView.hidden = YES;
        cell.secondaryView.userInteractionEnabled = NO;
    }
 */
    NSInteger rowNumm = tableView.tag - 100;
    
/*    if(indexPath.row != 0 && rowNumm >= 0){
        //now check for devices also
        skill =[[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:cellIndexPath.row];
        NSArray *devicesArray = [skill valueForKey:@"devices[categorizedSkills objectAtIndex:currentPlanIndex]];
        NSArray *websitesArray = [skill valueForKey:@"websitesAndApps"];
        
    }else if(indexPath.row == 0){
        skill = [[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:cellIndexPath.row];
    }
 */
    
    if ([[skill valueForKey:key] isEqualToString:@"YES"]) {
        [cell.itemSelctorBtnImage  setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", SELECTED_IMAGE]]];
        if(indexPath.row == 0){
            cell.secondaryView.hidden = NO;
            cell.secondaryView.userInteractionEnabled = YES;
        }else if(indexPath.row == 1){
            cell.secondaryView.hidden = NO;
            cell.secondaryView.userInteractionEnabled = YES;
            if(devicesArray.count > 0){
                cell.feedbackTableView.hidden = NO;
                cell.feedbackTableView.tag = 1000 + indexPath.row;
                cell.feedbackTableView.scrollEnabled = NO;
                [cell.feedbackTableView reloadData];
            }else{
                if(websitesArray.count > 0){
                    cell.feedbackTableView.hidden = NO;
                    cell.feedbackTableView.tag = 1000 + indexPath.row;
                    cell.feedbackTableView.scrollEnabled = NO;
                    [cell.feedbackTableView reloadData];
                }else{
                    cell.feedbackTableView.hidden = YES;
                }
            }
        }else if(indexPath.row == 2){
            cell.secondaryView.hidden = NO;
            cell.secondaryView.userInteractionEnabled = YES;
            if(websitesArray.count > 0){
                cell.feedbackTableView.hidden = NO;
                cell.feedbackTableView.tag = 1000 + indexPath.row;
                cell.feedbackTableView.scrollEnabled = NO;
                [cell.feedbackTableView reloadData];
            }else{
                cell.feedbackTableView.hidden = YES;
            }
        }
        
    }else{
        [cell.itemSelctorBtnImage  setImage:[UIImage imageNamed:UN_SELECTED_IMAGE]];
        if(indexPath.row != 0){
            cell.secondaryView.hidden = YES;
           // cell.secondaryView.userInteractionEnabled = NO;
        }else{
            cell.secondaryView.hidden = NO;
            cell.secondaryView.userInteractionEnabled = YES;
        }
        cell.feedbackTableView.hidden = YES;
    }
    key = [NSString stringWithFormat:@"group%ldrating",indexPath.row];
    switch ([[skill valueForKey:key] intValue]) {
        case 1:
        {
            [cell fillbutton:cell.noatallButton];
            break;
        }
        case 2:
        {
            //[cell.alittleButton setBackgroundImage:[UIImage imageNamed:@"selectedCircle"] forState:UIControlStateNormal];
            [cell fillbutton:cell.alittleButton];
            
            break;
        }
        case 3:
        {
            [cell fillbutton:cell.moderatelyButton];
            //[cell.moderatelyButton setBackgroundImage:[UIImage imageNamed:@"selectedCircle"] forState:UIControlStateNormal];
            break;
        }
        case 4:
        {
            [cell fillbutton:cell.veryMuchButton];
            //[cell.veryMuchButton setBackgroundImage:[UIImage imageNamed:@"selectedCircle"] forState:UIControlStateNormal];
            break;
        }
        case 5:
        {
            [cell fillbutton:cell.extremelyButton];
            //[cell.extremelyButton setBackgroundImage:[UIImage imageNamed:@"selectedCircle"] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)groupItemSelected:(NSIndexPath*)groupIndexPath inCell:(id)usingSoundCell{
    NSInteger rowNum = groupIndexPath.row;
     NSLog(@"group item selected in sound table view");
    NSIndexPath* cellIndexPath = [self.tableview indexPathForCell:usingSoundCell];
    //get the skill
    NSMutableDictionary* skill =[[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:cellIndexPath.row];
    if(![selectedSkills containsObject:skill]){
        [selectedSkills addObject:skill];
    }
    NSString* key = [NSString stringWithFormat:@"group%ld",rowNum];
    if ([[skill valueForKey:key] isEqualToString:@"YES"]) {
        [skill setValue:@"NO" forKey:key];
    }else{
        [skill setValue:@"YES" forKey:key];
    }
    
    [self.tableview reloadData];
    [self reloadAllInnerTableViews];
}

- (CGFloat)usingSoundTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath inUsingSound:(id)cell{
    // get the skill
    NSIndexPath* cellIndexPath = [self.tableview indexPathForCell:cell];
    NSDictionary* skill =[[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:cellIndexPath.row];
    NSArray *devicesArray = [skill valueForKey:@"devices"];
    NSArray *websitesArray = [skill valueForKey:@"websitesAndApps"];

    CGFloat height = 0.0;
    switch (indexPath.row) {
        case 0:
            height = 180;
            break;
        case 1:
        {
            if ([[skill valueForKey:@"group1"] isEqualToString:@"YES"]) {
                if(devicesArray.count > 0)
                    height = 180 + (devicesArray.count*40);
                else
                    height = 180 + (websitesArray.count*40);
            }
            height = height+60;
        }
            break;
        case 2:
        {
            if ([[skill valueForKey:@"group2"] isEqualToString:@"YES"]) {
                height = 180 + (websitesArray.count*40);
            }
            height = height + 60;
        }
        default:
            break;
    }
     NSLog(@"Returning height of row:%ld using sound table view as %ld",indexPath.row, height);
    return height;
}

- (NSInteger)usingSoundTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section inUsingSound:(id)usCell{
    NSInteger rowCount = 1;
    // get the skill
    //NSIndexPath* cellIndexPath = [self.tableview indexPathForCell:usCell];
    NSInteger rowIndex = tableView.tag - 10000;
    if(rowIndex >= 0 && rowIndex < [[categorizedSkills objectAtIndex:currentPlanIndex] count]){
     NSLog(@"row index is %ld",rowIndex);
    NSDictionary* skill =[[categorizedSkills objectAtIndex:currentPlanIndex] objectAtIndex:rowIndex];
    NSArray *devicesArray = [skill valueForKey:@"devices"];
    NSArray *websitesArray = [skill valueForKey:@"websitesAndApps"];
    if(devicesArray.count > 0)
        rowCount++;
    if(websitesArray.count > 0)
        rowCount++;
    }
    NSLog(@"tag of using sound table is %ld",tableView.tag);
    NSLog(@"Returning number of rows in using sound table view as %ld",rowCount);
    return rowCount;
}

#pragma mark - SkillFeedbackCellDelegate

-(void)ratingRecieved:(NSInteger)rating inCell:(id)cell{
    NSIndexPath* indexPath = [self.tableview indexPathForCell:(UITableViewCell *)cell];
    switch (rating) {
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
