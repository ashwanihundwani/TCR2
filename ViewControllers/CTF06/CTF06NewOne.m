//
//  AddActivityViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 28/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//
#import "CTF02.h"
#import "emotionsTableViewCell.h"
#import "CTF05.h"
#import "CTF04.h"
#import "CTF06NewOne.h"
#import "CTFSummary.h"
#import "ChangingThoughtsViewController.h"
#import "DBManager.h"
#import "EditTFListVC.h"

@interface CTF06NewOne ()
{
    NSArray *allTFArray, *allTFCategoriesArray,*allMyTF;
    NSMutableArray  *emotionsArray;
 
    //DBManager *dbManager;
    
}
-(IBAction) segmentedControlIndexChanged;
@end

@implementation CTF06NewOne

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add New Entry";
    // Do any additional setup after loading the view.
    self.dbManager = [[DBManager alloc] initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    
    self.EmotionsTableView.dataSource=self;
    self.EmotionsTableView.delegate=self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    //    emotionsArray = [NSMutableArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    
    [self setUpView];
    [self setData];
    
}

-(void)setUpView{
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTapped)];
    [self.navigationItem setLeftBarButtonItem:barButton];
    
}

-(void)viewDidAppear:(BOOL)animated

{
    
    [[self.view viewWithTag:335] setHidden:NO];

    [self setData];
    [self.scrollView setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.scrollView setContentSize:CGSizeMake(320,600)];
    [PersistenceStorage setObject:@"ctf06" andKey:@"ctfCategory"];
    
    //   self.textInfo.text = [PersistenceStorage getObjectForKey:@"thoughtList"];
    
    
}





- (void)viewWillAppear:(BOOL)animated
{
    [self setData];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
}




-(void)setData
{
    NSString *query = @"SELECT thoughtText,rating FROM My_TF where thoughtCategory = 'step6'";
    emotionsArray = [NSMutableArray arrayWithArray:[self.dbManager loadDataFromDB:query]];
    //[emotionsArray removeAllObjects];
    //   for (NSDictionary *emotion in allRecordsArray) {
    
    
    //[emotionsArray addObject:emotion];
    
    
    //  NSLog(@"%@",allRecordsArray);
    NSLog(@"''%@",emotionsArray);
    
    
}

-(IBAction) segmentedControlIndexChanged
{
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            //self.textLabel.text =@"Segment 1 selected.";
            
        { NSString *query = @"SELECT thoughtText,rating FROM My_TF where thoughtCategory = 'step6'";
            emotionsArray = [NSMutableArray arrayWithArray:[self.dbManager loadDataFromDB:query]];
            [[self.view viewWithTag:335] setHidden:NO];

            break;}
            
        case 1:
            //self.textLabel.text =@"Segment 2 selected.";
            
        {NSString *query1 = @"SELECT thoughtText,rating FROM My_TF where thoughtCategory = 'step3'";
            emotionsArray = [NSMutableArray arrayWithArray:[self.dbManager loadDataFromDB:query1]];
            [[self.view viewWithTag:335] setHidden:YES];

            break;}
        default:
            break;
    }
    
    [self.EmotionsTableView reloadData];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //   NSLog(@"%@",[emotionsArray count]);
    return [emotionsArray count];
}


/*-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
 if( cell == nil ) {
 cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell1"] autorelease];
 cell.accessoryType = UITableViewCellAccessoryNone;
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.font = [UIFont fontWithName:@"myFont" size:30];
 cell.textLabel.adjustsFontSizeToFitWidth = YES;
 }
 cell.accessoryView = [Some widget you want on the right... or not];
 cell.textLabel.text = @"Some Left justified string in whatever font here (BLACK)";
 cell.detailTextLabel.text = @"Some right justified string here... in whatever font you want (BLUE)";
 return cell;
 }
 
 */







