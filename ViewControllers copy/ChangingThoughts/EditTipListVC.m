//
//  EditTipListVC.m
//  TinnitusCoach
//
//  Created by Jiten on 02/05/15.
//  Copyright (c) 2015 Swipe Video Labs Pvt Ltd. All rights reserved.
//

#define UN_SELECTED_IMAGE @"u630.png"
#define SELECTED_IMAGE @"u648.png"

#import "EditTipListVC.h"
#import "EditTipsCell.h"
#import "PersistenceStorage.h"


@interface EditTipListVC () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *allTipsArray, *allTipsCategoriesArray,*allMyTips;
    
    NSMutableSet *sectionViewArray;
    NSMutableArray *selectedCategories,*tempSelectedCategories;
//    NSMutableArray *selectedIndexes;
    
}
@property(nonatomic,strong)DBManager *dbManager;
@end

@implementation EditTipListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Edit Tip List"];
    
    sectionViewArray = [NSMutableSet set];
    
    // Do any additional setup after loading the view.
    self.dbManager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    allTipsArray = [NSArray arrayWithArray:[self getPlanTipesType]];
    allTipsCategoriesArray = [ NSArray arrayWithArray:[self getPlanTipsTypeCategory]];
   // [self.tableViewOutlet reloadData];
    selectedCategories = [NSMutableArray arrayWithArray:[self getSelectedTips]];
    tempSelectedCategories = [ NSMutableArray arrayWithArray:selectedCategories];

    [self.tableViewOutlet setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//UIVIEW Helper
-(UIView *)headerViewWith:(NSString *)aTitle andDescription:(NSString *)aDescription andIndexpath:(NSInteger)index
{
#define DEFAULT_HEIGHT_LABEL 21
#define V_PADDING 5
#define AVALABLE_TIPS @"Available Tips"
    
#define X_POs 10
    
    CGRect frame = self.tableViewOutlet.frame;

    if(index == 0)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewOutlet.frame.size.width, 20)];
        [view setBackgroundColor:[UIColor clearColor]];
        
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, frame.size.width-20, DEFAULT_HEIGHT_LABEL)];
        [lblTitle setBackgroundColor:[UIColor clearColor]];
        [lblTitle setText:AVALABLE_TIPS];
        [lblTitle setFont:[UIFont boldSystemFontOfSize:16]];
        [view addSubview:lblTitle];
        
        CGRect frame = view.frame;
        frame.size.height = 41;
        
        return view;
    }
    else if (index == [allTipsArray count]+1)
    {
        CGRect frame = self.tableViewOutlet.frame;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewOutlet.frame.size.width, 20)];
        [view setBackgroundColor:[UIColor clearColor]];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(100, 10, frame.size.width-200, 30)];
        [btn setTitle:@"Save" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:31.0/255.0 green:96.0/255.0 blue:248.0/255.0 alpha:1]];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        btn.layer.cornerRadius = 3.0f;
        [btn addTarget:self action:@selector(onClickSaveButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setTextColor:[UIColor whiteColor]];
        [view addSubview:btn];
        
        frame = view.frame;
        frame.size.height = 50;
        
        return view;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewOutlet.frame.size.width, 5)];
    [view setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1]];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(X_POs, 5, frame.size.width-20, DEFAULT_HEIGHT_LABEL)];
    [lblTitle setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1]];
    [lblTitle setText:aTitle];
    [lblTitle setFont:[UIFont boldSystemFontOfSize:15]];
    [view addSubview:lblTitle];
    
    float y_Pos = lblTitle.frame.origin.y + lblTitle.frame.size.height + V_PADDING;
    
    UILabel *lblDesc = [[UILabel alloc] initWithFrame:CGRectMake(X_POs, y_Pos, frame.size.width-20, 22)];
    [lblDesc setBackgroundColor:[UIColor clearColor]];
    [lblDesc setNumberOfLines:2];
    [lblDesc setFont:[UIFont systemFontOfSize:14]];
    [lblDesc setText:aDescription];
    [view addSubview:lblDesc];
    
    y_Pos = lblDesc.frame.origin.y + lblDesc.frame.size.height + V_PADDING;
    
    UIButton *btnToggleHeader = [UIButton buttonWithType:UIButtonTypeCustom];
    btnToggleHeader.frame = CGRectMake(frame.size.width-(10+25), 5, 25, 25);
    [btnToggleHeader addTarget:self action:@selector(onClickToggleHeader:) forControlEvents:UIControlEventTouchUpInside];
    [btnToggleHeader setBackgroundColor:[UIColor clearColor]];
    btnToggleHeader.tag = index;
    
    if([sectionViewArray containsObject:[NSNumber numberWithInteger:index]])
    {
        [btnToggleHeader setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];
    }
    else
    {
        [btnToggleHeader setImage:[UIImage imageNamed:@"upArrow"] forState:UIControlStateNormal];
    }
    
    
    [view addSubview:btnToggleHeader];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, y_Pos, frame.size.width, 1)];
    [img setBackgroundColor:[UIColor whiteColor]];
    img.tag = index;
    [view addSubview:img];
    
    CGRect viewFrame = view.frame;
    viewFrame.size.height = y_Pos+1;//lblDesc.frame.size.height+lblDesc.frame.origin.y+10;
    view.frame = viewFrame;
    view.tag = index;
    return view;
}

