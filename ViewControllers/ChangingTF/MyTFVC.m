//
//  MyTFVC.m
//  TinnitusCoach
//
//  Created by Jiten on 02/05/15.
//  Copyright (c) 2015 Swipe Video Labs Pvt Ltd. All rights reserved.
//

#define EMPTY_TABLEVIEW @"You have no thoughts added to \nyour list. Please add at least \none thought to proceed!"

#import "MyTFVC.h"
#import "MyTipsHeaderView.h"
#import "NewPlanAddedViewController.h"

@interface MyTFVC ()<UITableViewDataSource, UITableViewDelegate>
{
    UIView *nomatchesView;
//    NSArray *allTipsArray,*allTipsWithCategories;
    NSMutableDictionary *_allMyTipsDetailDict;
}
@property(strong,nonatomic)DBManager *dbManager;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOutlet;

@property (nonatomic, strong) NSMutableArray *numOfTips;
@end

@implementation MyTFVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"My Sleep Tips"];
    [self emptyView];
    // Do any additional setup after loading the view.
    self.dbManager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    _allMyTipsDetailDict = [NSMutableDictionary dictionaryWithDictionary:[self gettingMyTips]];
    _numOfTips = [NSMutableArray arrayWithArray:[_allMyTipsDetailDict allKeys]];
    [_tableViewOutlet reloadData];
}

-(void)emptyView
{
    nomatchesView = [[UIView alloc] initWithFrame:self.view.frame];
    nomatchesView.backgroundColor = [UIColor clearColor];
    
    UILabel *matchesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,nomatchesView.frame.size.width,320)];
    matchesLabel.font = [UIFont boldSystemFontOfSize:18];
    matchesLabel.numberOfLines = 0;
    matchesLabel.lineBreakMode = UILineBreakModeWordWrap;
    matchesLabel.shadowColor = [UIColor lightTextColor];
    matchesLabel.textColor = [UIColor darkGrayColor];
    matchesLabel.shadowOffset = CGSizeMake(0, 1);
    matchesLabel.backgroundColor = [UIColor colorWithWhite: 0.70 alpha:1];
    matchesLabel.textAlignment =  NSTextAlignmentCenter;
    
    //Here is the text for when there are no results
    matchesLabel.text = EMPTY_TABLEVIEW;
    
    UIButton *newTipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    newTipButton.frame = CGRectMake(60, matchesLabel.frame.origin.y+ matchesLabel.frame.size.height+20, nomatchesView.frame.size.width-120, 30);
    [newTipButton setTitle:@"Select Tips" forState:UIControlStateNormal];
    [newTipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newTipButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [newTipButton setBackgroundColor:[UIColor colorWithRed:31.0/255.0 green:96.0/255.0 blue:248.0/255.0 alpha:1]];
    newTipButton.layer.cornerRadius = 5.0f;
    [newTipButton addTarget:self action:@selector(onClickNewTipButton) forControlEvents:UIControlEventTouchUpInside];
    
    nomatchesView.hidden = YES;
    [nomatchesView addSubview:matchesLabel];
    [nomatchesView addSubview:newTipButton];

    
    [self.tableViewOutlet insertSubview:nomatchesView belowSubview:self.tableViewOutlet];
}

