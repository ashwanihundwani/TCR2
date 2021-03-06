//
 //  TinnitusCoach
//
 //  Copyright (c) 2015 Creospan. All rights reserved.
//

#define UN_SELECTED_IMAGE @"whitecircle.png"
#define SELECTED_IMAGE @"whitecircle.png"

#import "CTFRatingsViewController.h"
#import "EditTFListVC.h"
#import "EditTFCell.h"
#import "PersistenceStorage.h"


@interface EditTFListVC () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *allTFArray, *allTFCategoriesArray,*allMyTF;
    
    NSMutableSet *sectionViewArray;
    NSMutableArray *selectedCategories,*tempSelectedCategories;
//    NSMutableArray *selectedIndexes;
    
}
@property(nonatomic,strong)DBManager *dbManager;
@end

@implementation EditTFListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Edit Thoughts List"];
    self.dbManager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
        sectionViewArray = [NSMutableSet set];
    
    
    allTFArray = [NSArray arrayWithArray:[self getPlanTFType]];
    allTFCategoriesArray = [ NSArray arrayWithArray:[self getPlanTFTypeCategory]];
   // [self.tableViewOutlet reloadData];
    selectedCategories = [NSMutableArray arrayWithArray:[self getSelectedTF]];
    tempSelectedCategories = [ NSMutableArray arrayWithArray:selectedCategories];

    [self.tableViewOutlet setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
 
}

-(void)viewDidAppear:(BOOL)animated
{
    
    if ([[PersistenceStorage getObjectForKey:@"EditTFMode"] isEqual: @"Off"])
    {
        
        [PersistenceStorage setObject:@"On" andKey:@"EditTFMode"];
        [self dismissModalViewControllerAnimated:YES];

        
    }

    
    allTFArray = [NSArray arrayWithArray:[self getPlanTFType]];
    allTFCategoriesArray = [ NSArray arrayWithArray:[self getPlanTFTypeCategory]];
    // [self.tableViewOutlet reloadData];
    selectedCategories = [NSMutableArray arrayWithArray:[self getSelectedTF]];
    tempSelectedCategories = [ NSMutableArray arrayWithArray:selectedCategories];
    
    [self.tableViewOutlet setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{    [self collapseList:nil];
}

 /*
    
    // Do any additional setup after loading the view.
    selectedCategories = [NSMutableArray arrayWithArray:[self getSelectedTF]];
    tempSelectedCategories = [ NSMutableArray arrayWithArray:selectedCategories];
//[self.tableViewOutlet reloadData];
  //  NSLog(@"%@",allTFCategoriesArray);
    
    
    
    
    
 
    
    for (NSDictionary *categoryDetailsDict in selectedCategories)
    {
        if (![tempSelectedCategories containsObject:categoryDetailsDict])
        {
            [self insertMyTF:categoryDetailsDict];
        }
        else
        {
            [tempSelectedCategories removeObject:categoryDetailsDict];
        }
    }
    
    
    for (NSDictionary *catDict in tempSelectedCategories) {
        [self deleteMyTF:catDict];
    }

*/

//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//UIVIEW Helper
-(UIView *)headerViewWith:(NSString *)aTitle andDescription:(NSString *)aDescription andIndexpath:(NSInteger)index
{
#define DEFAULT_HEIGHT_LABEL 21
#define V_PADDING 5
#define AVALABLE_TF @"Select Emotion(s)"
    
#define X_POs 10
    
    CGRect frame = self.tableViewOutlet.frame;

    if(index == 0)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewOutlet.frame.size.width, 20)];
        [view setBackgroundColor:[UIColor clearColor]];
        
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, frame.size.width-20, DEFAULT_HEIGHT_LABEL)];
        [lblTitle setBackgroundColor:[UIColor clearColor]];
        [lblTitle setText:AVALABLE_TF];
        [lblTitle setFont:[UIFont boldSystemFontOfSize:16]];
        [view addSubview:lblTitle];
        
        CGRect frame = view.frame;
        frame.size.height = 32;
        
        return view;
    }
    else if (index == [allTFArray count]+1)
    {
//NSLog(@"%@",index);
        CGRect frame = self.tableViewOutlet.frame;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewOutlet.frame.size.width, 25)];
        [view setBackgroundColor:[UIColor clearColor]];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(100, 10, frame.size.width-200, 30)];
        [btn setTitle:@"Save" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
        btn.layer.cornerRadius = 3.0f;
        [btn addTarget:self action:@selector(onClickSaveButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setTextColor:[UIColor whiteColor]];
    //    [view addSubview:btn];  DID NOT ADD BUTTON
        
        frame = view.frame;
        frame.size.height = 50;
        
        return view;
    }

    
    
     
    
    
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewOutlet.frame.size.width, 5)];
    [view setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1]];
    
    

    
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(X_POs, 5, frame.size.width-20, DEFAULT_HEIGHT_LABEL)];
    [lblTitle setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1]];
    [lblTitle setText:aTitle];
