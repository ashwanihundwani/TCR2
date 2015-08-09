//
//  WebsitesandAppsViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 3/30/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "WebsitesandAppsViewController.h"
#import "WebsitesandAppsCell.h"
#import "WebsitesandAppsWithCommentsCell.h"
#import "SoundActivitiesViewController.h"

@interface WebsitesandAppsViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *websitesandAppsSoundsArray;
}
@property (weak, nonatomic) IBOutlet UILabel *websitesandAppsSoundDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITableView *websitesandAppsSoundTableView;
@property (nonatomic, strong) DBManager *dbManagerSoundsList;

@property (nonatomic, strong) NSMutableArray *checkFlagArray;
@property (nonatomic, strong) NSMutableArray *commentsArray;

@end

@implementation WebsitesandAppsViewController



-(void)dismissKeyboard {
[self.view endEditing:YES];}

- (void)viewDidLoad {
    [super viewDidLoad];
  //  [commentsTextField SetDelegate:self];

    UINavigationBar *myBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    [self.view addSubview:myBar];
    
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Add Websites & Apps"];

    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStylePlain target:nil action:@selector(cancelTapped:)];
    item.leftBarButtonItem = leftButton;
    
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:nil action:@selector(addTapped:)];
     item.rightBarButtonItem = rightButton;
    
    
    
    
    [myBar pushNavigationItem:item animated:NO];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
    
    
    
    
    
    
    self.websitesandAppsSoundDescriptionLabel.text = [NSString stringWithFormat:@"Below are websites and apps with music, podcasts and other sounds. Select the websites and apps with %@ that you would like to add to your plan.",self.soundType];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(addWebsitesandApps)];

    // Do any additional setup after loading the view.
    
    self.dbManagerSoundsList = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    
    [self.websitesandAppsSoundTableView registerNib:[UINib nibWithNibName:@"WebsitesandAppsCell" bundle:nil] forCellReuseIdentifier:@"WebsitesandAppsCell"];
    
    [self.websitesandAppsSoundTableView registerNib:[UINib nibWithNibName:@"WebsitesandAppsWithCommentsCell" bundle:nil] forCellReuseIdentifier:@"WebsitesandAppsWithCommentsCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated
{
    [self loadWebsiteandAppsSounds];
    
}

-(NSInteger)checkCountForSoundTypeID :(NSInteger )soundTypeID
{
    NSString *query = [NSString stringWithFormat:@"SELECT (SELECT count(*) from MySounds  where soundTypeID = %ld) + (SELECT count(*) from MyDevices  where soundTypeID = %ld) + (SELECT count(*) from MyWebsites  where soundTypeID = %ld)", (long)soundTypeID, (long)soundTypeID, (long)soundTypeID];
    
    NSArray *recordArray = [self.dbManagerSoundsList loadDataFromDB:query];
    
    return [[[(NSDictionary *)[recordArray objectAtIndex:0] allValues] objectAtIndex:0] integerValue];
    
}

-(void)addWebsitesandApps
{
    NSInteger soundTypeID = 0;
    if ([self.soundType isEqualToString:@"Soothing Sound"]) {
        soundTypeID = 1;
    }
    else if ([self.soundType isEqualToString:@"Interesting Sound"]) {
        soundTypeID = 2;
    }
    else if ([self.soundType isEqualToString:@"Background Sound"]) {
        soundTypeID = 3;
    }
    
    NSInteger countForSoundType = [self checkCountForSoundTypeID:soundTypeID];
    NSCountedSet *filter = [NSCountedSet setWithArray:self.checkFlagArray];
    
    

    
    if ((countForSoundType + [filter countForObject:@"1"])<=1000) {
        
         
        NSMutableString *queryInsert = [NSMutableString stringWithFormat:@"insert into MyWebsites ('planID', 'groupID', 'skillID', 'soundTypeID', 'websiteID', 'comments','URL') values "];
        
        for (int i = 0; i<[self.checkFlagArray count]; i++) {
            if ([[self.checkFlagArray objectAtIndex:i] boolValue] == 1) {
                
                WebsitesandAppsWithCommentsCell *cell = (WebsitesandAppsWithCommentsCell*)[self.websitesandAppsSoundTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];

                
                
                
                [queryInsert appendFormat:@"(%ld, %ld, %ld, %ld, %ld, '%@','%@'),",(long)[PersistenceStorage getIntegerForKey:@"currentPlanID"], (long)[PersistenceStorage getIntegerForKey:@"currentGroupID"], (long)[PersistenceStorage getIntegerForKey:@"currentSkillID"], (long)soundTypeID, (long)[[[websitesandAppsSoundsArray objectAtIndex:i] valueForKey:@"ID"] integerValue], cell.commentsTextField.text,[[websitesandAppsSoundsArray objectAtIndex:i] valueForKey:@"URL"]];
                
            }
        }

        NSString *newQuery = [queryInsert substringToIndex:[queryInsert length]-1];
        
 
        
        
        BOOL isDone = [self.dbManagerSoundsList executeQuery:newQuery];
       
   //     SoundActivitiesViewController *npsv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SoundActivitiesViewController"];
        
  
        if (isDone == YES)
     
        {
  
            
        [PersistenceStorage setObject:@"Added Using Sound Websites Apps Option" andKey:@"actionTypeForResource"];
        [PersistenceStorage setObject:@"Websites & Apps" andKey:@"skillDetail2"];
 
        NSString *loadquery = [NSString stringWithFormat:@"select * from Plan_Website_Apps where soundTypeID = '%@' and ID IN (select websiteID from MyWebsites where planID ='%@') ",[PersistenceStorage getObjectForKey:@"soundTypeID"],[PersistenceStorage getObjectForKey:@"currentPlanID"]];
    
        NSArray *waArrayList = [self.dbManagerSoundsList loadDataFromDB:loadquery];
        NSMutableString *waString =[NSMutableString stringWithString:@""];
        NSLog(@"%@",waArrayList);
        
        
        for(int i= 0 ;i<[waArrayList count];i++)
        {
        
            [waString appendString:[[waArrayList objectAtIndex:i] valueForKey:@"waName"]];
            [waString appendString:@"|"];
            
        }
        
        if ([waString length] > 0) {
            NSString *outPut = waString;
            outPut = [outPut substringToIndex:[outPut length] - 2];
            NSLog(@"%@",outPut);
            [PersistenceStorage setObject:outPut andKey:@"skillDetail3"];
            
            
        }
        
        
        [self writeModifiedResource];
        
        
        
        NSLog(@"Success");
    }
    
           // [self.navigationController pushViewController:npsv animated:YES];

    }
  }





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
    
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"situationName"],[PersistenceStorage getObjectForKey:@"skillName"],self.soundType,[PersistenceStorage getObjectForKey:@"skillDetail2"],[PersistenceStorage getObjectForKey:@"skillDetail3"],nil,nil,nil,nil,nil];
    
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




