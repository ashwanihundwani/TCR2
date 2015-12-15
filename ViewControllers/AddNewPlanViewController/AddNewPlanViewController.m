//
//  AddNewPlanViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 3/18/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "AddNewPlanViewController.h"
#import "NewPlanAddedViewController.h"
#import "PlansViewController.h"
#import "MBProgressHUD.h"

@interface AddNewPlanViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *planListArray;
}

@property (nonatomic, weak) IBOutlet UITableView *plansListTableView;
@property (nonatomic, strong) DBManager *dbManagerPlansList;

@end

@implementation AddNewPlanViewController

-(void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 130, 44)];
    
    titleView.backgroundColor = [Utils colorWithHexValue:NAV_BAR_BLACK_COLOR];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 130, 25)];
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_1];
    
    titleLabel.font = pallete.secondObj;
    titleLabel.textColor = pallete.firstObj;
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"Add New Plan";
    
    UILabel *situationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, 130, 14)];
    
    pallete = [Utils getColorFontPair:eCFS_PALLETE_2];
    
    situationLabel.font = pallete.secondObj;
    situationLabel.textColor = pallete.firstObj;
    
    situationLabel.textAlignment = NSTextAlignmentCenter;
    situationLabel.backgroundColor = [UIColor clearColor];
    situationLabel.text = @"Your Situation";
    
    [titleView addSubview:titleLabel];
    [titleView addSubview:situationLabel];
    
    self.navigationItem.titleView = titleView;
    
    UILabel *backLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 20)];
    
    backLabel.text = @"Cancel";
    
    pallete = [Utils getColorFontPair:eCFS_PALLETE_3];
    
    backLabel.font = pallete.secondObj;
    backLabel.textColor = pallete.firstObj;
    
    [Utils addTapGestureToView:backLabel target:self
                      selector:@selector(cancel)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backLabel];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -8;
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, item, nil];
    self.dbManagerPlansList = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    
    [self loadPlanSituation];
    
    // Do any additional setup after loading the view.
}

-(void)loadPlanSituation{
    NSString *query = @"select * from Plan_Situatation where situationName NOT IN (select planName from MyPlans)";
    // Get the results.
    if (planListArray!= nil) {
        planListArray = nil;
    }
    planListArray = [[NSArray alloc] initWithArray:[self.dbManagerPlansList loadDataFromDB:query]];
    
    // Reload the table view.
    [self.plansListTableView reloadData];
}


-(void)writeToMyPlans:(NSString *)planName
{
    
    NSString *sqlPlan = [Utils getValidSqlString:planName];
    
    NSString *duplicateCheck = [NSString stringWithFormat:@"SELECT * from MyPlans  where planName = '%@'", sqlPlan];
    
    NSArray* duplicatePlanaArray = [self.dbManagerPlansList loadDataFromDB:duplicateCheck];
    if (duplicatePlanaArray.count > 0) {
        NSLog(@"duplicate plan");
    }else{
        NSString *query = [NSString stringWithFormat:@"insert into MyPlans ('planName', 'isActive', 'situationName','timeStamp') values ('%@', 1, '%@','%@')",sqlPlan,[PersistenceStorage getObjectForKey:@"sitName"],[NSDate date]];
        
        [PersistenceStorage setObject:planName andKey:@"newPlanName"];
        [PersistenceStorage setObject:planName andKey:@"planName"];
        NSString *queryaa = [NSString stringWithFormat: @"select ID from MyPlans where planName == '%@'", sqlPlan];
        [self writeAddedPlan];
        BOOL isDone = [self.dbManagerPlansList executeQuery:query];
        
        NSString *planID = [[[self.dbManagerPlansList loadDataFromDB:queryaa]objectAtIndex:0] valueForKey:@"ID"];
        [PersistenceStorage setObject:planID andKey:@"currentPlanID"];
        
        [PersistenceStorage setObject:[PersistenceStorage getObjectForKey:@"sitName"] andKey:@"situationName"];
        if (isDone == YES)
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"] ];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"Added";
            [hud show:YES];
            [hud hide:YES afterDelay:1];
        }
        else{
            NSLog(@"Error");
        }
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [planListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    if (cell == nil) {
        cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 12, 250, 20)];
        
        Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_4];
        
        titleLabel.font = pallete.secondObj;
        titleLabel.textColor = pallete.firstObj;
        titleLabel.tag = 6007;
        
        UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(22, 44, 298, 1)];
        
        separator.backgroundColor = [Utils colorWithHexValue:@"EEEEEE"];
        
        [cell addSubview:separator];
        
        [cell addSubview:titleLabel];
        
    }
    
    UILabel *label = (UILabel *)[cell viewWithTag:6007];
    
    label.text =[[planListArray objectAtIndex:indexPath.row] valueForKey:@"situationName"];
    return cell;
    
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}




- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    if( [inputText length] >= 4 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    

    if (buttonIndex == 1) {
        NSString* planName = [[alertView textFieldAtIndex:0] text];
        
        [self writeToMyPlans:planName];
        [self performSelector:@selector(navigateToNewPlanAdded:) withObject:planName afterDelay:1.1];
    }
}

-(void)navigateToNewPlanAdded:(NSString*)planName{
    NewPlanAddedViewController *npav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NewPlanAddedViewController"];
    npav.planName = planName;
    [self.navigationController pushViewController:npav animated:NO];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString * strRR = [NSString stringWithFormat:@"%@%@",@"Create a new plan for the situation: ", [[planListArray objectAtIndex:indexPath.row] valueForKey:@"situationName"]];
    
    
    NSString * sitName = [NSString stringWithFormat:@"%@", [[planListArray objectAtIndex:indexPath.row] valueForKey:@"situationName"]];
    
    
    [PersistenceStorage setObject:sitName andKey:@"sitName"];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Add Plan"  message:strRR delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[alertView textFieldAtIndex:0] setText:[[planListArray objectAtIndex:indexPath.row] valueForKey:@"situationName"]];
    
    [alertView show];
    
}

-(void)writeAddedPlan
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentTXTPath = [documentsDirectory stringByAppendingPathComponent:@"TinnitusCoachUsageData.csv"];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM/dd/yy";
    NSString *dateString = [dateFormatter stringFromDate: date];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"HH:mm:ss";
    NSString *timeString = [timeFormatter stringFromDate: date];
    NSString *type = @"Plan";
    
    NSString *str = @"Created Plan";
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,[PersistenceStorage getObjectForKey:@"newPlanName"],[PersistenceStorage getObjectForKey:@"sitName"],nil,nil,nil,nil,nil,nil,nil,nil,nil];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:documentTXTPath])
    {
        [finalStr writeToFile:documentTXTPath atomically:YES];
    }
    else
    {
        NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:documentTXTPath];
        [myHandle seekToEndOfFile];
        [myHandle writeData:[finalStr dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
}
@end
