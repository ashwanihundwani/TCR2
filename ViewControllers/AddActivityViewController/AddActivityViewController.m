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
@property (nonatomic, strong)UIView *buttonInnerView;

@end

@implementation AddActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *myBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 15, 320, 50)];
    [self.view addSubview:myBar];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Add New Activity"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStylePlain target:nil action:@selector(cancelTapped)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                    style:UIBarButtonItemStyleDone target:nil action:@selector(addTapped)];
    [myBar pushNavigationItem:item animated:NO];
    
    UILabel *firstLabel = (UILabel *)[self.view viewWithTag:200];
    
    firstLabel.font = [Utils helveticaNueueFontWithSize:17];
    
    NSString *ttext = [NSString stringWithFormat:@"You are adding this activity to the '%@' value",[PersistenceStorage getObjectForKey:@"valueName"]];
    
    firstLabel.text = ttext;
    
    UILabel* favLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 200, 200, 30)];
    favLabel.text = @"Also Add to Favorites";
    [self.view addSubview:favLabel];
    
    
    UIView *innerView = [[UIView alloc]initWithFrame:CGRectMake(3, 3, 24, 24)];
    innerView.layer.borderColor = [UIColor grayColor].CGColor;
    innerView.layer.borderWidth = 1;
    innerView.layer.cornerRadius = innerView.height / 2;
    innerView.userInteractionEnabled = NO;
    self.buttonInnerView = innerView;
    
    UIButton* favbtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 200, 30, 30)];
    [favbtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    [favbtn addSubview:innerView];
    
    [favbtn setBackgroundImage:[UIImage imageNamed:@"Selected_CheckBox.png"] forState:UIControlStateSelected];
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
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addButtonTapped:(id)sender {
    if ([self.nameTextField.text length]>0)
    {
        if(![self activityExists]){
            NSString *sqlStr = [Utils getValidSqlString:self.nameTextField.text];
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd";
            NSString *dateString = [formatter stringFromDate:date];
            
            NSTimeInterval  today = [[NSDate date] timeIntervalSince1970];
            //NSString *CurrentTime = [NSString stringWithFormat:@"%lf", today];
            NSString *query = [NSString stringWithFormat:@"insert into Plan_Activities (valueName,activityName,isActive,createdDate) values('%@','%@',%i,'%lf')",[PersistenceStorage getObjectForKey:@"valueName"],sqlStr,YES,today];
            
            [self.manager executeQuery:query];
            
            // If the query was successfully executed then pop the view controller.
            if (self.manager.affectedRows != 0) {
                
                // check for fav and add it
                if(self.favoriteButton.selected){
                    
                    NSString *query = [NSString stringWithFormat:@"insert into MyActivities (valueID,activityID,isFavourite,isSchedule,timeStamp,valueName,activityName,skillID, planID) values(%i,%lld,'%d',%i,'%@','%@','%@',%ld,%ld)",[PersistenceStorage getObjectForKey:@"valueID"],self.manager.lastInsertedRowID,1,YES,dateString,[PersistenceStorage getObjectForKey:@"valueName"],sqlStr,[PersistenceStorage getIntegerForKey:@"currentSkillID"],[PersistenceStorage getIntegerForKey:@"currentPlanID"]];
                    
                    // Execute the query.
                    [self.manager executeQuery:query];
                    
                }
                [PersistenceStorage setBool:YES andKey:@"NewUserDefinedActivityAdded"];
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
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
    
    NSString *sqlStr = [Utils getValidSqlString:self.nameTextField.text];
    
   NSString* queryString = [NSString stringWithFormat:@"select count(*) from Plan_Activities where activityName ='%@'",sqlStr];
    NSDictionary* dict = [[self.manager loadDataFromDB:queryString] objectAtIndex:0];
    int val = [(NSString*)[dict valueForKey:@"count(*)"] intValue];
    return  val > 0 ? YES:NO;
    
}

-(void)favbtnPressed:(UIView*)sender{
    UIButton* favBtn = (UIButton*)sender;
    if(favBtn.selected){
        favBtn.selected = NO;
        [favBtn addSubview:self.buttonInnerView];
    }else{
        favBtn.selected = YES;
        [self.buttonInnerView removeFromSuperview];
        
    }
    [favBtn setNeedsDisplay];
}

@end