//    [lblTitle addTarget:self action:@selector(onClickToggleHeader:) forControlEvents:UIControlEventTouchUpInside];

    
    
    
//    [lblTitle addTarget:self action:@selector(onClickToggleHeader:) forControlEvents:UIControlEventTouchUpInside];

    [lblTitle setFont:[UIFont boldSystemFontOfSize:15]];
    [view addSubview:lblTitle];
    
    float y_Pos = lblTitle.frame.origin.y + lblTitle.frame.size.height + V_PADDING;
    
    UILabel *lblDesc = [[UILabel alloc] initWithFrame:CGRectMake(X_POs, y_Pos, frame.size.width-20, 22)];
    [lblDesc setBackgroundColor:[UIColor clearColor]];
    [lblDesc setNumberOfLines:2];
    [lblDesc setFont:[UIFont systemFontOfSize:14]];
    [lblDesc setText:aDescription];
  //  [lblDesc addTarget:self action:@selector(onClickToggleHeader:) forControlEvents:UIControlEventTouchUpInside];
   // [lblDesc addTarget:self action:@selector(onClickToggleHeader:) forControlEvents:UIControlEventTouchUpInside];

    
    
    [view addSubview:lblDesc];
    
    y_Pos = lblDesc.frame.origin.y + lblDesc.frame.size.height + V_PADDING;
    
    UIButton *btnToggleHeader = [UIButton buttonWithType:UIButtonTypeCustom];
    btnToggleHeader.frame = CGRectMake(frame.size.width-75, 3, 68, 32);
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

- (IBAction)cancelTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}




-(IBAction)ClickSaveButton:(id)sender
{

    for (NSDictionary *categoryDetailsDict in selectedCategories)
    {
        if (![tempSelectedCategories containsObject:categoryDetailsDict])
        {
            [self insertMyTF:categoryDetailsDict];
        }
        else
        {
            [tempSelectedCategories removeObject:categoryDetailsDict];
        }
    }
    
    
    
    
    
    
    
    for (NSDictionary *catDict in tempSelectedCategories) {
        [self deleteMyTF:catDict];
    }
    if ([self.delegate respondsToSelector:@selector(didSaveTF)]) {
        [self.delegate didSaveTF];
    }
    
    
    NSString *myTFQuery = @"select * from My_TF";
//    [PersistenceStorage setObject:@"No emotions selected" andKey:@"thoughtList"];
    
    NSArray *myTFArray = [self.dbManager loadDataFromDB:myTFQuery];
    //NSMutableString *thoughtList =[NSMutableString stringWithString:@""];
    //NSLog(@"%@",thoughtList);
    
    //[thoughtList setString:@""];
    
    allMyTF = [NSArray arrayWithArray:myTFArray];
    NSMutableArray *selectedArray = [NSMutableArray new];
    for(NSDictionary *TFDict in myTFArray)
    {
        //        TFTypeID TFTypeCategoryID
        
        
        for(NSDictionary *TFCategory in allTFCategoriesArray) {
            
            if ([[TFCategory valueForKey:@"thoughtsTypeID"] isEqualToString:[TFDict valueForKey:@"thoughtTypeID"]] && [[ TFCategory valueForKey:@"ID"] isEqualToString:[TFDict valueForKey:@"thoughtTypeCategoryID"]]) {
                // NSLog(@"%@",[TFCategory valueForKey:@"thoughtTypeID"]);
                [selectedArray addObject:TFCategory];
//                [thoughtList appendString:[TFCategory valueForKey:@"thoughtsText"]];
  //              [thoughtList appendString:@","];
    //            NSLog(@"%@",thoughtList);
      //          [PersistenceStorage setObject:thoughtList andKey:@"thoughtList"];
                
                
            }
        }
        
    }
    
    [PersistenceStorage setObject:@"On" andKey:@"EditTFMode"];
    [self dismissModalViewControllerAnimated:YES];
}






-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 41;
    else if (section == [allTFArray count] +1)
        return 50;
    NSDictionary *TFDetailsDict = [allTFArray objectAtIndex:section-1];
    
    return [self headerViewWith:[TFDetailsDict valueForKey:@"thoughtTypeName"] andDescription:[TFDetailsDict valueForKey:@"thoughtTypeDesc"] andIndexpath:section].frame.size.height;
}

