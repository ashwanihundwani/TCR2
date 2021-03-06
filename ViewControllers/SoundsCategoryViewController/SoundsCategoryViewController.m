//
//  SoundsCategoryViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 3/29/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "SoundsCategoryViewController.h"
#import "TinnitusCoachSoundViewController.h"
#import "WebsitesandAppsViewController.h"
#import "OtherDevicesViewController.h"
#import "NookUS.h"
#import "AudioPlayerThreeViewController.h"
#import "SoundIntroDetailViewController.h"
#import "NookUsingSoundViewControllerOne.h"
#import <MediaPlayer/MPMediaPickerController.h>

@interface SoundsCategoryViewController ()
{
    NSArray *arrayOfSoundCategories;
}
@property (weak, nonatomic) IBOutlet UITableView *soundCategoryTableView;
@property (nonatomic, strong) DBManager *dbManager;
@end

@implementation SoundsCategoryViewController

- (void)viewDidLoad {
    
  arrayOfSoundCategories = [NSArray arrayWithObjects:@{@"sectionText":[NSString stringWithFormat: @"Pick %@ stored on your phone:",self.soundType], @"soundCategories":@[@{@"text":[NSString stringWithFormat:@"Tinnitus Coach %@ ",self.soundType], @"image":@"TCSounds.png"}, @{@"text":@"My Own Sounds", @"image":@"MyOwn.png"} ]}, @{@"sectionText":[NSString stringWithFormat:@"Pick %@ from the Internet:", self.soundType], @"soundCategories":@[@{@"text":@"Website & Apps", @"image":@"Website.png"}]}, @{@"sectionText":[NSString stringWithFormat:@"Make a list of %@ played from other devices you own:",self.soundType], @"soundCategories":@[@{@"text":@"Other Devices", @"image":@"Devices.png"}]}, nil];
    [super viewDidLoad];
    
    self.dbManager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    
    
/*arrayOfSoundCategories = [NSArray arrayWithObjects:@{@"sectionText":[NSString stringWithFormat: @"Pick %@ stored on your phone:",self.soundType], @"soundCategories":@[@{@"text":[NSString stringWithFormat:@"Tinnitus Coach %@ ",self.soundType], @"image":@"u353.png"}, @{@"text":@"My Own Sounds", @"image":@"iphone.png"}]}, @{@"sectionText":[NSString stringWithFormat:@"Pick %@ from the Internet:", self.soundType], @"soundCategories":@[@{@"text":@"Website & Apps", @"image":@"globe.png"}]}, @{@"sectionText":[NSString stringWithFormat:@"Make a list of %@ played from other devices you own:",self.soundType], @"soundCategories":@[@{@"text":@"Other Devices", @"image":@"u317.png"}]}, nil];
    [super viewDidLoad];
  */
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                                                   initWithTarget:self
                                                                  action:@selector(dismissKeyboard)];
                                   
                               //         [self.view addGestureRecognizer:tap];
    
    
    //[self.soundCategoryTableView reloadData];
    // Do any additional setup after loading the view.
}


-(void)dismissKeyboard {
       [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
}



-(IBAction)viewIntroductionAgainClicked:(id)sender{
    SoundIntroDetailViewController *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SoundIntroDetailViewController"];
    [self.navigationController pushViewController:siv animated:YES];
    
}





-(IBAction)learnMoreClicked:(id)sender{
    NookUS *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookUS"];
    [self.navigationController pushViewController:siv animated:YES];
    
}





#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [arrayOfSoundCategories count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rows = [[[arrayOfSoundCategories objectAtIndex:section] valueForKey:@"soundCategories"] count];
   return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    if (cell == nil) {
        cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        
        UIImageView *accessory = [[UIImageView alloc]initWithFrame:CGRectMake(293, 15, 13, 13)];
        
        [accessory setImage:[UIImage imageNamed:@"Active_Next-Arrow.png"]];
        
        [cell addSubview:accessory];
        
    }
    cell.textLabel.text =[[[[arrayOfSoundCategories objectAtIndex:indexPath.section] valueForKey:@"soundCategories"] objectAtIndex:indexPath.row] valueForKey:@"text"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
    cell.imageView.frame = CGRectMake(5.0, 5.0, 19.0, 19.0);
    cell.imageView.image = [UIImage imageNamed:[[[[arrayOfSoundCategories objectAtIndex:indexPath.section] valueForKey:@"soundCategories"] objectAtIndex:indexPath.row] valueForKey:@"image"]];
  //  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 38.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.soundCategoryTableView.frame.size.width-15, 60.0)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 5.0, self.soundCategoryTableView.frame.size.width-15, 50.0)];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont boldSystemFontOfSize:14.0];
    label.numberOfLines = 0;
    label.text = [[arrayOfSoundCategories objectAtIndex:section] valueForKey:@"sectionText"];
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_3];
   // label.font = pallete.secondObj;
    label.textColor = pallete.firstObj;
    
    
    
    [headerView addSubview:label];
    return headerView;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            TinnitusCoachSoundViewController *tcsv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TinnitusCoachSoundViewController"];
            tcsv.soundType = self.soundType;
            [self.navigationController presentModalViewController:tcsv animated:YES];
            
        }
        else if(indexPath.row == 1)
        {
            [self showMyOwnSounds];
        }
    }
    else if (indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            [self showWebsitesandApps];
        }
    }
    else if (indexPath.section == 2)
    {
        if(indexPath.row == 0)
        {
            [self showOtherDevices];
        }
    }
}

