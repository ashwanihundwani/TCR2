//
//  WeeklyViewController.m
//  TinnitusCoach
//
//  Created by Pramod Ganapati Patil on 13/06/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#define UN_SELECTED_IMAGE @"u630.png"
#define SELECTED_IMAGE @"u648.png"

#import "WeeklyViewController.h"
#import "FeedbackTableViewCell.h"
#import "EditTipsCell.h"



@interface WeeklyViewController ()
{
    NSMutableArray *allSkillsArray,*allMyPlanArray,*activeSkillsArray;
    BOOL firtTimeLoad;
    NSMutableArray *selectedSkills;
    NSMutableArray *feedbackArray;
    int maxNumberOfSkills,maxMyPlan;
    
}

@end

@implementation WeeklyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    allSkillsArray = [NSMutableArray new];
    allMyPlanArray = [NSMutableArray new];
    firtTimeLoad = YES;
    self.title = @"Weekly Reminder";
    
    selectedSkills = [NSMutableArray new];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
  //  [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    [self getAllSkillWithDetails];
    [self.tableview setBackgroundColor:[UIColor clearColor]];
    feedbackArray = [NSMutableArray new];
    
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





#pragma mark Tableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int numberOfSections = (maxNumberOfSkills * maxMyPlan) + maxMyPlan;
    return numberOfSections;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    
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
    if (indexPath.row == 0) {
        
        
        static NSString *feedbackCellIdentifier = @"FeedbackCellIdentifier";
        FeedbackTableViewCell *cell = (FeedbackTableViewCell *)[tableView dequeueReusableCellWithIdentifier:feedbackCellIdentifier];
        if(cell == nil)
        {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"FeedbackTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
            [cell.contentView setBackgroundColor:[UIColor whiteColor]];
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
        
        
        
        NSDictionary *skilDict = [allSkillsArray objectAtIndex:sectionForSkill];
        
        
        
        
        
        
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.skillID=%@",[skilDict valueForKey:@"skillID"]];
        
        NSArray *filteredArray = [feedbackArray filteredArrayUsingPredicate:predicate];
        
        if (filteredArray.count > 0) {
            NSMutableArray *fDict = [filteredArray objectAtIndex:0];
            
            int rating = [[fDict valueForKey:@"rating"] intValue];
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
            cell.contentView.backgroundColor = [UIColor lightGrayColor];
            
        }
        
        return cell;
        
    }
    
    
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section%(maxNumberOfSkills+1) == 0) {
        return 44;
    }
    return 61;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 136;
    }
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section%(maxNumberOfSkills+1) == 0) {
        
        UILabel *planTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableview.frame.size.width, 44)];
        [planTitle setBackgroundColor:[UIColor grayColor]];
        planTitle.numberOfLines = 1;
        planTitle.textAlignment = NSTextAlignmentCenter;
        planTitle.textColor = [UIColor whiteColor];
        planTitle.font = [UIFont boldSystemFontOfSize:16];
        NSDictionary *planDict = [ allMyPlanArray objectAtIndex:(section + 1)/(maxNumberOfSkills)];
        planTitle.text = [planDict valueForKey:@"planName"];
        
        return planTitle;
    }
    
    
    
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"EditTipsCell" owner:nil options:nil];
    EditTipsCell *cell = [nibs lastObject];
    [cell.btnToggleCategory addTarget:self action:@selector(onClickToggleCategory:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnToggleCategory setTag:section];
    
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    
    int sectionForSkill = section - ((section) / (maxNumberOfSkills + 1) + 1);
    
    NSDictionary *skillDict = [allSkillsArray objectAtIndex:sectionForSkill];
    cell.lblTitle.text = [skillDict valueForKey:@"skillName"];
    
cell.lblTitle.font = [UIFont boldSystemFontOfSize:16.0f]; //[UIFont boldSystemFontOfSize:16.0f]
    
    if (![activeSkillsArray containsObject:skillDict]) {
        [cell.btnToggleCategory setBackgroundImage:[UIImage imageNamed:UN_SELECTED_IMAGE] forState:UIControlStateNormal];

         //       [cell.btnToggleCategory setBackgroundImage:[UIImage imageNamed:UN_SELECTED_IMAGE] forState:UIControlStateNormal];
        cell.btnToggleCategory.hidden=NO;
      //  cell.lblTitle.alpha=.4;
      //  [cell setAlpha:0.4];
  //      cell.btnToggleCategory.alpha=0;

    }
    else
    {
       [cell.btnToggleCategory setBackgroundImage:[UIImage imageNamed:SELECTED_IMAGE] forState:UIControlStateNormal];
        cell.btnToggleCategory.hidden=NO;

             //   cell.btnToggleCategory.alpha=1;
        
      //  [cell setAlpha:1.0];

        
        //[cell.btnToggleCategory setBackgroundImage:[UIImage imageNamed:SELECTED_IMAGE] forState:UIControlStateNormal];
    }
    
    
    
    return cell.contentView;


    




}




