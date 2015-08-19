//
//  AddActivityViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 28/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//
#import "CTF01.h"
#import "ChangingThoughtsViewController.h"

#import "CTFSummary.h"
#import "CTF02.h"
#import "CTF03.h"

#import "ChangingThoughtsViewController.h"


@interface CTFSummary ()
 @property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
 
@end

@implementation CTFSummary

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Entry Summary";
    // Do any additional setup after loading the view.
    self.manager = [[DBManager alloc] initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    

    
    
    [self setUpView];
}

-(void)setUpView{
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
//    [self.navigationItem setLeftBarButtonItem:barButton];
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
   
    
    
    
}


-(void)viewDidAppear:(BOOL)animated

{
    [self.scrollView setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height+500)];
    [self.scrollView setContentSize:CGSizeMake(320,900)];

    
    UILabel *labelOne = (UILabel *)[self.view viewWithTag:1];
    UILabel *labelTwo = (UILabel *)[self.view viewWithTag:2];
    UILabel *labelThree = (UILabel *)[self.view viewWithTag:3];
    UILabel *labelFour = (UILabel *)[self.view viewWithTag:4];
    UILabel *labelFive = (UILabel *)[self.view viewWithTag:5];
    UILabel *labelSix = (UILabel *)[self.view viewWithTag:6];
    [labelOne setText:[PersistenceStorage getObjectForKey:@"ctf01text"]];
    
    [labelTwo setText:[PersistenceStorage getObjectForKey:@"ctf02text"]];
    [labelThree setText:[PersistenceStorage getObjectForKey:@"ctf03text"]];
    [labelFour setText:[PersistenceStorage getObjectForKey:@"ctf04text"]];
    [labelFive setText:[PersistenceStorage getObjectForKey:@"ctf05text"]];
[labelSix setText:[PersistenceStorage getObjectForKey:@"ctf06text"]];
    
//    [labelSix setText:[@"Step 6 - " stringByAppendingString:[PersistenceStorage getObjectForKey:@"ctf06text"]]];
    
    
    
    //((UILabel*)[self.view viewWithTag:2]).text = [PersistenceStorage getObjectForKey:@"ctf01text"];
    
    
    
    if (![[PersistenceStorage getObjectForKey:@"summaryReferer"] isEqual:@"ctf06"])
        
    {
        UILabel *ttitle = (UILabel *)[self.view viewWithTag:888];
        UIImageView *timg = (UIImage *)[self.view viewWithTag:777];
        UIButton *tbtn = (UIButton *)[self.view viewWithTag:999];
[tbtn setTitle: @"Close" forState: UIControlStateNormal];
        NSString *tlabel = [NSString stringWithFormat:@"Your Entry dated \n%@",   [PersistenceStorage getObjectForKey:@"entryDateTime"]];
    
        ttitle.text = tlabel;
        timg.hidden=YES;
    
        [PersistenceStorage setObject:@"None" andKey:@"Referer"];

    }
    else
    
    {
    [PersistenceStorage setObject:@"CTF" andKey:@"Referer"];

    
//    [PersistenceStorage setObject:@"ctf06" andKey:@"summaryReferer"];
    }
    
    
    
    
    
  //  self.nameTextField.text = [PersistenceStorage getObjectForKey:@"ctf02text"];
    
   }

- (void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
}



-(void)dismissKeyboard {
    [self.view endEditing:YES];
}



-(void)cancelTapped {
    ChangingThoughtsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"ChangingThoughtsViewController"];
    
    
    [self.navigationController pushViewController:ratingsView animated:YES];
}



- (IBAction)backButtonTapped:(id)sender {
    CTF01 *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"CTF01"];
    
    
    [self.navigationController pushViewController:ratingsView animated:NO];
    
    // Execute the query.
    //[self.manager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.manager.affectedRows != 0) {
        
        
        
        
        
        
        // Pop the view controller.
        //    [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
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
//    NSDate *date = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    formatter.dateFormat = @"yyyy-MM-dd";
//    
//    NSTimeInterval  today = [[NSDate date] timeIntervalSince1970];
//    NSString *CurrentTime = [NSString stringWithFormat:@"%d", today];
    
    
    //double *CurrentTime = [[NSDate date] timeIntervalSince1970];
    
    
    
//    [PersistenceStorage setObject:self.nameTextField.text andKey:@"ctf02text"];

  //  NSLog(@"%@",self.nameTextField.text);
    
    
    
    ChangingThoughtsViewController *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"ChangingThoughtsViewController"];
    
    
    [self.navigationController pushViewController:ratingsView animated:NO];
    
    
    // Execute the query.
    //[self.manager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.manager.affectedRows != 0) {
        
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
        
        
        
        // Pop the view controller.
        //    [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
    }
}




 


/*
 -(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
 [self.nameTextField resignFirstResponder];
 }*/
@end