-(void)onClickSaveButton:(id)sender
{
    
    for (NSDictionary *categoryDetailsDict in selectedCategories)
    {
        if (![tempSelectedCategories containsObject:categoryDetailsDict])
        {
            [self insertMyTips:categoryDetailsDict];
        }
        else
        {
            [tempSelectedCategories removeObject:categoryDetailsDict];
        }
    }
    
    
    for (NSDictionary *catDict in tempSelectedCategories) {
        [self deleteMyTips:catDict];
    }
    if ([self.delegate respondsToSelector:@selector(didSaveTips)]) {
        [self.delegate didSaveTips];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 41;
    else if (section == [allTipsArray count] +1)
        return 50;
    NSDictionary *tipsDetailsDict = [allTipsArray objectAtIndex:section-1];
    
    return [self headerViewWith:[tipsDetailsDict valueForKey:@"tipsTypeName"] andDescription:[tipsDetailsDict valueForKey:@"tipsTypeDesc"] andIndexpath:section].frame.size.height;
}

-(IBAction)onClickToggleHeader:(id)sender
{
    UIButton *btnHeader = (UIButton *)sender;
    
    UIView *view = [btnHeader superview];
    
    UIImageView *img = (UIImageView*)[view viewWithTag:btnHeader.tag];
    
    NSInteger tag;
    if(btnHeader.tag)
     tag = btnHeader.tag;
    else
        tag=0;
    
        if([sectionViewArray containsObject:[NSNumber numberWithInteger:tag]])
        {
            [btnHeader setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];
            [img setHidden:YES];
            [sectionViewArray removeObject:[NSNumber numberWithInteger:tag]];
        }
        else
        {
            [btnHeader setImage:[UIImage imageNamed:@"upArrow"] forState:UIControlStateNormal];
            [img setHidden:NO];
            [sectionViewArray addObject:[NSNumber numberWithInteger:tag]];
        }
        
        NSRange range = NSMakeRange(btnHeader.tag, 1);
        NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.tableViewOutlet reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [allTipsArray count]+2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0 || section == [allTipsArray count]+1)
    {
        return [self headerViewWith:@"tipsTypeName" andDescription:@"tipsTypeDesc" andIndexpath:section];
    }
    
    NSDictionary *tipsDetailsDict = [allTipsArray objectAtIndex:section-1];

    return [self headerViewWith:[tipsDetailsDict valueForKey:@"tipsTypeName"] andDescription:[tipsDetailsDict valueForKey:@"tipsTypeDesc"] andIndexpath:section];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0 || section == [allTipsArray count] +1)
        return 0;
    
    if([sectionViewArray containsObject:[NSNumber numberWithInteger:section]])
    {
        return 0;
    }
    
    NSDictionary *tipsDetailsDict = [allTipsArray objectAtIndex:section-1];
    NSPredicate *predicate = [ NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF.tipsTypeID == %@",[tipsDetailsDict valueForKey:@"ID"]]];
    NSArray *filterArray = [allTipsCategoriesArray filteredArrayUsingPredicate:predicate];
    
     NSDictionary *dict = [allTipsCategoriesArray objectAtIndex:0];
    
    NSMutableArray *sortArray = [NSMutableArray new];
    for(NSDictionary *categoriesDict in allTipsCategoriesArray) {
        
        if ([[categoriesDict valueForKey:@"tipsTypeID"] isEqualToString:[tipsDetailsDict valueForKey:@"ID"]]) {
            [sortArray addObject:categoriesDict];
            
        }
    }
    
    return [sortArray count];
    
   // return 4;
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
    
    NSDictionary *tipsDetailsDict = [allTipsArray objectAtIndex:indexPath.section-1];
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
        
//        [self onClickToggleCategory:cell.btnToggleCategory];
        [self toggleCategoryImage:YES andCell:cell];

    }
    cell.lblTitle.text = [categoryDetails valueForKey:@"tipsText"];

    return cell;
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
    
    NSDictionary *tipsDetailsDict = [allTipsArray objectAtIndex:indexPath.section-1];
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
        
