//
//  MySleepTipsVC.m
//  TinnitusCoach
//
//  Created by Creospan on 02/05/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//
#define UN_SELECTED_IMAGE @""
#define SELECTED_IMAGE @"Selected_CheckBox.png.png"

#define EMPTY_TABLEVIEW @"You have no sleep tips added to \nyour list. Please add at least \none tip to proceed!"

#import "TipsReminder.h"
#import "MyTipsHeaderView.h"
#import "NewPlanAddedViewController.h"
#import "EditTipsCell.h"
#import "SkillRatingsViewController.h"

@interface TipsReminder ()<UITableViewDataSource, UITableViewDelegate>
{
    UIView *nomatchesView;
    NSMutableDictionary *_allMyTipsDetailDict;
    NSMutableArray *_selectedMyTipsArray;
}

@property(strong,nonatomic)DBManager *dbManager;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOutlet;

@property (nonatomic, strong) NSMutableArray *numOfTips;

@end

@implementation TipsReminder

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Sleep Tips Reminder"];
    [self emptyView];
    // Do any additional setup after loading the view.
    self.dbManager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    _allMyTipsDetailDict = [NSMutableDictionary dictionaryWithDictionary:[self gettingMyTips]];
    _numOfTips = [NSMutableArray arrayWithArray:[_allMyTipsDetailDict allKeys]];
    _selectedMyTipsArray = [NSMutableArray new];
    [_tableViewOutlet reloadData];
}


-(void)viewDidAppear:(BOOL)animated
{
    NSString *queryForTips = @"select * from My_Tips";
    NSArray *allMyTips= [self.dbManager loadDataFromDB:queryForTips];
    NSLog(@"allmytips count %d",[allMyTips count]);
    if ([allMyTips count] == 0)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            self.dismissBlock();
        }];
    }
}



- (void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
}


-(void)emptyView
{
    nomatchesView = [[UIView alloc] initWithFrame:self.view.frame];
    nomatchesView.backgroundColor = [UIColor clearColor];
    UILabel *matchesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,nomatchesView.frame.size.width,150)];
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
    nomatchesView.hidden = YES;
    [nomatchesView addSubview:matchesLabel];
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
        [btn setTitle:@"Submit" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        btn.layer.cornerRadius = 3.0f;
        [btn addTarget:self action:@selector(onClickReturnTipsButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setTextColor:[UIColor whiteColor]];
        [view addSubview:btn];
        
        frame = view.frame;
        frame.size.height = 50;
        
        return view;
    }
    
    MyTipsHeaderView *mytipsHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"TipsReminder" owner:self options:nil] objectAtIndex:0];
    mytipsHeaderView.btnEditTips.layer.cornerRadius = 5.0f;
    mytipsHeaderView.viewFeedBack.layer.borderWidth = 1.0f;
    mytipsHeaderView.viewFeedBack.layer.borderColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1].CGColor;
    mytipsHeaderView.viewSkillReminder.layer.borderColor = [UIColor lightGrayColor].CGColor;
    mytipsHeaderView.viewSkillReminder.layer.borderWidth = 1.0f;
    
    [mytipsHeaderView.btnEditTips addTarget:self action:@selector(onClickEditTipsButton) forControlEvents:UIControlEventTouchUpInside];
    return mytipsHeaderView;
}


-(void)toggleCategoryImage:(BOOL)isSelected andCell:(EditTipsCell *)cell
{
    if([cell.imgCategory.image isEqual:[UIImage imageNamed:SELECTED_IMAGE]])
    {
        [cell.imgCategory setImage:[UIImage imageNamed:UN_SELECTED_IMAGE]];
    }
    else
    {
        [cell.imgCategory setImage:[UIImage imageNamed:SELECTED_IMAGE]];
    }
}


-(void)onClickToggleCategory:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableViewOutlet];
    NSIndexPath *indexPath = [self.tableViewOutlet indexPathForRowAtPoint:buttonPosition];
    EditTipsCell *cell = (EditTipsCell *)[self.tableViewOutlet cellForRowAtIndexPath:indexPath];
    if (indexPath != nil)
    {
        [self toggleCategoryImage:YES andCell:cell];
    }

    NSString *tipName = [_numOfTips objectAtIndex:indexPath.section-1];
    
    if([_allMyTipsDetailDict valueForKey:tipName])
        
    {
        NSDictionary *tipsDetailsDict = [[_allMyTipsDetailDict valueForKey:tipName] objectAtIndex:indexPath.row];
        if ([_selectedMyTipsArray containsObject:tipsDetailsDict]) {
            
            //       [self deleteMyTips:categoryDetails];
            [_selectedMyTipsArray removeObject:tipsDetailsDict];
        }
        else
        {
            //        [self insertMyTips:categoryDetails];
            [_selectedMyTipsArray addObject:tipsDetailsDict];
        }
        
    }
    [_tableViewOutlet reloadData];
    
    
}

