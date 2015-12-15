//
//  SoundActivitiesViewController+Table.m
//  TinnitusCoach
//
//  Created by Creospan on 14/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "SoundActivitiesViewController+Table.h"
#import "SoundsCategoryViewController.h"
#import "DeleteCormationManager.h"
#import "AudioPanningViewController.h"


@implementation SoundActivitiesViewController (Table)

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.soundUICompleteInfo && [self.soundUICompleteInfo count] > 0)
        return 4;
    else
        return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else
    {
        return [[self.soundUICompleteInfo objectAtIndex:section - 1] count];
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
        
        info.descriptionText = @"Soothing Sound, Interesting Sound, and Background Sound can help when your tinnitus is bothering you. Each helps in a different way. Explore each type of sound below.";
        
        info.skillImage = [UIImage imageNamed:@"1UsingSound.png"];
        
        [cell setSkillIntroInfo:info];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else
    {
        NSArray *items = [self.soundUICompleteInfo objectAtIndex:indexPath.section - 1];
        
        //intro cell
        if(indexPath.row == 0)
        {
            SoundIntroCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SoundIntroCell"];
            
            if(!cell)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SoundIntroCell" owner:nil options:nil] objectAtIndex:0];
            }
            
            cell.delegate = self;
            [cell setIntroInfo:[items objectAtIndex:0]];
            
            return cell;
        }
        else
        {
            id item = [items objectAtIndex:indexPath.row];
            
            if([item isKindOfClass:[WebsiteSoundInfo class]])
            {
                WebsiteSoundInfo *info = (WebsiteSoundInfo *)item;
                WebsiteSoundCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"WebsiteSoundCell"];
                
                if(!cell)
                {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"WebsiteSoundCell" owner:nil options:nil] objectAtIndex:0];
                }
                
                cell.delegate = self;
                
                CGFloat titleHeight = [Utils heightForLabelForString:info.title width:172 font:TITLE_LABEL_FONT];
                
                cell.titleHeightConst.constant = titleHeight + 5;
                
                [cell setSoundInfo:info];
                
                return cell;
            }
            else if([item isKindOfClass:[OtherSoundInfo class]])
            {
                OtherSoundInfo *info = (OtherSoundInfo *)item;
                OtherSoundsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"OtherSoundsCell"];
                
                if(!cell)
                {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"OtherSoundsCell" owner:nil options:nil] objectAtIndex:0];
                }
                
                cell.otherDelegate = self;
                
                [cell setSoundInfo:info];
                
                return cell;
            }
            else if([item isKindOfClass:[MyOwnSoundInfo class]])
            {
                MyOwnSoundInfo *info = (MyOwnSoundInfo *)item;
                MyOwnSoundCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MyOwnSoundCell"];
                
                if(!cell)
                {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"MyOwnSoundCell" owner:nil options:nil] objectAtIndex:0];
                }
                
                cell.delegate = self;
                
                [cell setSoundInfo:info];
                
                return cell;
            }
            else
            {
                TinnitusSoundInfo *info = (TinnitusSoundInfo *)item;
                TinnitusSoundCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TinnitusSoundCell"];
                
                if(!cell)
                {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"TinnitusSoundCell" owner:nil options:nil] objectAtIndex:0];
                }
                
                cell.delegate = self;
                
                [cell setTinnitusInfo:info];
                
                return cell;
            }
        }
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 0;
    }
    else
    {
        return 10;
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
        return 80;
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
    
    UIView *videoHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 80.0)];
    
    videoHeaderView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 24.0, 300.0, 20.0)];
    
    label.text = @"Sounds";
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_3];
    
    label.font = pallete.secondObj;
    
    label.textColor = pallete.firstObj;
    
    UILabel *subLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 54.0, 300.0, 20.0)];
    
    subLabel.text = @"You can add several sounds per category";
    
    pallete = [Utils getColorFontPair:eCFS_PALLETE_4];
    
    subLabel.font = pallete.secondObj;
    
    subLabel.textColor = pallete.firstObj;
    
    [videoHeaderView addSubview:subLabel];
    
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
        return 400;
    }
    else
    {
        NSArray *items = [self.soundUICompleteInfo objectAtIndex:indexPath.section - 1];
        
        id item = [items objectAtIndex:indexPath.row];
        
        if([item isKindOfClass:[SoundIntroInfo class]])
        {
            SoundIntroInfo *info = (SoundIntroInfo *)item;
            if ([items count] == 1) {
                CGFloat constant = 145;
                
                CGFloat height = [Utils heightForLabelForString:info.subTitle width:276 font:[Utils helveticaNueueFontWithSize:14]];
                
                return constant + height;
            }
            else
            {
                CGFloat constant = 115;
                
                CGFloat height = [Utils heightForLabelForString:info.subTitle width:276 font:[Utils helveticaNueueFontWithSize:14]];
                
                return constant + height;
            }
        }
        else if ([item isKindOfClass:[TinnitusSoundInfo class]])
        {
            TinnitusSoundInfo *info = (TinnitusSoundInfo *)item;
            
            CGFloat constant = 27;
            
            CGFloat height = [Utils heightForLabelForString:info.title width:172 font:TITLE_LABEL_FONT];
            
            return constant + height;
            
        }
        else if ([item isKindOfClass:[WebsiteSoundInfo class]])
        {
            WebsiteSoundInfo *info = (WebsiteSoundInfo *)item;
            
            CGFloat constant = 90;
            
            CGFloat titleHeight = [Utils heightForLabelForString:info.title width:172 font:TITLE_LABEL_FONT];
         
            CGFloat subtitleHeight = [Utils heightForLabelForString:info.descriptionStr width:172 font:SUB_TITLE_LABEL_FONT];
            
            
            return constant + titleHeight + subtitleHeight;
            
        }
        else if ([item isKindOfClass:[MyOwnSoundInfo class]])
        {
            MyOwnSoundInfo *info = (MyOwnSoundInfo *)item;
            
            CGFloat constant = 27;
            
            CGFloat height = [Utils heightForLabelForString:info.title width:172 font:TITLE_LABEL_FONT];
            
            return constant + height;
            
        }
        else
        {
            OtherSoundInfo *info = (OtherSoundInfo *)item;
        
            CGFloat constant = 80;
            
            CGFloat height = [Utils heightForLabelForString:info.title width:152 font:TITLE_LABEL_FONT];
            
            return constant + height;
        }
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return;
    }
        
    UITableViewCell *tableCell = [self.tableView cellForRowAtIndexPath:indexPath];

    if([tableCell isKindOfClass:[SoundIntroCell class]])
    {
        return;
    }
    
    NSArray *items = [self.soundUICompleteInfo objectAtIndex:indexPath.section - 1];
    
    id item = [items objectAtIndex:indexPath.row];
    
    
    if ([tableCell isKindOfClass:[OtherSoundsCell class]]) {
    }
    else if ([tableCell isKindOfClass:[WebsiteSoundCell class]])
    {
        WebsiteSoundInfo *info = (WebsiteSoundInfo *)item;
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:info.url]];
    }
    else if ([tableCell isKindOfClass:[MyOwnSoundCell class]])
    {
        MyOwnSoundInfo *info = (MyOwnSoundInfo *)item;
        [PersistenceStorage setObject:info.url andKey:@"mediaURL"];
        [PersistenceStorage setObject:info.title andKey:@"mediaName"];
        [PersistenceStorage setObject:@"My Own Sounds" andKey:@"skillDetail2"];
        [PersistenceStorage setObject:info.title  andKey:@"skillDetail4"];
        [self setSoundType:indexPath];
        [self playAud:nil];
    }
    
    else
    {
        TinnitusSoundInfo *info = (TinnitusSoundInfo *)item;
        
        NSString *query = [NSString stringWithFormat: @"select * from Plan_Sound_List where ID = %@",[info dbIdentifier]];
        
        
        NSArray *mySoundsArray = [[NSArray alloc] initWithArray:[self.dbManagerMySounds loadDataFromDB:query]];
        
        //NSLog(@"%@",mySoundsArray);
        
        AudioPanningViewController *audioPanning = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AudioPanningViewController"];
        audioPanning.url = [[mySoundsArray valueForKey:@"soundURL"] objectAtIndex:0];
        audioPanning.name = [[mySoundsArray valueForKey:@"soundName"] objectAtIndex:0];
        audioPanning.panning = audio;
        
        
        [PersistenceStorage setObject:[[mySoundsArray valueForKey:@"soundURL"] objectAtIndex:0] andKey:@"USsoundURL"];
        
        [PersistenceStorage setObject:[[mySoundsArray valueForKey:@"soundName"] objectAtIndex:0] andKey:@"USsoundName"];
        [self setSoundType:indexPath];
        [PersistenceStorage setObject:@"Tinnitus Coach Sounds" andKey:@"skillDetail2"];
        [PersistenceStorage setObject:[[mySoundsArray valueForKey:@"soundName"] objectAtIndex:0] andKey:@"skillDetail4"];
        [self.navigationController presentModalViewController:audioPanning animated:YES];
    }

}

