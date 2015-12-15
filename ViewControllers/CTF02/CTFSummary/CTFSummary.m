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
        
    }
    
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
    
    for (UIViewController* vc in self.navigationController.viewControllers) {
        if([vc isKindOfClass:[ChangingThoughtsViewController class]]){
            [self.navigationController popToViewController:vc animated:YES];
        }
    }

    if (self.manager.affectedRows != 0) {
        
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    else{
        NSLog(@"Could not execute the query.");
    }
}




 
@end
