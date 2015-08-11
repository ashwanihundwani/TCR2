//
//  SoundActivitiesViewController.m
//  TinnitusCoach
//
// //

#import "NewPlanAddedViewController.h"
#import "AudioPlayerOneViewController.h"
#import "AudioPlayerTwoViewController.h"
#import "NookUS.h"
#import "AudioPlayerThreeViewController.h"
#import "SoundActivitiesViewController.h"
#import "SoundsCategoryViewController.h"
#import "AudioPanningViewController.h"
#import "SoundTypeView.h"
#import "NookUS.h"
#import "SoundIntroDetailViewController.h"
#import "RatingsViewController.h"
#import "SkillRatingsViewController.h"

#import "MBProgressHUD.h"



@interface SoundActivitiesViewController ()<SoundTypeViewProtocol>
{
    NSMutableArray *mySoothingSoundsArray, *myInterestingSoundsArray, *myBackGroundSoundsArray;
    NSDictionary *otherDevicesPopupMessageDict;
    NSArray *mySoundsArray;
    NSArray *finalSoundsArray;
    
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightParameter;
@property (nonatomic, strong) SoundTypeView *soothingSoundView;
@property (nonatomic, strong) SoundTypeView *interestingSoundView;
@property (nonatomic, strong) SoundTypeView *backgroundSoundView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) DBManager *dbManagerMySounds;
@property (nonatomic) BOOL isViewLoaded;
@end

@implementation SoundActivitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isViewLoaded = YES;
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 170, 44)];
    
    titleView.backgroundColor = [Utils colorWithHexValue:NAV_BAR_BLACK_COLOR];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 170, 25)];
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_1];
    
    titleLabel.font = pallete.secondObj;
    titleLabel.textColor = pallete.firstObj;
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //titleLabel.textColor = [UIColor colorWithHexValue:@"797979"];
    titleLabel.backgroundColor = [UIColor clearColor];
    // titleLabel.text = @"Add New Plan";
    
    
    titleLabel.adjustsFontSizeToFitWidth=YES;
    titleLabel.minimumScaleFactor=0.5;
    
    
    titleLabel.text= [NSString stringWithFormat:@"Plan for %@ ",[PersistenceStorage getObjectForKey:@"planName"]];
    
    UILabel *situationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 23, 170, 19)];
    
    pallete = [Utils getColorFontPair:eCFS_PALLETE_2];
    
    situationLabel.font = pallete.secondObj;
    situationLabel.textColor = pallete.firstObj;
    
    situationLabel.textAlignment = NSTextAlignmentCenter;
    
    //titleLabel.textColor = [UIColor colorWithHexValue:@"797979"];
    situationLabel.backgroundColor = [UIColor clearColor];
    situationLabel.text = [PersistenceStorage getObjectForKey:@"skillName"];//@"Your Situation";
    
    [titleView addSubview:titleLabel];
    [titleView addSubview:situationLabel];
    
    self.navigationItem.titleView = titleView;

    self.dbManagerMySounds = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
   
    [self prepareOtherDevicesPopupMessageDict];
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"%@",[PersistenceStorage getObjectForKey:@"mediaURL"]);
    [self finalSoundArray];

}




