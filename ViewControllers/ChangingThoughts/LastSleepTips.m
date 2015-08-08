//
//  LastSleepTips.m
//  TinnitusCoach
//
 //  Copyright (c) 2015 Swipe Video Labs Pvt Ltd. All rights reserved.
//
#define UN_SELECTED_IMAGE @"u630.png"
#define SELECTED_IMAGE @"u648.png"

#import "LastSleepTips.h"
#import "EditTipsCell.h"
#import "RatingsViewController.h"

@interface LastSleepTips ()<UITableViewDataSource, UITableViewDelegate>
{
    
    NSMutableDictionary *_allMyTipsDetailDict;
    
    
    NSMutableSet *sectionViewArray;
}
@property (nonatomic, strong) NSMutableArray *numOfTips;


@end

@implementation LastSleepTips

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"My Sleep Tips"];
    [self.lblDesc setText:@"Which sleep tips did you use?"];
    
    [self.lblDesc setTextAlignment:NSTextAlignmentCenter];
    
    self.dbManager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    _allMyTipsDetailDict = [NSMutableDictionary dictionaryWithDictionary:[self gettingMyTips]];
    _numOfTips = [NSMutableArray arrayWithArray:[_allMyTipsDetailDict allKeys]];
    [_tableViewOutlet setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableViewOutlet setTableFooterView:[UIView new]];
    [_tableViewOutlet reloadData];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_numOfTips count]+1;
}

-(void)onClickReturnTipsButton:(id)sender
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RatingsViewController *ratingVC = [storyBoard instantiateViewControllerWithIdentifier:@"RatingsViewController"];
  ///     ratingVC.isFromTips = YES;
    [self.navigationController pushViewController:ratingVC animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
#define DEFAULT_HEIGHT_LABEL 21
#define V_PADDING 5
#define AVALABLE_TIPS @"Submit Tips"
    
#define X_POs 10
    
    if(section < [_numOfTips count])
    {
        CGRect frame = self.tableViewOutlet.frame;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewOutlet.frame.size.width, 20)];
        [view setBackgroundColor:[UIColor clearColor]];
        
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, frame.size.width-20, 21)];
        [lblTitle setBackgroundColor:[UIColor clearColor]];
        [lblTitle setText:[_numOfTips objectAtIndex:section]];
        [lblTitle setFont:[UIFont boldSystemFontOfSize:16]];
        [view addSubview:lblTitle];
        
        frame = view.frame;
        frame.size.height = 41;
        
        return view;
    }
    
    CGRect frame = self.tableViewOutlet.frame;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewOutlet.frame.size.width, 20)];
    [view setBackgroundColor:[UIColor clearColor]];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(100, 10, frame.size.width-200, 30)];
    [btn setTitle:AVALABLE_TIPS forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blackColor]];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    btn.layer.cornerRadius = 10.0f;
    [btn addTarget:self action:@selector(onClickReturnTipsButton:) forControlEvents:UIControlEventTouchUpInside];
    [btn.titleLabel setTextColor:[UIColor whiteColor]];
    [view addSubview:btn];
    
    frame = view.frame;
    frame.size.height = 50;
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section < [_numOfTips count])
    {
        return 41;
    }
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == [_numOfTips count])
        return 0;
    
    
    NSString *tipName = [ _numOfTips objectAtIndex:section];
    
    return [[_allMyTipsDetailDict valueForKey:tipName] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellIdenfier = @"CellIdentifier";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
//    if(cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdenfier];
//    }

    static NSString *cellIdentifier = @"CellIdentifier";
    EditTipsCell *cell = (EditTipsCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"EditTipsCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    
    cell.baseView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.baseView.layer.borderWidth = 1.0f;
    [cell.btnToggleCategory addTarget:self action:@selector(onClickToggleCategory:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnToggleCategory setTag:indexPath.row];
    NSString *tipName = [_numOfTips objectAtIndex:indexPath.section];
    
    NSDictionary *tipsDetailsDict = [[_allMyTipsDetailDict valueForKey:tipName] objectAtIndex:indexPath.row];
    
    [cell.lblTitle setFont:[UIFont systemFontOfSize:14.0f]];
    [cell.lblTitle setNumberOfLines:0];
    [cell.lblTitle sizeToFit];
    cell.lblTitle.text = [tipsDetailsDict valueForKey:@"category"];
    
    return cell;
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
    
    /*NSDictionary *tipsDetailsDict = [allTipsArray objectAtIndex:indexPath.section-1];
    // NSPredicate *predicate = [ NSPredicate predicateWithFormat:[NSString stringWithFormat:@"self.tipsTypeID == %d",[[tipsDetailsDict valueForKey:@"ID"] intValue]]];
    
    //    NSDictionary *categoryDetails =  [[allTipsCategoriesArray filteredArrayUsingPredicate:predicate] objectAtIndex:indexPath.row];
    
    NSMutableArray *sortArray = [NSMutableArray new];
    for(NSDictionary *categoriesDict in allTipsCategoriesArray) {
        
        if ([[categoriesDict valueForKey:@"tipsTypeID"] isEqualToString:[tipsDetailsDict valueForKey:@"ID"]]) {
            [sortArray addObject:categoriesDict];
            
        }
    }
    
    NSDictionary *categoryDetails =  [sortArray objectAtIndex:indexPath.row];
    if ([selectedCategories containsObject:categoryDetails]) {
        
        [self deleteMyTips:categoryDetails];
    }
    else
    {
        [self insertMyTips:categoryDetails];
    }*/
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



@end
