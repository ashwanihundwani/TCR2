//
//  AddActivityViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 28/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "CTF01.h"
#import "CTF02.h"
#import "CTF03.h"


#import "CTF04.h"
#import "CTF06NewOne.h"
#import "CTF05.h"



#import "ChangingThoughtsViewController.h"


@interface CTF05 ()
@property (nonatomic, strong) UILabel* placeHolderLabel;
@end

@implementation CTF05

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add New Entry";
    // Do any additional setup after loading the view.
    self.manager = [[DBManager alloc] initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.nameTextView.layer.cornerRadius = 5;
    [self.nameTextView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    self.nameTextView.layer.borderWidth = 0.5;
    self.nameTextView.clipsToBounds = true;
    self.nameTextView.textContainer.maximumNumberOfLines = 2;
    self.nameTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.nameTextView associateConstraints:self.TextViewHeightConstraint];
    // add placeholder text
    self.placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 2.0,self.nameTextView.frame.size.width - 10.0, 25.0)];
    
    
    [self.placeHolderLabel setText:@"Type your response here."];
    [self.placeHolderLabel setFont:[UIFont systemFontOfSize:14]];
    [self.placeHolderLabel setBackgroundColor:[UIColor clearColor]];
    [self.placeHolderLabel setTextColor:[UIColor lightGrayColor]];
    
    [self.nameTextView addSubview:self.placeHolderLabel];
    [self setUpView];
    self.nameTextView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
     [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




-(void)setUpView{
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTapped)];
    [self.navigationItem setLeftBarButtonItem:barButton];
    
}



-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

-(void)viewDidAppear:(BOOL)animated
{    self.nameTextView.text = [PersistenceStorage getObjectForKey:@"ctf05text"];

    UILabel *labelOne = (UILabel *)[self.view viewWithTag:433];
    labelOne.text = [PersistenceStorage getObjectForKey:@"ctf02text"];
    if([self.nameTextView hasText]){
        [self.placeHolderLabel setHidden:YES];
    }
}

-(void)cancelTapped {
    for (UIViewController* vc in self.navigationController.viewControllers) {
        if([vc isKindOfClass:[ChangingThoughtsViewController class]]){
            [self.navigationController popToViewController:vc animated:YES];
        }
    }

}



- (IBAction)backButtonTapped:(id)sender {
    CTF04 *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"CTF04"];
    
    
    [self.navigationController pushViewController:ratingsView animated:YES];
    
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
    
    
    NSString *query = [NSString stringWithFormat:@"insert into Plan_Activities (valueName,activityName,isActive,createdDate) values('%@','%@',%i,'%@')",[PersistenceStorage getObjectForKey:@"valueName"],self.nameTextView.text,YES,CurrentTime];
    
    
    NSLog(@"%@",self.nameTextView.text);
    
    [PersistenceStorage setObject:self.nameTextView.text andKey:@"ctf05text"];

    
    CTF06NewOne *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"CTF06NewOne"];
    
    
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


// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    const float movementDuration = 0.3f;
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-20, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    const float movementDuration = 0.3f;
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+20, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
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

#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)theTextView
{
    if (![self.nameTextView hasText]) {
        self.placeHolderLabel.hidden = NO;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (![self.nameTextView hasText]) {
        self.placeHolderLabel.hidden = NO;
    }
}

- (void) textViewDidChange:(UITextView *)textView
{
    if(![self.nameTextView hasText]) {
        self.placeHolderLabel.hidden = NO;
    }
    else{
        self.placeHolderLabel.hidden = YES;
    }  
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
@end