-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"X" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        
                                        NSString *query = [NSString stringWithFormat:@"delete from My_TF where thoughtCategory='step6' and thoughtText='%@'",[[emotionsArray objectAtIndex:indexPath.row] valueForKey:@"thoughtText"]];
                                        
                                        NSLog(@"%@",query);
                                        
                                        
                                        
                                        BOOL isDone = [self.dbManager executeQuery:query];
                                        if (isDone == YES)
                                        {
                                            
                                            NSLog(@"Success");
                                            //block(YES);
                                        }
                                        else{
                                            NSLog(@"Error");
                                            //  block(NO);
                                            
                                        }
                                        
                                        [self setData];
                                        [self.EmotionsTableView reloadData];
                                        
                                        
                                    }];
    button.backgroundColor = [UIColor redColor]; //arbitrary color
    
    
    
    
    
    
    
    return @[button]; //array with all the buttons you want. 1,2,3, etc...
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // you need to implement this method too or nothing will work:
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES; //tableview must be editable or nothing will work...
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    
    // NSMutableString *thoughtList =[NSMutableString stringWithString:@""];
    //[thoughtList appendString:[[emotionsArray objectAtIndex:indexPath.row] valueForKey:@"thoughtText"]];
    //  [thoughtList appendString:[[emotionsArray objectAtIndex:indexPath.row] valueForKey:@"rating"]];
    
    
    UIButton* deleteBtn = (UIButton*)[cell viewWithTag:1089];
    if(deleteBtn == nil){
        deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(4, cell.frame.origin.y+8, 25, 25)];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"Active_Trash_Button.png"] forState:UIControlStateNormal];
        deleteBtn.tag = 1089;
        [deleteBtn addTarget:self action:@selector(deleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:deleteBtn];

    }
    
    
    UILabel* emotioTextLabel = (UILabel*)[cell viewWithTag:1090];
    if(emotioTextLabel == nil){
        emotioTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, cell.frame.origin.y+5, 200, 35)];
        emotioTextLabel.tag = 1090;
        [cell addSubview:emotioTextLabel];
    }
    
    emotioTextLabel.textColor = [UIColor blackColor];
    emotioTextLabel.text = [[emotionsArray objectAtIndex:indexPath.row] valueForKey:@"thoughtText"];
    
    
    //cell.textLabel.text = [[emotionsArray objectAtIndex:indexPath.row] valueForKey:@"thoughtText"];
    cell.detailTextLabel.text = [[emotionsArray objectAtIndex:indexPath.row] valueForKey:@"rating"];
    
    
    return cell;
}



-(void)dismissKeyboard {
    [self.view endEditing:YES];
}



