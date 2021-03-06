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
    NSArray *emotionsArray;
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
    emotionsArray = [self.dbManager loadDataFromDB:query];
//[emotionsArray removeAllObjects];
  //   for (NSDictionary *emotion in allRecordsArray) {
        
         
//[emotionsArray addObject:emotion];
    

  //  NSLog(@"%@",allRecordsArray);
NSLog(@"''%@",emotionsArray);

    
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

    
    
    
    cell.textLabel.text = [[emotionsArray objectAtIndex:indexPath.row] valueForKey:@"thoughtText"];
    cell.detailTextLabel.text = [[emotionsArray objectAtIndex:indexPath.row] valueForKey:@"rating"];

     
    return cell;
}
 


-(void)dismissKeyboard {
    [self.view endEditing:YES];
}



- (void)cancelTapped  {
    ChangingThoughtsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"ChangingThoughtsViewController"];
    
    
    [self.navigationController pushViewController:ratingsView animated:NO];
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







/*
 -(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
 [self.nameTextField resignFirstResponder];
 }*/
@end
