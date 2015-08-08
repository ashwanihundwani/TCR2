//
//  TipsForSleepVC.m
//  TinnitusCoach
//
//  Created by Jiten on 26/04/15.
//  Copyright (c) 2015 Swipe Video Labs Pvt Ltd. All rights reserved.
//

#import "TipsForSleepVC.h"
#import "SkillIntroductionViewController.h"

@interface TipsForSleepVC () <UITextFieldDelegate>
{
    UIView *nomatchesView;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgTipsSleep;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UITextField *txtFldLearnMore;
@property (weak, nonatomic) IBOutlet UIButton *btnIntroAgain;
@property (weak, nonatomic) IBOutlet UIView *skillReminderView;
@property (weak, nonatomic) IBOutlet UIView *feedBackView;
@property (weak, nonatomic) IBOutlet UITextField *txtFldCreateMyTips;
- (IBAction)onClickViewIntroAgain:(id)sender;
- (IBAction)onClickRenderSwicth:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *reminderSwitch;

@end

@implementation TipsForSleepVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.txtFldCreateMyTips setDelegate:self];
    [self leftViewwithImage:[UIImage imageNamed:@"lightbulb"]];
    [self rightViewwithImage:[UIImage imageNamed:@"leftArrow"]];
    
    self.btnIntroAgain.layer.cornerRadius = 10.0f;
    
    self.skillReminderView.layer.borderColor = [UIColor grayColor].CGColor;
    self.skillReminderView.layer.borderWidth = 1.0f;
    
    self.feedBackView.layer.borderColor = [UIColor grayColor].CGColor;
    self.feedBackView.layer.borderWidth = 1.0f;
    
    [self.feedBackView setBackgroundColor:[UIColor clearColor]];
    [self.skillReminderView setBackgroundColor:[UIColor clearColor]];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}



-(void)leftViewwithImage:(UIImage *)image
{
    CGSize size = CGSizeMake(25, 25);
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    imgView.clipsToBounds = YES;
    CGFloat h = self.txtFldLearnMore.bounds.size.height;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, h, h)];
    imgView.frame = CGRectMake((h-size.width)/2, (h-size.height)/2, size.width, size.height);
    [paddingView addSubview:imgView];
    self.txtFldLearnMore.leftView = paddingView;
    self.txtFldLearnMore.leftViewMode = UITextFieldViewModeAlways;
}

-(void)rightViewwithImage:(UIImage *)image
{
    CGSize size = CGSizeMake(25, 25);
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    imgView.clipsToBounds = YES;
    CGFloat h = self.txtFldLearnMore.bounds.size.height;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, h, h)];
    imgView.frame = CGRectMake((h-size.width)/2, (h-size.height)/2, size.width, size.height);
    [paddingView addSubview:imgView];
    self.txtFldLearnMore.rightView = paddingView;
    self.txtFldLearnMore.rightViewMode = UITextFieldViewModeAlways;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickViewIntroAgain:(id)sender {
    
#define TIPS_FOR_SLEEP @"Tips for Better Sleep"
#define KEY_SKILLNAME   @"skillName"

    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:TIPS_FOR_SLEEP,KEY_SKILLNAME, nil];
    
    SkillIntroductionViewController *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SkillIntroductionViewController"];
   // siv.skillsDict = dict;
    [self.navigationController pushViewController:siv animated:YES];
}

- (IBAction)onClickRenderSwicth:(id)sender {
}

#pragma Mark UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([textField isEqual:self.txtFldCreateMyTips])
    {
        [self openMySleepTipsVC];
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(void)openMySleepTipsVC
{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [main instantiateViewControllerWithIdentifier:@"MySleepTipsVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