//       [self deleteMyTips:categoryDetails];
        [selectedCategories removeObject:categoryDetails];
    }
    else
    {
//        [self insertMyTips:categoryDetails];
        [selectedCategories addObject:categoryDetails];
    }
    [_tableViewOutlet reloadData];
}

#pragma mark Database Transaction
#pragma mark - Getting plan tips types
-(NSArray *)getPlanTipesType
{
    NSString *query = @"select * from Plan_Tips_Types";
    
    return [self.dbManager loadDataFromDB:query];
    
    
}

-(NSArray *)getPlanTipsTypeCategory
{
    NSString *query = @"select * from Plan_Tips_Types_Cateogories";
    
    return [self.dbManager loadDataFromDB:query];


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

-(NSArray *)getSelectedTips
{
    
    NSString *myTipsQuery = @"select * from My_Tips";
    NSArray *myTipsArray = [self.dbManager loadDataFromDB:myTipsQuery];
    
    allMyTips = [NSArray arrayWithArray:myTipsArray];
    NSMutableArray *selectedArray = [NSMutableArray new];
    for(NSDictionary *tipsDict in myTipsArray)
    {
//        tipsTypeID tipsTypeCategoryID
        
        
        for(NSDictionary *tipsCategory in allTipsCategoriesArray) {
            
            if ([[tipsCategory valueForKey:@"tipsTypeID"] isEqualToString:[tipsDict valueForKey:@"tipsTypeID"]] && [[ tipsCategory valueForKey:@"ID"] isEqualToString:[tipsDict valueForKey:@"tipsTypeCategoryID"]]) {
                
                [selectedArray addObject:tipsCategory];
            }
        }
    
    }
    
    return selectedArray;
}

#pragma mark add myTips
-(void)insertMyTips:(NSDictionary*)selectedTipsCategories
{
    int planID = (int)[PersistenceStorage getIntegerForKey:@"currentPlanID"];
    int skillID = (int)[PersistenceStorage getIntegerForKey:@"currentSkillID"];
    int grouID = (int)[PersistenceStorage getIntegerForKey:@"currentGroupID"];
    
    
    NSString *inserQquery = [NSString stringWithFormat:@"insert into My_Tips (planID,groupID,skillID,tipsTypeID,tipsTypeCategoryID) values(%d,%d,%d,%d,%d)",planID,grouID,skillID,[[selectedTipsCategories valueForKey:@"tipsTypeID"] intValue],[[selectedTipsCategories valueForKey:@"ID"] intValue]];
    
    // Execute the query.
    [self.dbManager executeQuery:inserQquery];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        
        // Pop the view controller.
    }
    else{
        NSLog(@"Could not execute the query.");
    }
    
//    [selectedCategories removeAllObjects];
//    [selectedCategories addObjectsFromArray:[self getSelectedTips]];
//    [_tableViewOutlet reloadData];
}

#pragma mark - deletingMyTips
-(void)deleteMyTips:(NSDictionary*)selectedTipsCategories
{
    NSString *ID;
    
    for(NSDictionary *tipsDict in allMyTips)
    {
        //        tipsTypeID tipsTypeCategoryID
        
        
       
            
            if ([[selectedTipsCategories valueForKey:@"tipsTypeID"] isEqualToString:[tipsDict valueForKey:@"tipsTypeID"]] && [[selectedTipsCategories valueForKey:@"ID"] isEqualToString:[tipsDict valueForKey:@"tipsTypeCategoryID"]]) {
                
                ID = [tipsDict valueForKey:@"ID"];
            }
        
        
    }

    
    NSString *deleteQquery = [NSString stringWithFormat:@"delete from My_Tips where ID=%@",ID];
    
 
    
    
    // Execute the query.
    [self.dbManager executeQuery:deleteQquery];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        
        // Pop the view controller.
    }
    else{
        NSLog(@"Could not execute the query.");
    }
    
//    [selectedCategories removeAllObjects];
//    [selectedCategories addObjectsFromArray:[self getSelectedTips]];
//    [_tableViewOutlet reloadData];
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
