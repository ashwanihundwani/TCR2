//
//  SamplerViewController.m
//  TinnitusCoach
//
//  Created by Swipe Video Labs Pvt. Ltd. on 14/03/15.
//  Copyright (c) 2015 Swipe Video Labs Pvt. Ltd.. All rights reserved.
//

#import "SamplerViewController.h"
#import "PlayerViewController.h"
#import "AudioPanningViewController.h"
#import "SamplerVideoViewController.h"

#import "NookUsingSoundViewControllerOne.h"  // This is for the Nook page
#import "RatingsViewController.h"
#import "MBProgressHUD.h"
#import "SamplerSoundsCell.h"



#import <MediaPlayer/MediaPlayer.h>
@interface SamplerViewController (){
//    UITableView *alertTableView;
    NSArray *videoArray;
    NSArray *videoHeaderArray;
    UIAlertView *alert;
}
@property (nonatomic,strong)  NSArray *soundArray;
@end

@implementation SamplerViewController


-(UIView *)tableHeaderView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 86)];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 13, 280, 60)
                        ];
    
    titleLabel.numberOfLines = 3;
    
    titleLabel.backgroundColor = [UIColor clearColor];
    view.backgroundColor = [Utils colorWithHexValue:@"EFEFF4"];
    
    titleLabel.text = @"The sample sounds and exercises below are easy to use and can be helpful right away for some people.";
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_2];
    
    titleLabel.font = pallete.secondObj;
    titleLabel.textColor = pallete.firstObj;
    
    [view addSubview:titleLabel];
    
    return view;
}


-(void)setUpView{
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
 
 //  [self.navigationItem setRightBarButtonItem:UIButton];
    
}





-(void)viewDidAppear:(BOOL)animated{
    
//    [self.scrollView setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
//    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.tableView.frame.size.height + self.tableView.frame.origin.y-100)];
    
    if ([[PersistenceStorage getObjectForKey:@"Referer"] isEqual:  @"AudioPanningVC"]) {
        RatingsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"RatingsViewController"];

        //ratingsView.skillSection = @"Sounds";
      //  ratingsView.skillDetail = self.name;
        
//[self.navigationController pushViewController:ratingsView animated:YES];
        [self.navigationController presentModalViewController:ratingsView animated:YES];
    }  

    
    
    if ([[PersistenceStorage getObjectForKey:@"Referer"] isEqual:  @"SamplerVideoVC"]) {
        RatingsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"RatingsViewController"];
        
        //ratingsView.skillSection = @"Sounds";
        //  ratingsView.skillDetail = self.name;
        
        //[self.navigationController pushViewController:ratingsView animated:YES];
        [self.navigationController presentModalViewController:ratingsView animated:YES];
    }
    
    
    
    
    
    if ([[PersistenceStorage getObjectForKey:@"Referer"] isEqual: @"RatingsVC"]) {

        
       /* MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"] ];
         
         hud.mode = MBProgressHUDModeCustomView;
         
         hud.labelText = @"Feedback Received";
         
         [hud show:YES];
         [hud hide:YES afterDelay:1.5];
        
        */
        
        
        
        
        NSString *actionSheetTitle = @"Where would you like to go now?"; //Action Sheet Title
        NSString *other0 = @"Repeat This Exercise"; //Action Sheet Button Titles
        NSString *other1 = @"Know About This Exercise";
        NSString *other2 = @"Try Another Exercise";
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

    
    
    
    
    
    
    [self writeVisitedSampler];
    
}




- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    //   NSString * theValue = [(UILabel*)[self viewWithTag:t200] text];
    
    
    
    
    if  ([buttonTitle isEqualToString:@"Repeat This Exercise"]) {
        
        AudioPanningViewController *audioPanning = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AudioPanningViewController"];
     //   audioPanning.url = [dict valueForKey:@"soundURL"];
       //  audioPanning.name = [dict valueForKey:@"soundName"];
        // audioPanning.panning = audio;
        
        
     audioPanning.url = [PersistenceStorage getObjectForKey:@"SamplerSoundURL"];
        audioPanning.name = [PersistenceStorage getObjectForKey:@"SamplerSoundName"];
         audioPanning.panning = audio;

        
        
        // [self.navigationController pushViewController:audioPanning animated:YES];
        
 //       [self.navigationController presentModalViewController:audioPanning animated:NO];
        
        
        
        
            //[self.navigationController pushViewController:ratingsView animated:YES];
            [self.navigationController presentModalViewController:audioPanning animated:YES];
        
        
    }
    if ([buttonTitle isEqualToString:@"Know About This Exercise"]) {
        NookUsingSoundViewControllerOne *samplerView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookUsingSoundViewControllerOne"];
        [self.navigationController pushViewController:samplerView animated:NO];
    }

    
    if ([buttonTitle isEqualToString:@"Try Another Exercise"]) {
      
        
    }
    
    if ([buttonTitle isEqualToString:@"Return Home"]) {
        [[self tabBarController] setSelectedIndex:0];
        
    }
    
}
-(void)goToHome
{
    self.tabBarController.selectedIndex = 0;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.samplerTableView setSeparatorInset:UIEdgeInsetsMake(0, 66, 0, 0)];
    
    self.headerLabel.hidden = TRUE;
    //self.headerLabel.backgroundColor = [Utils colorWithHexValue:@"EFEFF4"];
    
    // Do any additional setup after loading the view.
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    titleView.backgroundColor = [Utils colorWithHexValue:NAV_BAR_BLACK_COLOR];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_1];
    
    titleLabel.font = pallete.secondObj;
    titleLabel.textColor = pallete.firstObj;
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //titleLabel.textColor = [UIColor colorWithHexValue:@"797979"];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"Sampler";
    
    [titleView addSubview:titleLabel];
    
    self.navigationItem.titleView = titleView;
    
    UIImageView *backLabel = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 15, 20)];
    
    backLabel.image = [UIImage imageNamed:@"Active_Back-Arrow.png"];
    
    [Utils addTapGestureToView:backLabel target:self
                      selector:@selector(goToHome)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backLabel];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -8;
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, item, nil];


    
    self.samplerTableView.tableHeaderView = [self tableHeaderView];
    
    [self.samplerTableView setDataSource:self];
    [self.samplerTableView setDelegate:self ];
    
   // [self.view setBackgroundColor:[UIColor colorWithRed:255/255.0f green:252/255.0f blue:252/255.0f alpha:1.0f]];

    
    
   //[self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    
   // UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goToHomeView)];
    //self.navigationItem.hidesBackButton = YES;
    //self.navigationItem.leftBarButtonItem = item;

    
    
//[self.navigationItem.leftBarButtonItem setTitle:@"Back"];
   //[self.navigationItem setLeftBarButtonItem:barButton];
    
    
    
    
    [self.samplerTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
/* soundArray = [NSArray arrayWithObjects:@"Frog",@"Rain",@"Fan",@"Ocean Waves", nil];
//    videoArray = [NSArray arrayWithObjects:@{@"name":@"Deep Breathing",@"image":@"deepbreathing"},@{@"name":@"Imagery",@"image":@"imagery"},@{@"name":@"Circling to sleep",@"image":@"circlingSleep"}, nil];*/
    videoHeaderArray = [NSArray arrayWithObjects:@"Learn about Deep Breathing",@"Learn about Imagery",@"Learn about Guided Meditation", nil];
    [self.samplerTableView registerNib:[UINib nibWithNibName:@"SamplerCustomCell" bundle:nil] forCellReuseIdentifier:@"SamplerCell"];
    //self.samplerTableView.contentInset = UIEdgeInsetsMake(-76, 0, 0, 0);
   
    ////self.edgesForExtendedLayout = UIRectEdgeNone;
   
    // [alertTableView setTag:100];
    [self.samplerTableView setTag:200];
    self.dbManagerForSound = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];

    self.dbManagerForVideo = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    [self loadSoundData];
    [self loadVideoData];
}