-(void)onClickNewTipButton
{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditTipListVC *vc = [main instantiateViewControllerWithIdentifier:@"EditTipListVC"];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section != 0 && section <= [_numOfTips count])
    {
        CGRect frame = self.tableViewOutlet.frame;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewOutlet.frame.size.width, 20)];
        [view setBackgroundColor:[UIColor lightGrayColor]];
        
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, frame.size.width-20, 21)];
        [lblTitle setBackgroundColor:[UIColor clearColor]];
        [lblTitle setText:[_numOfTips objectAtIndex:section-1]];
        [lblTitle setFont:[UIFont boldSystemFontOfSize:16]];
        [view addSubview:lblTitle];
        
        frame = view.frame;
        frame.size.height = 41;
        
        return view;
    }
    
    if(section == [_numOfTips count] +1)
    {
        CGRect frame = self.tableViewOutlet.frame;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewOutlet.frame.size.width, 20)];
        [view setBackgroundColor:[UIColor clearColor]];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(100, 10, frame.size.width-200, 30)];
        [btn setTitle:@"Return to Plan" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:31.0/255.0 green:96.0/255.0 blue:248.0/255.0 alpha:1]];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        btn.layer.cornerRadius = 3.0f;
        [btn addTarget:self action:@selector(onClickReturnTipsButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setTextColor:[UIColor whiteColor]];
        [view addSubview:btn];
        
        frame = view.frame;
        frame.size.height = 50;
        
        return view;
    }
    
    MyTipsHeaderView *mytipsHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"MyTipsHeaderView" owner:self options:nil] objectAtIndex:0];
    mytipsHeaderView.btnEditTips.layer.cornerRadius = 5.0f;
    mytipsHeaderView.viewFeedBack.layer.borderWidth = 1.0f;
    mytipsHeaderView.viewFeedBack.layer.borderColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1].CGColor;
    mytipsHeaderView.viewSkillReminder.layer.borderColor = [UIColor lightGrayColor].CGColor;
    mytipsHeaderView.viewSkillReminder.layer.borderWidth = 1.0f;
    
    [mytipsHeaderView.btnEditTips addTarget:self action:@selector(onClickEditTipsButton) forControlEvents:UIControlEventTouchUpInside];
    return mytipsHeaderView;
}

-(void)onClickReturnTipsButton:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setNotificationFlag" object:nil userInfo:nil];
    
    NSArray *viewControllers = [self.navigationController viewControllers];
    
    
    [self.navigationController popToViewController:[viewControllers objectAtIndex:[viewControllers count]-3] animated:NO];
    
    //NewPlanAddedViewController *npav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NewPlanAddedViewController"];
    //[self.navigationController :npav animated:YES];
}