-(void)onClickToggleCategory:(UIButton *)sender
{
    NSInteger section = sender.tag;
    int sectionForSkill = section - ((section) / (maxNumberOfSkills + 1) + 1);
 //   NSLog(@"ALLSKILL array %@",allSkillsArray);
    
NSDictionary *skillDict = [allSkillsArray objectAtIndex:sectionForSkill];
   //  NSDictionary *skillDict = [allSkillsArray objectAtIndex:sender.tag];

    if ([selectedSkills containsObject:skillDict]) {
    
    
 //   if ([activeSkillsArray containsObject:skillDict]) {
        
    
    
       [sender setBackgroundImage:[UIImage imageNamed:UN_SELECTED_IMAGE] forState:UIControlStateNormal];
      //  sender.alpha=1;

        [activeSkillsArray removeObject:skillDict];
    }
    else
    {
        [sender setBackgroundImage:[UIImage imageNamed:SELECTED_IMAGE] forState:UIControlStateNormal];
    //    sender.alpha=1;

        [activeSkillsArray addObject:skillDict];
    }
    
    
    
    //    NSRange range = NSMakeRange(sender.tag, 1);
    //    NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
    //    [self.tableview reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableview reloadData];
    //    [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:sender.tag] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    
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
    
      //  [allSkillsArray removeAllObjects];
      //  allSkillsArray = activeSkillsArray;

    
    
        [_tableview reloadData];
}






#pragma mark feedback button action

-(void)noatallButtonAction:(UIButton*)pressedButton
{
    
    int section = pressedButton.tag;
    int sectionForSkill = section - ((section) / (maxNumberOfSkills + 1) + 1);
    
    NSDictionary *skilDict = [allSkillsArray objectAtIndex:sectionForSkill];
    
    NSMutableDictionary *newfDict = [NSMutableDictionary new];
    
    [newfDict setValue:[skilDict valueForKey:@"skillName"] forKey:@"skillName"];
    [newfDict setValue:@"1" forKey:@"rating"];
    [newfDict setValue:[skilDict valueForKey:@"planName"] forKey:@"planName"];
    [newfDict setValue:[skilDict valueForKey:@"situationName"] forKey:@"situationName"];
    
    [feedbackArray addObject:newfDict];
    
    
    for(NSMutableDictionary *dict in selectedSkills){
        if([[dict objectForKey:@"planName"] isEqual:[skilDict valueForKey:@"planName"]] && [[dict objectForKey:@"skillName"] isEqual:[skilDict valueForKey:@"skillName"]] && [[dict objectForKey:@"situationName"] isEqual:[skilDict valueForKey:@"situationName"]] ) {
            [dict setObject:@"1" forKey:@"rating"];
        }
    }
    
    [self.tableview reloadData];
 }