-(void)loadSoundData{
    NSString *query = @"select * from Sampler_Sound";
    
    // Get the results.
    if (self.soundArray!= nil) {
        self.soundArray = nil;
    }
    self.soundArray = [[NSArray alloc] initWithArray:[self.dbManagerForSound loadDataFromDB:query]];
    
    // Reload the table view.
    [self.samplerTableView reloadData];
}


-(void)loadVideoData{
    NSString *query = @"select * from Sampler_Exercise";
    
    // Get the results.
    if (videoArray!= nil) {
        videoArray = nil;
    }
    videoArray = [[NSArray alloc] initWithArray:[self.dbManagerForVideo loadDataFromDB:query]];
    
    // Reload the table view.
    [self.samplerTableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.tabBarController.tabBar setHidden:NO];

    [self.navigationItem setHidesBackButton:NO];
    //  [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    switch (tableView.tag) {
        case 300:
            return 1;
            break;
        case 100:
            return 1;
            break;
        case 200:
            return 2;
            break;
        default:
            return 0;
            break;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 300:
            return [videoHeaderArray count];
            break;
        case 100:
            return 1;
            break;
        case 200:
        {
            switch (section) {
                case 0:
                    return [self.soundArray count];
                    break;
                case 1:
                    return [videoArray count];
                    break;
                default:
                    return 1;
                    break;
            }
        }
            break;
        default:
            return 1;
            break;
    }
    
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
            
        case 300:{
            UITableViewCell *cell;
            
            if (cell == nil) {
                cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            }
            cell.imageView.image = [UIImage imageNamed:@"lightbulb32"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text =[videoHeaderArray objectAtIndex:indexPath.row];
            cell.textLabel.font= [UIFont systemFontOfSize:13];

            return cell;

            break;
        }
            
        case 100:{
            
            UITableViewCell *cell;
            
            if (cell == nil) {
                cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            }
            cell.imageView.image = [UIImage imageNamed:@"lightbulb32"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"Learn about Sounds";
            cell.textLabel.font= [UIFont systemFontOfSize:13];

            return cell;
            break;
        }
        case 200:
        {
            switch (indexPath.section) {
                case 0:{
                    
                    NSDictionary *dict = [self.soundArray objectAtIndex:indexPath.row];
                    SamplerSoundsCell *itemCell = [self.samplerTableView dequeueReusableCellWithIdentifier:@"SamplerSoundsCell"];
                    
                    itemCell.titleLabel.text = [dict valueForKey:@"soundName"];
                    
                    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_4];
                    
                    itemCell.titleLabel.font = pallete.secondObj;
                    itemCell.titleLabel.textColor = pallete.firstObj;
                    
                    return itemCell;
                }
                    break;
                case 1:{
                    NSDictionary *dict = [videoArray objectAtIndex:indexPath.row];
                    
//                    NSInteger videoName = [self.dbManagerForVideo.arrColumnNames indexOfObject:@"exerciseName"];
//                    NSInteger description = [self.dbManagerForVideo.arrColumnNames indexOfObject:@"exerciseDetail"];
                   
                    SamplerCustomCell *samplerCell;
                    if (samplerCell == nil) {
                        samplerCell = [tableView dequeueReusableCellWithIdentifier:@"SamplerCell" forIndexPath:indexPath];
                    }
                    //samplerCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    switch (indexPath.row) {
                        case 0:
                            samplerCell.samplerImageView.image = [UIImage imageNamed:@"samplermeditation"];
                            break;
                        case 1:
                            samplerCell.samplerImageView.image = [UIImage imageNamed:@"samplerimagery"];

                            break;
                        case 2:
                          samplerCell.samplerImageView.image = [UIImage imageNamed:@"samplersleep"];

                            break;
                        default:
                            break;
                    }
                    samplerCell.titleLabel.text = [dict valueForKey:@"exerciseName"];
                    
                    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_4];
                    
                    samplerCell.titleLabel.font = pallete.secondObj;
                    samplerCell.titleLabel.textColor = pallete.firstObj;

                    samplerCell.descriptionLabel.text =[dict valueForKey:@"exerciseDetail"];
                    
                    pallete = [Utils getColorFontPair:eCFS_PALLETE_5];
                    samplerCell.descriptionLabel.font = pallete.secondObj;
                    samplerCell.descriptionLabel.textColor = pallete.firstObj;

//                    samplerCell.descriptionLabel.text =[[videoArray objectAtIndex:indexPath.row]objectAtIndex:description];
                  //  samplerCell.durationLabel.text = @"12 mins";
                    return samplerCell;
                }
                    break;
                default:
                    return 0;
                    break;
            }
            return 0;
        }
        default:
            return nil;
            break;
    }
    return 0;
    
}

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section  {
    switch (section) {
        case 0:
            return @"Sounds";
            break;
        case 1:
            return @"Relaxation Exercises";
            break;
        default:
            return 0;
            break;
    }
}*/