-(void)onClickReturnTipsButton:(id)sender
{
    NSMutableString *mainString=[[NSMutableString alloc]initWithString:@""];
    
    for (NSDictionary *tArr in _selectedMyTipsArray) {
        
        NSString *string=[tArr valueForKey:@"category"];
        [mainString appendFormat:@"%@|",string];
        
        
    }
    [PersistenceStorage setObject:mainString andKey:@"skillDetail1"];
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSDateFormatter* day = [[NSDateFormatter alloc] init];
        [day setDateFormat: @"EEEE"];
        NSString *weekday =[day stringFromDate:[NSDate date]];
        if ([weekday isEqualToString:@"Monday"])
        {       [PersistenceStorage setObject:@"Yes" andKey:@"ItsMondayShowWR"];
        }
        else
        {
            [PersistenceStorage setObject:@"SomeOtherDay" andKey:@"ItsMondayShowWR"];
            
        }
        NSString *query = @"select * from My_Tips";
        NSArray *allMyTips=[NSArray arrayWithArray:[self.dbManager loadDataFromDB:query]];
        NSMutableString *planIDs = [NSMutableString string];
        NSMutableSet *distinctPlanIDs = [NSMutableSet set];
        for(NSDictionary *dict in allMyTips){
            [distinctPlanIDs addObject:[dict objectForKey:@"planID"]];
        }
        NSInteger count = distinctPlanIDs.count;
        for(NSString *planID in distinctPlanIDs){
            
            [planIDs appendString:@"'"];
            [planIDs appendString:planID];
            [planIDs appendString:@"'"];
            count--;
            if (count > 0) {
                [planIDs appendString:@","];
            }
        }
        NSString *query1 = [NSString stringWithFormat:@"select * from MyPlans where ID IN (%@)",planIDs];
        NSArray *plans = [self.dbManager loadDataFromDB:query1];
        NSMutableString *planNames = [NSMutableString string];
        count = plans.count;
        for(NSDictionary *plan in plans){
            [planNames appendString:[plan objectForKey:@"planName"]];
            count--;
            if(count > 0){
                [planNames appendString:@"|"];
            }
        }
        
        NSMutableString *string = [NSMutableString string];
        
        NSInteger outerCount = _allMyTipsDetailDict.count;
        
        for(NSString *detail in [_allMyTipsDetailDict allKeys]){
            
            outerCount--;
            NSArray *items = [_allMyTipsDetailDict objectForKey:detail];
            
            count = items.count;
            
            for(NSDictionary *dict in items){
                
                [string appendString:[dict objectForKey:@"category"]];
                count--;
                if(count > 0 || outerCount > 0){
                    [string appendString:@"|"];
                }
                
            }
        }
        
        [PersistenceStorage setObject:@"TipsReminderRating" andKey:@"TipsReminder"];
        
        [PersistenceStorage setObject:@"Tips for Better Sleep" andKey:@"skillNameTips"];
        
        [PersistenceStorage setObject:planNames andKey:@"planNameTips"];
        
        [PersistenceStorage setObject:planNames andKey:@"situationNameTips"];
        
        string = [[string stringByReplacingOccurrencesOfString:@"," withString:@">"] mutableCopy];
        
        [PersistenceStorage setObject:string andKey:@"skillDetailTips"];
        //TODO - plan & situation name.
        
        
        UIStoryboard *storyBoard = [ UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SkillRatingsViewController *mySleepsViewCotroller = [storyBoard instantiateViewControllerWithIdentifier:@"SkillRatingsViewController"];
        
        mySleepsViewCotroller.dismissBlock = self.dismissBlock;
        UIWindow *currentWindow = [[UIApplication sharedApplication].windows firstObject];
        [currentWindow.rootViewController presentViewController:mySleepsViewCotroller animated:YES completion:^{
            
        }];
        
    }];
    
}


- (IBAction)cancelTapped:(id)sender {
    [PersistenceStorage setObject:@"TipsReminder" andKey:@"Referer"];

    NSDictionary *dict = [_selectedMyTipsArray objectAtIndex:0];
    NSString *firstLineTip = [dict valueForKey:@"category"];
    [PersistenceStorage setObject:firstLineTip andKey:@"firstLineSleepTip"];

    
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
    static NSString *cellIdentifier = @"CellIdentifier";
    EditTipsCell *cell = (EditTipsCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"EditTipsCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    
    [cell.btnToggleCategory addTarget:self action:@selector(onClickToggleCategory:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnToggleCategory setTag:indexPath.row];
    
    
    NSString *tipName = [_numOfTips objectAtIndex:indexPath.section-1];
    
    if([_allMyTipsDetailDict valueForKey:tipName])
        
    {
        NSDictionary *tipsDetailsDict = [[_allMyTipsDetailDict valueForKey:tipName] objectAtIndex:indexPath.row];
        
        if ([_selectedMyTipsArray containsObject:tipsDetailsDict]) {
            
            //        [self onClickToggleCategory:cell.btnToggleCategory];
            cell.checkImage.image = [UIImage imageNamed:SELECTED_IMAGE];
            cell.checkImage.hidden = FALSE;
            
        }
        else{
            
            cell.checkImage.image = [UIImage imageNamed:UN_SELECTED_IMAGE];
            cell.checkImage.hidden = TRUE;
            
        }
        cell.lblTitle.text = [tipsDetailsDict valueForKey:@"category"];
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat constant = 27;
    
    NSString *tipName = [_numOfTips objectAtIndex:indexPath.section-1];
    
    if([_allMyTipsDetailDict valueForKey:tipName])
        
    {
        NSDictionary *tipsDetailsDict = [[_allMyTipsDetailDict valueForKey:tipName] objectAtIndex:indexPath.row];
        
        NSString *string = [tipsDetailsDict valueForKey:@"category"];
        
        CGFloat labelHeight = [Utils heightForLabelForString:string width:255 font:TITLE_LABEL_FONT];
        
        constant += labelHeight;
        
        return constant;
    }
    
    
    return 0;
   
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
        NSDictionary *catDetails;
        for(NSDictionary *tipscategories in allTipsCotegories){
            if ([tipeCatId isEqualToString:[tipscategories valueForKey:@"ID"]] && [ tipeID isEqualToString:[tipscategories valueForKey:@"tipsTypeID"]]) {
                
                catDetails = tipscategories;
                break;
            }
        }
        
        if (catDetails != nil) {
            
            NSString *tID = [myTips valueForKey:@"tipsTypeID"];
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


@end
