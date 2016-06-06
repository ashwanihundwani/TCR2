//
//  SamplerViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 14/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "SamplerViewController.h"
#import "PlayerViewController.h"
#import "AudioPanningViewController.h"
#import "SamplerVideoViewController.h"

#import "NookUsingSoundViewControllerOne.h"  // This is for the Nook page
#import "RatingsViewController.h"

#import "NookDB.h"
#import "NookMGM.h"
#import "NookImg.h"
#import "NookUS.h"
#import "AudioPlayerTwoViewController.h"



#import "MBProgressHUD.h"



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
    titleLabel.numberOfLines = 100;
    
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
    if ([[PersistenceStorage getObjectForKey:@"Referer"] isEqual:  @"AudioPanningVC"]) {
        RatingsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"RatingsViewController"];
        [self.navigationController presentModalViewController:ratingsView animated:YES];
    }
    if ([[PersistenceStorage getObjectForKey:@"Referer"] isEqual:  @"SamplerVideoVC"]) {
        RatingsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"RatingsViewController"];
        [self.navigationController presentModalViewController:ratingsView animated:YES];
    }
    
    if ([[PersistenceStorage getObjectForKey:@"Referer"] isEqual:  @"AudioPlayerTwoViewController"]) {
        RatingsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"RatingsViewController"];
        [self.navigationController presentModalViewController:ratingsView animated:YES];
    }
    if ([[PersistenceStorage getObjectForKey:@"Referer"] isEqual: @"RatingsVC"]) {
        NSString *actionSheetTitle = @"Where would you like to go now?"; //Action Sheet Title
        NSString *other0 = @"Repeat This Exercise"; //Action Sheet Button Titles
        NSString *other1 = @"Learn About This Exercise";
        NSString *other2 = @"Try Another Exercise";
        NSString *other3 = @"Return Home";
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
    NSLog(@"%@",[PersistenceStorage getObjectForKey:@"SamplerexerciseUrl"]);
    if  ([buttonTitle isEqualToString:@"Repeat This Exercise"]) {
        [PersistenceStorage setObject:nil andKey:@"skillDetail1"];
        [PersistenceStorage setObject:buttonTitle andKey:@"optionName"];
        [self writeClickedNextSteps];
        if ([[PersistenceStorage getObjectForKey:@"SamplerType"] isEqualToString:@"Sounds"])
        {
            
            AudioPanningViewController *audioPanning = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AudioPanningViewController"];
            audioPanning.url = [PersistenceStorage getObjectForKey:@"SamplerSoundURL"];
            audioPanning.name = [PersistenceStorage getObjectForKey:@"SamplerSoundName"];
            audioPanning.panning = audio;
            [self.navigationController presentModalViewController:audioPanning animated:YES];
        }
        else
        {
            UIViewController* vc = nil;
            if([[PersistenceStorage getObjectForKey:@"exerciseName"] isEqualToString:@"Circling to Sleep"]){
                AudioPlayerTwoViewController *audioPanning = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AudioPlayerTwoViewController"];
                audioPanning.url = [PersistenceStorage getObjectForKey:@"SamplerexerciseURL"];
                audioPanning.name = [PersistenceStorage getObjectForKey:@"exerciseName"];
                audioPanning.panning = audio;
                vc = audioPanning;
            }else{
                SamplerVideoViewController *audioPanning = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SamplerVideoViewController"];
                audioPanning.panning = video;
                vc = audioPanning;
            }
            [self.navigationController presentModalViewController:vc animated:NO];
        }
        
    }
    if ([buttonTitle isEqualToString:@"Learn About This Exercise"]) {
        [PersistenceStorage setObject:nil andKey:@"skillDetail1"];
        [PersistenceStorage setObject:buttonTitle andKey:@"optionName"];
        [self writeClickedNextSteps];
         if ([[PersistenceStorage getObjectForKey:@"SamplerType"] isEqual:  @"Sounds"])
         {
             NookUS *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"NookUS"];
             [self.navigationController pushViewController:ratingsView animated:NO];
         }
        else
        {
            if ([[PersistenceStorage getObjectForKey:@"exerciseName"] isEqual:  @"Circling to Sleep"]) {
                NookMGM *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"NookMGM"];
                [self.navigationController pushViewController:ratingsView animated:NO];
            }
            if ([[PersistenceStorage getObjectForKey:@"exerciseName"] isEqual:  @"Deep Breathing"]) {
                NookDB *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"NookDB"];
                [self.navigationController pushViewController:ratingsView animated:NO];
            }
            if ([[PersistenceStorage getObjectForKey:@"exerciseName"] isEqual:  @"Imagery"]) {
                NookImg *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"NookImg"];
                [self.navigationController pushViewController:ratingsView animated:NO];
            }
        }
    }
    
    
    if ([buttonTitle isEqualToString:@"Try Another Exercise"]) {
        
        [PersistenceStorage setObject:nil andKey:@"skillDetail1"];
        
        [PersistenceStorage setObject:buttonTitle andKey:@"optionName"];
        [self writeClickedNextSteps];
        
    }
    
    if ([buttonTitle isEqualToString:@"Return Home"]) {
        [[self tabBarController] setSelectedIndex:0];
        
        [PersistenceStorage setObject:nil andKey:@"skillDetail1"];
        
        [PersistenceStorage setObject:buttonTitle andKey:@"optionName"];
        [self writeClickedNextSteps];
        
    
    }
    
}