- (void)cancelTapped  {
    for (UIViewController* vc in self.navigationController.viewControllers) {
        if([vc isKindOfClass:[ChangingThoughtsViewController class]]){
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}


/*-(void)cancelTapped{
 [self dismissViewControllerAnimated:YES completion:^{
 
 }];
 }
 */
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

- (IBAction)addButtonTapped:(id)sender {
        
    
    
    
    EditTFListVC *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"EditTFListVC"];
    
    
    [self.navigationController presentModalViewController:ratingsView animated:YES];

    
    
}



- (IBAction)nextButtonTapped:(id)sender {
    
    
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *currentTime = [dateFormatter stringFromDate:today];
    
    NSTimeInterval  today1 = [[NSDate date] timeIntervalSince1970];
    NSString *intervalString = [NSString stringWithFormat:@"%f", today1];
    
    NSLog(@"%@",intervalString);
    // Execute the query.
    //[self.manager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    
    NSString *myTFQuery = @"select * from My_TF where thoughtCategory='step6'";
    
    NSArray *myTFArray = [self.dbManager loadDataFromDB:myTFQuery];
    NSMutableString *thoughtList =[NSMutableString stringWithString:@""];
    
    
    
    
    
    
    for(int i= 0 ;i<[myTFArray count];i++)
    {
        
        
        [thoughtList appendString:[[myTFArray objectAtIndex:i] valueForKey:@"thoughtText"]];
        [thoughtList appendString:@" ("];
        [thoughtList appendString:[[myTFArray objectAtIndex:i] valueForKey:@"rating"]];
        [thoughtList appendString:@")   "];
        
        
        
    }
    
    if ([thoughtList length] > 0) {
        NSString *outPut = thoughtList;
        outPut = [outPut substringToIndex:[outPut length] - 2];
        NSLog(@"%@",outPut);
        [PersistenceStorage setObject:outPut andKey:@"ctf06text"];
        
        
    }
    NSString *query = [NSString stringWithFormat:@"insert into My_TF_Set ('planID','situationDescription', 'thoughtDescription', 'emotionsList','thoughtError', 'newThought', 'newEmotionsList', 'dateTime','dateTimeSeconds') values ('%@','%@', '%@', '%@','%@', '%@', '%@','%@','%@')",
                       [PersistenceStorage getObjectForKey:@"currentPlanID"],
                       [PersistenceStorage getObjectForKey:@"ctf01text"],
                       [PersistenceStorage getObjectForKey:@"ctf02text"],
                       [PersistenceStorage getObjectForKey:@"ctf03text"],
                       [PersistenceStorage getObjectForKey:@"ctf04text"],
                       [PersistenceStorage getObjectForKey:@"ctf05text"],
                       [PersistenceStorage getObjectForKey:@"ctf06text"],
                       currentTime,intervalString
                       
                       ];
    
    
    BOOL isDone = [self.dbManager executeQuery:query];
    
    
    if (self.dbManager.affectedRows != 0) {
        
    }
    else{
        NSLog(@"Could not execute the query.,,");
    }
    
    [PersistenceStorage setObject:@"ctf06" andKey:@"summaryReferer"];

    
    CTFSummary *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"CTFSummary"];
    
    
    [self.navigationController pushViewController:ratingsView animated:YES];

  
}


 






- (IBAction)backButtonTapped:(id)sender {
    CTF05 *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"CTF05"];
    
    
    [self.navigationController pushViewController:ratingsView animated:YES];
    
    // Execute the query.
    //[self.manager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
}


-(void)deleteBtnPressed:(UIView*)sender{
    UITableViewCell* cell = (UITableViewCell*)[sender superview];
    NSIndexPath* indexPath = [self.EmotionsTableView indexPathForCell:cell];
    NSInteger rowIndex = indexPath.row;
    NSDictionary* emotionDict = [emotionsArray objectAtIndex:rowIndex];
    NSString* deleteQuery = @"";[NSString stringWithFormat:@"delete from My_TF where thoughtCategory = 'step3' and thoughtText = '%@' and rating = '%@'",[emotionDict valueForKey:@"thoughtText"],[emotionDict valueForKey:@"rating"]];
    if(self.segmentedControl.selectedSegmentIndex == 0){
        deleteQuery = [NSString stringWithFormat:@"delete from My_TF where thoughtCategory = 'step6' and thoughtText = '%@' and rating = '%@'",[emotionDict valueForKey:@"thoughtText"],[emotionDict valueForKey:@"rating"]];
    }else{
        deleteQuery = [NSString stringWithFormat:@"delete from My_TF where thoughtCategory = 'step3' and thoughtText = '%@' and rating = '%@'",[emotionDict valueForKey:@"thoughtText"],[emotionDict valueForKey:@"rating"]];
    }
    [self.dbManager executeQuery:deleteQuery];
    if(self.dbManager.affectedRows > 0){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"] ];
        
        hud.mode = MBProgressHUDModeCustomView;
        
        hud.labelText = @"Removed";
        
        [hud show:YES];
        [hud hide:YES afterDelay:1];
        [emotionsArray removeObjectAtIndex:rowIndex];
        [self.EmotionsTableView reloadData];
    }
}





/*
 -(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
 [self.nameTextField resignFirstResponder];
 }*/
@end
