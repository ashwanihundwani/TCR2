//
//  OtherDevicesViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 3/30/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "OtherDevicesViewController.h"
#import "OtherDevicesCell.h"
#import "OtherDevicesWithCommentsCell.h"
#import "SoundActivitiesViewController.h"
#import "MBProgressHUD.h"

@interface OtherDevicesViewController ()<OtherDevicesCellDelegate, OtherDevicesWithCommentsCellDelegate>
{
    NSArray *otherDevicesSoundsArray;
    NSArray *selectCountArray;
}
@property (weak, nonatomic) IBOutlet UILabel *otherDevicesSoundDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITableView *otherDevicesSoundTableView;
@property (nonatomic, strong) DBManager *dbManagerSoundsList;

@property (nonatomic, strong) NSMutableArray *checkFlagArray;
@property (nonatomic, strong) NSMutableArray *commentsArray;
@end

@implementation OtherDevicesViewController

-(void)didTapCheckBox:(id)sender{
    
    UITableViewCell *cell = (UITableViewCell *)sender;
    
    NSIndexPath *path = [self.otherDevicesSoundTableView indexPathForCell:cell];
    
    NSInteger index = path.row;
    
    if ([[self.checkFlagArray objectAtIndex:index]boolValue]) {
        [self.checkFlagArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:NO]];
        //WebsitesandAppsCell *cell = [self.websitesandAppsSoundTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [self.otherDevicesSoundTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    else
    {
        [self.checkFlagArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:YES]];
        [self.otherDevicesSoundTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }

}

-(CGFloat)heightForIndexPath:(NSIndexPath *)indexPath
{
    CGFloat constant = 37;
    
    if ([[self.checkFlagArray objectAtIndex:indexPath.row] boolValue]) {
        constant = 87;
    }
    else
    {
        constant = 36;
        
        
    }
    
    NSString *planName = [[otherDevicesSoundsArray objectAtIndex:indexPath.row] valueForKey:@"deviceName"];
    
    CGFloat labelHeight = [Utils heightForLabelForString:planName width:238 font:TITLE_LABEL_FONT];
    
    constant += labelHeight;
    
    return constant;
    
}

-(UIView *)tableHeaderView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 15, 276, 20)
                           ];
    
    titleLabel.numberOfLines = 1000;
    
    titleLabel.backgroundColor = [UIColor clearColor];
    view.backgroundColor = [Utils colorWithHexValue:@"EFEFF4"];
    
    titleLabel.text = [NSString stringWithFormat:@"Are there other devices you own that you can use to play %@? (Example: CD player to listen to music from your own collection or to use a fan for sound.) Select and add them to your plan.",self.soundType];
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_2];
    
    titleLabel.font = pallete.secondObj;
    titleLabel.textColor = pallete.firstObj;
    
    CGFloat height = [Utils heightForLabelForString:titleLabel.text width:276 font:pallete.secondObj];
    
    titleLabel.height = height;
    
    view.height += height;
    
    [view addSubview:titleLabel];
    
    return view;
}


-(void)dismissKeyboard {
    [self.view endEditing:YES];}


