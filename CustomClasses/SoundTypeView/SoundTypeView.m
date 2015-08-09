//
//  SoundTypeView.m
//  testUIChanges
//
//  Created by Creospan   on 01/04/15.
//  Copyright (c) 2015 Creospan  . All rights reserved.
//

#import "SoundTypeView.h"
#import "OtherDevicesSoundActivityCell.h"
#import "WebsitesandAppsSoundActivityCell.h"
#import "MyOwnSoundsActivityCell.h"
#import "SoundsActivityCell.h"

#import "DeleteCormationManager.h"


@interface SoundTypeView ()
@property (strong, nonatomic) NSArray *soundActivitiesArray;
@property (nonatomic, strong) DBManager *dbManagerMySounds;

@property(nonatomic, strong) NSMutableArray *tempSoundsArray;
@property(nonatomic, strong) NSString *soundTypeName;

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
            if ([aView isKindOfClass: NSClassFromString(name)]){
                view = aView;
            }
            
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
        
        
        
        
        
        //NSLog(@"TEMPSA %@",self.tempSoundsArray);
        
        
        float heightForTable = [self getHeightForTableView:self.tempSoundsArray];
        [self.soundActivitiesTableView setFrame:CGRectMake(self.soundActivitiesTableView.frame.origin.x, self.soundActivitiesTableView.frame.origin.y, self.soundActivitiesTableView.frame.size.width, heightForTable)];
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + heightForTable);
        if ([self.tempSoundsArray count]>0) {
            self.soundActivityTableStatus.text = @"Below are the activities under this plan";
            
        }
        [self.soundActivitiesTableView registerNib:[UINib nibWithNibName:@"OtherDevicesSoundActivityCell" bundle:nil] forCellReuseIdentifier:@"OtherDevicesSoundActivityCell"];
        [self.soundActivitiesTableView registerNib:[UINib nibWithNibName:@"WebsitesandAppsSoundActivityCell" bundle:nil] forCellReuseIdentifier:@"WebsitesandAppsSoundActivityCell"];
         [self.soundActivitiesTableView registerNib:[UINib nibWithNibName:@"MyOwnSoundsActivityCell" bundle:nil] forCellReuseIdentifier:@"MyOwnSoundsActivityCell"];
        
         [self.soundActivitiesTableView registerNib:[UINib nibWithNibName:@"SoundsActivityCell" bundle:nil] forCellReuseIdentifier:@"SoundsActivityCell"];
        
    }
    return self;
}

-(void)reInitializeUIWithFrame:(CGRect)frame andData:(NSArray *)dataArray{
    self.soundActivitiesArray = [[NSMutableArray alloc] initWithArray:dataArray];
    
    self.tempSoundsArray = [self setData:self.soundActivitiesArray];

    float heightForTable = [self getHeightForTableView:self.tempSoundsArray];
    [self.soundActivitiesTableView setFrame:CGRectMake(self.soundActivitiesTableView.frame.origin.x, self.soundActivitiesTableView.frame.origin.y, self.soundActivitiesTableView.frame.size.width, heightForTable)];
    
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + heightForTable);
    if ([self.tempSoundsArray count]>0) {
        self.soundActivityTableStatus.text = @"Below are the activities under this plan";
        
    }
    [self setNeedsDisplay];
    [self.soundActivitiesTableView reloadData];
}

-(void)drawRect:(CGRect)rect
{
    
}

-(float)getHeightForTableView:(NSArray*)recordsArray
{
    float heightForTableView = 0;
    
    for (NSDictionary *dict in recordsArray) {
        if ([dict valueForKey:@"websiteID"]) {
            heightForTableView = heightForTableView + 100;
        }
        else if ([dict valueForKey:@"deviceID"])
        {
            heightForTableView = heightForTableView + 90;
            
        }
        else if ([dict valueForKey:@"MyOwnSoundID"])
        {
            heightForTableView = heightForTableView + 44;
            
        }
        else
            heightForTableView = heightForTableView + 44;
    }
    
    return heightForTableView;
    
}

-(float)getHeightForTableItem:(NSDictionary*)dict
{
    float heightForItem = 0;

        if ([dict valueForKey:@"websiteID"]) {
            heightForItem = 100;
        }
        else if ([dict valueForKey:@"deviceID"])
        {
            heightForItem =  90;
            
        }
        else if ([dict valueForKey:@"MyOwnSoundID"])
        {
            heightForItem = 44;
            
        }
        else
            heightForItem =  44;
    
    return heightForItem;
    
}