-(void)setSoundType:(NSIndexPath*)indexPath{
    switch (indexPath.section) {
        case 1:
            [PersistenceStorage setObject:@"Soothing Sound" andKey:@"skillDetail1"];
            break;
        case 2:
            [PersistenceStorage setObject:@"Interesting Sound" andKey:@"skillDetail1"];
            break;
        case 3:
            [PersistenceStorage setObject:@"Background Sound" andKey:@"skillDetail1"];
            break;
    
        default:
            break;
    }
}

-(void)didTapDelete:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    NSArray *items = [self.soundUICompleteInfo objectAtIndex:indexPath.section - 1];

    id item = [items objectAtIndex:indexPath.row];
    
    DeleteCormationManager *manager = [DeleteCormationManager getInstance];
    
    [manager showAlertwithPositiveBlock:^(BOOL positive) {
        
        [self deleteSoundFromDB:item andCompletion:^(BOOL success) {
            
            if (success) {
                
                [self prepareData];
            }
            
        }];
        
    } negativeBlock:^(BOOL negative) {
        
        //Do nothing
        
    }];
    
    
}

-(void)writeModifiedResource:(NSString *)itemTitle
{
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
    NSString *type = @"Skill";
    NSString *optionName = [PersistenceStorage getObjectForKey:@"optionName"];
    NSString *str = [PersistenceStorage getObjectForKey:@"actionTypeForResource"];
    
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"situationName"],[PersistenceStorage getObjectForKey:@"skillName"],[PersistenceStorage getObjectForKey:@"skillDetail1"],[PersistenceStorage getObjectForKey:@"skillDetail2"],itemTitle,nil,nil,nil,nil,nil];
    
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

