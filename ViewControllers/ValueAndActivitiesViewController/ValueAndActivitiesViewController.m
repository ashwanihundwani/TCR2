//
//  ValueAndActivitiesViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 28/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "ValueAndActivitiesViewController.h"

@interface ValueAndActivitiesViewController ()<UITableViewDelegate,UITableViewDataSource>{
   NSArray *valueandActivityArray;
}
@property (nonatomic, strong) DBManager *dbManagerValues;

@end

@implementation ValueAndActivitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"Values and Activities";
    self.dbManagerValues = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
     [self setupTable];
}

-(void)setupTable{
    [self.valueActivityTableView setDataSource:self];
    [self.valueActivityTableView setDelegate:self];
    valueandActivityArray = [NSArray arrayWithObjects:@"Adventure",@"Authority",@"Artistic",@"Caring",@"Challenge",@"Change",@"Cooperation",@"Excitement",@"Family",@"Fitness",@"Food",@"Friendship",@"Fun",@"Growth",@"Health",@"Inner Peace",@"Intimacy",@"Knowledge",@"Leisure",@"Military",@"Outdoor",@"Physical",@"Social",@"Spirituality",@"Tradition", nil];
    [self.valueActivityTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [valueandActivityArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [valueandActivityArray objectAtIndex:indexPath.row];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *valName = [valueandActivityArray objectAtIndex:indexPath.row];
   

    NSString *query = [NSString stringWithFormat: @"select ValueDescription from Plan_Values where valueName = '%@'", valName];
 
    
    
    NSArray *mySoundsArray = [[NSArray alloc] initWithArray:[self.dbManagerValues loadDataFromDB:query]];
    
    
    [PersistenceStorage setObject:valName andKey:@"valueName"];
    
    
    NSArray *temp=  [mySoundsArray valueForKey:@"valueDescription"];
    
    
    
//    [PersistenceStorage setObject:[mySoundsArray valueForKey:@"valueDescription"] andKey:@"valueDescriptiontemp"];

NSLog(@"%@",[temp objectAtIndex:0]);
    
    
    [PersistenceStorage setObject:[temp objectAtIndex:0] andKey:@"valueDescription"];

  //  [[[PersistenceStorage getObjectForKey:@"valueDescriptiontemo"] allObjects]objectAtIndex:0];
    
    
    
    if (indexPath.row < 400) {
        

        
        ActivitiesViewController *avc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ActivitiesViewController"];
        [self.navigationController pushViewController:avc animated:YES];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

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

@end