- (void) OldshowMyOwnSounds{
    /*
    // if the user has already chosen some music, display that list
    if (userMediaItemCollection) {
        
        MusicTableViewController *controller = [[MusicTableViewController alloc] initWithNibName: @"MusicTableView" bundle: nil];
        controller.delegate = self;
        
        controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        [self presentModalViewController: controller animated: YES];
        [controller release];
        
        // else, if no music is chosen yet, display the media item picker
    } else {
        
    */    MPMediaPickerController *picker =
        [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAny];
        
        picker.delegate						= self;
        picker.allowsPickingMultipleItems	= NO;
        picker.prompt						= NSLocalizedString (@"Add audio to play", "Prompt in media item picker");
        
        // The media item picker uses the default UI style, so it needs a default-style
        //		status bar to match it visually
        [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated: YES];
    
    
    [picker.navigationController setNavigationBarHidden:YES animated:NO];
    
        [self presentModalViewController: picker animated: YES];
    
}





-(void)showMyOwnSounds
{
    MPMediaPickerController *picker =
    [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAnyAudio];
    
    picker.delegate = self;
    picker.allowsPickingMultipleItems       = NO;
    picker.prompt = @"Add Audio to My Own Sounds";
    
    if(picker != NULL)
        [self presentModalViewController: picker animated: YES];
}

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) collection {
    
    
    MPMediaItem *item = [[collection items] objectAtIndex:0];
    NSURL *turl = [item valueForProperty:MPMediaItemPropertyAssetURL];
    NSString *titl = [item valueForProperty:MPMediaItemPropertyTitle];

    NSString *url  = [turl absoluteString];
    
    [PersistenceStorage setObject:url andKey:@"mediaURL"];
 
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

    
    NSLog(@"ULLL %@",url);
    
    
    NSString *duplicateCheck = [NSString stringWithFormat:@"SELECT count(*) from MyOwnSounds  where soundTypeID = %d and PlanID = %d and URL = '%@'", soundTypeID, [PersistenceStorage getIntegerForKey:@"currentPlanID"], url];
    NSLog(@"%@",duplicateCheck);
    
    NSString *rowCount = [self.dbManager loadDataFromDB:duplicateCheck];
    
		  NSLog(@"%@", [rowCount valueForKey:@"count(*)"]);
		  
		//  if ([rowCount valueForKey:@"count(*)"]==0)
        //  {
              
              
           
    
            NSString *query = [NSString stringWithFormat:@"insert into MyOwnSounds ('planID', 'groupID', 'skillID', 'soundTypeID', 'URL','comments') values (%ld, %ld, %ld, %d,'%@','%@')",(long)[PersistenceStorage getIntegerForKey:@"currentPlanID"], (long)[PersistenceStorage getIntegerForKey:@"currentGroupID"], (long)[PersistenceStorage getIntegerForKey:@"currentSkillID"], soundTypeID,url,titl];
    
     
              
    
    BOOL isDone = [self.dbManager executeQuery:query];
    if (isDone == YES)
    {
        NSLog(@"Success");

    }
    
      //    }
          


    [self dismissModalViewControllerAnimated: YES];
 //   NSLog(@"Collection %@",url);
    
    
   // NSError *error;
//self.player = [[AVAudioPlayer alloc] url error:&error];
    
  //  if (!error) {
    //    [self.player prepareToPlay];
      //  [self.player play];
//    }

    
}

    //selectedSongCollection=mediaItemCollection;
//}
//After you are done with selecting the song, implement the delegate to dismiss the picker:

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    [self dismissModalViewControllerAnimated: YES];
}









- (void)showWebsitesandApps
{
    WebsitesandAppsViewController *wav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"WebsitesandAppsViewController"];
    wav.soundType = self.soundType;
    
    
  //  MyCustomViewController *myModalViewController = [[WebsitesandAppsViewController alloc] init];
  //  [myModalViewController setTitle:@"Foo"];
    
 //   UIViewController *vc = [UIViewController new];
 //   UINavigationController *nav = [[UINavigationController alloc] initWithRoot:vc];
   // [self presentViewController:nav animated:YES completion:nil];
    
    
   // UINavigationController *modalNavController = [[UINavigationController alloc] initWithRootView:wav];
   // [myModalViewController release];
    
    // This is intended to be presented in another view controller class
    [self presentModalViewController:wav animated:YES];
    
    
    
    
    
    //[self.navigationController presentModalViewController:wav animated:YES];
}

- (void)showOtherDevices
{
    OtherDevicesViewController *odv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"OtherDevicesViewController"];
    odv.soundType = self.soundType;
    [self.navigationController presentModalViewController:odv animated:YES];
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
