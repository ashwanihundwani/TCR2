//
//  AddActivityViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 28/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "AddActivityViewController.h"

@interface AddActivityViewController ()
@property (nonatomic, strong) void (^onCompletion)(id result);
@property (nonatomic, strong) UIButton* favoriteButton;


@end

@implementation AddActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"Add New Activity";
    UINavigationBar *myBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 15, 320, 50)];
    [self.view addSubview:myBar];
    
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Add New Activity"];
    
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStylePlain target:nil action:@selector(cancelTapped)];
//item.leftBarButtonItem = leftButton;
    
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                    style:UIBarButtonItemStyleDone target:nil action:@selector(addTapped)];
 //   item.rightBarButtonItem = rightButton;
    
    
    
    
    [myBar pushNavigationItem:item animated:NO];

    UILabel *firstLabel = (UILabel *)[self.view viewWithTag:200];
    
    firstLabel.font = [Utils helveticaNueueFontWithSize:17];
    
    NSString *ttext = [NSString stringWithFormat:@"You are adding this activity to the '%@' value",[PersistenceStorage getObjectForKey:@"valueName"]];

    firstLabel.text = ttext;

    UILabel* favLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 200, 200, 30)];
    favLabel.text = @"Also Add to Favorites";
    [self.view addSubview:favLabel];
    UIButton* favbtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 200, 30, 30)];
    [favbtn setBackgroundImage:[UIImage imageNamed:@"u630.png"] forState:UIControlStateNormal];
    [favbtn setBackgroundImage:[UIImage imageNamed:@"u648.png"] forState:UIControlStateSelected];
    [favbtn addTarget:self action:@selector(favbtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    favbtn.selected = NO;
    [self.view addSubview:favbtn];
    self.favoriteButton = favbtn;
    // Do any additional setup after loading the view.
   self.manager = [[DBManager alloc] initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                                                   initWithTarget:self
                                                                  action:@selector(dismissKeyboard)];
                                   
                                        [self.view addGestureRecognizer:tap];

    
    
   // [self setUpView];
}

-(void)setUpView{
   [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
   UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTapped)];
    [self.navigationItem setLeftBarButtonItem:barButton];

}



-(void)dismissKeyboard {
      [self.view endEditing:YES];
}



- (IBAction)cancelTapped:(id)sender {
    
    
    
    [self dismissViewControllerAnimated:YES completion:^{
       
       // self.onCompletion(self.someRetrievedValue);
        
        
    }];
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
    
    if ([self.nameTextField.text length]>0)
        
    {
        if(![self activityExists]){
            
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd";
            NSString *dateString = [formatter stringFromDate:date];
            
            NSTimeInterval  today = [[NSDate date] timeIntervalSince1970];
            NSString *CurrentTime = [NSString stringWithFormat:@"%d", today];
            NSString *query = [NSString stringWithFormat:@"insert into Plan_Activities (valueName,activityName,isActive,createdDate) values('%@','%@',%i,'%@')",[PersistenceStorage getObjectForKey:@"valueName"],self.nameTextField.text,YES,CurrentTime];
            
            [self.manager executeQuery:query];
            
            // If the query was successfully executed then pop the view controller.
            if (self.manager.affectedRows != 0) {
                
                // check for fav and add it
                if(self.favoriteButton.selected){
                    NSString *query = [NSString stringWithFormat:@"insert into MyActivities (valueID,activityID,isFavourite,isSchedule,timeStamp,valueName,activityName) values(%i,%lld,'%d',%i,'%@','%@','%@')",[PersistenceStorage getObjectForKey:@"valueID"],self.manager.lastInsertedRowID,1,YES,dateString,[PersistenceStorage getObjectForKey:@"valueName"],self.nameTextField.text];
                    
                    // Execute the query.
                    [self.manager executeQuery:query];
                    
                }
                [PersistenceStorage setBool:YES andKey:@"NewUserDefinedActivityAdded"];
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
                
                
                
                
                // Pop the view controller.
                //    [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                NSLog(@"Could not execute the query.");
            }
        }else{
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Sorry,cannot add this activity" message:@"The activity that you are trying to add already exists." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    
    
}

-(BOOL)activityExists{
   NSString* queryString = [NSString stringWithFormat:@"select count(*) from Plan_Activities where valueName =\"%@\" and activityName =\"%@\"",[PersistenceStorage getObjectForKey:@"valueName"],self.nameTextField.text];
    NSDictionary* dict = [[self.manager loadDataFromDB:queryString] objectAtIndex:0];
    int val = [(NSString*)[dict valueForKey:@"count(*)"] intValue];
    return  val > 0 ? YES:NO;
    
}

-(void)favbtnPressed:(UIView*)sender{
    UIButton* favBtn = (UIButton*)sender;
    if(favBtn.selected){
        favBtn.selected = NO;
    }else{
        favBtn.selected = YES;
    }
    [favBtn setNeedsDisplay];
}

/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.nameTextField resignFirstResponder];
}*/
@end