-(void)alittleButtonButtonAction:(UIButton*)pressedButton
{
    int section = pressedButton.tag;
    int sectionForSkill = section - ((section) / (maxNumberOfSkills + 1) + 1);
    
    NSDictionary *skilDict = [allSkillsArray objectAtIndex:sectionForSkill];
    
    NSMutableDictionary *newfDict = [NSMutableDictionary new];
         
    [newfDict setValue:[skilDict valueForKey:@"skillName"] forKey:@"skillName"];
    [newfDict setValue:@"2" forKey:@"rating"];
    [newfDict setValue:[skilDict valueForKey:@"planName"] forKey:@"planName"];
    [newfDict setValue:[skilDict valueForKey:@"situationName"] forKey:@"situationName"];

    [feedbackArray addObject:newfDict];
    
    
    for(NSMutableDictionary *dict in selectedSkills){
        if([[dict objectForKey:@"planName"] isEqual:[skilDict valueForKey:@"planName"]] && [[dict objectForKey:@"skillName"] isEqual:[skilDict valueForKey:@"skillName"]] && [[dict objectForKey:@"situationName"] isEqual:[skilDict valueForKey:@"situationName"]] ) {
            [dict setObject:@"2" forKey:@"rating"];
         }
    }
    
    [self.tableview reloadData];
    
    
}
-(void)moderatelyButtonAction:(UIButton*)pressedButton
{
    int section = pressedButton.tag;
    int sectionForSkill = section - ((section) / (maxNumberOfSkills + 1) + 1);
    
    NSDictionary *skilDict = [allSkillsArray objectAtIndex:sectionForSkill];
    
    NSMutableDictionary *newfDict = [NSMutableDictionary new];
    
    [newfDict setValue:[skilDict valueForKey:@"skillName"] forKey:@"skillName"];
    [newfDict setValue:@"3" forKey:@"rating"];
    [newfDict setValue:[skilDict valueForKey:@"planName"] forKey:@"planName"];
    [newfDict setValue:[skilDict valueForKey:@"situationName"] forKey:@"situationName"];
    
    [feedbackArray addObject:newfDict];
    
    
    for(NSMutableDictionary *dict in selectedSkills){
        if([[dict objectForKey:@"planName"] isEqual:[skilDict valueForKey:@"planName"]] && [[dict objectForKey:@"skillName"] isEqual:[skilDict valueForKey:@"skillName"]] && [[dict objectForKey:@"situationName"] isEqual:[skilDict valueForKey:@"situationName"]] ) {
            [dict setObject:@"3" forKey:@"rating"];
        }
    }
    
    [self.tableview reloadData];

}
-(void)extremelyButtonAction:(UIButton*)pressedButton
{
    int section = pressedButton.tag;
    int sectionForSkill = section - ((section) / (maxNumberOfSkills + 1) + 1);
    
    NSDictionary *skilDict = [allSkillsArray objectAtIndex:sectionForSkill];
    
    NSMutableDictionary *newfDict = [NSMutableDictionary new];
    
    [newfDict setValue:[skilDict valueForKey:@"skillName"] forKey:@"skillName"];
    [newfDict setValue:@"5" forKey:@"rating"];
    [newfDict setValue:[skilDict valueForKey:@"planName"] forKey:@"planName"];
    [newfDict setValue:[skilDict valueForKey:@"situationName"] forKey:@"situationName"];
    
    [feedbackArray addObject:newfDict];
    
    
    for(NSMutableDictionary *dict in selectedSkills){
        if([[dict objectForKey:@"planName"] isEqual:[skilDict valueForKey:@"planName"]] && [[dict objectForKey:@"skillName"] isEqual:[skilDict valueForKey:@"skillName"]] && [[dict objectForKey:@"situationName"] isEqual:[skilDict valueForKey:@"situationName"]] ) {
            [dict setObject:@"5" forKey:@"rating"];
        }
    }
    
    [self.tableview reloadData];
    
}
-(void)veryMuchButtonAction:(UIButton*)pressedButton
{
    int section = pressedButton.tag;
    int sectionForSkill = section - ((section) / (maxNumberOfSkills + 1) + 1);
    
    NSDictionary *skilDict = [allSkillsArray objectAtIndex:sectionForSkill];
    
    NSMutableDictionary *newfDict = [NSMutableDictionary new];
    
    [newfDict setValue:[skilDict valueForKey:@"skillName"] forKey:@"skillName"];
    [newfDict setValue:@"4" forKey:@"rating"];
    [newfDict setValue:[skilDict valueForKey:@"planName"] forKey:@"planName"];
    [newfDict setValue:[skilDict valueForKey:@"situationName"] forKey:@"situationName"];
    
    [feedbackArray addObject:newfDict];
    
    
    for(NSMutableDictionary *dict in selectedSkills){
        if([[dict objectForKey:@"planName"] isEqual:[skilDict valueForKey:@"planName"]] && [[dict objectForKey:@"skillName"] isEqual:[skilDict valueForKey:@"skillName"]] && [[dict objectForKey:@"situationName"] isEqual:[skilDict valueForKey:@"situationName"]] ) {
            [dict setObject:@"4" forKey:@"rating"];
        }
    }
    
    [self.tableview reloadData];
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
        
    }];
}


@end