-(void)finalSoundArray
{
    NSString *query = [NSString stringWithFormat: @"select ID, soundName from Plan_Sound_List where soundTypeID = 1 AND ID IN(select soundID from MySounds where planID= %@)" ,[PersistenceStorage getObjectForKey:@"currentPlanID"]];
    
    NSMutableArray *fSoundsArray = [[NSMutableArray alloc] initWithArray:[self.dbManagerMySounds loadDataFromDB:query]];
    
    
    
    
    query = [NSString stringWithFormat: @"select deviceName,deviceID, comments from MyDevices Inner JOIN Plan_Devices on MyDevices.deviceID = Plan_Devices.ID where myDevices.soundTypeID = 1 and planID = %@",[PersistenceStorage getObjectForKey:@"currentPlanID"]];
    [fSoundsArray addObjectsFromArray:[self.dbManagerMySounds loadDataFromDB:query]];
    
    //  NSLog(@"hhh%@",query);
    
    
    query = [NSString stringWithFormat: @"select waName , waDetail,websiteID, comments,MyWebsites.URL from MyWebsites Inner JOIN Plan_Website_Apps on MyWebsites.websiteId = Plan_Website_Apps.ID where MyWebsites.soundTypeID = 1 and planID = %@",[PersistenceStorage getObjectForKey:@"currentPlanID"]];
    
    [fSoundsArray addObjectsFromArray:[self.dbManagerMySounds loadDataFromDB:query]];
    
    
    query = [NSString stringWithFormat: @"select * from MyOwnSounds where soundTypeID = 1 and planID = %@",[PersistenceStorage getObjectForKey:@"currentPlanID"]];
    
    [fSoundsArray addObjectsFromArray:[self.dbManagerMySounds loadDataFromDB:query]];
    
    
    
    
    
    
    
    
    
    
   query = [NSString stringWithFormat: @"select ID, soundName from Plan_Sound_List where soundTypeID = 2 AND ID IN(select soundID from MySounds where planID= %@)" ,[PersistenceStorage getObjectForKey:@"currentPlanID"]];
    
    [fSoundsArray addObjectsFromArray:[self.dbManagerMySounds loadDataFromDB:query]];
    
    
    
    
    query = [NSString stringWithFormat: @"select deviceName,deviceID, comments from MyDevices Inner JOIN Plan_Devices on MyDevices.deviceID = Plan_Devices.ID where myDevices.soundTypeID = 2 and planID = %@",[PersistenceStorage getObjectForKey:@"currentPlanID"]];
    [fSoundsArray addObjectsFromArray:[self.dbManagerMySounds loadDataFromDB:query]];
    
    //  NSLog(@"hhh%@",query);
    
    
    query = [NSString stringWithFormat: @"select waName , waDetail,websiteID, comments,MyWebsites.URL from MyWebsites Inner JOIN Plan_Website_Apps on MyWebsites.websiteId = Plan_Website_Apps.ID where MyWebsites.soundTypeID = 2 and planID = %@",[PersistenceStorage getObjectForKey:@"currentPlanID"]];
    
    [fSoundsArray addObjectsFromArray:[self.dbManagerMySounds loadDataFromDB:query]];
    
    
    query = [NSString stringWithFormat: @"select * from MyOwnSounds where soundTypeID = 2 and planID = %@",[PersistenceStorage getObjectForKey:@"currentPlanID"]];
    
    [fSoundsArray addObjectsFromArray:[self.dbManagerMySounds loadDataFromDB:query]];
    
    
    
    
    
    
    query  = [NSString stringWithFormat: @"select ID, soundName from Plan_Sound_List where soundTypeID = 3 AND ID IN(select soundID from MySounds where planID= %@)" ,[PersistenceStorage getObjectForKey:@"currentPlanID"]];
    
    [fSoundsArray addObjectsFromArray:[self.dbManagerMySounds loadDataFromDB:query]];
    
    
    
    
    query = [NSString stringWithFormat: @"select deviceName,deviceID, comments from MyDevices Inner JOIN Plan_Devices on MyDevices.deviceID = Plan_Devices.ID where myDevices.soundTypeID = 3 and planID = %@",[PersistenceStorage getObjectForKey:@"currentPlanID"]];
    [fSoundsArray addObjectsFromArray:[self.dbManagerMySounds loadDataFromDB:query]];
    
    //  NSLog(@"hhh%@",query);
    
    
    query = [NSString stringWithFormat: @"select waName , waDetail,websiteID, comments,MyWebsites.URL from MyWebsites Inner JOIN Plan_Website_Apps on MyWebsites.websiteId = Plan_Website_Apps.ID where MyWebsites.soundTypeID = 3 and planID = %@",[PersistenceStorage getObjectForKey:@"currentPlanID"]];
    
    [fSoundsArray addObjectsFromArray:[self.dbManagerMySounds loadDataFromDB:query]];
    
    
    query = [NSString stringWithFormat: @"select * from MyOwnSounds where soundTypeID = 3 and planID = %@",[PersistenceStorage getObjectForKey:@"currentPlanID"]];
    
    [fSoundsArray addObjectsFromArray:[self.dbManagerMySounds loadDataFromDB:query]];
    

    
    
    
    
    
    //    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:mySoundsArray];
    // NSArray *arrayWithoutDuplicates = [orderedSet array];
    
    NSLog(@"FIINALL  SOUND ARRAY %@",fSoundsArray);
    finalSoundsArray = fSoundsArray;
    
}










-(NSArray *)loadMySounds:(NSInteger)typeID
{
    NSString *query = [NSString stringWithFormat: @"select * from MySounds where soundTypeID = %ld  and planID = %@", (long)typeID, [PersistenceStorage getObjectForKey:@"currentPlanID"]];
    
     mySoundsArray = [[NSArray alloc] initWithArray:[self.dbManagerMySounds loadDataFromDB:query]];
    return mySoundsArray;
    // Reload the table view.
}

-(NSDictionary *)getSoundDetailForTypeID:(NSInteger)typeID andSoundID:(NSInteger)soundID
{
   // NSString *query = [NSString stringWithFormat: @"select * from Plan_Sound_List where soundTypeID = %ld", (long)typeID];
    
    
    NSString *query = [NSString stringWithFormat: @"select * from Plan_Sound_List where soundTypeID = %ld", (long)typeID];
    
    
    
     mySoundsArray = [[NSArray alloc] initWithArray:[self.dbManagerMySounds loadDataFromDB:query]];
    
    return [mySoundsArray objectAtIndex:0];
}

-(void)createMySoundsView:(NSArray *)sounds
{
    
    
    
    
    
}


-(IBAction)playAud:(id)sender{
    AudioPlayerThreeViewController *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AudioPlayerThreeViewController"];
    [self.navigationController presentModalViewController:siv animated:YES];
    
}



-(IBAction)learnMoreClicked:(id)sender{
    NookUS *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookUS"];
    [self.navigationController pushViewController:siv animated:YES];
    
}




-(IBAction)viewIntroductionAgainClicked:(id)sender{
  
    [self writeViewedIntroduction ];
    SoundIntroDetailViewController *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SoundIntroDetailViewController"];
    [self.navigationController pushViewController:siv animated:YES];
    
}

