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
    NSMutableArray *allSkillsArray;
    BOOL firtTimeLoad;
    NSMutableArray *selectedSkills;
    NSMutableArray *feedbackArray;
}

@end

@implementation WeeklyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    allSkillsArray = [NSMutableArray new];
    firtTimeLoad = YES;
    self.title = @"Weekly Reminder";
    
    selectedSkills = [NSMutableArray new];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view setBackgroundColor:[UIColor lightGrayColor]];

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


#pragma mark Tableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [allSkillsArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
        NSDictionary *skillDict = [allSkillsArray objectAtIndex:section];
        if ([selectedSkills containsObject:skillDict]) {
            if ([[allSkillsArray objectAtIndex:section] valueForKey:@"devices"] != nil) {
                NSArray *devicesArray = [[allSkillsArray objectAtIndex:section] valueForKey:@"devices"];
                
                
                return 2 + devicesArray.count;
                
                
            }
            return 1;
            
        }
   
    
    
    return 0;
}
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
        }
        
        [cell.noatallButton setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
        [cell.alittleButton setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
        [cell.moderatelyButton setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
        [cell.veryMuchButton setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
        [cell.extremelyButton setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
        
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
        
        NSDictionary *skilDict = [allSkillsArray objectAtIndex:indexPath.section];

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
            cell.contentView.backgroundColor = [UIColor lightGrayColor];
        
        
        }
        
        
        
    if (indexPath.row == 1) {
        cell.textLabel.text = @"Do you use this devices?";
        
    }
        else
        {
            NSArray *devicesArray = [[allSkillsArray objectAtIndex:indexPath.section] valueForKey:@"devices"];
            NSDictionary *deviceDict = [ devicesArray objectAtIndex:indexPath.row-2];
            cell.textLabel.text = [deviceDict valueForKey:@"deviceName"];
            cell.contentView.backgroundColor = [UIColor lightGrayColor];

        }
        
        return cell;
        
    }
    
    
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
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
    
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"EditTipsCell" owner:nil options:nil];
    EditTipsCell *cell = [nibs lastObject];
    [cell.btnToggleCategory addTarget:self action:@selector(onClickToggleCategory:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnToggleCategory setTag:section];
    
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    
    
    NSDictionary *skillDict = [allSkillsArray objectAtIndex:section];
    cell.lblTitle.text = [skillDict valueForKey:@"skillName"];
    if (![selectedSkills containsObject:skillDict]) {
        
        [cell.btnToggleCategory setBackgroundImage:[UIImage imageNamed:UN_SELECTED_IMAGE] forState:UIControlStateNormal];
    }
    else
    {
        [cell.btnToggleCategory setBackgroundImage:[UIImage imageNamed:SELECTED_IMAGE] forState:UIControlStateNormal];
    }

    

    return cell.contentView;
}


-(void)onClickToggleCategory:(UIButton *)sender
{
    
    NSDictionary *skillDict = [allSkillsArray objectAtIndex:sender.tag];
    if ([selectedSkills containsObject:skillDict]) {
        
        [sender setBackgroundImage:[UIImage imageNamed:UN_SELECTED_IMAGE] forState:UIControlStateNormal];
        [selectedSkills removeObject:skillDict];
    }
    else
    {
    [sender setBackgroundImage:[UIImage imageNamed:SELECTED_IMAGE] forState:UIControlStateNormal];
        [selectedSkills addObject:skillDict];
    }
    
    NSRange range = NSMakeRange(sender.tag, 1);
    NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tableview reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
    

}

-(void)getAllSkillWithDetails
{
    
    NSString *query = @"select  distinct DM.skillID,PS.skillName,DM.deviceID,PD.deviceName from MyDevices as DM,Plan_skills as PS,Plan_Devices as PD where DM.skillID=PS.ID and DM.deviceID=PD.ID";
    DBManager *dbManager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    NSArray *resultArray = [dbManager loadDataFromDB:query];
    
    [allSkillsArray removeAllObjects];

    for (NSDictionary *recordDict in resultArray) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.skillID=%@",[recordDict valueForKey:@"skillID"]];
        NSMutableArray *devices = [NSMutableArray new];

        if([allSkillsArray filteredArrayUsingPredicate:predicate].count == 0)
        {
            NSArray *respectiveDevices = [resultArray filteredArrayUsingPredicate:predicate];
            for (NSDictionary *skillDict in respectiveDevices) {
                NSMutableDictionary *deviceDict = [NSMutableDictionary new];
                [deviceDict setValue:[skillDict valueForKey:@"deviceID"] forKey:@"deviceID"];
                [deviceDict setValue:[skillDict valueForKey:@"deviceName"] forKey:@"deviceName"];
                [devices addObject:deviceDict];
                
            }
            NSMutableDictionary *skillDetails = [NSMutableDictionary new];
            [skillDetails setValue:[recordDict valueForKey:@"skillID"] forKey:@"skillID"];
            [skillDetails setValue:[recordDict valueForKey:@"skillName"] forKey:@"skillName"];
            if (devices.count > 0) {
                [skillDetails setValue:devices forKey:@"devices"];
                
            }
            [allSkillsArray addObject:skillDetails];

            
        }
        
        
        
    }
    
//    if (resultArray.count > 0) {
//        [allSkillsArray addObjectsFromArray:resultArray];
//
//    }
    
//    //NSDictionary *skillDict =
//    [allSkillsArray addObject:@{@"skill":@"Using Sound1",
//                                @"devices":@[@"Cd1"]}];
//    [allSkillsArray addObject:@{@"skill":@"Using Sound2",
//                                @"devices":@[@"Cd2"]}];
//    [allSkillsArray addObject:@{@"skill":@"Using Sound3",
//                                @"devices":@[@"Cd3"]}];
    [_tableview reloadData];
}

#pragma mark feedback button action

-(void)noatallButtonAction:(UIButton*)pressedButton
{
    NSDictionary *skilDict = [allSkillsArray objectAtIndex:pressedButton.tag];
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.skillID=%@",[skilDict valueForKey:@"skillID"]];
    
    NSArray *filteredArray = [feedbackArray filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        NSMutableArray *fDict = [filteredArray objectAtIndex:0];
        [feedbackArray removeObject:fDict];
        
    }
    NSMutableDictionary *newfDict = [NSMutableDictionary new];

    [newfDict setValue:[skilDict valueForKey:@"skillID"] forKey:@"skillID"];
    [newfDict setValue:@"1" forKey:@"rating"];
    [feedbackArray addObject:newfDict];
//    [pressedButton setBackgroundImage:[UIImage imageNamed:@"selectedCircle1"] forState:UIControlStateNormal];
  
    NSIndexPath *indexPath = [ NSIndexPath indexPathForRow:0 inSection:pressedButton.tag];
    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    NSLog(@"Feedback no at all for == %@",skilDict);
}
-(void)alittleButtonButtonAction:(UIButton*)pressedButton
{
    NSDictionary *skilDict = [allSkillsArray objectAtIndex:pressedButton.tag];
    NSLog(@"Feedback alittleButton for == %@",skilDict);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.skillID=%@",[skilDict valueForKey:@"skillID"]];
    
    NSArray *filteredArray = [feedbackArray filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        NSMutableArray *fDict = [filteredArray objectAtIndex:0];
        [feedbackArray removeObject:fDict];
        
    }
    NSMutableDictionary *newfDict = [NSMutableDictionary new];
    
    [newfDict setValue:[skilDict valueForKey:@"skillID"] forKey:@"skillID"];
    [newfDict setValue:@"2" forKey:@"rating"];
    [feedbackArray addObject:newfDict];
    NSIndexPath *indexPath = [ NSIndexPath indexPathForRow:0 inSection:pressedButton.tag];
    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];


}
-(void)moderatelyButtonAction:(UIButton*)pressedButton
{
    NSDictionary *skilDict = [allSkillsArray objectAtIndex:pressedButton.tag];
    NSLog(@"Feedback moderately for == %@",skilDict);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.skillID=%@",[skilDict valueForKey:@"skillID"]];
    
    NSArray *filteredArray = [feedbackArray filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        NSMutableArray *fDict = [filteredArray objectAtIndex:0];
        [feedbackArray removeObject:fDict];
        
    }
    NSMutableDictionary *newfDict = [NSMutableDictionary new];
    
    [newfDict setValue:[skilDict valueForKey:@"skillID"] forKey:@"skillID"];
    [newfDict setValue:@"3" forKey:@"rating"];
    [feedbackArray addObject:newfDict];
    NSIndexPath *indexPath = [ NSIndexPath indexPathForRow:0 inSection:pressedButton.tag];
    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

}
-(void)extremelyButtonAction:(UIButton*)pressedButton
{
    NSDictionary *skilDict = [allSkillsArray objectAtIndex:pressedButton.tag];
    NSLog(@"Feedback extremely for == %@",skilDict);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.skillID=%@",[skilDict valueForKey:@"skillID"]];
    
    NSArray *filteredArray = [feedbackArray filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        NSMutableArray *fDict = [filteredArray objectAtIndex:0];
        [feedbackArray removeObject:fDict];
        
    }
    NSMutableDictionary *newfDict = [NSMutableDictionary new];
    
    [newfDict setValue:[skilDict valueForKey:@"skillID"] forKey:@"skillID"];
    [newfDict setValue:@"5" forKey:@"rating"];
    [feedbackArray addObject:newfDict];
    NSIndexPath *indexPath = [ NSIndexPath indexPathForRow:0 inSection:pressedButton.tag];
    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

}
-(void)veryMuchButtonAction:(UIButton*)pressedButton
{
    NSDictionary *skilDict = [allSkillsArray objectAtIndex:pressedButton.tag];
    NSLog(@"Feedback veryMuch for == %@",skilDict);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.skillID=%@",[skilDict valueForKey:@"skillID"]];
    
    NSArray *filteredArray = [feedbackArray filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        NSMutableArray *fDict = [filteredArray objectAtIndex:0];
        [feedbackArray removeObject:fDict];
        
    }
    NSMutableDictionary *newfDict = [NSMutableDictionary new];
    
    [newfDict setValue:[skilDict valueForKey:@"skillID"] forKey:@"skillID"];
    [newfDict setValue:@"4" forKey:@"rating"];
    [feedbackArray addObject:newfDict];
    NSIndexPath *indexPath = [ NSIndexPath indexPathForRow:0 inSection:pressedButton.tag];
    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

}
@end
