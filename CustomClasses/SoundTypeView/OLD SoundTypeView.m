//
//  SoundTypeView.m
//  testUIChanges
//
//  Created by Vimal Venugopalan on 01/04/15.
//  Copyright (c) 2015 Vimal Venugopalan. All rights reserved.
//

#import "SoundTypeView.h"
#import "OtherDevicesWithCommentsCell.h"
#import "WebsitesandAppsWithCommentsCell.h"

@interface SoundTypeView ()
@property (strong, nonatomic) NSMutableArray *soundActivitiesArray;
@property (nonatomic, strong) DBManager *dbManagerMySounds;

@property(nonatomic, strong) NSArray *tempSoundsArray;

@end

@implementation SoundTypeView



+ (id)viewFromNibWithName: (NSString*)name
{
    UIView *view = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed: name owner: self options: nil];
    if (views)
    {
        for (UIView *aView in views)
        {
            if ([aView isKindOfClass: NSClassFromString(name)])
                view = aView;
        }
    }
    return view;
}

- (id)initWithFrame:(CGRect)frame andData:(NSArray *)dataArray
{
    self = [SoundTypeView viewFromNibWithName: @"SoundTypeView"];
    if (self)
    {
        
        self.dbManagerMySounds = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];

      self.soundActivitiesArray = [[NSMutableArray alloc] initWithArray:dataArray];
        
      self.tempSoundsArray = [self setData:self.soundActivitiesArray];
        
        float heightForTable = [self getHeightForTableView:self.tempSoundsArray];
        [self.soundActivitiesTableView setFrame:CGRectMake(self.soundActivitiesTableView.frame.origin.x, self.soundActivitiesTableView.frame.origin.y, self.soundActivitiesTableView.frame.size.width, heightForTable)];
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + heightForTable);
        if ([dataArray count]>0) {
            self.soundActivityTableStatus.text = @"Here are the sounds in this category:";
            
        }
        [self.soundActivitiesTableView registerNib:[UINib nibWithNibName:@"OtherDevicesWithCommentsCell" bundle:nil] forCellReuseIdentifier:@"OtherDevicesWithCommentsCell"];
        [self.soundActivitiesTableView registerNib:[UINib nibWithNibName:@"WebsitesandAppsWithCommentsCell" bundle:nil] forCellReuseIdentifier:@"WebsitesandAppsWithCommentsCell"];
        
        
    }
    return self;
}

-(float)getHeightForTableView:(NSArray*)recordsArray
{
    float heightForTableView = 0;

    for (NSDictionary *dict in recordsArray) {
        if ([dict valueForKey:@"websiteID"] || [dict valueForKey:@"deviceID"]) {
            heightForTableView = heightForTableView + 100;
        }
        else
            heightForTableView = heightForTableView + 44;
    }
    
    return heightForTableView;

}




