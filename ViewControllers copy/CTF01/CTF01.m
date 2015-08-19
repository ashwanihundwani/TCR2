//
//  AddActivityViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 28/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "CTF01.h"
#import "CTF02.h"
#import "ChangingThoughtsViewController.h"


@interface CTF01 ()

@end

@implementation CTF01

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


-(void)viewDidAppear:(BOOL)animated

{

    self.nameTextField.text = [PersistenceStorage getObjectForKey:@"ctf01text"];



}



- (void)viewWillAppear:(BOOL)animated
{
     [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
}



-(void)setUpView{
   [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
   UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTapped)];
    [self.navigationItem setLeftBarButtonItem:barButton];

}



-(void)dismissKeyboard {
      [self.view endEditing:YES];
}



-(void)cancelTapped {
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

    [PersistenceStorage setObject:self.nameTextField.text andKey:@"ctf01text"];

    
    
    
    CTF02 *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"CTF02"];
    
   
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