-(void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.otherDevicesSoundTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.otherDevicesSoundTableView.backgroundColor = [Utils colorWithHexValue:@"EFEFF4"];
    self.otherDevicesSoundTableView.tableHeaderView = [self tableHeaderView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 320, 44)];
    
    //titleView.backgroundColor = [Utils colorWithHexValue:NAV_BAR_BLACK_COLOR];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, 44)];
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_1];
    
    titleLabel.font = pallete.secondObj;
    titleLabel.textColor = pallete.firstObj;
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //titleLabel.textColor = [UIColor colorWithHexValue:@"797979"];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = [NSString stringWithFormat:@"Add %@", self.soundType];
    
    [titleView addSubview:titleLabel];
    
    UILabel *situationLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 30
                                                                       , 200, 20)];
    
    pallete = [Utils getColorFontPair:eCFS_PALLETE_2];
    
    situationLabel.font = pallete.secondObj;
    situationLabel.textColor = pallete.firstObj;
    
    situationLabel.textAlignment = NSTextAlignmentCenter;
    
    //titleLabel.textColor = [UIColor colorWithHexValue:@"797979"];
    situationLabel.backgroundColor = [UIColor clearColor];
    situationLabel.text = @"Other Devices";
    
    [titleView addSubview:situationLabel];
    
    [self.view addSubview:titleView];
    
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 20)];
    
    backImg.image = [UIImage imageNamed:@"Active_Back-Arrow.png"];
    
    UILabel *backLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 32, 60, 20)];
    
    [backLabel addSubview:backImg];
    
    backLabel.text = @"";
    
    pallete = [Utils getColorFontPair:eCFS_PALLETE_3];
    
    backLabel.font = pallete.secondObj;
    backLabel.textColor = pallete.firstObj;
    
    [Utils addTapGestureToView:backLabel target:self
                      selector:@selector(cancelTapped)];
    
    [self.view addSubview:backLabel];
    
    
    UILabel *doneLabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 32, 60, 20)];
    
    doneLabel.textAlignment = NSTextAlignmentRight;
    
    doneLabel.text = @"Done";
    
    pallete = [Utils getColorFontPair:eCFS_PALLETE_3];
    
    doneLabel.font = pallete.secondObj;
    doneLabel.textColor = pallete.firstObj;
    
    [Utils addTapGestureToView:doneLabel target:self
                      selector:@selector(addTapped)];
    
    [self.view addSubview:doneLabel];
    
    
    
    self.otherDevicesSoundDescriptionLabel.text = [NSString stringWithFormat:@"Are there other devices you own that you can use to play %@? (Example: CD player to listen to music from your own collection or to use a fan for sound.) Select and add them to your plan.",self.soundType];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(addOtherDevices)];
    
    // Do any additional setup after loading the view.
    
    self.dbManagerSoundsList = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    
    [self.otherDevicesSoundTableView registerNib:[UINib nibWithNibName:@"OtherDevicesCell" bundle:nil] forCellReuseIdentifier:@"OtherDevicesCell"];
    
    [self.otherDevicesSoundTableView registerNib:[UINib nibWithNibName:@"OtherDevicesWithCommentsCell" bundle:nil] forCellReuseIdentifier:@"OtherDevicesWithCommentsCell"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)checkCountForSoundTypeID :(NSInteger )soundTypeID
{
    NSString *query = [NSString stringWithFormat:@"SELECT (SELECT count(*) from MySounds  where soundTypeID = %ld) + (SELECT count(*) from MyDevices  where soundTypeID = %ld) + (SELECT count(*) from MyWebsites  where soundTypeID = %ld)", (long)soundTypeID, (long)soundTypeID, (long)soundTypeID];
    
    NSArray *recordArray = [self.dbManagerSoundsList loadDataFromDB:query];
    
    return [[[(NSDictionary *)[recordArray objectAtIndex:0] allValues] objectAtIndex:0] integerValue];
    
}





-(void)addTapped
{
    NSLog(@"Comments array:%@",self.commentsArray);
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

    
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:otherDevicesSoundsArray];
    if ((countForSoundType + [filter countForObject:@"1"])<=100) {
        NSMutableString *query = [NSMutableString stringWithFormat:@"insert into MyDevices ('planID', 'groupID', 'skillID', 'soundTypeID', 'deviceID', 'comments') values "];
        
        for (int i = 0; i<[self.checkFlagArray count]; i++) {
            if ([[self.checkFlagArray objectAtIndex:i] boolValue] == 1) {
                
                [query appendFormat:@"(%ld, %ld, %ld, %ld, %ld, '%@'),",[PersistenceStorage getIntegerForKey:@"currentPlanID"], (long)[PersistenceStorage getIntegerForKey:@"currentGroupID"], [PersistenceStorage getIntegerForKey:@"currentSkillID"], soundTypeID, (long)[[[otherDevicesSoundsArray objectAtIndex:i] valueForKey:@"ID"] integerValue], [self getCommentsAtIndex:i]];
            
                 }

        }
        NSString *newQuery = [query substringToIndex:[query length]-1];
        
        
         BOOL isDone = [self.dbManagerSoundsList executeQuery:newQuery];
      
            SoundActivitiesViewController *npsv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SoundActivitiesViewController"];
        
        [self.navigationController pushViewController:npsv animated:YES];
        if (isDone)

        {
            
            
            [PersistenceStorage setObject:@"Added Using Sound Other Devices Option" andKey:@"actionTypeForResource"];
             [PersistenceStorage setObject:@"Other Devices" andKey:@"skillDetail2"];

            
            
            
            
           //  NSString *query = [NSString stringWithFormat:@"select * from Plan_Devices where soundTypeID = '%@' and ID IN (select deviceID from MyDevices where planID ='%@') ",[PersistenceStorage getObjectForKey:@"soundTypeID"],[PersistenceStorage getObjectForKey:@"currentPlanID"]];
            
            
            NSString *query = [NSString stringWithFormat:@"select * from Plan_Devices where ID IN (select deviceID from MyDevices where planID ='%@') ",[PersistenceStorage getObjectForKey:@"currentPlanID"]];
            
            
            
            NSArray *deviceArrayList = [self.dbManagerSoundsList loadDataFromDB:query];
            NSMutableString *deviceString =[NSMutableString stringWithString:@""];
          //  NSLog(@"%@",deviceArrayList);
            
            
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
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"] ];
            
            hud.mode = MBProgressHUDModeCustomView;
            
            hud.labelText = @"Added";
            
            [hud show:YES];
            [hud hide:YES afterDelay:1];
            
            
            
            NSLog(@"Success");
        }
        else{
            NSLog(@"Error");
        }
    
    
    
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tinnitus Coach" message:[NSString stringWithFormat:@"You have already added %ld sounds in this list. You cannot add more than 100 sounds.", (long)countForSoundType] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    
    [self performSelector:@selector(navigateBack) withObject:nil afterDelay:1.1];
}

