//
//  TipsViewController+Table.m
//  TinnitusCoach
//
//  Created by Ashwani Hundwani on 13/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "TipsViewController+Table.h"
#import "DeleteCormationManager.h"

@implementation TipsViewController (Table)

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section != 2)
    {
        return 1;
    }
    else
    {
        return self.exercises.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        SkillIntroductionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SkillIntroductionCell"];
        
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SkillIntroductionCell" owner:nil options:nil] objectAtIndex:0];
        }
        
        cell.delegate = self;
        
        SkillIntroInfo *info = [[SkillIntroInfo alloc]init];
        
        info.descriptionText = @"To use Tips for Better Sleep select the tips you want to use. Press “View My Sleep Tips” below to get started.";
        
        info.skillImage = [UIImage imageNamed:@"7TipsforBetterSleep.png"];
        
        [cell setSkillIntroInfo:info];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if(indexPath.section == 1)
    {
        SkillReminderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SkillReminderCell_Tips"];
        
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SkillReminderCell_Tips" owner:nil options:nil] objectAtIndex:0];
        }
        
        id reminder = nil;
        
        NSString *query = [NSString stringWithFormat:@"select * from MySkillReminders where SkillName = 'Tips for Better Sleep' and PlanName = '%@'",[Utils getValidSqlString:[PersistenceStorage getObjectForKey:@"planName"]]];
        
        self.manager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
        
        NSArray *reminders = [[NSArray alloc] initWithArray:[self.manager loadDataFromDB:query]];
        
        SkillReminderInfo *info = [[SkillReminderInfo alloc]init];
        info.reminderDate = @"";
        info.tryUsingText = @"";
        info.reminderExists = reminder ? YES : NO;
        
        [cell setReminderInfo:info];
        if([reminders count] == 1)
        {
            [cell setSkillReminderSwitchState:YES];
        }
        else
        {
            [cell setSkillReminderSwitchState:NO];
        }

        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.delegate = self;
        
        return cell;
    }
    else
    {
        UITableViewCell *cell =  [self.tableView dequeueReusableCellWithIdentifier:@"ExcersiceCell"];
        
        if(cell == nil)
        {
            cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExcersiceCell"];
            
            UIImageView *accessory = [[UIImageView alloc]initWithFrame:CGRectMake(286, 15, 13, 13)];
            
            [accessory setImage:[UIImage imageNamed:@"Active_Next-Arrow.png"]];
            
            [cell addSubview:accessory];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(22 , 11, 276, 20)];
            
            titleLabel.tag = 1007;
            
            Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_4];
            
            titleLabel.font = pallete.secondObj;
            titleLabel.textColor = pallete.firstObj;
            
            [cell addSubview:titleLabel];
            
            UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(22, 43, 298, 1)];
            
            separator.backgroundColor = [Utils colorWithHexValue:@"EEEEEE"];
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell addSubview:separator];
        }
        
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:1007];
        
        titleLabel.text = [self.exercises objectAtIndex:indexPath.row];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section != 2)
    {
        return 10;
    }
    else
    {
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    
    view.backgroundColor = [Utils colorWithHexValue:@"EEEEEE"];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 2)
    {
        return 60;
    }
    else
    {
        return 0;
    }
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *videoHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 56.0)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 24.0, 200.0, 20.0)];
    
    label.text = @"Tips for Better Sleep";
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_3];
    
    label.font = pallete.secondObj;
    
    label.textColor = pallete.firstObj;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(20, videoHeaderView.frame.size.height - 1, 300, 1)];
    
    line.backgroundColor = [Utils colorWithHexValue:@"EEEEEE"];
    
    [videoHeaderView addSubview:line];
    
    [videoHeaderView addSubview:label];
    
    return videoHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 370;
    }
    else if(indexPath.section == 1)
    {
        /*
        NSString *query = [NSString stringWithFormat:@"select * from MySkillReminders where SkillName = 'Tips for Better Sleep'"];
        
        self.manager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
        
        NSArray *reminders = [[NSArray alloc] initWithArray:[self.manager loadDataFromDB:query]];
        
        if([reminders count] == 1)
        {
            return 128;
        }
        else
        {
            return 100;
        }
         */
        return 140;
    }
    else
    {
        return 44;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2)
    {
        switch (indexPath.row) {
            case 0:
            {
                [self openMySleepTipsVC:self];
            }
                
            default:
                break;
        }
    }
}

#pragma mark
#pragma mark Skill Intro Delegate Methods
-(void)didTapIntro:(id)sender
{
    [self viewIntroductionAgainClicked:self];
}
-(void)didTapLearnMore:(id)sender
{
    [self learnMoreClicked:self];
}

#pragma mark Skill Reminder Methods
-(void)didTapActivate:(id)sender
{
    
    //[self goToScheduler:sender];
    // check for toggle
    SkillReminderCell* cell = (SkillReminderCell*)sender;
    if([cell getSkillReminderSwitchState]){
        [cell setSkillReminderSwitchState:TRUE];
        [self toggle1:YES];
        
    }else{
        [cell setSkillReminderSwitchState:FALSE];
        [self toggle1:NO];

    }

}

-(void)didTapTrash:(id)sender
{
    DeleteCormationManager *manager = [DeleteCormationManager getInstance];
    
    [manager showAlertwithPositiveBlock:^(BOOL positive) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"] ];
        
        hud.mode = MBProgressHUDModeCustomView;
        
        hud.labelText = @"Removed";
        
        [hud show:YES];
        [hud hide:YES afterDelay:1];
        
        [self DeleteReminder:self];
        [self.tableView reloadData];
        
    } negativeBlock:^(BOOL negative) {
        
        //TODO - do nothing.
        
    }];
}


#pragma mark Abstract Methods
-(NSString *)activityText
{
    return @"Tips for Better Sleep";
}

@end