-(IBAction)onClickToggleHeader:(id)sender
{
    NSLog(@"I am here");
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
            
        //    NSLog(@"%f",[NSNumber numberWithInteger:tag]);
            
        }
        else
        {
            [btnHeader setImage:[UIImage imageNamed:@"upArrow"] forState:UIControlStateNormal];
            [img setHidden:NO];
            [sectionViewArray addObject:[NSNumber numberWithInteger:tag]];
        }

    // [sectionViewArray addObject:[NSNumber numberWithInteger:2]];

    
        NSRange range = NSMakeRange(btnHeader.tag, 1);
        NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.tableViewOutlet reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationAutomatic];
}


-(IBAction)collapseList:(id)sender
{
    UIButton *btnHeader = (UIButton *)sender;
    
    UIView *view = [btnHeader superview];
    
    UIImageView *img = (UIImageView*)[view viewWithTag:btnHeader.tag];

    
    
    NSInteger tag;
    
    
    [sectionViewArray addObject:[NSNumber numberWithInteger:1]];
    NSRange range1 = NSMakeRange(1, 1);
    NSIndexSet *sectionToReload1 = [NSIndexSet indexSetWithIndexesInRange:range1];
    [self.tableViewOutlet reloadSections:sectionToReload1 withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
     [sectionViewArray addObject:[NSNumber numberWithInteger:2]];
      NSRange range2 = NSMakeRange(2, 1);
    NSIndexSet *sectionToReload2 = [NSIndexSet indexSetWithIndexesInRange:range2];
    [self.tableViewOutlet reloadSections:sectionToReload2 withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [sectionViewArray addObject:[NSNumber numberWithInteger:3]];
    NSRange range3 = NSMakeRange(3, 1);
    NSIndexSet *sectionToReload3 = [NSIndexSet indexSetWithIndexesInRange:range3];
    [self.tableViewOutlet reloadSections:sectionToReload3 withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [sectionViewArray addObject:[NSNumber numberWithInteger:4]];
    NSRange range4 = NSMakeRange(4, 1);
    NSIndexSet *sectionToReload4 = [NSIndexSet indexSetWithIndexesInRange:range4];
    [self.tableViewOutlet reloadSections:sectionToReload4 withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [sectionViewArray addObject:[NSNumber numberWithInteger:5]];
    NSRange range5 = NSMakeRange(5, 1);
    NSIndexSet *sectionToReload5 = [NSIndexSet indexSetWithIndexesInRange:range5];
    [self.tableViewOutlet reloadSections:sectionToReload5 withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [sectionViewArray addObject:[NSNumber numberWithInteger:6]];
    NSRange range6 = NSMakeRange(6, 1);
    NSIndexSet *sectionToReload6 = [NSIndexSet indexSetWithIndexesInRange:range6];
    [self.tableViewOutlet reloadSections:sectionToReload6 withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
    
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [allTFArray count]+2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0 || section == [allTFArray count]+1)
    {
        return [self headerViewWith:@"thoughtTypeName" andDescription:@"thoughtTypeDesc" andIndexpath:section];
    }
    
    NSDictionary *TFDetailsDict = [allTFArray objectAtIndex:section-1];

    return [self headerViewWith:[TFDetailsDict valueForKey:@"thoughtTypeName"] andDescription:[TFDetailsDict valueForKey:@"thoughtTypeDesc"] andIndexpath:section];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0 || section == [allTFArray count] +1)
        return 0;
    
    if([sectionViewArray containsObject:[NSNumber numberWithInteger:section]])
    {
        return 0;
    }
    
    NSDictionary *TFDetailsDict = [allTFArray objectAtIndex:section-1];
    NSPredicate *predicate = [ NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF.thoughtsTypeID == %@",[TFDetailsDict valueForKey:@"ID"]]];
    NSArray *filterArray = [allTFCategoriesArray filteredArrayUsingPredicate:predicate];
    
     NSDictionary *dict = [allTFCategoriesArray objectAtIndex:0];
    
    NSMutableArray *sortArray = [NSMutableArray new];
    for(NSDictionary *categoriesDict in allTFCategoriesArray) {
        
        if ([[categoriesDict valueForKey:@"thoughtsTypeID"] isEqualToString:[TFDetailsDict valueForKey:@"ID"]]) {
            [sortArray addObject:categoriesDict];
            
        }
    }
    
    
    [sectionViewArray removeObject:[NSNumber numberWithInteger:section]];

    
    return [sortArray count];
    
   // return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    EditTFCell *cell = (EditTFCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"EditTFCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    
    [cell.btnToggleCategory addTarget:self action:@selector(onClickToggleCategory:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnToggleCategory setTag:indexPath.row];
    
    NSDictionary *TFDetailsDict = [allTFArray objectAtIndex:indexPath.section-1];
   // NSPredicate *predicate = [ NSPredicate predicateWithFormat:[NSString stringWithFormat:@"self.TFTypeID == %d",[[TFDetailsDict valueForKey:@"ID"] intValue]]];
    
//    NSDictionary *categoryDetails =  [[allTFCategoriesArray filteredArrayUsingPredicate:predicate] objectAtIndex:indexPath.row];
    
    NSMutableArray *sortArray = [NSMutableArray new];
    for(NSDictionary *categoriesDict in allTFCategoriesArray) {
        
        if ([[categoriesDict valueForKey:@"thoughtsTypeID"] isEqualToString:[TFDetailsDict valueForKey:@"ID"]]) {
            [sortArray addObject:categoriesDict];
            
        }
    }

    NSDictionary *categoryDetails =  [sortArray objectAtIndex:indexPath.row];
    
    if ([selectedCategories containsObject:categoryDetails]) {
        
//        [self onClickToggleCategory:cell.btnToggleCategory];
        [self toggleCategoryImage:YES andCell:cell];

    }
    cell.lblTitle.text = [categoryDetails valueForKey:@"thoughtsText"];

    return cell;
}

-(void)onClickToggleCategory:(id)sender
{
    NSLog(@"Inside onClickToggleCategory");
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableViewOutlet];
    NSIndexPath *indexPath = [self.tableViewOutlet indexPathForRowAtPoint:buttonPosition];
    EditTFCell *cell = (EditTFCell *)[self.tableViewOutlet cellForRowAtIndexPath:indexPath];
    if (indexPath != nil)
    {
        [self toggleCategoryImage:YES andCell:cell];
    }
    
    NSDictionary *TFDetailsDict = [allTFArray objectAtIndex:indexPath.section-1];
    // NSPredicate *predicate = [ NSPredicate predicateWithFormat:[NSString stringWithFormat:@"self.TFTypeID == %d",[[TFDetailsDict valueForKey:@"ID"] intValue]]];
    
    //    NSDictionary *categoryDetails =  [[allTFCategoriesArray filteredArrayUsingPredicate:predicate] objectAtIndex:indexPath.row];
    
    NSMutableArray *sortArray = [NSMutableArray new];
    for(NSDictionary *categoriesDict in allTFCategoriesArray) {
        
        if ([[categoriesDict valueForKey:@"thoughtsTypeID"] isEqualToString:[TFDetailsDict valueForKey:@"ID"]]) {
            [sortArray addObject:categoriesDict];
            
        }
    }
    
    NSDictionary *categoryDetails =  [sortArray objectAtIndex:indexPath.row];
    if ([selectedCategories containsObject:categoryDetails]) {
        
//       [self deleteMyTF:categoryDetails];
        [selectedCategories removeObject:categoryDetails];
    }
    else
    {
//        [self insertMyTF:categoryDetails];
        [selectedCategories addObject:categoryDetails];
    }
    
    NSLog(@"%@",[categoryDetails valueForKey:@"thoughtsText"]);
    
    [PersistenceStorage setObject:[categoryDetails valueForKey:@"thoughtsText"] andKey:@"emotionName"];

    
    [_tableViewOutlet reloadData];
    
    
    

    
//NSLog(@"%@",indexPath.length);
    
}

#pragma mark Database Transaction
#pragma mark - Getting plan TF types
-(NSArray *)getPlanTFType
{
    NSString *query = @"select * from Plan_TF_Types";
    
    return [self.dbManager loadDataFromDB:query];
    
    
}

-(NSArray *)getPlanTFTypeCategory
{
    NSString *query = @"select * from Plan_TF_Types_Cateogories";
 //   NSLog(@"%@", [self.dbManager loadDataFromDB:query]);
    return [self.dbManager loadDataFromDB:query];


}

-(void)toggleCategoryImage:(BOOL)isSelected andCell:(EditTFCell *)cell
{
    if([cell.imgCategory.image isEqual:[UIImage imageNamed:SELECTED_IMAGE]])
    {
        [cell.imgCategory setImage:[UIImage imageNamed:UN_SELECTED_IMAGE]];
    }
    else
    {
            [PersistenceStorage setObject:@"Off" andKey:@"EditTFMode"];

        
        [cell.imgCategory setImage:[UIImage imageNamed:SELECTED_IMAGE]];
        CTFRatingsViewController *addvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CTFRatingsViewController"];
        
        
        [self presentModalViewController:addvc animated:YES];
    }
}

-(NSArray *)getSelectedTF
{
    
    NSString *myTFQuery = @"select * from My_TF";
    NSArray *myTFArray = [self.dbManager loadDataFromDB:myTFQuery];
    // NSMutableString *thoughtList =[NSMutableString stringWithString:@""];
    allMyTF = [NSArray arrayWithArray:myTFArray];
    NSMutableArray *selectedArray = [NSMutableArray new];
    for(NSDictionary *TFDict in myTFArray)
    {
//        TFTypeID TFTypeCategoryID
        
        
        for(NSDictionary *TFCategory in allTFCategoriesArray) {
            
            if ([[TFCategory valueForKey:@"thoughtsTypeID"] isEqualToString:[TFDict valueForKey:@"thoughtTypeID"]] && [[ TFCategory valueForKey:@"ID"] isEqualToString:[TFDict valueForKey:@"thoughtTypeCategoryID"]]) {
               // NSLog(@"%@",[TFCategory valueForKey:@"thoughtTypeID"]);
                [selectedArray addObject:TFCategory];
                
                
                
                
                
//                [thoughtList appendString:[TFCategory valueForKey:@"thoughtsText"]];
  //              [thoughtList appendString:@","];
           //     NSLog(@"%@",thoughtList);
                
            }
        }
    
    }
  //  [PersistenceStorage setObject:thoughtList andKey:@"thoughtList"];
    
    

 //   NSLog(@"%@",selectedArray);
    
    
    
    return selectedArray;
}

#pragma mark add myTF
-(void)insertMyTF:(NSDictionary*)selectedTFCategories
{
    int planID = (int)[PersistenceStorage getIntegerForKey:@"currentPlanID"];
    int skillID = (int)[PersistenceStorage getIntegerForKey:@"currentSkillID"];
    int grouID = (int)[PersistenceStorage getIntegerForKey:@"currentGroupID"];
    
    
    
    
    
    NSString *deleteQuery = [NSString stringWithFormat:@"delete from My_TF  where  thoughtCategory = 'step3' and planID = %d and thoughtText='%@'",planID,[selectedTFCategories valueForKey:@"thoughtsText"]];
    
                              NSLog(@"%@",deleteQuery);
    
                              [self.dbManager executeQuery:deleteQuery];

                              
                              
    NSString *inserQquery = [NSString stringWithFormat:@"insert into My_TF (planID,groupID,skillID,thoughtTypeID,thoughtTypeCategoryID,thoughtText,rating,thoughtCategory) values(%d,%d,%d,%d,%d,'%@',%d)",planID,grouID,skillID,[[selectedTFCategories valueForKey:@"thoughtsTypeID"] intValue],[[selectedTFCategories valueForKey:@"ID"] intValue],[selectedTFCategories valueForKey:@"thoughtsText"],3];
    
    
//    [selectedTipsCategories valueForKey:@"ID"]
  
    
    NSLog(@"%@",inserQquery);
    // Execute the query.
    [self.dbManager executeQuery:inserQquery];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
 //        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
    }
    
//    [selectedCategories removeAllObjects];
//    [selectedCategories addObjectsFromArray:[self getSelectedTF]];
//    [_tableViewOutlet reloadData];
}

#pragma mark - deletingMyTF
-(void)deleteMyTF:(NSDictionary*)selectedTFCategories
{
    NSString *ID;
    
    for(NSDictionary *TFDict in allMyTF)
    {
        //        TFTypeID TFTypeCategoryID
        
        
       
            
            if ([[selectedTFCategories valueForKey:@"thoughtsTypeID"] isEqualToString:[TFDict valueForKey:@"thoughtTypeID"]] && [[selectedTFCategories valueForKey:@"ID"] isEqualToString:[TFDict valueForKey:@"thoughtTypeCategoryID"]]) {
                
                
                
                ID = [TFDict valueForKey:@"ID"];
            }
        
        
    }

    
    NSString *deleteQquery = [NSString stringWithFormat:@"delete from My_TF where ID=%@",ID];
    
    NSLog(@"%@",deleteQquery);
    
    // Execute the query.
    [self.dbManager executeQuery:deleteQquery];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        
        // Pop the view controller.
    }
    else{
        NSLog(@"Could not execute the zxzxzxquery.");
    }
    
//    [selectedCategories removeAllObjects];
//    [selectedCategories addObjectsFromArray:[self getSelectedTF]];
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
