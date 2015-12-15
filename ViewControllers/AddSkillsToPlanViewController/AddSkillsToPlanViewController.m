//
//  AddSkillsToPlanViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 3/22/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "AddSkillsToPlanViewController.h"
#import "SkillDetailViewController.h"
#import "ImagerySkillDetailViewController.h"
#import "TipsSkillDetailViewController.h"
#import "SoundSkillDetailViewController.h"
#import "BreathingSkillDetailViewController.h"
#import "MeditationSkillDetailViewController.h"
#import "ThoughtsSkillDetailViewController.h"
#import "PleasantSkillDetailViewController.h"
#import "SkillCell.h"




@interface AddSkillsToPlanViewController ()
{
    NSArray *skillListArray;
}
@property (nonatomic, strong) IBOutlet UITableView *skillsTableView;
@property (nonatomic, strong) DBManager *dbManagerSkillList;

@end

@implementation AddSkillsToPlanViewController

-(CGFloat)heightForIndexPath:(NSIndexPath *)indexPath
{
    CGFloat constant = 27;
    
    NSString *skillName = [[skillListArray objectAtIndex:indexPath.row] valueForKey:@"skillName"];
    
    NSString *skillDesc = [[skillListArray objectAtIndex:indexPath.row] valueForKey:@"skillDetail"];
    
    CGFloat titleLabelHeight = [Utils heightForLabelForString:skillName width:250 font:TITLE_LABEL_FONT];
    
    CGFloat subTitleLabelHeight = [Utils heightForLabelForString:skillDesc width:250 font:[Utils helveticaNueueFontWithSize:16]];
    
    
    constant += (titleLabelHeight + subTitleLabelHeight);
    
    return constant;
    
}

-(void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIView *)tableHeaderView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 15, 276, 20)
                           ];
    
    titleLabel.numberOfLines = 1000;
    
    titleLabel.backgroundColor = [UIColor clearColor];
    view.backgroundColor = [Utils colorWithHexValue:@"EFEFF4"];
    
    titleLabel.text = @"Tap a skill to learn more and add it to your plan:";;
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_2];
    
    titleLabel.font = pallete.secondObj;
    titleLabel.textColor = pallete.firstObj;
    
    CGFloat height = [Utils heightForLabelForString:titleLabel.text width:276 font:pallete.secondObj];
    
    titleLabel.height = height;
    
    view.height += height;
    
    [view addSubview:titleLabel];
    
    return view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.skillsTableView.tableHeaderView = [self tableHeaderView];
    
    self.skillsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    
    titleView.backgroundColor = [Utils colorWithHexValue:NAV_BAR_BLACK_COLOR];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_1];
    
    titleLabel.font = pallete.secondObj;
    titleLabel.textColor = pallete.firstObj;
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //titleLabel.textColor = [UIColor colorWithHexValue:@"797979"];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"Add Skills To Plan";
    
    [titleView addSubview:titleLabel];
    
    self.navigationItem.titleView = titleView;
    
    UIImageView *backLabel = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 15, 20)];
    
    backLabel.image = [UIImage imageNamed:@"Active_Back-Arrow.png"];
    
    [Utils addTapGestureToView:backLabel target:self
                      selector:@selector(cancel)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backLabel];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -8;
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, item, nil];
    self.dbManagerSkillList = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    
    [self loadPlanSkills];
    
    // Do any additional setup after loading the view.
}

-(void)loadPlanSkills{
    NSString *query = [NSString stringWithFormat:@"select * from Plan_Skills where ID NOT IN (select skillID from MySkills where planID==%@) and ID NOT IN (select skillID from Skills_Situation where situationName=='%@') ",[PersistenceStorage getObjectForKey:@"currentPlanID"],[PersistenceStorage getObjectForKey:@"situationName"]];
    // Get the results.
    if (skillListArray!= nil) {
        skillListArray = nil;
    }
    skillListArray = [[NSArray alloc] initWithArray:[self.dbManagerSkillList loadDataFromDB:query]];
    // Reload the table view.
    [self.skillsTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [skillListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    SkillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SkillCell"];
    
    cell.titleLabel.text = [[skillListArray objectAtIndex:indexPath.row] valueForKey:@"skillName"];
    
    cell.descriptionLabel.text = [[skillListArray objectAtIndex:indexPath.row] valueForKey:@"skillDetail"];
    
    CGFloat titleLabelHeight = [Utils heightForLabelForString:cell.titleLabel.text width:250 font:TITLE_LABEL_FONT];
    
    cell.titleHeightConst.constant = titleLabelHeight;
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    return cell;
    
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self heightForIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  //  cell.textLabel.text =[[skillListArray objectAtIndex:indexPath.row] valueForKey:@"skillName"];
    NSString *tSkillName = [[skillListArray objectAtIndex:indexPath.row] valueForKey:@"skillName"];
     
    
    if ([tSkillName isEqualToString:@"Guided Meditation"])
    {
        MeditationSkillDetailViewController *dav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"MeditationSkillDetailViewController"];
       dav.skillDict = [skillListArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:dav animated:YES];
    }
    
    
    
    if ([tSkillName isEqualToString:@"Deep Breathing"])
    {
        BreathingSkillDetailViewController *dav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"BreathingSkillDetailViewController"];
         dav.skillDict = [skillListArray objectAtIndex:indexPath.row];[self.navigationController pushViewController:dav animated:YES];
    }
    
    if ([tSkillName isEqualToString:@"Pleasant Activities"])
    {
        PleasantSkillDetailViewController *dav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"PleasantSkillDetailViewController"];
         dav.skillDict = [skillListArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:dav animated:YES];
    }
    
    if ([tSkillName isEqualToString:@"Using Sound"])
    {
       SoundSkillDetailViewController *dav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SoundSkillDetailViewController"];
         dav.skillDict = [skillListArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:dav animated:YES];
    }
    
    if ([tSkillName isEqualToString:@"Imagery"])
    {
        ImagerySkillDetailViewController *dav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ImagerySkillDetailViewController"];
         dav.skillDict = [skillListArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:dav animated:YES];
    }
    if ([tSkillName isEqualToString:@"Changing Thoughts & Feelings"])
    {
        ThoughtsSkillDetailViewController *dav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ThoughtsSkillDetailViewController"];
        dav.skillDict = [skillListArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:dav animated:YES];
    }
    if ([tSkillName isEqualToString:@"Tips for Better Sleep"])
    {
        TipsSkillDetailViewController *dav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TipsSkillDetailViewController"];
        dav.skillDict = [skillListArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:dav animated:YES];
    }
  
}




@end
