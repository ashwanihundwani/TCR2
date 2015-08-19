//
//  lastTF.m
//  TinnitusCoach
//
 //  Copyright (c) 2015 Swipe Video Labs Pvt Ltd. All rights reserved.
//
#define UN_SELECTED_IMAGE @"u630.png"
#define SELECTED_IMAGE @"u648.png"

#import "LastTF.h"
#import "EditTFCell.h"
#import "RatingsViewController.h"

@interface LastTF ()<UITableViewDataSource, UITableViewDelegate>
{
    
    NSMutableDictionary *_allMyTFDetailDict;
    
    
    NSMutableSet *sectionViewArray;
}
@property (nonatomic, strong) NSMutableArray *numOfTF;


@end

@implementation lastTF

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"My Sleep TF"];
    [self.lblDesc setText:@"Which sleep TF did you use?"];
    
    [self.lblDesc setTextAlignment:NSTextAlignmentCenter];
    
    self.dbManager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    _allMyTFDetailDict = [NSMutableDictionary dictionaryWithDictionary:[self gettingMyTF]];
    _numOfTF = [NSMutableArray arrayWithArray:[_allMyTFDetailDict allKeys]];
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
    return [_numOfTF count]+1;
}

-(void)onClickReturnTFButton:(id)sender
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RatingsViewController *ratingVC = [storyBoard instantiateViewControllerWithIdentifier:@"RatingsViewController"];
  ///     ratingVC.isFromTF = YES;
    [self.navigationController pushViewController:ratingVC animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
#define DEFAULT_HEIGHT_LABEL 21
#define V_PADDING 5
#define AVALABLE_TF @"Submit TF"
    
#define X_POs 10
    
    if(section < [_numOfTF count])
    {
        CGRect frame = self.tableViewOutlet.frame;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewOutlet.frame.size.width, 20)];
        [view setBackgroundColor:[UIColor clearColor]];
        
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, frame.size.width-20, 21)];
        [lblTitle setBackgroundColor:[UIColor clearColor]];
        [lblTitle setText:[_numOfTF objectAtIndex:section]];
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
    [btn setTitle:AVALABLE_TF forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blackColor]];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    btn.layer.cornerRadius = 10.0f;
    [btn addTarget:self action:@selector(onClickReturnTFButton:) forControlEvents:UIControlEventTouchUpInside];
    [btn.titleLabel setTextColor:[UIColor whiteColor]];
    [view addSubview:btn];
    
    frame = view.frame;
    frame.size.height = 50;
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section < [_numOfTF count])
    {
        return 41;
    }
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == [_numOfTF count])
        return 0;
    
    
    NSString *tipName = [ _numOfTF objectAtIndex:section];
    
    return [[_allMyTFDetailDict valueForKey:tipName] count];
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
    EditTFCell *cell = (EditTFCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"EditTFCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    
    cell.baseView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.baseView.layer.borderWidth = 1.0f;
    [cell.btnToggleCategory addTarget:self action:@selector(onClickToggleCategory:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnToggleCategory setTag:indexPath.row];
    NSString *tipName = [_numOfTF objectAtIndex:indexPath.section];
    
    NSDictionary *TFDetailsDict = [[_allMyTFDetailDict valueForKey:tipName] objectAtIndex:indexPath.row];
    
    [cell.lblTitle setFont:[UIFont systemFontOfSize:14.0f]];
    [cell.lblTitle setNumberOfLines:0];
    [cell.lblTitle sizeToFit];
    cell.lblTitle.text = [TFDetailsDict valueForKey:@"category"];
    
    return cell;
}

-(void)toggleCategoryImage:(BOOL)isSelected andCell:(EditTFCell *)cell
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
    EditTFCell *cell = (EditTFCell *)[self.tableViewOutlet cellForRowAtIndexPath:indexPath];
    if (indexPath != nil)
    {
        [self toggleCategoryImage:YES andCell:cell];
    }
    
    /*NSDictionary *TFDetailsDict = [allTFArray objectAtIndex:indexPath.section-1];
    // NSPredicate *predicate = [ NSPredicate predicateWithFormat:[NSString stringWithFormat:@"self.TFTypeID == %d",[[TFDetailsDict valueForKey:@"ID"] intValue]]];
    
    //    NSDictionary *categoryDetails =  [[allTFCategoriesArray filteredArrayUsingPredicate:predicate] objectAtIndex:indexPath.row];
    
    NSMutableArray *sortArray = [NSMutableArray new];
    for(NSDictionary *categoriesDict in allTFCategoriesArray) {
        
        if ([[categoriesDict valueForKey:@"TFTypeID"] isEqualToString:[TFDetailsDict valueForKey:@"ID"]]) {
            [sortArray addObject:categoriesDict];
            
        }
    }
    
    NSDictionary *categoryDetails =  [sortArray objectAtIndex:indexPath.row];
    if ([selectedCategories containsObject:categoryDetails]) {
        
        [self deleteMyTF:categoryDetails];
    }
    else
    {
        [self insertMyTF:categoryDetails];
    }*/
}

