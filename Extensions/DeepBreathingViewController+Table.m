//
//  DeepBreathingViewController+Table.m
//  TinnitusCoach
//
//  Created by Ashwani Hundwani on 13/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "DeepBreathingViewController+Table.h"

@implementation DeepBreathingViewController (Table)

-(CGFloat)heightForIndexPath:(NSIndexPath *)indexPath
{
    CGFloat constant = 27;
    
    CGFloat labelHeight = [Utils heightForLabelForString:[self.exercises objectAtIndex:indexPath.row] width:240 font:TITLE_LABEL_FONT];
    
    constant += labelHeight;
    
    return constant;
}


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
        
        info.descriptionText = @"Regular use of deep breathing can help you relax and remove your focus from tinnitus.";
        info.skillImage = [UIImage imageNamed:@"2DeepBreathing.png"];
        
        [cell setSkillIntroInfo:info];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if(indexPath.section == 1)
    {
        SkillReminderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SkillReminderCell"];
        
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SkillReminderCell" owner:nil options:nil] objectAtIndex:0];
        }
        
        id reminder = nil;
        
        NSString *query = [NSString stringWithFormat:@"select * from MySkillReminders where SkillName = 'Deep Breathing' and PlanName = '%@'",[Utils getValidSqlString:[PersistenceStorage getObjectForKey:@"planName"]]];
        
        self.manager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
        
        NSArray *reminders = [[NSArray alloc] initWithArray:[self.manager loadDataFromDB:query]];
        
        SkillReminderInfo *info = [[SkillReminderInfo alloc]init];
        
        if([reminders count] == 1)
        {
            reminder = [reminders objectAtIndex:0];
            info.reminderDate = [reminder objectForKey:@"ScheduledDate"];
            info.tryUsingText = [NSString stringWithFormat:@"Try using %@", [reminder objectForKey:@"SkillName"]];
        }
        else
        {
            info.reminderDate = @"";
            info.tryUsingText = @"";
        }
        
        
        info.reminderExists = reminder ? YES : NO;
        
        [cell setReminderInfo:info];
        
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
            
            accessory.tag = ACCESSORY_IMAGE_TAG;
            
            [cell addSubview:accessory];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(22 , 11, 240, 20)];
            
            titleLabel.numberOfLines = 1000;
            
            titleLabel.tag = 1007;
            
            Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_4];
            
            titleLabel.font = pallete.secondObj;
            titleLabel.textColor = pallete.firstObj;
            
            [cell addSubview:titleLabel];
            
            UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(22, 43, 298, 1)];
            
            separator.backgroundColor = [Utils colorWithHexValue:@"EEEEEE"];
            
            separator.tag = SEPARATOR_TAG;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell addSubview:separator];
        }
        
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:TITLE_LABEL_TAG];
        
        titleLabel.text = [self.exercises objectAtIndex:indexPath.row];
        
        CGFloat labelHeight = [Utils heightForLabelForString:titleLabel.text width:240 font:TITLE_LABEL_FONT];
        
        
        titleLabel.height = labelHeight;
        
        UIView *separator = [cell viewWithTag:SEPARATOR_TAG];
        
        CGFloat height = [self heightForIndexPath:indexPath];
        
        separator.y = height - 1;
        
        UIImageView *accessory = (UIImageView *)[cell viewWithTag:ACCESSORY_IMAGE_TAG];
        
        accessory.y = height / 2 - accessory.height / 2;
        
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
    if(section == 2)
    {
        UIView *videoHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 56.0)];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 24.0, 200.0, 20.0)];
        
        label.text = @"Excercises";
        
        Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_3];
        
        label.font = pallete.secondObj;
        
        label.textColor = pallete.firstObj;
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(20, videoHeaderView.frame.size.height - 1, 300, 1)];
        
        line.backgroundColor = [Utils colorWithHexValue:@"EEEEEE"];
        
        [videoHeaderView addSubview:line];
        
        [videoHeaderView addSubview:label];
        
        return videoHeaderView;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 360;
    }
    else if(indexPath.section == 1)
    {
        NSString *query = [NSString stringWithFormat:@"select * from MySkillReminders where SkillName = 'Deep Breathing'and PlanName = '%@'",[Utils getValidSqlString:[PersistenceStorage getObjectForKey:@"planName"]]];
        
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
    }
    else
    {
        return [self heightForIndexPath:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2)
    {
        switch (indexPath.row) {
            case 0:
            {
                [self PlayVideoOne:self];
            }
                break;
            case 1:
            {
                [self PlayVideoTwo:self];
            }
                break;
                
            case 2:
            {
                [self BreathingTimer:self];
            }
                break;
                
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
    [self goToScheduler:self];
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
    return @"Deep Breathing";
}




@end
