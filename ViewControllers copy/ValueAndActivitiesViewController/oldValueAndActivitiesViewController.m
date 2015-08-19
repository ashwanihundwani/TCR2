//
//  ValueAndActivitiesViewController.m
//  TinnitusCoach
//
//  Created by Swipe Video Labs Pvt. Ltd. on 28/03/15.
//  Copyright (c) 2015 Swipe Video Labs Pvt. Ltd.. All rights reserved.
//

#import "ValueAndActivitiesViewController.h"

@interface ValueAndActivitiesViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *valueandActivityArray;
}

@end

@implementation ValueAndActivitiesViewController

-(UIView *)tableHeaderView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 70)];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 280, 40)
                           ];
    
    titleLabel.numberOfLines = 3;
    
    titleLabel.backgroundColor = [UIColor clearColor];
    view.backgroundColor = [Utils colorWithHexValue:@"EFEFF4"];
    
    titleLabel.text = @"Click on a value below to see a list of activities that fit that value.";
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_2];
    
    titleLabel.font = pallete.secondObj;
    titleLabel.textColor = pallete.firstObj;
    
    [view addSubview:titleLabel];
    
    return view;
}

-(void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.valueActivityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    titleView.backgroundColor = [Utils colorWithHexValue:NAV_BAR_BLACK_COLOR];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_1];
    
    titleLabel.font = pallete.secondObj;
    titleLabel.textColor = pallete.firstObj;
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //titleLabel.textColor = [UIColor colorWithHexValue:@"797979"];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"Values and Activities";
    
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
    
    
    
    self.valueActivityTableView.tableHeaderView = [self tableHeaderView];
    [self setupTable];
}

-(void)setupTable{
    [self.valueActivityTableView setDataSource:self];
    [self.valueActivityTableView setDelegate:self];
    valueandActivityArray = [NSArray arrayWithObjects:@"Adventure",@"Authority",@"Artistic",@"Caring",@"Challenge",@"Change",@"Cooperation",@"Excitement",@"Family",@"Fitness",@"Food",@"Friendship",@"Fun",@"Growth",@"Health",@"Inner Peace",@"Intimacy",@"Knowledge",@"Leisure",@"Military",@"Outdoor",@"Physical",@"Social",@"Spirituality",@"Tradition", nil];
    [self.valueActivityTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [valueandActivityArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"ValueCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ValueCell"];
        
        UIImageView *accessory = [[UIImageView alloc]initWithFrame:CGRectMake(286, 15, 13, 13)];
        
        [accessory setImage:[UIImage imageNamed:@"Active_Next-Arrow.png"]];
        
        [cell addSubview:accessory];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(22 , 11, 200, 20)];
        
        titleLabel.tag = 1007;
        
        Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_4];
        
        titleLabel.font = pallete.secondObj;
        titleLabel.textColor = pallete.firstObj;
        
        [cell addSubview:titleLabel];
        
        UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(22, 43, 298, 1)];
        
        separator.backgroundColor = [Utils colorWithHexValue:@"EEEEEE"];
        
        [cell addSubview:separator];
    }
    
    UILabel *label = (UILabel *)[cell viewWithTag:1007];
    
    label.text = [valueandActivityArray objectAtIndex:indexPath.row];
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *valName = [valueandActivityArray objectAtIndex:indexPath.row];
    
    [PersistenceStorage setObject:valName andKey:@"valueName"];
    
    
    if (indexPath.row < 4) {
        
        
        
        ActivitiesViewController *avc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ActivitiesViewController"];
        [self.navigationController pushViewController:avc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
