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

#import "ChangingThoughtsViewController.h"


@interface CTF02 ()
@property (nonatomic, strong) UILabel* placeHolderLabel;
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
    
    self.nameTextView.layer.cornerRadius = 5;
    [self.nameTextView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    self.nameTextView.layer.borderWidth = 0.5;
    self.nameTextView.clipsToBounds = true;
    [self.nameTextView associateConstraints:self.TextViewHeightConstraint];
    self.nameTextView.textContainer.maximumNumberOfLines = 2;
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


-(void)setUpView{
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTapped)];
    [self.navigationItem setLeftBarButtonItem:barButton];
    
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


-(void)viewDidAppear:(BOOL)animated

{
    
    self.nameTextView.text = [PersistenceStorage getObjectForKey:@"ctf02text"];
    if([self.nameTextView hasText]){
        [self.placeHolderLabel setHidden:YES];
    }
    
    
}
-(void)dismissKeyboard {
    [self.view endEditing:YES];
}



-(void)cancelTapped {
    
    for (UIViewController* vc in self.navigationController.viewControllers) {
        if([vc isKindOfClass:[ChangingThoughtsViewController class]]){
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}



- (IBAction)backButtonTapped:(id)sender {
    CTF01 *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"CTF01"];
    [self.navigationController pushViewController:ratingsView animated:NO];
    if (self.manager.affectedRows != 0) {
    }
    else{
        NSLog(@"Could not execute the query.");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addButtonTapped:(id)sender {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSTimeInterval  today = [[NSDate date] timeIntervalSince1970];
    NSString *CurrentTime = [NSString stringWithFormat:@"%d", today];
    [PersistenceStorage setObject:self.nameTextView.text andKey:@"ctf02text"];
    CTF03 *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"CTF03"];
    [self.navigationController pushViewController:ratingsView animated:YES];
    if (self.manager.affectedRows != 0) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
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
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-5, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    const float movementDuration = 0.3f;
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+5, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
}


#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)theTextView
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
