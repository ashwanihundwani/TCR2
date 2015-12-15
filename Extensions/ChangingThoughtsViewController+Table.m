//
//  ChangingThoughtsViewController+Table.m
//  TinnitusCoach
//
//  Created by Creospan on 06/09/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "ChangingThoughtsViewController+Table.h"

@implementation ChangingThoughtsViewController (Table)
-(CGFloat)heightForIndexPath:(NSIndexPath *)indexPath
{
    CGFloat constant = 27;
    
    CGFloat labelHeight = [Utils heightForLabelForString:[self.thoughtsAndFeelings objectAtIndex:indexPath.row] width:240 font:TITLE_LABEL_FONT];
    
    constant += labelHeight;
    
    return constant;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else
    {
        return self.thoughtsAndFeelings.count;
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
        
        info.descriptionText = @"When you are feeling bad, changing your thoughts can help you feel better.  Click “Add New Entry” to start the step-by-step guide to Changing Thoughts and Feelings.";
        
        info.skillImage = [UIImage imageNamed:@"6ChangingThoughts&Feelings.png"];
        
        [cell setSkillIntroInfo:info];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
        
        titleLabel.text = [self.thoughtsAndFeelings objectAtIndex:indexPath.row];
        
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
    if(section == 0)
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
    if(section == 1)
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
    if(section != 1)
        return nil;
    
    UIView *videoHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 56.0)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 24.0, 300.0, 20.0)];
    
    label.text = @"Changing Thoughts & Feelings";
    
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
        return 380;
    }
    else
    {
        return [self heightForIndexPath:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
            {
                [self newEntryClicked:self];
            }
                break;
            case 1:
            {
                [self viewEntriesClicked:self];
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

#pragma mark Abstract Methods

-(NSString *)planText
{
    return [NSString stringWithFormat:@"Plan for %@ ",[PersistenceStorage getObjectForKey:@"planName"]];
}

-(NSString *)activityText{
    
    return [PersistenceStorage getObjectForKey:@"skillName"];
}
@end