-(NSArray*)loadMyDevices:(NSInteger)typeID
{
    
    
    NSString *query = [NSString stringWithFormat: @"select planID,groupID,skillID,deviceID,Mydevices.soundTypeID,comments,Plan_Devices.DeviceName from MyDevices left outer join   Plan_Devices on Plan_Devices.ID=MyDevices.DeviceID where MyDevices.soundTypeID = %ld  and planID = %@  " , (long)typeID, [PersistenceStorage getObjectForKey:@"currentPlanID"]];

    
    
     
    
    
    
//    NSString *query = [NSString stringWithFormat: @"select * from MyDevices  where soundTypeID = %ld  and planID = %@", (long)typeID, [PersistenceStorage getObjectForKey:@"currentPlanID"]];
    NSArray *myDevicesArray = [[NSArray alloc] initWithArray:[self.dbManagerMySounds loadDataFromDB:query]];
  
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:myDevicesArray];
    NSArray *arrayWithoutDuplicates = [orderedSet array];
    
    
     return arrayWithoutDuplicates;
}

-(NSArray*)loadMyWebsitesAndApps:(NSInteger)typeID
{
    NSString *query = [NSString stringWithFormat: @"select * from MyWebsites  where soundTypeID = %ld and planID = %@", (long)typeID, [PersistenceStorage getObjectForKey:@"currentPlanID"]];
    // Get the results.
    NSArray *myWebsitesArray = [[NSArray alloc] initWithArray:[self.dbManagerMySounds loadDataFromDB:query]];
    
       return myWebsitesArray;
}


-(NSArray*)loadMyOwnSounds:(NSInteger)typeID
{
    NSString *query = [NSString stringWithFormat: @"select * from MyOwnSounds where soundTypeID = %ld and planID = %@", (long)typeID, [PersistenceStorage getObjectForKey:@"currentPlanID"]];
    // Get the results.
    NSArray *myOwnSoundsArray = [[NSArray alloc] initWithArray:[self.dbManagerMySounds loadDataFromDB:query]];
    
    return myOwnSoundsArray;
}


-(void)sayHello:(NSNotification*)notification {

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"] ];
    
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.labelText = @"Removed";
    
    [hud show:YES];
    [hud hide:YES afterDelay:1];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [self setUpSubViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sayHello:) name:@"sayHelloNotification" object:nil];
    
//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sayHello:) name:@"sayHelloNotification"; object:nil];
    
    //// To chech for the feedback modal
    if ([[PersistenceStorage getObjectForKey:@"Referer"] isEqual: @"AudioPlayerOneViewController"]) {
        SkillRatingsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"SkillRatingsViewController"];
        
        //ratingsView.skillSection = @"Sounds";
        //  ratingsView.skillDetail = self.name;
        
        
         
        
        
        //[self.navigationController pushViewController:ratingsView animated:YES];
        [self.navigationController presentModalViewController:ratingsView animated:YES];
    }
    
    
    if ([[PersistenceStorage getObjectForKey:@"Referer"] isEqual: @"AudioPlayerThreeViewController"]) {
        RatingsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"RatingsViewController"];
        
        //ratingsView.skillSection = @"Sounds";
        //  ratingsView.skillDetail = self.name;
        
        //[self.navigationController pushViewController:ratingsView animated:YES];
        [self.navigationController presentModalViewController:ratingsView animated:YES];
    }

    
    
    if ([[PersistenceStorage getObjectForKey:@"Referer"] isEqual: @"SamplerVideoVC"]) {
        RatingsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"RatingsViewController"];
        
        //ratingsView.skillSection = @"Sounds";
        //  ratingsView.skillDetail = self.name;
        
        //[self.navigationController pushViewController:ratingsView animated:YES];
        [self.navigationController presentModalViewController:ratingsView animated:YES];
    }
    
    
    
    
    
    if ([[PersistenceStorage getObjectForKey:@"Referer"] isEqual: @"SkillRatingsViewController"] ||
        [[PersistenceStorage getObjectForKey:@"Referer"] isEqual: @"RatingsVC"]) {
        
        
        /* MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"] ];
         
         hud.mode = MBProgressHUDModeCustomView;
         
         hud.labelText = @"Feedback Received";
         
         [hud show:YES];
         [hud hide:YES afterDelay:1.5];
         
         */
        
        
        
        
        NSString *actionSheetTitle = @"Where would you like to go now?"; //Action Sheet Title
        NSString *other0 = @"Repeat This Skill"; //Action Sheet Button Titles
        NSString *other1 = @"Learn About This Skill";
        NSString *other2 = @"Try Another Skill";
        NSString *other3 = @"Return Home";
        //   NSString *other4 = @"Return Home";
        NSString *cancelTitle = @"Cancel";
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:actionSheetTitle
                                      delegate:self
                                      cancelButtonTitle:nil
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:other0, other1, other2, other3, nil];
        
        [actionSheet showInView:self.view];
        
        
        
        
        [PersistenceStorage setObject:@"OK" andKey:@"Referer"];
        
        
    }
    
    
    
    
    
    
    
    
    
    
}


