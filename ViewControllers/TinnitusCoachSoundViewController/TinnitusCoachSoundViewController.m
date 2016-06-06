//
//  TinnitusCoachSoundViewController.m
//  TinnitusCoach
//
//
//

#import "TinnitusCoachSoundViewController.h"
#import "TinnitusCoachSoundCell.h"
#import "SoundActivitiesViewController.h"
#import "MBProgressHUD.h"



@interface TinnitusCoachSoundViewController ()<TinnitusCoachSoundCellProtocol>
{
    NSArray *tinnitusSoundsArray;
    NSInteger currentPlayingIndex;
}


@property (weak, nonatomic) IBOutlet UILabel *tinnitusCoachSoundDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITableView *tinnitusCoachSoundTableView;
@property (nonatomic, strong) DBManager *dbManagerSoundsList;

@end

@implementation TinnitusCoachSoundViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentPlayingIndex = -1;
    UINavigationBar *myBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    [self.view addSubview:myBar];
    
    
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 20)];
    
    backImg.image = [UIImage imageNamed:@"Active_Back-Arrow.png"];
    
    UILabel *backLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 32, 60, 20)];
    
    [backLabel addSubview:backImg];
    
    backLabel.text = @"";
    [Utils addTapGestureToView:backLabel target:self selector:@selector(cancelTapped)];
    
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backLabel];
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Add Tinnitus Coach Sound"];
    item.leftBarButtonItem = leftButton;
    [myBar pushNavigationItem:item animated:NO];
    self.tinnitusCoachSoundDescriptionLabel.text = [NSString stringWithFormat:@"Listen to the sounds below. They are %@ to many people. Are any of them %@ for you? Would you like to add any of these to your plan?", [self.soundType stringByReplacingOccurrencesOfString:@"Sound" withString:@""],[self.soundType stringByReplacingOccurrencesOfString:@"Sound" withString:@""]];
    
    self.dbManagerSoundsList = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    [self.tinnitusCoachSoundTableView registerNib:[UINib nibWithNibName:@"TinnitusCoachSoundCell" bundle:nil] forCellReuseIdentifier:@"TinnitusCoachSoundCell"];
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 130, 44)];
    
    titleView.backgroundColor = [Utils colorWithHexValue:NAV_BAR_BLACK_COLOR];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 130, 25)];
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_1];
    titleLabel.font = pallete.secondObj;
    titleLabel.textColor = pallete.firstObj;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    NSString *tinnitusCoachTitle = [NSString stringWithFormat:@"Add %@" , self.soundType];
    titleLabel.text = tinnitusCoachTitle;
    UILabel *situationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, 130, 14)];
    pallete = [Utils getColorFontPair:eCFS_PALLETE_2];
    situationLabel.font = pallete.secondObj;
    situationLabel.textColor = pallete.firstObj;
    situationLabel.textAlignment = NSTextAlignmentCenter;
    situationLabel.backgroundColor = [UIColor clearColor];
    situationLabel.text = @"Tinnitus Coach Sounds";
    [titleView addSubview:titleLabel];
    [titleView addSubview:situationLabel];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    self.navigationItem.titleView = titleView;
    pallete = [Utils getColorFontPair:eCFS_PALLETE_3];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadTinnitusSounds];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
    
    [self loadTinnitusSounds];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [self.audioPlayer stop];
    [self.tabBarController.tabBar setHidden:NO];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.audioPlayer stop];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // [audioPlayer stop];
    
}



-(void)loadTinnitusSounds{
    NSString *query = [NSString stringWithFormat:@"select * from Plan_Sound_List where soundTypeID IN (select ID from Plan_Sound_Types where soundTypeName = '%@') and  ID NOT IN (select soundID from MySounds where planID==%@) ", self.soundType,[PersistenceStorage getObjectForKey:@"currentPlanID"]];
    
    // Get the results.
    if (tinnitusSoundsArray!= nil) {
        tinnitusSoundsArray = nil;
    }
    tinnitusSoundsArray = [[NSArray alloc] initWithArray:[self.dbManagerSoundsList loadDataFromDB:query]];
    // Reload the table view.
    [self.tinnitusCoachSoundTableView reloadData];
}


-(NSInteger)checkCountForSoundTypeID :(NSInteger )soundTypeID
{
    NSString *query = [NSString stringWithFormat:@"SELECT (SELECT count(*) from MySounds  where soundTypeID = %ld) + (SELECT count(*) from MyDevices  where soundTypeID = %ld) + (SELECT count(*) from MyWebsites  where soundTypeID = %ld)", (long)soundTypeID, (long)soundTypeID, (long)soundTypeID];
    
    NSArray *recordArray = [self.dbManagerSoundsList loadDataFromDB:query];
    
    return [[[recordArray objectAtIndex:0] valueForKey:query]integerValue];
    
}