-(void)goToHome
{
    self.tabBarController.selectedIndex = 0;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.samplerTableView.backgroundColor = [UIColor whiteColor];
    
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
    // Do any additional setup after loading the view.
    [self.samplerTableView setDataSource:self];
    [self.samplerTableView setDelegate:self ];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.samplerTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    videoHeaderArray = [NSArray arrayWithObjects:@"Learn about Deep Breathing",@"Learn about Imagery",@"Learn about Guided Meditation", nil];
    [self.samplerTableView registerNib:[UINib nibWithNibName:@"SamplerCustomCell" bundle:nil] forCellReuseIdentifier:@"SamplerCell"];
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
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.textLabel.numberOfLines = 0;
            [cell.textLabel sizeToFit];
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
                    UITableViewCell *cell;
                    NSDictionary *dict = [self.soundArray objectAtIndex:indexPath.row];
                    if (cell == nil) {
                        cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
                        
                        UIImageView *accessory = [[UIImageView alloc]initWithFrame:CGRectMake(286, 15, 13, 13)];
                        
                        [accessory setImage:[UIImage imageNamed:@"Active_Next-Arrow.png"]];
                        
                        accessory.tag = ACCESSORY_IMAGE_TAG;
                        
                        [cell addSubview:accessory];
                    }
                    
                    
                    cell.imageView.image = [UIImage imageNamed:@"samplersounds"];
                    cell.textLabel.font= [UIFont systemFontOfSize:16];
                    cell.textLabel.text = [dict valueForKey:@"soundName"];
                    return cell;
                }
                    break;
                case 1:{
                    NSDictionary *dict = [videoArray objectAtIndex:indexPath.row];
                    SamplerCustomCell *samplerCell;
                    if (samplerCell == nil) {
                        samplerCell = [tableView dequeueReusableCellWithIdentifier:@"SamplerCell" forIndexPath:indexPath];
                    }
                    samplerCell.accessoryType = UITableViewCellAccessoryNone;
                    switch (indexPath.row) {
                        case 0:
                            samplerCell.imageView.image = [UIImage imageNamed:@"samplermeditation"];
                            break;
                        case 1:
                            samplerCell.imageView.image = [UIImage imageNamed:@"samplerimagery"];
                            
                            break;
                        case 2:
                            samplerCell.imageView.image = [UIImage imageNamed:@"samplersleep"];
                            
                            break;
                        default:
                            break;
                    }
                    samplerCell.titleLabel.text = [dict valueForKey:@"exerciseName"];
                    samplerCell.descriptionLabel.text =[dict valueForKey:@"exerciseDetail"];
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
    return 50.0;
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
                    UIView *soundHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 10.0)];
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 10.0, 90.0, 30.0)];
                    label.text = @"Sounds";
                    label.font= [UIFont boldSystemFontOfSize:15];
                    label.textColor= [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1];
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark];
                    //[button setFrame:CGRectMake(label.frame.origin.x + label.frame.size.width, 10.0, 30.0, 30.0)];
                    [button setFrame:CGRectMake(270, 10.0, 30.0, 30.0)];
                    
                    button.tag = section;
                    button.hidden = NO;
                    [button setBackgroundColor:[UIColor clearColor]];
                    [button addTarget:self action:@selector(soundHeaderClicked) forControlEvents:UIControlEventTouchUpInside];
                    [soundHeaderView addSubview:label];
                    [soundHeaderView addSubview:button];
                    return soundHeaderView;
                }
                break;
                case 1:
                {
                    UIView *videoHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 40.0)];
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 10.0, 200.0, 30.0)];
                    label.text = @"Relaxation Exercises";
                    label.font= [UIFont boldSystemFontOfSize:15];
                    label.textColor= [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1];
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
                    [button setFrame:CGRectMake(270, 10.0, 30.0, 30.0)];
                    button.tag = section;
                    button.hidden = NO;
                    [button setBackgroundColor:[UIColor clearColor]];
                    [button addTarget:self action:@selector(videoHeaderClicked) forControlEvents:UIControlEventTouchUpInside];
                    [videoHeaderView addSubview:label];
                    [videoHeaderView addSubview:button];
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

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 200:{
            switch (section) {
                case 0:{
                    UIView *soundHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 60.0)];
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 10.0, 280, 60.0)];
                    label.text = @"To hear more sounds, go to \"Add and Use Plans\" from the home page, and add \"Using Sound\" to a plan.";
                    label.font = [UIFont systemFontOfSize:12];
                    label.textColor= [UIColor darkGrayColor];
                    label.numberOfLines =3;
                    [soundHeaderView addSubview:label];
                    return soundHeaderView;
                }
                default:
                    return nil;
            }
        }

        default:
            return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 200:
            return 60;
            default:
            return 0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    switch (tableView.tag) {
        case 100:{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            NookUS *sounds = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookUS"];
            [self.navigationController pushViewController:sounds animated:YES];
        }
        
        break;
        case 200:
        {
            switch (indexPath.section) {
                case 0:{
                    NSDictionary *dict = [self.soundArray objectAtIndex:indexPath.row];
                    AudioPanningViewController *audioPanning = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AudioPanningViewController"];
                    audioPanning.url = [dict valueForKey:@"soundURL"];
                    audioPanning.name = [dict valueForKey:@"soundName"];
                    audioPanning.panning = audio;
                    
                     [PersistenceStorage setObject:audioPanning.url andKey:@"SamplerSoundURL"];
                    
                    [PersistenceStorage setObject:audioPanning.name andKey:@"SamplerSoundName"];
                    
                    [PersistenceStorage setObject:audioPanning.name andKey:@"skillDetailSampler"];
                    [PersistenceStorage setObject:audioPanning.name andKey:@"skillDetail1"];
                    [PersistenceStorage setObject:@"Sounds" andKey:@"SamplerType"];
                    [self.navigationController presentModalViewController:audioPanning animated:NO];
                    
                }
                
                break;
                case 1:{
                    NSDictionary *dict = [videoArray objectAtIndex:indexPath.row];
                    UIViewController* vc = nil;
                    if([[dict valueForKey:@"exerciseName"] isEqualToString:@"Circling to Sleep"]){
                        AudioPlayerTwoViewController *audioPanning = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AudioPlayerTwoViewController"];
                        audioPanning.url = [dict valueForKey:@"exerciseURL"];
                        audioPanning.name = [dict valueForKey:@"exerciseName"];
                        audioPanning.panning = audio;
                        vc = audioPanning;
                    }else{
                        SamplerVideoViewController *audioPanning = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SamplerVideoViewController"];
                        audioPanning.panning = video;
                        audioPanning.videoURL = [dict valueForKey:@"exerciseURL"];
                        vc = audioPanning;
                    }
                    
                    [PersistenceStorage setObject:[dict valueForKey:@"exerciseURL"] andKey:@"SamplerexerciseURL"];
                    
 
                    [PersistenceStorage setObject:@"Relaxation Exercises" andKey:@"SamplerType"];
                    [PersistenceStorage setObject:[dict valueForKey:@"exerciseName"] andKey:@"exerciseName"];
                    [PersistenceStorage setObject:[dict valueForKey:@"exerciseName"] andKey:@"skillDetailSampler"];
                    [self.navigationController presentModalViewController:vc animated:NO];
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
                    NookDB *deep = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookDB"];
                    [self.navigationController pushViewController:deep animated:YES];
                }
                break;
                case 1:
                //imagery
                {
                    [alert dismissWithClickedButtonIndex:0 animated:YES];
                    
                    NookImg *imagery = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookImg"];
                    [self.navigationController pushViewController:imagery animated:YES];
                }
                break;
                
                case 2:
                //guided meditation
                {
                    [alert dismissWithClickedButtonIndex:0 animated:YES];
                    
                    NookMGM *guidedmeditation = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookMGM"];
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
    [self writeSamplerViewedInfoSound];

    alert = [[UIAlertView alloc] initWithTitle:@"Sounds"
                                       message:@"Listening to sound can reduce  your stress and help you cope with tinnitus"
                                      delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:@"OK", nil];
    
    UITableView *alertSoundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,10, 284, 44)
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
    [self writeSamplerViewedInfoExercise];

    alert = [[UIAlertView alloc] initWithTitle:@"Relaxation Exercises"
                                       message:@"Relaxation can lower your stress. Lowering your stress makes you cope with tinnitus"
                                      delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:@"OK", nil];
    
    UITableView *alertVideoTableView = [[UITableView alloc] initWithFrame:CGRectMake(-20,10, 310, 140)
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
        RatingsViewController *addvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"RatingsViewController"];
        [self.navigationController presentModalViewController:addvc animated:YES];
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
    NSString * navMethod = @"";
    if([PersistenceStorage getIntegerForKey:@"HomeButtonTapped"] == self.tabBarController.selectedIndex ){
        navMethod = @"Navigated from Home Screen";
        [PersistenceStorage setInteger:-1 andKey:@"HomeButtonTapped"];
    }else if([PersistenceStorage getIntegerForKey:@"TabBarButtonTapped"] == self.tabBarController.selectedIndex){
        navMethod = @"Navigated from Nav Bar";
        [PersistenceStorage setInteger:-1 andKey:@"TabBarButtonTapped"];
    }else{
        navMethod = nil;
        return;
    }
    NSLog(@"navigation method is:%@ and parent controller is: %@ and isMovingToParentViewController is:%@", navMethod, [[self parentViewController] class], [[self presentingViewController] class]);
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,navMethod,str,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil];
    
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



-(void)writeSamplerViewedInfoSound{
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
    NSString *type = @"Sampler";
    
    NSString *str = @"Viewed Info";
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,nil,nil,@"Sound",nil,nil,nil,nil,nil,nil,nil,nil];
    
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


-(void)writeSamplerViewedInfoExercise{
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
    NSString *type = @"Sampler";
    
    NSString *str = @"Viewed Info";
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,nil,nil,@"Relaxation Exercises",nil,nil,nil,nil,nil,nil,nil,nil];
    
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


-(void)writeClickedNextSteps
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
    NSString *type = @"Sampler";
    NSString *optionName = [PersistenceStorage getObjectForKey:@"optionName"];
    NSString *str = @"Selected a Next Steps Option";
    
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,optionName,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil];
    
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