-(void)didTapInformation:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    NSArray *items = [self.soundUICompleteInfo objectAtIndex:indexPath.section - 1];
    
    id item = [items objectAtIndex:indexPath.row];
    
    if([item isKindOfClass:[OtherSoundInfo class]])
    {
        OtherSoundInfo *info = (OtherSoundInfo *)item;
        
        NSString *description = [self.otherDevicesPopupMessageDict objectForKey:info.title];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:info.title message:description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
        
        
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


#pragma mark
#pragma mark Skill Intro Delegate Methods
-(void)didTapOnExplore:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    if (indexPath.section == 1) {
        SoundsCategoryViewController *scv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SoundsCategoryViewController"];
        scv.soundType = @"Soothing Sound";
        [self.navigationController pushViewController:scv animated:YES];
    }
    else if (indexPath.section == 2) {
        SoundsCategoryViewController *scv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SoundsCategoryViewController"];
        scv.soundType = @"Interesting Sound";
        
        [self.navigationController pushViewController:scv animated:YES];
    }
    else  if (indexPath.section == 3){
        SoundsCategoryViewController *scv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SoundsCategoryViewController"];
        scv.soundType = @"Background Sound";
        [self.navigationController pushViewController:scv animated:YES];
    }
}


-(void)deleteSoundFromDB:(id)item andCompletion:(void (^)(BOOL success))block
{
    if ([item isKindOfClass:[OtherSoundInfo class]]) {
        
        OtherSoundInfo *info = (OtherSoundInfo *)item;
        
        NSString *_soundTypeName;
        
        if ([info.typeId isEqualToString:@"1"])
        {_soundTypeName=@"Soothing Sound";}
        else
            if ([info.typeId isEqualToString:@"2"])
            {_soundTypeName=@"Interesting Sound";}
        
            else
                
                if ([info.typeId isEqualToString:@"3"])
                {_soundTypeName=@"Background Sound";}
        
        
        
        [PersistenceStorage setObject:@"Removed Using Sound Other Devices Option" andKey:@"actionTypeForResource"];
        [PersistenceStorage setObject:_soundTypeName andKey:@"skillDetail1"];
        [PersistenceStorage setObject:@"Other Devices" andKey:@"skillDetail2"];
        
        [self writeModifiedResource:info.title];
        
        NSString *query = [NSString stringWithFormat:@"delete from MyDevices where deviceID=%@     and planID = %@", [item dbIdentifier], [PersistenceStorage getObjectForKey:@"currentPlanID"]];
        
        BOOL isDone = [self.dbManagerMySounds executeQuery:query];
        if (isDone == YES)
        {
            NSLog(@"Success");
            block(YES);
        }
        else{
            block(NO);
            
        }
        
    }
    else if ([item isKindOfClass:[WebsiteSoundInfo class]])
    {
        WebsiteSoundInfo *info = (WebsiteSoundInfo *)item;
        
        NSString *_soundTypeName;
        
        if ([info.typeId isEqualToString:@"1"])
        {_soundTypeName=@"Soothing Sound";}
        else
            if ([info.typeId isEqualToString:@"2"])
            {_soundTypeName=@"Interesting Sound";}
        
            else
                
                if ([info.typeId isEqualToString:@"3"])
                {_soundTypeName=@"Background Sound";}
        
        [PersistenceStorage setObject:@"Removed Using Sound Website Apps Option" andKey:@"actionTypeForResource"];
        [PersistenceStorage setObject:_soundTypeName andKey:@"skillDetail1"];
        [PersistenceStorage setObject:@"Websites & Apps" andKey:@"skillDetail2"];

        [self writeModifiedResource:info.title];
        
        NSString *query = [NSString stringWithFormat:@"delete from MyWebsites where websiteID=%@     and planID = %@", [item dbIdentifier], [PersistenceStorage getObjectForKey:@"currentPlanID"]];
        
        BOOL isDone = [self.dbManagerMySounds executeQuery:query];
        if (isDone == YES)
        {
            NSLog(@"Success");
            block(YES);
            
        }
        else{
            block(NO);
            
        }
    }
    
    else
    {
        
        
        TinnitusSoundInfo *info = (TinnitusSoundInfo *)item;
        
        NSString *query = [NSString stringWithFormat:@"delete from MySounds where soundID=%@ and planID = %@", [item dbIdentifier] , [PersistenceStorage getObjectForKey:@"currentPlanID"]];
        
        BOOL isDone = [self.dbManagerMySounds executeQuery:query];
        if (isDone == YES)
        {
            NSLog(@"Success");
            block(YES);
            
        }
        else{
            block(NO);
            
        }
        
    }
}

#pragma mark Abstract Methods
-(NSString *)activityText
{
    return @"Using Sounds";
}





@end
