//
//  SoundsCategoryViewController.m
//  TinnitusCoach
//
//  Created by Swipe Video Labs on 3/29/15.
//  Copyright (c) 2015 Swipe Video Labs Pvt Ltd. All rights reserved.
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
        
        UIImageView *accessory = [[UIImageView alloc]initWithFrame:CGRectMake(286, 15, 13, 13)];
        
        [accessory setImage:[UIImage imageNamed:@"Active_Next-Arrow.png"]];
        
        [cell addSubview:accessory];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 8, 26, 26)];
        
        imageView.tag = 1006;
        
        [cell addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(55 , 11, 200, 20)];
        
        titleLabel.numberOfLines = 1000;
        
        titleLabel.tag = 1007;
        
        Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_4];
        
        titleLabel.font = pallete.secondObj;
        titleLabel.textColor = pallete.firstObj;
        
        [cell addSubview:titleLabel];
        
        UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(55, 43, 298, 1)];
        
        separator.tag = 1234;
        separator.backgroundColor = [Utils colorWithHexValue:@"EEEEEE"];
        
        [cell addSubview:separator];
    }
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1007];
    
    titleLabel.text = [[[[arrayOfSoundCategories objectAtIndex:indexPath.section] valueForKey:@"soundCategories"] objectAtIndex:indexPath.row] valueForKey:@"text"];
    
    CGFloat labelHeight = [Utils heightForLabelForString:titleLabel.text width:200 font:TITLE_LABEL_FONT];
    
    
//    titleLabel.height = labelHeight;
    
    UIView *separator = [cell viewWithTag:1234];
    
    CGFloat height = [self heightForIndexPath:indexPath];
    
  //  separator.y = height - 1;
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1006];
    
    imageView.image = [UIImage imageNamed:[[[[arrayOfSoundCategories objectAtIndex:indexPath.section] valueForKey:@"soundCategories"] objectAtIndex:indexPath.row] valueForKey:@"image"]];
    
    
    
    //For now - disable my own sounds.
    if(indexPath.section == 0 && indexPath.row == 1)
    {
        titleLabel.textColor = [UIColor lightGrayColor];
    }
    else
    {
        titleLabel.textColor = [UIColor blackColor];
    }
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

-(CGFloat)heightForIndexPath:(NSIndexPath *)indexPath
{
    CGFloat constant = 27;
    
    NSString *str = [[[[arrayOfSoundCategories objectAtIndex:indexPath.section] valueForKey:@"soundCategories"] objectAtIndex:indexPath.row] valueForKey:@"text"];
    CGFloat labelHeight = [Utils heightForLabelForString:str width:200 font:TITLE_LABEL_FONT];
    
    constant += labelHeight;
    
    return constant;
    
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self heightForIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat constant = 22;
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_3];
    
    CGFloat height = [Utils heightForLabelForString:[[arrayOfSoundCategories objectAtIndex:section] valueForKey:@"sectionText"] width:276 font:pallete.secondObj];
    
    return constant + height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *videoHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(22.0, 13.0, 276, 20)];
    label.numberOfLines = 1000;
    label.text = [[arrayOfSoundCategories objectAtIndex:section] valueForKey:@"sectionText"];
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_3];
    label.font = pallete.secondObj;
    label.textColor = pallete.firstObj;
    
    CGFloat height = [Utils heightForLabelForString:label.text width:276 font:label.font];
    
  //  label.height = height;
    
  //  videoHeaderView.height += height;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(20, videoHeaderView.frame.size.height - 1, 300, 1)];
    
    line.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.098/255.0 alpha:0.22];;
    
    [videoHeaderView addSubview:line];
    
    [videoHeaderView addSubview:label];
    return videoHeaderView;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            TinnitusCoachSoundViewController *tcsv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TinnitusCoachSoundViewController"];
            tcsv.soundType = self.soundType;
            [self.navigationController pushViewController:tcsv animated:YES];
            
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
    [self.navigationController presentModalViewController:wav animated:YES];
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