-(NSArray *)setData:(NSArray*)dataArray
{
    if([dataArray count]>0)
    {
     /*   NSString *query = [NSString stringWithFormat: @"select soundName from Plan_Sound_List where soundTypeID = %@ AND ID IN(select soundID from MySounds where planID = %@ )", [[dataArray objectAtIndex:0] valueForKey:@"soundTypeID"], [PersistenceStorage getObjectForKey:@"currentPlanID"] ];
 
        NSMutableArray *mySoundsArray = [[NSMutableArray alloc] initWithArray:[self.dbManagerMySounds loadDataFromDB:query]];
        
        query = [NSString stringWithFormat: @"select deviceName,deviceID, comments from MyDevices Inner JOIN Plan_Devices on MyDevices.deviceID = Plan_Devices.ID where soundTypeID = %ld and planID = %@ ", (long)[[[dataArray objectAtIndex:0] valueForKey:@"soundTypeID"]integerValue], [PersistenceStorage getObjectForKey:@"currentPlanID"]];

    //    [mySoundsArray addObjectsFromArray:[self.dbManagerMySounds loadDataFromDB:query]];
        
        query = [NSString stringWithFormat: @"select waName , waDetail,websiteID, comments from MyWebsites Inner JOIN Plan_Website_Apps on MyWebsites.websiteId = Plan_Website_Apps.ID where soundTypeID = %ld and planID = %@ ", (long)[[[dataArray objectAtIndex:0] valueForKey:@"soundTypeID"]integerValue],[PersistenceStorage getObjectForKey:@"currentPlanID"]];
       
      */
        
        
        
        
        NSString *query = [NSString stringWithFormat: @"select * from Plan_Sound_List where soundTypeID = %@ AND ID IN(select soundID from MySounds where planID = %@ )", [[dataArray objectAtIndex:0] valueForKey:@"soundTypeID"], [PersistenceStorage getObjectForKey:@"currentPlanID"] ];
        
        NSMutableArray *mySoundsArray = [[NSMutableArray alloc] initWithArray:[self.dbManagerMySounds loadDataFromDB:query]];
        
        query = [NSString stringWithFormat: @"select * from MyDevices Inner JOIN Plan_Devices on MyDevices.deviceID = Plan_Devices.ID where soundTypeID = %ld and planID = %@ ", (long)[[[dataArray objectAtIndex:0] valueForKey:@"soundTypeID"]integerValue], [PersistenceStorage getObjectForKey:@"currentPlanID"]];
        
            [mySoundsArray addObjectsFromArray:[self.dbManagerMySounds loadDataFromDB:query]];
        
        query = [NSString stringWithFormat: @"select * from MyWebsites Inner JOIN Plan_Website_Apps on MyWebsites.websiteId = Plan_Website_Apps.ID where soundTypeID = %ld and planID = %@ ", (long)[[[dataArray objectAtIndex:0] valueForKey:@"soundTypeID"]integerValue],[PersistenceStorage getObjectForKey:@"currentPlanID"]];
        [mySoundsArray addObjectsFromArray:[self.dbManagerMySounds loadDataFromDB:query]];
        
      
      
      [mySoundsArray addObjectsFromArray:[self.dbManagerMySounds loadDataFromDB:query]];
        
        NSLog(@"%@",mySoundsArray);

        return mySoundsArray;
    }
    return nil;
        // Reload the table view.
       //[self.soundActivitiesTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tempSoundsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier;
    if ([[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"deviceID"] != nil) {
        CellIdentifier = @"OtherDevicesWithCommentsCell";
        OtherDevicesWithCommentsCell *cell;

        if (cell == nil) {
            cell =  [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        }
        
        cell.nameLabel.text = [[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"deviceName"];
        
        cell.commentsTextField.text = [[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"comments"];
        cell.checkBoxButton.hidden = YES;
        return cell;
    }
    else if ([[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"websiteID"] != nil) {
        CellIdentifier = @"WebsitesandAppsWithCommentsCell";
        WebsitesandAppsWithCommentsCell *cell;
        
        if (cell == nil) {
            cell =  [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        }
        
        cell.nameLabel.text = [[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"waName"];
        
        cell.descriptionLabel.text =[[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"waDetail"];
        
        cell.commentsTextField.text = [[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"comments"];
        cell.checkBoxButton.hidden = YES;
        return cell;
    }
    else
    {
        CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSString *str = [[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"soundName"];
        cell.textLabel.text =str;
        cell.imageView.image = [UIImage imageNamed:@"u353.png"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"deviceID"] != nil) {
        return 100;
    }
    else if ([[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"websiteID"] != nil)
    {
        return 100;
    }
    else
    {
        return 44;
    }
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"X" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        NSLog(@"Action to perform with Button 1");
                                        
                                        
                                        NSDictionary *dict = [self.tempSoundsArray objectAtIndex:indexPath.row];
                                        NSLog(@"%@",dict);
                                        
                                        
                                        
//NSString *query = [NSString stringWithFormat:@"delete from  MyActivities where ActivityID = '%@'",[dict valueForKey:@"ID"]];
  //                                      NSLog(@"%@",query);
                                        
                                        
                                    }];
    button.backgroundColor = [UIColor grayColor]; //arbitrary color
    
    
    return @[button];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // you need to implement this method too or nothing will work:
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([[self delegate] respondsToSelector:@selector(tableViewCellClicked:)]) {
        [[self delegate] tableViewCellClicked:[self.soundActivitiesArray objectAtIndex:indexPath.row]];
    }
}

@end


