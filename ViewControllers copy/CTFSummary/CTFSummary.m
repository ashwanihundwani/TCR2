//
//  AddActivityViewController.m
//  TinnitusCoach
//
//  Created by Swipe Video Labs Pvt. Ltd. on 28/03/15.
//  Copyright (c) 2015 Swipe Video Labs Pvt. Ltd.. All rights reserved.
//

#import "CTF01.h"
#import "CTF02.h"
#import "CTF03.h"

#import "ChangingThoughtsViewController.h"


@interface CTF02 ()

@end

@implementation CTF02

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add New Entry";
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
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTapped)];
    [self.navigationItem setLeftBarButtonItem:barButton];
    
}



-(void)viewDidAppear:(BOOL)animated

{
    
    self.nameTextField.text = [PersistenceStorage getObjectForKey:@"ctf02text"];
    
    
    
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
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSTimeInterval  today = [[NSDate date] timeIntervalSince1970];
    NSString *CurrentTime = [NSString stringWithFormat:@"%d", today];
    
    
    //double *CurrentTime = [[NSDate date] timeIntervalSince1970];
    
    
    
    [PersistenceStorage setObject:self.nameTextField.text andKey:@"ctf02text"];

    NSLog(@"%@",self.nameTextField.text);
    
    
    
    CTF03 *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"CTF03"];
    
    
    [self.navigationController pushViewController:ratingsView animated:YES];
    
    
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