- (void)cancelTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)addTapped:(id)sender;
{
    NSInteger soundTypeID = 0;
    if ([self.soundType isEqualToString:@"Soothing Sound"]) {
        soundTypeID = 1;
    }
    else if ([self.soundType isEqualToString:@"Interesting Sound"]) {
        soundTypeID = 2;
    }
    else if ([self.soundType isEqualToString:@"Background Sound"]) {
        soundTypeID = 3;
    }
    
    NSInteger countForSoundType = [self checkCountForSoundTypeID:soundTypeID];
    NSCountedSet *filter = [NSCountedSet setWithArray:self.checkFlagArray];
    
    
    
    
    if ((countForSoundType + [filter countForObject:@"1"])<=100) {
        
        
        
        
        NSMutableString *query = [NSMutableString stringWithFormat:@"insert into MyWebsites ('planID', 'groupID', 'skillID', 'soundTypeID', 'websiteID', 'comments','URL') values "];
        
        for (int i = 0; i<[self.checkFlagArray count]; i++) {
            if ([[self.checkFlagArray objectAtIndex:i] boolValue] == 1) {
                
                WebsitesandAppsWithCommentsCell *cell = (WebsitesandAppsWithCommentsCell*)[self.websitesandAppsSoundTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                
                [query appendFormat:@"(%ld, %ld, %ld, %ld, %ld, '%@','%@'),",(long)[PersistenceStorage getIntegerForKey:@"currentPlanID"], (long)[PersistenceStorage getIntegerForKey:@"currentGroupID"], (long)[PersistenceStorage getIntegerForKey:@"currentSkillID"], (long)soundTypeID, (long)[[[websitesandAppsSoundsArray objectAtIndex:i] valueForKey:@"ID"] integerValue], cell.commentsTextField.text,[[websitesandAppsSoundsArray objectAtIndex:i] valueForKey:@"URL"]];
                
            }
        }
        
        
        
        
        
        NSString *newQuery = [query substringToIndex:[query length]-1];
        
        
        
        BOOL isDone = [self.dbManagerSoundsList executeQuery:newQuery];
        
        SoundActivitiesViewController *npsv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SoundActivitiesViewController"];
        
        
      //  if (isDone == YES)
            
      //{

        
      //  if (isDone == YES)
            
        //{
            
            
            [PersistenceStorage setObject:@"Added Using Sound Websites Apps Option" andKey:@"actionTypeForResource"];
            [PersistenceStorage setObject:@"Websites & Apps" andKey:@"skillDetail2"];
            
            NSString *loadquery = [NSString stringWithFormat:@"select * from Plan_Website_Apps where   ID IN (select websiteID from MyWebsites where planID ='%@') ",[PersistenceStorage getObjectForKey:@"currentPlanID"]];
            
            NSArray *waArrayList = [self.dbManagerSoundsList loadDataFromDB:loadquery];
            NSMutableString *waString =[NSMutableString stringWithString:@""];
            NSLog(@"%@",waArrayList);
            
            
            for(int i= 0 ;i<[waArrayList count];i++)
            {
                
                [waString appendString:[[waArrayList objectAtIndex:i] valueForKey:@"waName"]];
                [waString appendString:@"|"];
                
            }
            
            if ([waString length] > 0) {
                NSString *outPut = waString;
                outPut = [outPut substringToIndex:[outPut length] - 1];
                 [PersistenceStorage setObject:outPut andKey:@"skillDetail3"];
                
                
            }
            
            
            [self writeModifiedResource];
            
            
        
        
        
        
        
            [self dismissViewControllerAnimated:YES completion:^{
                
                
            //    [[NSNotificationCenter defaultCenter] postNotificationName: @"sayHelloNotification"; object: nil;];
                
                
         }];

    //}
    //else
    //{
     //   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tinnitus Coach" message:[NSString stringWithFormat:@"You have already added %ld sounds in this list. You cannot add more than 100 sounds.", (long)countForSoundType] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
      //  [alert show];
    //}
    
    
    
}
}


- (BOOL)textFieldShouldReturn:(UITextField *)commentsTextField {
   // [self.commentsTextField resignFirstResponder];
    return NO;
}

-(void)loadWebsiteandAppsSounds{
    
    NSInteger soundTypeID = 0;
    if ([self.soundType isEqualToString:@"Soothing Sound"]) {
        soundTypeID = 1;
    }
    else if ([self.soundType isEqualToString:@"Interesting Sound"]) {
        soundTypeID = 2;
    }
    else if ([self.soundType isEqualToString:@"Background Sound"]) {
        soundTypeID = 3;
    }
    
    
    
 //   NSString *query = [NSString stringWithFormat:@"select * from Plan_Website_Apps where soundTypeID = %d",soundTypeID];
    
    
    
    
    NSString *query = [NSString stringWithFormat:@"select * from Plan_Website_Apps where soundTypeID = %d and ID NOT IN (select websiteID from MyWebsites where planID==%@) ",soundTypeID,[PersistenceStorage getObjectForKey:@"currentPlanID"]];

    
    
    
    
    // Get the results.
    if (websitesandAppsSoundsArray!= nil) {
        websitesandAppsSoundsArray = nil;
    }
    websitesandAppsSoundsArray = [[NSArray alloc] initWithArray:[self.dbManagerSoundsList loadDataFromDB:query]];
    
    self.checkFlagArray = [[NSMutableArray alloc] init];
    self.commentsArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<[websitesandAppsSoundsArray count]; i++) {
        [self.checkFlagArray addObject:[NSNumber numberWithBool:0]];
        [self.commentsArray addObject:@""];
    }
    
    // Reload the table view.
    [self.websitesandAppsSoundTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [websitesandAppsSoundsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    if([[self.checkFlagArray objectAtIndex:indexPath.row]boolValue]) {
        
        WebsitesandAppsWithCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WebsitesandAppsWithCommentsCell" forIndexPath:indexPath];
        cell.nameLabel.text = [[websitesandAppsSoundsArray objectAtIndex:indexPath.row] valueForKey:@"waName"];
        
        cell.descriptionLabel.text =[[websitesandAppsSoundsArray objectAtIndex:indexPath.row] valueForKey:@"waDetail"];
        //cell.index = indexPath.row;
        cell.commentsTextField.text = [self.commentsArray objectAtIndex:indexPath.row];
        
        cell.checkBoxButton.tag = indexPath.row;
        [cell.checkBoxButton addTarget:self action:@selector(checkBoxButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.delegate = self;
        return cell;
    }
    else
    {
        WebsitesandAppsCell *cell= [tableView dequeueReusableCellWithIdentifier:@"WebsitesandAppsCell" forIndexPath:indexPath];

        cell.nameLabel.text = [[websitesandAppsSoundsArray objectAtIndex:indexPath.row] valueForKey:@"waName"];
        
        cell.descriptionLabel.text =[[websitesandAppsSoundsArray objectAtIndex:indexPath.row] valueForKey:@"waDetail"];

        
        cell.checkBoxButton.tag = indexPath.row;
        [cell.checkBoxButton addTarget:self action:@selector(checkBoxButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }

    
    
    
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[self.checkFlagArray objectAtIndex:indexPath.row] boolValue]) {
        return 100.0f;
    }
    else
    {
        return 70.0f;
    }
}

- (void)checkBoxButtonClicked:(id)sender
{
    NSInteger index = ((UIButton *)sender).tag;
    if ([[self.checkFlagArray objectAtIndex:index]boolValue]) {
        [self.checkFlagArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:NO]];
        [self.websitesandAppsSoundTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
      //  cell.commentsTextField.text
        
             //   cell.commentsTextField.text = [[websitesandAppsSoundsArray objectAtIndex:indexPath.row] valueForKey:@"waName"];
        
    }
    else
    {
        [self.checkFlagArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:YES]];
        [self.websitesandAppsSoundTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - WebSiteCaptureCommentsDelegate

-(void)captureComments:(UITableViewCell*)cell{
    // to capture the comments
    // get the index
    WebsitesandAppsWithCommentsCell* argCell = (WebsitesandAppsWithCommentsCell*)cell;
    NSIndexPath* indexPath = [self.websitesandAppsSoundTableView indexPathForCell:cell];
    [self.commentsArray replaceObjectAtIndex:indexPath.row withObject:argCell.commentsTextField.text];
    
}

@end