-(void)writeToMySounds:(NSString *)soundID type:(NSString*)soundTypeID
{
    NSInteger countForSoundType = [self checkCountForSoundTypeID:[soundTypeID integerValue]];
    
    if (countForSoundType < 1000) {
        NSString *query = [NSString stringWithFormat:@"insert into MySounds ('planID', 'groupID', 'skillID', 'soundTypeID', 'soundID') values (%ld, %ld, %ld, %ld, %ld)",(long)[PersistenceStorage getIntegerForKey:@"currentPlanID"], (long)[PersistenceStorage getIntegerForKey:@"currentGroupID"], (long)[PersistenceStorage getIntegerForKey:@"currentSkillID"], (long)[soundTypeID integerValue], (long)[soundID integerValue]];
        BOOL isDone = [self.dbManagerSoundsList executeQuery:query];
        if (isDone == YES)
        {
            NSLog(@"Success");
        }
        else{
            NSLog(@"Error");
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tinnitus Coach" message:@"You have reached the limit. You cannot add more than 1000 sounds." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tinnitusSoundsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TinnitusCoachSoundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TinnitusCoachSoundCell" forIndexPath:indexPath];
    [cell resetView];
    cell.delegate = self;
    cell.soundURL = [[tinnitusSoundsArray objectAtIndex:indexPath.row] valueForKey:@"soundURL"];
    
    cell.songTitleLabel.text =[[tinnitusSoundsArray objectAtIndex:indexPath.row] valueForKey:@"soundName"];
    
    [cell.addToPlanButton addTarget:self action:@selector(addToPlanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if(currentPlayingIndex == indexPath.row){
        cell.audioPlayer = self.audioPlayer;
        [cell.player play];
        if ([self.audioPlayer isPlaying]) {
            cell.playPauseButton.selected = YES;
        }
    }
    
    cell.addToPlanButton.tag = indexPath.row;
    return cell;
    
    
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88.0f;
}


-(void)cancelTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)addToPlanButtonClicked:(id)sender
{
    NSInteger index = ((UIButton *)sender).tag;
    [self writeToMySounds:[[tinnitusSoundsArray objectAtIndex:index] valueForKey:@"ID"] type:[[tinnitusSoundsArray objectAtIndex:index] valueForKey:@"soundTypeID"]];
    
    [self performSelector:@selector(navigateBack) withObject:nil afterDelay:1.1];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"] ];
    
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.labelText = @"Added";
    
    [hud show:YES];
    [hud hide:YES afterDelay:1];
}

-(void)navigateBack{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)playFile:(NSString*)filePath{
    NSString *path = [[NSBundle mainBundle]pathForResource:filePath ofType:nil];
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:path] error:NULL];
    [self.audioPlayer play];
}

-(void)pausePlay{
    [self.audioPlayer pause];
}

-(void)stopPlay{
    [self.audioPlayer stop];
}


-(void)resumePlay{
    [self.audioPlayer play];
}

#pragma mark - TinnitusCoachCell Delegates

-(void)didSelectPlayPauseButton:(id)cell
{
    TinnitusCoachSoundCell* argCell = (TinnitusCoachSoundCell*)cell;
    if (currentPlayingIndex == -1){
        [self playFile:argCell.soundURL];
        argCell.audioPlayer = self.audioPlayer;
        [[argCell player] play];
        argCell.playPauseButton.selected = YES;
        
        
    }
    else
    {
        TinnitusCoachSoundCell* selectedCell = (TinnitusCoachSoundCell*)[self.tinnitusCoachSoundTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentPlayingIndex inSection:0]];
        if (![selectedCell.soundURL isEqualToString:[argCell soundURL]]) {
            [selectedCell resetView];
            selectedCell.audioPlayer = nil;
            [self.audioPlayer stop];
            [selectedCell playPauseButton].selected = NO;
            [self playFile:argCell.soundURL];
            argCell.audioPlayer = self.audioPlayer;
            [[argCell player]  play];
            [argCell playPauseButton].selected = YES;
            
        }
        else
        {
            if([self.audioPlayer isPlaying]) // Shows the Pause symbol
            {
                [argCell playPauseButton].selected = NO;
                [[argCell player] pause];
                [self pausePlay];
                
            }
            else    // Shows the Play symbol
            {
                [argCell playPauseButton].selected = YES;
                [self resumePlay];
                [[argCell player] play];
                
            }
            
        }
    }    
    currentPlayingIndex = argCell.addToPlanButton.tag;
    
}




@end