-(void)viewDidDisappear:(BOOL)animated{
    if(self.soothingSoundView)
        [self.soothingSoundView removeFromSuperview];
    if(self.interestingSoundView)
        [self.interestingSoundView removeFromSuperview];
    if(self.backgroundSoundView)
        [self.backgroundSoundView removeFromSuperview];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    //   NSString * theValue = [(UILabel*)[self viewWithTag:t200] text];
    
    
    
    
    if  ([buttonTitle isEqualToString:@"Repeat This Skill"]) {
        
        [PersistenceStorage setObject:buttonTitle andKey:@"optionName"];
        [PersistenceStorage setObject:nil andKey:@"skillDetail1"];
        
        
        
        
        [self writeClickedNextSteps];

        
        
        
    }
    if ([buttonTitle isEqualToString:@"Learn About This Skill"]) {
        
        [PersistenceStorage setObject:buttonTitle andKey:@"optionName"];
        [PersistenceStorage setObject:nil andKey:@"skillDetail1"];
        [self writeClickedNextSteps];

        NookUS *samplerView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookUS"];
        [self.navigationController pushViewController:samplerView animated:NO];
    }
    
    
    if ([buttonTitle isEqualToString:@"Try Another Skill"]) {
        
        [PersistenceStorage setObject:buttonTitle andKey:@"optionName"];
        [PersistenceStorage setObject:nil andKey:@"skillDetail1"];
        [self writeClickedNextSteps];

        NewPlanAddedViewController *samplerView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NewPlanAddedViewController"];
        [self.navigationController pushViewController:samplerView animated:YES];

    }
    
    if ([buttonTitle isEqualToString:@"Return Home"]) {

        [PersistenceStorage setObject:buttonTitle andKey:@"optionName"];
        [PersistenceStorage setObject:nil andKey:@"skillDetail1"];
        [self writeClickedNextSteps];

        [[self tabBarController] setSelectedIndex:0];
        
    }
    
    
    
    
    
    
}