#pragma mark Database Transaction
-(NSMutableDictionary *)gettingMyTF
{
    NSString *query = @"select * from My_TF";
    
    NSArray *allMyTF=[NSArray arrayWithArray:[self.dbManager loadDataFromDB:query]];
    
    return [self setAllTFDetails:allMyTF];
}
-(NSMutableDictionary *)setAllTFDetails:(NSArray *)allMyTF
{
    NSMutableArray *allFilteredTFArray = [NSMutableArray new];
    NSString *queryForTF = @"select * from Plan_TF_Types";
    NSString *queryForTFCategpries = @"select * from Plan_TF_Types_Cateogories";
    
    NSArray *allTF=[NSArray arrayWithArray:[self.dbManager loadDataFromDB:queryForTF]];
    NSArray *allTFCotegories=[NSArray arrayWithArray:[self.dbManager loadDataFromDB:queryForTFCategpries]];
    
    for (NSDictionary *myTF in allMyTF) {
        NSString *tipeID = [myTF valueForKey:@"TFTypeID"];
        NSString  *tipeCatId = [myTF valueForKey:@"TFTypeCategoryID"];
        //        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF.TFTypeID ==%@ AND SELF.ID == %@",[myTF valueForKey:@"TFTypeID"],[ myTF valueForKey:@"TFTypeCategoryID"]]];
        //
        //        NSArray *filteredArray = [allTFCotegories filteredArrayUsingPredicate:predicate ];
        
        NSDictionary *catDetails;
        
        for(NSDictionary *TFcategories in allTFCotegories){
            if ([tipeCatId isEqualToString:[TFcategories valueForKey:@"ID"]] && [ tipeID isEqualToString:[TFcategories valueForKey:@"TFTypeID"]]) {
                
                catDetails = TFcategories;
                break;
            }
        }
        
        if (catDetails != nil) {
            
            NSString *tID = [myTF valueForKey:@"TFTypeID"];
            
            //            NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"self.ID == %@",tID]];
            //            NSArray *TFArray = [allTF filteredArrayUsingPredicate:predicate];
            NSDictionary *gotTip;
            
            for (NSDictionary *tipDict in allTF){
                
                if([tID isEqualToString:[tipDict valueForKey:@"ID"]])
                {
                    gotTip = tipDict;
                }
            }
            
            if (gotTip != nil) {
                
                
                NSString *strTipName = [gotTip valueForKey:@"TFTypeName"];
                NSNumber *TFID = [NSNumber numberWithInt:[[gotTip valueForKey:@"ID"] intValue]];
                
                NSString *strTipCategoryText = [catDetails valueForKey:@"TFText"];
                NSNumber *myTFID = [NSNumber numberWithInt:[[myTF valueForKey:@"ID"] intValue]];
                
                NSDictionary *TFDetailDict = [ NSDictionary dictionaryWithObjects:@[myTFID,TFID,strTipName,strTipCategoryText] forKeys:@[@"ID",@"TFID",@"tip",@"category"]];
                
                
                [allFilteredTFArray addObject:TFDetailDict];
                
            }
            
        }
        
        
        
    }
    
    
    NSMutableDictionary *welfilteredTF = [NSMutableDictionary new];
    
    for (NSDictionary *myFilteredTF in allFilteredTFArray)
    {
        if (![[welfilteredTF allKeys] containsObject:[myFilteredTF valueForKey:@"tip"]]) {
            
            
            NSNumber *TFId = [myFilteredTF valueForKey:@"TFID"];
            
            //                NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"self.TFID == %d",[TFId intValue]]];
            //
            //                NSArray *filterArray = [allFilteredTFArray  filteredArrayUsingPredicate:predicate];
            NSMutableArray *filterArray = [NSMutableArray new];
            for (NSDictionary *fetchDict in allFilteredTFArray)
            {
                if ([TFId intValue] == [[fetchDict valueForKey:@"TFID"] intValue])
                {
                    [filterArray addObject:fetchDict];
                    
                }
                
            }
            
            if (filterArray.count > 0) {
                [welfilteredTF setValue:filterArray forKey:[myFilteredTF valueForKey:@"tip"]];
                
            }
            
        }
        
        
    }
    
    return welfilteredTF;
    
}



@end