-(void)onClickEditTipsButton
{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditTipListVC *vc = [main instantiateViewControllerWithIdentifier:@"EditTipListVC"];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if(_numOfTips == nil)
//    {
//        return 0;
//    }
    if(_numOfTips && [_numOfTips count] > 0)
    {
        [nomatchesView setHidden:YES];
        return [_numOfTips count]+2;
    }
    else
    {
        [self.tableViewOutlet setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [nomatchesView setHidden:NO];
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 287;
    else
        return 41;
    //if(_numOfTips && [_numOfTips count] > 0)
    //return 287;
    
    //else
      //  return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0 || section == [_numOfTips count]+1)
        return 0;
    NSString *tipName = [ _numOfTips objectAtIndex:section-1];
    
    return [[_allMyTipsDetailDict valueForKey:tipName] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdenfier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdenfier];
    }
    
    NSString *tipName = [_numOfTips objectAtIndex:indexPath.section-1];
    if([_allMyTipsDetailDict valueForKey:tipName])
    {
//        NSString *tipNmaeStr = [tipName  stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSDictionary *tipsDetailsDict = [[_allMyTipsDetailDict valueForKey:tipName] objectAtIndex:indexPath.row];

        [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [cell.textLabel setNumberOfLines:0];
        [cell.textLabel sizeToFit];
        cell.textLabel.text = [tipsDetailsDict valueForKey:@"category"];
    }

    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Database Transaction
-(NSMutableDictionary *)gettingMyTips
{
    NSString *query = @"select * from My_Tips";

    NSArray *allMyTips=[NSArray arrayWithArray:[self.dbManager loadDataFromDB:query]];
    
    return [self setAllTipsDetails:allMyTips];
}
-(NSMutableDictionary *)setAllTipsDetails:(NSArray *)allMyTips
{
    NSMutableArray *allFilteredTipsArray = [NSMutableArray new];
    NSString *queryForTips = @"select * from Plan_Tips_Types";
    NSString *queryForTipsCategpries = @"select * from Plan_Tips_Types_Cateogories";

    NSArray *allTips=[NSArray arrayWithArray:[self.dbManager loadDataFromDB:queryForTips]];
    NSArray *allTipsCotegories=[NSArray arrayWithArray:[self.dbManager loadDataFromDB:queryForTipsCategpries]];
    
    for (NSDictionary *myTips in allMyTips) {
        NSString *tipeID = [myTips valueForKey:@"tipsTypeID"];
        NSString  *tipeCatId = [myTips valueForKey:@"tipsTypeCategoryID"];
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF.tipsTypeID ==%@ AND SELF.ID == %@",[myTips valueForKey:@"tipsTypeID"],[ myTips valueForKey:@"tipsTypeCategoryID"]]];
//        
//        NSArray *filteredArray = [allTipsCotegories filteredArrayUsingPredicate:predicate ];
        
        NSDictionary *catDetails;
        
        for(NSDictionary *tipscategories in allTipsCotegories){
            if ([tipeCatId isEqualToString:[tipscategories valueForKey:@"ID"]] && [ tipeID isEqualToString:[tipscategories valueForKey:@"tipsTypeID"]]) {
                
                catDetails = tipscategories;
                break;
            }
        }
        
        if (catDetails != nil) {
            
            NSString *tID = [myTips valueForKey:@"tipsTypeID"];
            
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"self.ID == %@",tID]];
//            NSArray *tipsArray = [allTips filteredArrayUsingPredicate:predicate];
            NSDictionary *gotTip;
            
            for (NSDictionary *tipDict in allTips){
                
                if([tID isEqualToString:[tipDict valueForKey:@"ID"]])
                {
                    gotTip = tipDict;
                }
            }
            
            if (gotTip != nil) {
                
            
                NSString *strTipName = [gotTip valueForKey:@"tipsTypeName"];
                NSNumber *tipsID = [NSNumber numberWithInt:[[gotTip valueForKey:@"ID"] intValue]];

                NSString *strTipCategoryText = [catDetails valueForKey:@"tipsText"];
                NSNumber *myTipsID = [NSNumber numberWithInt:[[myTips valueForKey:@"ID"] intValue]];
                
                NSDictionary *tipsDetailDict = [ NSDictionary dictionaryWithObjects:@[myTipsID,tipsID,strTipName,strTipCategoryText] forKeys:@[@"ID",@"tipsID",@"tip",@"category"]];
                                                
                                                
                [allFilteredTipsArray addObject:tipsDetailDict];
                
            }
            
        }
        
        
        
    }
    
    
    NSMutableDictionary *welfilteredTips = [NSMutableDictionary new];
    
    for (NSDictionary *myFilteredTips in allFilteredTipsArray)
        {
            if (![[welfilteredTips allKeys] containsObject:[myFilteredTips valueForKey:@"tip"]]) {
                
           
                NSNumber *tipsId = [myFilteredTips valueForKey:@"tipsID"];
                
//                NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"self.tipsID == %d",[tipsId intValue]]];
//                
//                NSArray *filterArray = [allFilteredTipsArray  filteredArrayUsingPredicate:predicate];
                NSMutableArray *filterArray = [NSMutableArray new];
                for (NSDictionary *fetchDict in allFilteredTipsArray)
                {
                    if ([tipsId intValue] == [[fetchDict valueForKey:@"tipsID"] intValue])
                    {
                        [filterArray addObject:fetchDict];

                    }
                    
                }
             
                if (filterArray.count > 0) {
                    [welfilteredTips setValue:filterArray forKey:[myFilteredTips valueForKey:@"tip"]];

                }
                
            }
            
            
        }
    
    return welfilteredTips;
    
}

#pragma mark - edit tips vc delegate
-(void)didSaveTips
{
    _allMyTipsDetailDict = [NSMutableDictionary dictionaryWithDictionary:[self gettingMyTips]];
    _numOfTips = [NSMutableArray arrayWithArray:[_allMyTipsDetailDict allKeys]];
    [_tableViewOutlet reloadData];
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