-(void)setUpSubViews
{
    mySoothingSoundsArray = [[NSMutableArray alloc] init];
    [mySoothingSoundsArray addObjectsFromArray:[self loadMySounds:1]];
    [mySoothingSoundsArray addObjectsFromArray:[self loadMyDevices:1]];
    [mySoothingSoundsArray addObjectsFromArray:[self loadMyWebsitesAndApps:1]];
    [mySoothingSoundsArray addObjectsFromArray:[self loadMyOwnSounds:1]];
    
    //NSLog(@"%@",mySoothingSoundsArray);
    if(YES){//self.soothingSoundView != nil || self.isViewLoaded){
    self.soothingSoundView = [[SoundTypeView alloc] initWithFrame:CGRectMake(0, 490.0, self.view.frame.size.width, 216) andData:mySoothingSoundsArray];
    }else{
        
        [self.soothingSoundView reInitializeUIWithFrame:CGRectMake(0, 490.0, self.view.frame.size.width, 216) andData:mySoothingSoundsArray];

    }
    self.soothingSoundView.delegate = self;
    self.soothingSoundView.soundTitleLabel.text = @"Soothing Sound";
    self.soothingSoundView.soundDescriptionLabel.text = @"This type of sound makes you feel better as soon as you hear it.";
    
    self.soothingSoundView.exploreAndAddButton.tag = 1;
    [self.soothingSoundView.exploreAndAddButton addTarget:self action:@selector(addSoundsClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    myInterestingSoundsArray = [[NSMutableArray alloc] init];
    [myInterestingSoundsArray addObjectsFromArray:[self loadMySounds:2]];
    [myInterestingSoundsArray addObjectsFromArray:[self loadMyDevices:2]];
    [myInterestingSoundsArray addObjectsFromArray:[self loadMyWebsitesAndApps:2]];
    [myInterestingSoundsArray addObjectsFromArray:[self loadMyOwnSounds:2]];
  //  NSLog(@"%@",myInterestingSoundsArray);
    if(YES){//self.interestingSoundView != nil || self.isViewLoaded){
    self.interestingSoundView = [[SoundTypeView alloc] initWithFrame:CGRectMake(0.0, self.soothingSoundView.frame.origin.y + self.soothingSoundView.frame.size.height +8, self.view.frame.size.width, 216) andData:myInterestingSoundsArray];
    } else{
        [self.interestingSoundView reInitializeUIWithFrame:CGRectMake(0.0, self.soothingSoundView.frame.origin.y + self.soothingSoundView.frame.size.height +8, self.view.frame.size.width, 216) andData:myInterestingSoundsArray];
    }
    self.interestingSoundView.delegate = self;
    self.interestingSoundView.soundTitleLabel.text = @"Interesting Sound";
    self.interestingSoundView.soundDescriptionLabel.text = @"An Interesting Sound attracts your attention. It helps shift your attention away from your tinnitus.";
    
    self.interestingSoundView.exploreAndAddButton.tag = 2;
    [self.interestingSoundView.exploreAndAddButton addTarget:self action:@selector(addSoundsClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    myBackGroundSoundsArray = [[NSMutableArray alloc] init];
    [myBackGroundSoundsArray addObjectsFromArray:[self loadMySounds:3]];
    [myBackGroundSoundsArray addObjectsFromArray:[self loadMyDevices:3]];
    [myBackGroundSoundsArray addObjectsFromArray:[self loadMyWebsitesAndApps:3]];
    [myBackGroundSoundsArray addObjectsFromArray:[self loadMyOwnSounds:3]];
    
   // NSLog(@"BACKGROUND %@",myBackGroundSoundsArray);
    if(YES)//self.backgroundSoundView != nil || self.isViewLoaded)
        self.backgroundSoundView = [[SoundTypeView alloc] initWithFrame:CGRectMake(00.0, self.interestingSoundView.frame.origin.y + self.interestingSoundView.frame.size.height +8, self.view.frame.size.width, 216) andData:myBackGroundSoundsArray];
    else
        [self.backgroundSoundView reInitializeUIWithFrame:CGRectMake(00.0, self.interestingSoundView.frame.origin.y + self.interestingSoundView.frame.size.height +8, self.view.frame.size.width, 216) andData:myBackGroundSoundsArray];
    self.backgroundSoundView.delegate = self;
    self.backgroundSoundView.soundTitleLabel.text = @"Background Sound";
    self.backgroundSoundView.soundDescriptionLabel.text = @"Most people notice their tinnitus more when they are in a quiet place. You are less likely to notice your tinnitus if you add a Background Sound.";
    
    self.backgroundSoundView.exploreAndAddButton.tag =3;
    [self.backgroundSoundView.exploreAndAddButton addTarget:self action:@selector(addSoundsClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:self.soothingSoundView];
    [self.scrollView addSubview:self.interestingSoundView];
    [self.scrollView addSubview:self.backgroundSoundView];
    
    
    //[self.scrollView setNeedsUpdateConstraints];
    [self.scrollView setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.backgroundSoundView.frame.size.height + self.backgroundSoundView.frame.origin.y -100)];

    self.isViewLoaded = NO;

}






-(void)layoutSubviews
{
    mySoothingSoundsArray = [[NSMutableArray alloc] init];
    [mySoothingSoundsArray addObjectsFromArray:[self loadMySounds:1]];
    [mySoothingSoundsArray addObjectsFromArray:[self loadMyDevices:1]];
    [mySoothingSoundsArray addObjectsFromArray:[self loadMyWebsitesAndApps:1]];
    [mySoothingSoundsArray addObjectsFromArray:[self loadMyOwnSounds:1]];

    self.soothingSoundView = [[SoundTypeView alloc] initWithFrame:CGRectMake(10.0, 490.0, self.view.frame.size.width-20, 216) andData:mySoothingSoundsArray];
    self.soothingSoundView.delegate = self;
    self.soothingSoundView.soundTitleLabel.text = @"Soothing Sound";
    self.soothingSoundView.soundDescriptionLabel.text = @"This type of sound makes you feel better as soon as you hear it.";
    
    self.soothingSoundView.exploreAndAddButton.tag = 1;
    [self.soothingSoundView.exploreAndAddButton addTarget:self action:@selector(addSoundsClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    myInterestingSoundsArray = [[NSMutableArray alloc] init];
    [myInterestingSoundsArray addObjectsFromArray:[self loadMySounds:2]];
    [myInterestingSoundsArray addObjectsFromArray:[self loadMyDevices:2]];
    [myInterestingSoundsArray addObjectsFromArray:[self loadMyWebsitesAndApps:2]];
    [myInterestingSoundsArray addObjectsFromArray:[self loadMyOwnSounds:2]];

    
    self.interestingSoundView = [[SoundTypeView alloc] initWithFrame:CGRectMake(10.0, self.soothingSoundView.frame.origin.y + self.soothingSoundView.frame.size.height +8, self.view.frame.size.width-20, 216) andData:myInterestingSoundsArray];
    self.interestingSoundView.delegate = self;
    self.interestingSoundView.soundTitleLabel.text = @"Interesting Sound";
    self.interestingSoundView.soundDescriptionLabel.text = @"An Interesting Sound attracts your attention. It helps shift your attention away from your tinnitus.";
    
    self.interestingSoundView.exploreAndAddButton.tag = 2;
    [self.interestingSoundView.exploreAndAddButton addTarget:self action:@selector(addSoundsClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    myBackGroundSoundsArray = [[NSMutableArray alloc] init];
    [myBackGroundSoundsArray addObjectsFromArray:[self loadMySounds:3]];
    [myBackGroundSoundsArray addObjectsFromArray:[self loadMyDevices:3]];
    [myBackGroundSoundsArray addObjectsFromArray:[self loadMyWebsitesAndApps:3]];
    [myBackGroundSoundsArray addObjectsFromArray:[self loadMyOwnSounds:3]];

    
    self.backgroundSoundView = [[SoundTypeView alloc] initWithFrame:CGRectMake(10.0, self.interestingSoundView.frame.origin.y + self.interestingSoundView.frame.size.height +8, self.view.frame.size.width-20, 216) andData:myBackGroundSoundsArray];
    self.backgroundSoundView.delegate = self;
    self.backgroundSoundView.soundTitleLabel.text = @"Background Sound";
    self.backgroundSoundView.soundDescriptionLabel.text = @"Most people notice their tinnitus more when they are in a quiet place. You are less likely to notice your tinnitus if you add a Background Sound.";
    
    self.backgroundSoundView.exploreAndAddButton.tag =3;
    [self.backgroundSoundView.exploreAndAddButton addTarget:self action:@selector(addSoundsClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.scrollView addSubview:self.soothingSoundView];
    [self.scrollView addSubview:self.interestingSoundView];
    [self.scrollView addSubview:self.backgroundSoundView];
    
    
    //[self.scrollView setNeedsUpdateConstraints];
    [self.scrollView setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.backgroundSoundView.frame.size.height + self.backgroundSoundView.frame.origin.y-100)];
}

- (void)addSoundsClicked:(id)sender{
    if (((UIButton *)sender).tag == 1) {
        SoundsCategoryViewController *scv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SoundsCategoryViewController"];
        scv.soundType = @"Soothing Sound";
        [PersistenceStorage setObject:@"1" andKey:@"soundTypeID"];

        
        [self.navigationController pushViewController:scv animated:YES];
    }
    else if (((UIButton *)sender).tag == 2) {
        SoundsCategoryViewController *scv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SoundsCategoryViewController"];
        scv.soundType = @"Interesting Sound";
        [PersistenceStorage setObject:@"2" andKey:@"soundTypeID"];

        
        [self.navigationController pushViewController:scv animated:YES];
    }
    else  if (((UIButton *)sender).tag == 3){
        SoundsCategoryViewController *scv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SoundsCategoryViewController"];
        scv.soundType = @"Background Sound";
        [PersistenceStorage setObject:@"1" andKey:@"soundTypeID"];

        [self.navigationController pushViewController:scv animated:YES];
    }
}




-(void)onDelete
{
     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"] ];
    
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.labelText = @"Removed";
    
    [hud show:YES];
    [hud hide:YES afterDelay:1];

}



-(void)tableViewCellClicked:(NSDictionary *)soundDict //(NSDictionary *)soundDict
{
    
   // NSDictionary *soundDict = [finalSoundsArray objectAtIndex:rowNum];
    
    // NSLog(@"ROWNUM DICCT %d",rowNum);
    
     if ([soundDict valueForKey:@"deviceID"] != nil) {
         
         
         NSString *description = [otherDevicesPopupMessageDict objectForKey:[soundDict valueForKey:@"deviceName"]];
         
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[soundDict valueForKey:@"deviceName"] message:description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         
         [alert show];
         
         
         NSLog(@"%@",soundDict);
         
         
         
         if ([[soundDict valueForKey:@"soundTypeID"] isEqualToString:@"1"])
             
         {
             [PersistenceStorage setObject:@"Soothing Sound" andKey:@"skillDetail1"];
             [PersistenceStorage setObject:@"1" andKey:@"soundTypeID"];
             
         }
         
         if ([[soundDict valueForKey:@"soundTypeID"] isEqualToString:@"2"])
             
         {
             [PersistenceStorage setObject:@"Interesting Sound" andKey:@"skillDetail1"];
             [PersistenceStorage setObject:@"2" andKey:@"soundTypeID"];
             
         }
         
         if ([[soundDict valueForKey:@"soundTypeID"] isEqualToString:@"3"])
             
         {
             [PersistenceStorage setObject:@"Background Sound" andKey:@"skillDetail1"];
             [PersistenceStorage setObject:@"3" andKey:@"soundTypeID"];

             
         }
         

         
         NSString *query = [NSString stringWithFormat:@"select * from Plan_Devices where soundTypeID = '%@' and ID IN (select deviceID from MyDevices where planID ='%@') ",[PersistenceStorage getObjectForKey:@"soundTypeID"],[PersistenceStorage getObjectForKey:@"currentPlanID"]];
         
         // NSString *myTFQuery = @"select * from MyDevices where thoughtCategory='step3'";
         
         NSArray *deviceArrayList = [self.dbManagerMySounds loadDataFromDB:query];
         NSMutableString *deviceString =[NSMutableString stringWithString:@""];
         NSLog(@"DDDDDDDDDDD %@",deviceArrayList);
         
         
         for(int i= 0 ;i<[deviceArrayList count];i++)
         {
             
             
             [deviceString appendString:[[deviceArrayList objectAtIndex:i] valueForKey:@"deviceName"]];
             [deviceString appendString:@"|"];
             
             
         }
         
         if ([deviceString length] > 0) {
             NSString *outPut = deviceString;
             outPut = [outPut substringToIndex:[outPut length] - 2];
             NSLog(@"%@",outPut);
             [PersistenceStorage setObject:outPut andKey:@"skillDetail3"];
             
             
         }
         
         
         
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
             NSString *str = @"Viewed Info";
             
             NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"situationName"],[PersistenceStorage getObjectForKey:@"skillName"],[PersistenceStorage getObjectForKey:@"skillDetail1"],@"Other Devices",[soundDict valueForKey:@"deviceName"],[soundDict valueForKey:@"skillDetail3"],nil,nil,nil,nil];
             
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
    else if ([soundDict valueForKey:@"websiteID"] != nil)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[soundDict valueForKey:@"URL"]]];
    }
    
    else if ([soundDict valueForKey:@"MyOwnSoundID"] != nil && [soundDict valueForKey:@"URL"] !=nil)
    {
        
       [PersistenceStorage setObject:[soundDict valueForKey:@"URL"] andKey:@"mediaURL" ];
        [self playAud:nil];
  }
    
    
    else //if ([soundDict valueForKey:@"soundName"] != nil)
    {
        
        
    //    NSLog(@"SOUNDID %d",[soundDict valueForKey:@"ID"] );

     //   [PersistenceStorage setObject:[soundDict valueForKey:@"soundName"] andKey:@"soundName" ];
        
        
        
        
     //   NSDictionary *tempDict = [self getSoundDetailForTypeID:[[soundDict valueForKey:@"soundTypeID"]integerValue] andSoundID:[[soundDict valueForKey:@"soundID"]integerValue]];
        
        
//        fileArray objectAtIndex:0
        
        
        
         NSString *query = [NSString stringWithFormat: @"select * from Plan_Sound_List where soundName = '%@'",[PersistenceStorage getObjectForKey:@"soundName"]];

     //   NSString *query = [NSString stringWithFormat: @"select * from Plan_Sound_List where ID = '%d'",[[soundDict valueForKey:@"soundID"]integerValue]];

        
        
         mySoundsArray = [[NSArray alloc] initWithArray:[self.dbManagerMySounds loadDataFromDB:query]];
        
//NSLog(@"%@",[PersistenceStorage getObjectForKey:@"soundName"]);
        
         NSLog(@"LIST NOW     %@",mySoundsArray);
        
        
        AudioPlayerOneViewController *audioPanning = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AudioPlayerOneViewController"];
        
        audioPanning.url = [[mySoundsArray valueForKey:@"soundURL"] objectAtIndex:0];
        audioPanning.name = [[mySoundsArray valueForKey:@"soundName"] objectAtIndex:0];
    audioPanning.panning = audio;
        
        
        if ([[[mySoundsArray valueForKey:@"soundTypeID"] objectAtIndex:0] isEqualToString:@"1"])
            
        {
            [PersistenceStorage setObject:@"Soothing Sound" andKey:@"skillDetail1"];

        }
            
        if ([[[mySoundsArray valueForKey:@"soundTypeID"] objectAtIndex:0] isEqualToString:@"2"])
            
        {
            [PersistenceStorage setObject:@"Interesting Sound" andKey:@"skillDetail1"];

        }
        
        if ([[[mySoundsArray valueForKey:@"soundTypeID"] objectAtIndex:0] isEqualToString:@"3"])
            
        {
            [PersistenceStorage setObject:@"Background Sound" andKey:@"skillDetail1"];

        }
        
        
        
        
        
        
        [PersistenceStorage setObject:audioPanning.name andKey:@"skillDetail2"];

        
        
        
 
        
        
        
[PersistenceStorage setObject:[[mySoundsArray valueForKey:@"soundURL"] objectAtIndex:0] andKey:@"USsoundURL"];

        [PersistenceStorage setObject:[[mySoundsArray valueForKey:@"soundName"] objectAtIndex:0] andKey:@"USsoundName"];

        
         //  [self.navigationController presentModalViewController:ratingsView animated:YES];
        
        
        [self.navigationController presentModalViewController:audioPanning animated:YES];
  //
        
        
        
        
        
        
        
    }
    
}






-(void)viewedInfo:itemName
{
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
    NSString *str = @"Viewed Info";
    
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"situationName"],[PersistenceStorage getObjectForKey:@"skillName"],itemName,nil,nil,nil,nil,nil,nil,nil];
    
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



- (void) tableViewCellDeleted:(NSDictionary *)soundDict fromView:(UIView*)view{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"] ];
    
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.labelText = @"Removed";
    
    [hud show:YES];
    [hud hide:YES afterDelay:1];
    
    // here check for the view and try to readjust the remaining view
    float heightAdjust  = [self getHeightForTableItem:soundDict];
    if(view == self.soothingSoundView){
        // need to adjust followiing two views
        self.interestingSoundView.frame = CGRectMake(0.0, self.soothingSoundView.frame.origin.y + self.soothingSoundView.frame.size.height +8, self.view.frame.size.width,self.interestingSoundView.frame.size.height);
        self.backgroundSoundView.frame = CGRectMake(00.0, self.interestingSoundView.frame.origin.y + self.interestingSoundView.frame.size.height +8, self.view.frame.size.width, self.backgroundSoundView.frame.size.height);
        //self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - heightAdjust);
       // [self.scrollView setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.backgroundSoundView.frame.size.height + self.backgroundSoundView.frame.origin.y)];
    }else if (view == self.interestingSoundView){
        //need to adjust one following class
        self.backgroundSoundView.frame = CGRectMake(00.0, self.interestingSoundView.frame.origin.y + self.interestingSoundView.frame.size.height +8, self.view.frame.size.width, self.backgroundSoundView.frame.size.height);
        //self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - heightAdjust);
        //[self.scrollView setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.backgroundSoundView.frame.size.height + self.backgroundSoundView.frame.origin.y)];
    }else if(view == self.backgroundSoundView){
        //nothing to do, just adjust scroll size
        //self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - heightAdjust);
        //[self.scrollView setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.backgroundSoundView.frame.size.height + self.backgroundSoundView.frame.origin.y)];
    }
    
    [self.view setNeedsDisplay];
}



-(void)didTapInformation:(NSDictionary *)soundDict
{
//NSLog(@"SOUND DICT %@",soundDict);
//NSLog(@"%@",[soundDict valueForKey:@"deviceID"]);

 
  //  NSIndexPath *indexPath = [tableView indexPathForCell:sender];
    
//    NSArray *items = [soundUICompleteInfo objectAtIndex:indexPath.section - 1];
    
    // item = [items objectAtIndex:NSIndexPath.row];
    
 //   if([item isKindOfClass:[OtherSoundInfo class]])
  //  {
  //      OtherSoundInfo *info = (OtherSoundInfo *)item;
        
    //    NSString *description = [otherDevicesPopupMessageDict objectForKey:info.title];
        
  //      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:info.title message:description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
//[alert show];
    
    
    
    
    NSString *description = [otherDevicesPopupMessageDict objectForKey:@"Satellite Radio"];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Info" message:description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
    
    
    
}



-(void)prepareOtherDevicesPopupMessageDict
{
   otherDevicesPopupMessageDict = @{@"Record Player" : @"Do you have a collection of vinyl records? Listening to old records can be an especially enjoyable source of sound to help you with your tinnitus.",
                                          
                                          @"Satellite Radio" : @"Satellite radio is a service that offers well over 100 radio stations. Each station offers a different type of music, or a different type of talk show. A special receiver is needed and there is a monthly service fee.",
                                          @"Sound Pillow (Pillow with Speakers)" : @"A sound pillow is a pillow with thin flexible speakers inside. You can connect it to any device with a standard headphone jack. Usually only the person using the pillow hears the sound being played through it.",
                                          @"Table Top Sound Generator" : @"A table top sound generator is usually a small device with several buttons. Each button plays a different sound. Table top sound generators can be used any time, but many people with tinnitus use them for help with sleep.",
                                          @"Television" : @"People with tinnitus often use television as a source of soothing sound, background sound, and interesting sound.", @"Water Fountain": @"Many people with tinnitus find the sound of water to be helpful. A water fountain is one way to add the sound of water to your environment. The size and shape of the fountain will affect how the water sounds as it moves through the fountain.",
                                          @"Wind Chimes" : @"If you enjoy the sound of wind chimes, they can be used to add sound to your environment.",
                                          @"Other" : @"If you have device you want to use that was not listed in this section, you can use “other” to add it to your plan.",
                                          @"Cassette Tape Player" : @"Do you have old cassette tapes of music or other sounds you enjoy? Using sounds that you enjoyed in the past can be a great way to help you feel better when your tinnitus is bothering you.",
                                          @"CD Player" : @"Many people have CD collections of music or other sounds. Playing CDs of sounds you like can be an especially helpful tool for managing reactions to tinnitus.",
                                          @"Computer with Internet" : @"You can use the internet to listen to music, nature sounds, custom mixes of sound, audio recordings of relaxation exercises and more. Look in the Resources section of the Tinnitus Coach for links to websites that might be helpful.",
                                          @"Ear-Level Sound Generators" : @"Some people with tinnitus wear a small device on their ear that makes a “shhh” sound. The sound is most often used as soothing sound or background sound.",
                                          @"Fan/AC" : @"Some people with tinnitus find it helpful to use the sound from fans, air conditioners or other devices as background sound or soothing sound.",
                                          @"Hearing Aids with Built-in Sound Generators": @"Some hearing aids can also make a “shhh” sound. The “shhh” sound can be used as background sound or soothing sound to help manage reactions to tinnitus.",
                                          @"MP3 Player/iPod™" : @"An mp3 player is a small device you can use to store and play digital sound files. Carrying an mp3 player is an easy way keep a large variety of sounds with you at all times.",
                                          @"Music Channel" : @"Music channels are included as a part of most cable or satellite services for televisions. Each music station plays a steady stream of a different type of music.",
                                          @"Musical Instrument(s)" : @"Playing a musical instrument can be a powerful way to use sound to manage your reactions to tinnitus.",
                                          @"Radio" : @"Many people with tinnitus use sound from a favorite radio station or radio show to help them feel more comfortable at times when their tinnitus is bothering them."
                                          };
}



-(void)writeClickedNextSteps
{
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
    NSString *str = @"Selected a Next Steps Option";
    
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,optionName,[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"situationName"],[PersistenceStorage getObjectForKey:@"skillName"],[PersistenceStorage getObjectForKey:@"skillDetail1"],nil,nil,nil,nil,nil,nil,nil];
    
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




-(void)writeViewedIntroduction{
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
    NSString *str = @"Watched Skill Introduction";
    
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"situationName"],[PersistenceStorage getObjectForKey:@"skillName"],nil,nil,nil,nil,nil,nil,nil,nil];
    
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
