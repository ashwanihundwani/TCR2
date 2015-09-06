//
//  PleasantActivityViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 28/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "PleasantActivityViewController.h"
#import "PleasantIntroDetailViewController.h"
#import "NookUsingSoundViewControllerOne.h"
#import "NookPA.h"
#import "ValueAndActivitiesViewController.h"
#import "FavoritesViewController.h"
#import "SwiperViewController.h"
#import "IntroPageInfo.h"

@interface PleasantActivityViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *paArray;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation PleasantActivityViewController

- (void)viewDidLoad {
     [self setUpView];
    [super viewDidLoad];
    
    
    self.activties = @[@"Values and Activities", @"Favorites"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    /*
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
    
    titleLabel.text= [NSString stringWithFormat:@"Plan for %@ ",[PersistenceStorage getObjectForKey:@"planName"]];
    titleLabel.adjustsFontSizeToFitWidth=YES;
    titleLabel.minimumScaleFactor=0.5;

    
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

    
    self.title = @"Pleasant Activities";
        // Do any additional setup after loading the view.
  
     */
}

-(void)setUpView{
    self.pleasantActivityImageView.image = [UIImage imageNamed:@"5PleasantActivities"];
    paArray = [[NSArray alloc]initWithObjects:@"Favorites",@"Value & activities", nil];
    [self.scheduleTableView setDelegate:self];
    [self.scheduleTableView setDataSource:self];
    [self.scheduleTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.learnMoreButton.layer setCornerRadius:3.5f];
    [self.viewIntroButton.layer setCornerRadius:3.5f];
}



-(void)viewDidAppear:(BOOL)animated
{
    
    
    [self.scrollView setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.scrollView setContentSize:CGSizeMake(320,600)];
    
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)viewIntroductionAgainClicked:(id)sender{
    
    [self writeViewedIntroduction];
    
    /*
    PleasantIntroDetailViewController *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"PleasantIntroDetailViewController"];
    [self.navigationController pushViewController:siv animated:YES];
     */
    
    NSMutableArray *pageInfos = [NSMutableArray array];
    
    IntroPageInfo *info = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro5image1.png"] title: P_A_PAGE1_TITLE description:@"Working and doing chores are important. It is also important to do some things just because you enjoy them. Pleasant activities are activities you enjoy."];
    
    [pageInfos addObject:info];
    
    IntroPageInfo *info2 = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro5image2.png"] title: @"How can \"Pleasant Activities\" help me?" description:P_A_INTRO_PAGE2];
    
    [pageInfos addObject:info2];
    
    IntroPageInfo *info3 = [[IntroPageInfo alloc] initWithimage:[UIImage imageNamed:@"Intro5image3.png"] title: P_A_PAGE3_TITLE description:P_A_INTRO_PAGE3];
    
    [pageInfos addObject:info3];
    
    SwiperViewController *swiper = [[SwiperViewController alloc]init];
    
    swiper.pageInfos = pageInfos;
    
    swiper.header = @"Welcome to Pleasant Activities";
    
    [self.navigationController pushViewController:swiper animated:YES];
    
}

-(NSString *)planText
{
    return [NSString stringWithFormat:@"Plan for %@ ",[PersistenceStorage getObjectForKey:@"planName"]];
}

-(NSString *)activityText{
    
    return [PersistenceStorage getObjectForKey:@"skillName"];
}


-(IBAction)learnMoreClicked:(id)sender{
    NookPA *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookPA"];
    [self.navigationController pushViewController:siv animated:YES];
    
}


-(IBAction)favoritesClicked:(id)sender{
    FavoritesViewController *favc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"FavoritesViewController"];
    [self.navigationController pushViewController:favc animated:YES];
    
}


-(IBAction) valuesClicked:(id)sender{
    ValueAndActivitiesViewController *vaavc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ValueAndActivitiesViewController"];
    [self.navigationController pushViewController:vaavc animated:YES];
    
}

 



#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [paArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [paArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:15.0];

    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]init];
    label.text = @"Schedule Pleasant Activities";
    label.font = [UIFont fontWithName:@"Helvetica Neue" size:15.0];
    return label;
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        FavoritesViewController *favc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"FavoritesViewController"];
        [self.navigationController pushViewController:favc animated:YES];
    }else{
        ValueAndActivitiesViewController *vaavc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ValueAndActivitiesViewController"];
        [self.navigationController pushViewController:vaavc animated:YES];
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

 


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