-(NSMutableArray *)setData:(NSArray*)dataArray
{
    
   // NSLog(@"Data Array   %@",dataArray);
    
    if([dataArray count]>0)
    {
        NSString *query = [NSString stringWithFormat: @"select ID, soundName from Plan_Sound_List where soundTypeID = %@ AND ID IN(select soundID from MySounds where planID= %@)", [[dataArray objectAtIndex:0] valueForKey:@"soundTypeID"] ,[PersistenceStorage getObjectForKey:@"currentPlanID"]];
        
        NSMutableArray *mySoundsArray = [[NSMutableArray alloc] initWithArray:[self.dbManagerMySounds loadDataFromDB:query]];
        
        
 
        
        query = [NSString stringWithFormat: @"select deviceName,deviceID, comments from MyDevices Inner JOIN Plan_Devices on MyDevices.deviceID = Plan_Devices.ID where myDevices.soundTypeID = %ld and planID = %@", (long)[[[dataArray objectAtIndex:0] valueForKey:@"soundTypeID"]integerValue],[PersistenceStorage getObjectForKey:@"currentPlanID"]];
        [mySoundsArray addObjectsFromArray:[self.dbManagerMySounds loadDataFromDB:query]];
        
      //  NSLog(@"hhh%@",query);
        
        
        query = [NSString stringWithFormat: @"select waName , waDetail,websiteID, comments,MyWebsites.URL from MyWebsites Inner JOIN Plan_Website_Apps on MyWebsites.websiteId = Plan_Website_Apps.ID where MyWebsites.soundTypeID = %ld and planID = %@", (long)[[[dataArray objectAtIndex:0] valueForKey:@"soundTypeID"]integerValue],[PersistenceStorage getObjectForKey:@"currentPlanID"]];
        
        [mySoundsArray addObjectsFromArray:[self.dbManagerMySounds loadDataFromDB:query]];
      
        
        query = [NSString stringWithFormat: @"select * from MyOwnSounds where soundTypeID = %ld and planID = %@", (long)[[[dataArray objectAtIndex:0] valueForKey:@"soundTypeID"]integerValue],[PersistenceStorage getObjectForKey:@"currentPlanID"]];
        
        [mySoundsArray addObjectsFromArray:[self.dbManagerMySounds loadDataFromDB:query]];
        
        
    //    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:mySoundsArray];
       // NSArray *arrayWithoutDuplicates = [orderedSet array];
        
        NSLog(@"SOUND ARRAY %@",mySoundsArray);
        
     //    return arrayWithoutDuplicates;
            return mySoundsArray;
    }
    return nil;
    // Reload the table view.
    //[self.soundActivitiesTableView reloadData];
}