-(void)navigateBack{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(NSString*)getCommentsAtIndex:(int) index{
    NSString* retString = @"";
    NSString* commentStringFromArray = [self.commentsArray objectAtIndex:index];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    NSString* commentsStringFromCell = ((OtherDevicesWithCommentsCell *)[self.otherDevicesSoundTableView cellForRowAtIndexPath:indexPath]).commentsTextField.text;
    if (commentStringFromArray.length > 0) {
        return commentStringFromArray;
    }else if (commentsStringFromCell.length > 0){
        return commentsStringFromCell;
    }else{
        return retString;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadOtherDevicesSounds];
    
}

-(void)loadOtherDevicesSounds{
  //  NSString *query = [NSString stringWithFormat:@"select * from Plan_Devices"];
    
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
    

    NSString *soundTypeIdStr = [NSString stringWithFormat:@"%d", soundTypeID];
    
    NSString *query = [NSString stringWithFormat:@"select * from Plan_Devices where soundTypeID = '%@' and ID NOT IN (select deviceID from MyDevices where planID ='%@' and soundTypeID = '%@' ) ",soundTypeIdStr,[PersistenceStorage getObjectForKey:@"currentPlanID"],soundTypeIdStr];

    
    NSLog(@"%@",query)    ;
    
    // Get the results.
    if (otherDevicesSoundsArray!= nil) {
        otherDevicesSoundsArray = nil;
    }
    otherDevicesSoundsArray = [[NSArray alloc] initWithArray:[self.dbManagerSoundsList loadDataFromDB:query]];
    
    self.checkFlagArray = [[NSMutableArray alloc] init];
    self.commentsArray =  [[NSMutableArray alloc] initWithCapacity:[otherDevicesSoundsArray count]];
    
    for (int i = 0; i<[otherDevicesSoundsArray count]; i++) {
        [self.checkFlagArray addObject:[NSNumber numberWithBool:0]];
        [self.commentsArray addObject:@""];
    }
    
    // Reload the table view.
    [self.otherDevicesSoundTableView reloadData];
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [otherDevicesSoundsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if([[self.checkFlagArray objectAtIndex:indexPath.row]boolValue]) {
        
        OtherDevicesWithCommentsCell *cell;
        if (cell == nil) {
            cell =  [tableView dequeueReusableCellWithIdentifier:@"OtherDevicesWithCommentsCell" forIndexPath:indexPath];
        }
        
        cell.nameLabel.text = [[otherDevicesSoundsArray objectAtIndex:indexPath.row] valueForKey:@"deviceName"];
        cell.commentsTextField.text = [self.commentsArray objectAtIndex:indexPath.row];
        
        cell.delegate = self;
        cell.checkDelegate = self;
        return cell;
    }
    else
    {
        OtherDevicesCell *cell;
        if (cell == nil) {
            cell =  [tableView dequeueReusableCellWithIdentifier:@"OtherDevicesCell" forIndexPath:indexPath];
        }
        
        
        cell.delegate = self;
        cell.nameLabel.text = [[otherDevicesSoundsArray objectAtIndex:indexPath.row] valueForKey:@"deviceName"];
        
        return cell;
    }
    
    
    
    
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self heightForIndexPath:indexPath];
}



- (void)checkBoxButtonClicked:(id)sender
{
    NSInteger index = ((UIButton *)sender).tag;
    if ([[self.checkFlagArray objectAtIndex:index]boolValue]) {
        [self.checkFlagArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:NO]];
        //WebsitesandAppsCell *cell = [self.websitesandAppsSoundTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [self.otherDevicesSoundTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    else
    {
        [self.checkFlagArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:YES]];
        [self.otherDevicesSoundTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
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


- (void)cancelTapped
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - AddDeviceCaptureCommentsDelegate

-(void)captureDeviceComments:(UITableViewCell*)cell{
    // to capture the comments
    // get the index
    OtherDevicesWithCommentsCell* argCell = (OtherDevicesWithCommentsCell*)cell;
    NSIndexPath* indexPath = [self.otherDevicesSoundTableView indexPathForCell:cell];
    [self.commentsArray replaceObjectAtIndex:indexPath.row withObject:argCell.commentsTextField.text];
    
}

@end
