//
//  AddActivityViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 28/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//
#import "CTF02.h"
#import "emotionsTableViewCell.h"
#import "CTF03.h"
#import "CTF04.h"
#import "ChangingThoughtsViewController.h"
#import "DBManager.h"
#import "EditTFListVC.h"

@interface CTF03 ()
{
    NSMutableArray *emotionsArray;
//DBManager *dbManager;

}

@end

@implementation CTF03

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
    self.nameTextField.delegate = self;

}

-(void)setUpView{
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTapped)];
    [self.navigationItem setLeftBarButtonItem:barButton];
    
}

-(void)viewDidAppear:(BOOL)animated

{
    
    [self setData];
    [self.scrollView setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.scrollView setContentSize:CGSizeMake(320,600)];
    [PersistenceStorage setObject:@"ctf03" andKey:@"ctfCategory"];

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
    NSString *query = @"SELECT thoughtText,rating FROM My_TF where thoughtCategory = 'step3'";
    emotionsArray = [NSMutableArray arrayWithArray:[self.dbManager loadDataFromDB:query]];
//[emotionsArray removeAllObjects];
  //   for (NSDictionary *emotion in allRecordsArray) {
        
         
//[emotionsArray addObject:emotion];
    

  //  NSLog(@"%@",allRecordsArray);
NSLog(@"''%@",emotionsArray);

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
    
                                        NSString *query = [NSString stringWithFormat:@"delete from My_TF where thoughtCategory='step3' and thoughtText='%@'",[[emotionsArray objectAtIndex:indexPath.row] valueForKey:@"thoughtText"]];
                                        
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
        deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, cell.frame.origin.y, 44, 44)];
        [deleteBtn setImage:[UIImage imageNamed:@"Active_Trash_Button.png"] forState:UIControlStateNormal];
        
       // deleteBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(6, 8, 8, 10);
        
        deleteBtn.tag = 1089;
        [deleteBtn addTarget:self action:@selector(deleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:deleteBtn];
        
    }
    UILabel* emotioTextLabel = (UILabel*)[cell viewWithTag:1090];
    if(emotioTextLabel == nil){
        emotioTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, cell.frame.origin.y+5, 195, 35)];
        emotioTextLabel.tag = 1090;
        [cell addSubview:emotioTextLabel];
    }
    //cell.textLabel.text = [[emotionsArray objectAtIndex:indexPath.row] valueForKey:@"thoughtText"];
    emotioTextLabel.textColor = [UIColor blackColor];
    emotioTextLabel.text = [[emotionsArray objectAtIndex:indexPath.row] valueForKey:@"thoughtText"];
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
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSTimeInterval  today = [[NSDate date] timeIntervalSince1970];
    NSString *CurrentTime = [NSString stringWithFormat:@"%d", today];
    
    
    //double *CurrentTime = [[NSDate date] timeIntervalSince1970];
    
    
    
    
    NSLog(@"%@",self.nameTextField.text);
    EditTFListVC *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"EditTFListVC"];
    
    
    [self.navigationController presentModalViewController:ratingsView animated:YES];

    // Execute the query.
    //[self.manager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        
        
        
        
        
        
        // Pop the view controller.
        //    [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
    }
}



- (IBAction)nextButtonTapped:(id)sender {
    
    NSString *myTFQuery = @"select * from My_TF where thoughtCategory='step3'";
    
    NSArray *myTFArray = [self.dbManager loadDataFromDB:myTFQuery];
    NSMutableString *thoughtList =[NSMutableString stringWithString:@""];
     NSLog(@"%@",myTFArray);
    
    
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
        [PersistenceStorage setObject:outPut andKey:@"ctf03text"];

        
    }

    
    
    CTF04 *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"CTF04"];
    
    
    [self.navigationController pushViewController:ratingsView animated:YES];
    

    
    
    
    
    
    
}





- (IBAction)backButtonTapped:(id)sender {
    CTF02 *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"CTF02"];
    
    
    [self.navigationController pushViewController:ratingsView animated:YES];
    
    // Execute the query.
    //[self.manager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    }

-(void)deleteBtnPressed:(UIView*)sender{
    DeleteCormationManager *manager = [DeleteCormationManager getInstance];
    
    [manager showAlertwithPositiveBlock:^(BOOL positive) {
        //delete from db
        UITableViewCell* cell = (UITableViewCell*)[sender superview];
        NSIndexPath* indexPath = [self.EmotionsTableView indexPathForCell:cell];
        NSInteger rowIndex = indexPath.row;
        NSDictionary* emotionDict = [emotionsArray objectAtIndex:rowIndex];
        NSString* deleteQuery = [NSString stringWithFormat:@"delete from My_TF where thoughtCategory = 'step3' and thoughtText = '%@' and rating = '%@'",[emotionDict valueForKey:@"thoughtText"],[emotionDict valueForKey:@"rating"]];
        [self.dbManager executeQuery:deleteQuery];
        if(self.dbManager.affectedRows > 0){
            [emotionsArray removeObjectAtIndex:rowIndex];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"] ];
            
            hud.mode = MBProgressHUDModeCustomView;
            
            hud.labelText = @"Removed";
            
            [hud show:YES];
            [hud hide:YES afterDelay:1];
            
        }
        [self.EmotionsTableView reloadData];
    } negativeBlock:^(BOOL negative) {
        
        //DO nothing
    }];
}




#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



/*
 -(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
 [self.nameTextField resignFirstResponder];
 }*/
@end