-(void)deleteSoundFromDB:(NSDictionary *)soundDict andCompletion:(void (^)(BOOL success))block
{
    if ([soundDict valueForKey:@"deviceID"] != nil) {
        NSString *query = [NSString stringWithFormat:@"delete from MyDevices where deviceID=%@     and planID = %@", [soundDict valueForKey:@"deviceID"], [PersistenceStorage getObjectForKey:@"currentPlanID"]];
        
        BOOL isDone = [self.dbManagerMySounds executeQuery:query];
        if (isDone == YES)
        {
        
             if ([[soundDict valueForKey:@"soundTypeID"] isEqualToString:@"1"])
            {_soundTypeName=@"Soothing Sound";}
            else
                if ([[soundDict valueForKey:@"soundTypeID"] isEqualToString:@"2"])
                {_soundTypeName=@"Interesting Sound";}

            else
                
                if ([[soundDict valueForKey:@"soundTypeID"] isEqualToString:@"3"])
                {_soundTypeName=@"Background Sound";}

            
            
            [PersistenceStorage setObject:@"Removed Using Sound Other Devices Option" andKey:@"actionTypeForResource"];
            [PersistenceStorage setObject:_soundTypeName andKey:@"skillDetail1"];
            [PersistenceStorage setObject:@"Other Devices" andKey:@"skillDetail2"];
      
            //[PersistenceStorage setObject:@"Added Using Sound Other Devices Option" andKey:@"actionTypeForResource"];
//            [PersistenceStorage setObject:@"Other Devices" andKey:@"skillDetail2"];
            
            
            
            
            
            NSString *query = [NSString stringWithFormat:@"select * from Plan_Devices where   ID IN (select deviceID from MyDevices where planID ='%@') ",[PersistenceStorage getObjectForKey:@"currentPlanID"]];
            
            
            NSArray *deviceArrayList = [self.dbManagerMySounds loadDataFromDB:query];
            NSMutableString *deviceString =[NSMutableString stringWithString:@""];
            
            
            for(int i= 0 ;i<[deviceArrayList count];i++)
            {
                
                
                [deviceString appendString:[[deviceArrayList objectAtIndex:i] valueForKey:@"deviceName"]];
                [deviceString appendString:@"|"];
                
                
            }
            
            if ([deviceString length] > 0) {
                NSString *outPut = deviceString;
                outPut = [outPut substringToIndex:[outPut length] - 1];
                NSLog(@"%@",outPut);
                [PersistenceStorage setObject:outPut andKey:@"skillDetail3"];
                
                
            }
            
            
            
            [self writeModifiedResource];
            
            NSLog(@"Success");
            block(YES);
        }
        else{
             block(NO);
            
        }
        
    }
    else if ([soundDict valueForKey:@"websiteID"] != nil)
    {
        
        
//NSString *query = [NSString stringWithFormat: @"select * from MyDevices  where soundTypeID = %ld and planID = %@", (long)typeID, [PersistenceStorage getObjectForKey:@"currentPlanID"]];
        
        
        NSString *query = [NSString stringWithFormat:@"delete from MyWebsites where websiteID=%@     and planID = %@", [soundDict valueForKey:@"websiteID"], [PersistenceStorage getObjectForKey:@"currentPlanID"]];
      
        
        
        
        BOOL isDone = [self.dbManagerMySounds executeQuery:query];
        if (isDone == YES)
        {
            
            
            
            
            
            
            
            if ([[soundDict valueForKey:@"soundTypeID"] isEqualToString:@"1"])
            {_soundTypeName=@"Soothing Sound";}
            else
                if ([[soundDict valueForKey:@"soundTypeID"] isEqualToString:@"2"])
                {_soundTypeName=@"Interesting Sound";}
            
                else
                    
                    if ([[soundDict valueForKey:@"soundTypeID"] isEqualToString:@"3"])
                    {_soundTypeName=@"Background Sound";}
            
            
            
            [PersistenceStorage setObject:@"Removed Using Sound Website Apps Option" andKey:@"actionTypeForResource"];
            [PersistenceStorage setObject:_soundTypeName andKey:@"skillDetail1"];
            [PersistenceStorage setObject:@"Websites & Apps" andKey:@"skillDetail2"];
            
            //[PersistenceStorage setObject:@"Added Using Sound Other Devices Option" andKey:@"actionTypeForResource"];
            //            [PersistenceStorage setObject:@"Other Devices" andKey:@"skillDetail2"];
            
            
            
            
            
            NSString *query = [NSString stringWithFormat:@"select * from Plan_Website_Apps where   ID IN (select websiteID from MyWebsites where planID ='%@') ",[PersistenceStorage getObjectForKey:@"currentPlanID"]];
            
            
            NSArray *waArrayList = [self.dbManagerMySounds loadDataFromDB:query];
            NSMutableString *waString =[NSMutableString stringWithString:@""];
            
            
            for(int i= 0 ;i<[waArrayList count];i++)
            {
                
                
                [waString appendString:[[waArrayList objectAtIndex:i] valueForKey:@"waName"]];
                [waString appendString:@"|"];
                
                
            }
            
            if ([waString length] > 0) {
                NSString *outPut = waString;
                outPut = [outPut substringToIndex:[outPut length] - 1];
                NSLog(@"%@",outPut);
                [PersistenceStorage setObject:outPut andKey:@"skillDetail3"];
                
                
            }
            
            
            
            [self writeModifiedResource];
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            NSLog(@"Success");
            block(YES);
            
        }
        else{
             block(NO);
            
        }
        [self.soundActivitiesTableView reloadData];
    }
    
    

    else if ([soundDict valueForKey:@"MyOwnSoundID"] != nil)
    {
        
        
        //NSString *query = [NSString stringWithFormat: @"select * from MyDevices  where soundTypeID = %ld and planID = %@", (long)typeID, [PersistenceStorage getObjectForKey:@"currentPlanID"]];
        
        
        NSString *query = [NSString stringWithFormat:@"delete from MyOwnSounds where MyOwnSoundID=%@     and planID = %@", [soundDict valueForKey:@"MyOwnSoundID"], [PersistenceStorage getObjectForKey:@"currentPlanID"]];
        
        
        
        
        BOOL isDone = [self.dbManagerMySounds executeQuery:query];
        if (isDone == YES)
        {
            NSLog(@"Success");
            block(YES);
            
        }
        else{
            block(NO);
            
        }
        [self.soundActivitiesTableView reloadData];
    }
    
    
    
    
    
    else
    {
        NSString *query = [NSString stringWithFormat:@"delete from MySounds where soundID=%@ and planID = %@", [soundDict valueForKey:@"ID"] , [PersistenceStorage getObjectForKey:@"currentPlanID"]];
        
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
        CellIdentifier = @"OtherDevicesSoundActivityCell";
        OtherDevicesSoundActivityCell *cell;
        
        if (cell == nil) {
            cell =  [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        }
        
        
        UIImageView *deleteButton = [[UIImageView alloc]initWithFrame:CGRectMake(8, 48, 27, 27)];
        
        [deleteButton setImage:[UIImage imageNamed:@"Active_Trash_Button.png"]];
        
        deleteButton.tag = indexPath.row;
        
        cell.tag = indexPath.row;
        
        [Utils addTapGestureToView:deleteButton target:self selector:@selector(onDelete:)];
        
        [cell addSubview:deleteButton];

        
        
      //  cell.deleteButton.tag = indexPath.row;
        //[Utils addTapGestureToView:cell.deleteButton target:self selector:@selector(onDelete:)];
//[cell addSubview:deleteButton];

        
        cell.nameLabel.text = [[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"deviceName"];
        
        if ([[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"comments"] != nil)
        {
        
        cell.commentsTextField.text = [[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"comments"];
        }
        
        
        return cell;
    }
    else if ([[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"websiteID"] != nil) {
        CellIdentifier = @"WebsitesandAppsSoundActivityCell";
        WebsitesandAppsSoundActivityCell *cell;
        
        if (cell == nil) {
            cell =  [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        }
   
        
        UIImageView *deleteButton = [[UIImageView alloc]initWithFrame:CGRectMake(12, 65, 27, 27)];
        
        [deleteButton setImage:[UIImage imageNamed:@"Active_Trash_Button.png"]];
        
        deleteButton.tag = indexPath.row;
                cell.tag = indexPath.row;
        
        [Utils addTapGestureToView:deleteButton target:self selector:@selector(onDelete:)];
        
        [cell addSubview:deleteButton];

        
        cell.nameLabel.text = [[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"waName"];
        
        cell.descriptionLabel.text =[[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"waDetail"];
        
        //cell.commentsTextField.text = [[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"comments"];
        
        if (![[[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"comments"] isEqualToString:@"(null)"])
        {
            
            cell.commentsTextField.text = [[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"comments"];
        }
        
        
        
        
        
        return cell;
    }
    else if ([[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"MyOwnSoundID"] != nil) {
        CellIdentifier = @"MyOwnSoundsActivityCell";
        MyOwnSoundsActivityCell *cell;
        
        if (cell == nil) {
            cell =  [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        }
        
      //  cell.nameLabel.text = [[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"comments"];
                cell.tag = indexPath.row;
        
        
        
        
        if (![[[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"comments"] isEqualToString:@"(null)"])
        {
            
            cell.nameLabel.text = [[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"comments"];
        }
        
        UIImageView *deleteButton = [[UIImageView alloc]initWithFrame:CGRectMake(12, 65, 27, 27)];
        
        [deleteButton setImage:[UIImage imageNamed:@"Active_Trash_Button.png"]];
        
        deleteButton.tag = indexPath.row;
        cell.tag = indexPath.row;
        
        
        
        
        
        
        
        
     //   cell.descriptionLabel.text =[[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"URL"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.commentsTextField.text = [[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"URL"];
        [Utils addTapGestureToView:deleteButton target:self selector:@selector(onDelete:)];
        
        [cell addSubview:deleteButton];
        return cell;
    }
    
         else if ([[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"ID"] != nil)
    
    {
    
    CellIdentifier = @"SoundsActivityCell";
            SoundsActivityCell *cell;
            
            if (cell == nil) {
                cell =  [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            }
            
            cell.nameLabel.text = [[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"soundName"];
            cell.nameLabel.tag = 2222;//indexPath.row;
            cell.delegate = self;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
    }
    
//        
//        
//        
//        
//        CellIdentifier = @"Cell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        }
//        
//        NSString *str = [[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"soundName"];
//        cell.textLabel.text =str;
//        cell.imageView.image = [UIImage imageNamed:@"u353.png"];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//       // NSLog(@"%@",self.tempSoundsArray) ;
//
//            return cell;
//    }

    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[self.tempSoundsArray objectAtIndex:indexPath.row] valueForKey:@"deviceID"] != nil) {
        return 90;
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
                                        [self deleteSoundFromDB:[self.tempSoundsArray objectAtIndex:indexPath.row] andCompletion:^(BOOL success)
                                         {
                                             if (success) {
//                                                 [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//                                                 UIAlertView *alert = [[UIAlertView alloc]   //show alert box with option to play or exit
//                                                                       initWithTitle: @"Removed an Item"
//                                                                       message:@"The item in this list was removed. You should see it cleared from the list when you come back to this screen."
//                                                                       delegate:self
//                                                                       cancelButtonTitle:nil
//                                                                       otherButtonTitles:@"OK",nil];
//                                                 
//                                                 
//                                                 
//                                                 [alert show];
                                             
                                             
                                             
                                             [self.tempSoundsArray removeObjectAtIndex:indexPath.row];

                                             
    [self.soundActivitiesTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
                                                 //    [self.soundActivitiesTableView reloadData];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"sayHelloNotification" object:nil];
                                                 
                                             }

                                         }];
                                    }];
    button.backgroundColor = [UIColor redColor]; //arbitrary color
    
 
    return @[button];
}



-(void)onDelete:(id)sender
{
     NSInteger tag =[(UIGestureRecognizer *)sender view].tag;
    if([self confirmAndDeleteSoundItemAtPosition:tag]){
        float heightForTable = [self getHeightForTableView:self.tempSoundsArray];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - heightForTable);
        [self.soundActivitiesTableView reloadData];
    }
       
}

-(BOOL)confirmAndDeleteSoundItemAtPosition:(NSInteger)index{
    DeleteCormationManager *manager = [DeleteCormationManager getInstance];
    __block BOOL retval = NO;
    [manager showAlertwithPositiveBlock:^(BOOL positive) {
        
        [self deleteSoundFromDB:[self.tempSoundsArray objectAtIndex:index] andCompletion:^(BOOL success)
         
         {
             if (success) {

                 [self itemDeletedAtIndex:index];
                 retval = YES;
                 //[[NSNotificationCenter defaultCenter] postNotificationName:@"sayHelloNotification" object:nil];
             }
             
         }];
    } negativeBlock:^(BOOL negative) {
        retval = NO;
        //DO nothing
    }];
    return retval;
}

-(void)itemDeletedAtIndex:(NSInteger)index{
    
    NSDictionary* dict = [self.tempSoundsArray objectAtIndex:index];
    [self.tempSoundsArray removeObjectAtIndex:index];
    float heightAdjust = [self getHeightForTableItem:dict];
    //[self setNeedsDisplay];
    if(self.tempSoundsArray.count == 0){
        self.soundActivityTableStatus.text = @"You have no added sounds";
    }
    [self.soundActivitiesTableView reloadData];
    self.soundActivitiesTableView.frame = CGRectMake(self.soundActivitiesTableView.frame.origin.x, self.soundActivitiesTableView.frame.origin.y, self.soundActivitiesTableView.frame.size.width, [self getHeightForTableView:self.tempSoundsArray]);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - heightAdjust);
    
    [self.delegate tableViewCellDeleted:dict fromView:self];
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"sayHelloNotification" object:nil];
}


-(void)onsDelete:(id)sender

{
    //    DeleteCormationManager *manager = [DeleteCormationManager getInstance];
    //
    //    [manager showAlertwithPositiveBlock:^(BOOL positive) {
    //
    NSInteger tag =[(UIGestureRecognizer *)sender view].tag;
    
    //  [(UIGestureRecognizer *)sender view].tag
    
    
    
    //
    //
    //
    
    
    
    
    [self deleteSoundFromDB:[self.tempSoundsArray objectAtIndex:tag] andCompletion:^(BOOL success)
     {
         if (success) {
             [self.tempSoundsArray removeObjectAtIndex:tag];
             //      [self.soundActivitiesTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
         //    [self.soundActivitiesTableView reloadData];
             if([[self delegate] respondsToSelector:@selector(tableViewCellDeleted:)]) {
                // [[self delegate] tableViewCellDeleted:[self.soundActivitiesArray objectAtIndex:tag]];
             }
         }
         
     }];
    
    
    
    
    
    
    
    [self setNeedsDisplay];
    
    
    //     [PersistenceStorage setObject:[[userPlansArray objectAtIndex:tag] valueForKey:@"planName"] andKey:@"deletingPlanName"];
    //    [PersistenceStorage setObject:[[userPlansArray objectAtIndex:tag] valueForKey:@"situationName"] andKey:@"deletingSituationName"];
    
    
    [PersistenceStorage setObject:@"OK" andKey:@"soundListMode"];
    
    
 //   [self refreshScreen];
    
    
    
    //DO nothing
}







- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    // you need to implement this method too or nothing will work:
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



-(void)tableView:(UITableView *)tableView   didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    //   NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    // UITableViewCell *cell = [tableView cellForRowAtIndexPath:selectedIndexPath];
    
    
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
  //  NSLog(@"TEST LABEL %@",cell.textLabel.text);
    
    UILabel *label = (UILabel*)[cell viewWithTag:2222];
    
    if (![[label text] isEqualToString:nil])
    {
        
        [PersistenceStorage setObject:[label text]  andKey:@"soundName" ];
        
        NSLog(@"Label Text: %@", [label text]);

        
    }
    
    
    if([[self delegate] respondsToSelector:@selector(tableViewCellClicked:)]) {
        
     //   NSLog(@"%@",[self.soundActivitiesArray objectAtIndex:indexPath.row]);
        
        [[self delegate] tableViewCellClicked:[self.soundActivitiesArray objectAtIndex:indexPath.row]];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


//
//-(void)tableView:(UITableView *)tableView   didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    
//    
// //   NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
//   // UITableViewCell *cell = [tableView cellForRowAtIndexPath:selectedIndexPath];
//    
//    
//    
//    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    
//  //  NSLog(@"TEST LABEL %@",cell.nameLabel.text);
//
//    
//    
//    if (![cell.textLabel.text isEqualToString:nil])
//    {
//        
//  //      [PersistenceStorage setObject:cell.textLabel.text  andKey:@"soundName" ];
//     
//        
//    //    NSLog(@"TEST LABEL %@",cell.textLabel.text);
//        
//    }
//    
//    
//    if([[self delegate] respondsToSelector:@selector(tableViewCellClicked:)]) {
//        
////[[self delegate] tableViewCellClicked:[self.soundActivitiesArray objectAtIndex:indexPath.row]];
//  
//        
//        
//        [[self delegate] tableViewCellClicked:indexPath.row];//[self.tempSoundsArray objectAtIndex:indexPath.row]];
//        
//        }
//    
////[tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//           
//    }

    
    
-(void)writeModifiedResource{
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
    NSString *type = @"Skill";
    NSString *optionName = [PersistenceStorage getObjectForKey:@"optionName"];
    NSString *str = [PersistenceStorage getObjectForKey:@"actionTypeForResource"];
    
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"situationName"],[PersistenceStorage getObjectForKey:@"skillName"],[PersistenceStorage getObjectForKey:@"skillDetail1"],[PersistenceStorage getObjectForKey:@"skillDetail2"],[PersistenceStorage getObjectForKey:@"skillDetail3"],nil,nil,nil,nil,nil];
    
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



#pragma mark - SoundActivityCellDelegate

-(void)onDeleteSoundItem:(UITableViewCell*)cell{
    NSLog(@"On delete cell called");
    NSIndexPath* indexPath = [self.soundActivitiesTableView indexPathForCell:cell];
    [self confirmAndDeleteSoundItemAtPosition:indexPath.row];
}




@end