#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case 0:
            return 44.0f;
            break;
            
        case 1:
            return 105.0f;
            break;
            
        default:
            return 44.0f;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 56.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if(section == 0)
        return 10;
    else
        return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == 0)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
        
        view.backgroundColor = [Utils colorWithHexValue:NAV_BAR_BLACK_COLOR];
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height - 1, 320, 1)];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
        
        line1.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.098/255.0 alpha:0.22];;
        
        line2.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.098/255.0 alpha:0.22];;
        
        [view addSubview:line1];
        [view addSubview:line2];
        
        return view;
    }
    
    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //Headerview
    switch (tableView.tag) {
        case 100:
            
            break;
        case 200:{
            switch (section) {
                case 0:
                {
                    UIView *soundHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 56.0)];
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 24.0, 90.0, 20.0)];
                    label.text = @"Sounds";
                    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_3];
                    label.font = pallete.secondObj;
                    label.textColor = pallete.firstObj;
                    
                    UIImageView *infoImage = [[UIImageView alloc]initWithFrame:CGRectMake(275, 22.0, 25.0, 25.0)];
                    
                    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(20, soundHeaderView.frame.size.height - 1, 300, 1)];
                    
                    line.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.098/255.0 alpha:0.22];;
                    
                    [soundHeaderView addSubview:line];

                    
                    [Utils addTapGestureToView:infoImage target:self selector:@selector(soundHeaderClicked)];
                    infoImage.image =  [UIImage imageNamed:@"Active_Information_icon.png"];
                    
                

                    [soundHeaderView addSubview:label];
                    [soundHeaderView addSubview:infoImage];
                    return soundHeaderView;
                }
                    break;
                case 1:
                {
                    UIView *videoHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 56.0)];
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 24.0, 200.0, 20.0)];
                    label.text = @"Relaxation Exercises";
                    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_3];
                    label.font = pallete.secondObj;
                    label.textColor = pallete.firstObj;
                    
                    UIImageView *infoImage = [[UIImageView alloc]initWithFrame:CGRectMake(275, 22.0, 25, 25)];
                    
                    [Utils addTapGestureToView:infoImage target:self selector:@selector(videoHeaderClicked)];
                    infoImage.image =  [UIImage imageNamed:@"Active_Information_icon.png"];
                    
                    
                    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(20, videoHeaderView.frame.size.height - 1, 300, 1)];
                    
                    line.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.098/255.0 alpha:0.22];;
                    
                    [videoHeaderView addSubview:line];
                    
                    [videoHeaderView addSubview:infoImage];
                    [videoHeaderView addSubview:label];
                    return videoHeaderView;
                }
                    break;
                default:
                    return nil;
                    break;
            }

            
        }
        default:
            return nil;
            break;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    switch (tableView.tag) {
        case 100:{
            [alert dismissWithClickedButtonIndex:0 animated:YES];

            NookUsingSoundViewControllerOne *sounds = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookUsingSoundViewControllerOne"];
            [self.navigationController pushViewController:sounds animated:YES];
        }
            
            break;
        case 200:
        {
            switch (indexPath.section) {
                case 0:{
                    NSDictionary *dict = [self.soundArray objectAtIndex:indexPath.row];
//                    NSInteger name = [self.dbManagerForSound.arrColumnNames indexOfObject:@"soundName"];
//                    NSInteger url = [self.dbManagerForSound.arrColumnNames indexOfObject:@"soundURL"];

                    AudioPanningViewController *audioPanning = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AudioPanningViewController"];
                    audioPanning.url = [dict valueForKey:@"soundURL"];
                    audioPanning.name = [dict valueForKey:@"soundName"];
                    audioPanning.panning = audio;
                    
                    
                    [PersistenceStorage setObject:audioPanning.url andKey:@"SamplerSoundURL"];

                  [PersistenceStorage setObject:audioPanning.name andKey:@"SamplerSoundName"];

                    

                    
                    
                    

                   // [self.navigationController pushViewController:audioPanning animated:YES];
                    
                    [self.navigationController presentModalViewController:audioPanning animated:NO];

                    
                    
                    
//                    RatingsViewController *addvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"RatingsViewController"];
                    //  ratingsView.skillSection = @"Sounds";
                    //        ratingsView.skillDetail = @"Frog";
                    //UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:addvc];
                    // nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    //[self presentViewController:nav animated:YES completion:^{
                    
                    // }];
                    
  //                  [self.navigationController presentModalViewController:addvc animated:YES];
                    
                    
                    
                    
                    
                }
                    
                    break;
                case 1:{
                    NSDictionary *dict = [videoArray objectAtIndex:indexPath.row];
//                    NSString *str = [dict valueForKey:@"exerciseURL"];
                   // NSURL *videoUrl = [[NSBundle mainBundle]URLForResource:[dict valueForKey:@"exerciseURL"] withExtension:nil];
                   /* MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc]initWithContentURL:videoUrl];
                    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer.moviePlayer];
                    [self presentMoviePlayerViewControllerAnimated:moviePlayer];
                    moviePlayer.moviePlayer.movieSourceType   = MPMovieSourceTypeFile;
                    moviePlayer.moviePlayer.shouldAutoplay = YES;
                    [moviePlayer.moviePlayer setFullscreen:YES animated:YES];
//                  [moviePlayer.moviePlayer play];*/
                    SamplerVideoViewController *audioPanning = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SamplerVideoViewController"];
                    audioPanning.panning = video;
                    audioPanning.videoURL = [dict valueForKey:@"exerciseURL"];
                    
                    
                    
                    [PersistenceStorage setObject:audioPanning.url andKey:@"SamplerexerciseURL"];
                    
//[PersistenceStorage setObject:audioPanning.panning andKey:@"SamplersoundName"];

                    
                    
                    
            //        [self.navigationController pushViewController:audioPanning animated:YES];
                    
                    [self.navigationController presentModalViewController:audioPanning animated:NO];

                    
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        case 300:{
            switch (indexPath.row) {
                case 0:
                    //deep breathing
                {
                    [alert dismissWithClickedButtonIndex:0 animated:YES];
                    NookUsingSoundViewControllerOne *deep = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookUsingSoundViewControllerOne"];
                    [self.navigationController pushViewController:deep animated:YES];
                }
                    break;
                case 1:
                    //imagery
                {
                    [alert dismissWithClickedButtonIndex:0 animated:YES];

                    NookUsingSoundViewControllerOne *imagery = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookUsingSoundViewControllerOne"];
                    [self.navigationController pushViewController:imagery animated:YES];
                }
                    break;
                    
                case 2:
                    //guided meditation
                {
                    [alert dismissWithClickedButtonIndex:0 animated:YES];

                    NookUsingSoundViewControllerOne *guidedmeditation = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookUsingSoundViewControllerOne"];
                    [self.navigationController pushViewController:guidedmeditation animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            
            break;
        default:
            break;
    }
  
}


#pragma mark - SectionHeader Buttons
-(void)soundHeaderClicked{
    alert = [[UIAlertView alloc] initWithTitle:@"Sounds"
                                                    message:@"Listening to sound can reduce  your stress and help you cope with tinnitus"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    
    UITableView *alertSoundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,10, 264, 44)
                                                        style:UITableViewStyleGrouped];
    [alertSoundTableView setTag:100];
    alertSoundTableView.delegate = self;
    alertSoundTableView.dataSource = self;
    alertSoundTableView.backgroundColor = [UIColor clearColor];
    [alert setValue:alertSoundTableView forKey:@"accessoryView"];
   alertSoundTableView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0);
    [alert show];
    [alertSoundTableView reloadData];

}

-(void)videoHeaderClicked{
    alert = [[UIAlertView alloc] initWithTitle:@"Relaxation Exercises"
                                                    message:@"Relaxation can lower your stress. Lowering your stress makes you cope with tinnitus"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    
    UITableView *alertVideoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,10, 264, 140)
                                                               style:UITableViewStyleGrouped];
    [alertVideoTableView setTag:300];
    alertVideoTableView.delegate = self;
    alertVideoTableView.dataSource = self;
    alertVideoTableView.backgroundColor = [UIColor clearColor];
    [alert setValue:alertVideoTableView forKey:@"accessoryView"];
    alertVideoTableView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0);
    [alert show];
    [alertVideoTableView reloadData];
}



- (void)playbackDidFinish:(NSNotification*)aNotification
{}

-(void)doneButtonClick:(NSNotification *)aNotification{
    NSNumber *reason = [aNotification.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    if ([reason intValue] == MPMovieFinishReasonUserExited) {
        
        
//        UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:RatingsViewController];
  //      [[self navigationController] presentModalViewController:controller animated:YES];
        
        
    //    [[self navigationController] presentModalViewController:newTransactionViewController animated:YES];
        
        
        RatingsViewController *addvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"RatingsViewController"];
      //  ratingsView.skillSection = @"Sounds";
        //        ratingsView.skillDetail = @"Frog";
        //UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:addvc];
        // nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        //[self presentViewController:nav animated:YES completion:^{
        
        // }];
        
        [self.navigationController presentModalViewController:addvc animated:YES];

        
        
        
        
        
//        RatingsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"RatingsViewController"];
  //          ratingsView.skillSection = @"Sounds";
    //        ratingsView.skillDetail = @"Frog";
  //          [self presentViewController:ratingsView animated:YES completion:^{
  
        
      //  [[self navigationController] presentModalViewController:RatingsViewController animated:YES];

        
      //      }];

    }
}


-(void)movieFinishedCallback:(NSNotification*)aNotification {
   // [self dismissMoviePlayerViewControllerAnimated];
     NSNumber *reason = [aNotification.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    if ([reason intValue] == MPMovieFinishReasonUserExited) {
        RatingsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"RatingsViewController"];
        ratingsView.skillSection = @"Sounds";
        ratingsView.skillDetail = @"Frog";
        [self presentViewController:ratingsView animated:YES completion:^{
            
        }];
        
    }
}

-(void)writeVisitedSampler{
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
    NSString *type = @"Navigation";
    
    NSString *str = @"Sampler";
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,nil,str,nil,nil,nil,nil,nil,nil,nil,nil];
    
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
@end
