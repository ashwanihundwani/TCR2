//
//  RatingsViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 18/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "ActivityRatingsViewController.h"
#import "ASStarRatingView.h"
#import "ActivitiesViewController.h"
#import "DeepBreathingViewController.h"
#import "NookUsingSoundViewControllerOne.h"

@interface ActivityRatingsViewController ()<UITextViewDelegate,ASStarRatingViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    ASStarRatingView *ratingView;
    UIButton *button;
    NSArray *tableArray;
}
@property(nonatomic,strong)  UITextView *textView;
@property(nonatomic,strong) UITableView *table;

// -(IBAction)textFieldReturn:(id)sender;


@end

@implementation ActivityRatingsViewController





-(void)dismissKeyboard {
    //  [self.view endEditing:YES];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Your Thoughts";
    
    
    
    
    //    self.skillSection = [self.skillDict valueForKey:@"skillName"];
    
    self.skillSection = [PersistenceStorage getObjectForKey:@"skillName"];
    
    
    //   UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
    //                                initWithTarget:self
    //                              action:@selector(dismissKeyboard)];
    
    //    [self.view addGestureRecognizer:tap];
    
    
    
    // Do any additional setup after loading the view.
    [self setUpView];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{//[super viewWillAppear:animated];
    self.title = @"Your Thoughts";
    
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{[self setView:nil];
    
    [self.tabBarController.tabBar setHidden:NO];
}


-(void) ViewDidDisappear: (bool) animated
{
    [self setView:nil]; }


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder]; // Dismiss the keyboard.
    // Execute any additional code
    
    return YES;
}



-(void)setUpView{
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    tableArray = @[@{@"name":@"Repeat this skill",@"image":@"refresh37"},@{@"name":@"Learn about this skill",@"image":@"archive32"},@{@"name":@"Try another skill",@"image":@"archive32"},@{@"name":@"Return Home",@"image":@"home32"}];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(24, 85, self.view.frame.size.width -20, 45)];
    label.text = @"How helpful was the skill you just completed? \n(select one)";
    label.numberOfLines = 2;
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_3];
    
    label.font = pallete.secondObj;
    label.textColor = pallete.firstObj;
    
    [self.view addSubview:label];
    
    ratingView = [[ASStarRatingView alloc]initWithFrame:CGRectMake(5, 130, 315, 80)];
    [ratingView setMaxAllowedRating:5.0];
    [ratingView setMinAllowedRating:0.0];
    [ratingView setDelegate:self];
    [self.view addSubview:ratingView];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(24, 224, 300, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.098/255.0 alpha:0.22];
    [self.view addSubview:lineView];
    
    UILabel *addlabel = [[UILabel alloc]initWithFrame:CGRectMake(24, 243, self.view.frame.size.width -20, 45)];
    addlabel.text = @"Additional comments or thoughts \n(optional):";
    
    
    addlabel.numberOfLines = 2;
    
    pallete = [Utils getColorFontPair:eCFS_PALLETE_3];
    
    addlabel.font = pallete.secondObj;
    addlabel.textColor = pallete.firstObj;
    
    [self.view addSubview:addlabel];
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(24, addlabel.frame.origin.y + addlabel.frame.size.height + 22 ,272, 110)];
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.098/255.0 alpha:0.22].CGColor;
    [self.textView setDelegate:self];
    [self.view addSubview:self.textView];
    
    
    
    
    button = [[UIButton alloc]initWithFrame:CGRectMake(114, self.textView.frame.origin.y + self.textView.frame.size.height + 20, 84, 38)];
    [button setTitle:@"Submit" forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:16.0];
    [button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
    
    button.layer.cornerRadius = 3.0f;
    [button setUserInteractionEnabled:NO];
    [self.navigationItem setHidesBackButton:YES];
    [button setBackgroundColor:[Utils colorWithHexValue:LABEL_BLUE_TEXT_COLOR_HEX_VALUE]];
    
    [self.view addSubview:button];
    
}

-(void)buttonTapped{
    
    [PersistenceStorage setObject:@"ActivityRatingsVC" andKey:@"Referer"];
    
    
    [self dismissModalViewControllerAnimated:YES];
    ActivitiesViewController *samplerView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ActivitiesViewController"];
    [self.navigationController pushViewController:samplerView animated:NO];
    
    [self writeWithRating];
    
    
    
    
    
    
    
    
    // [self showTable];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [self.textView resignFirstResponder];
        return NO;
    }
    return YES;
}



-(void)writeWithRating{
    NSURL *path = [self getUrlOfFiles:@"TinnitusCoachUsageData.csv"];
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentTXTPath = [documentsDirectory stringByAppendingPathComponent:@"TinnitusCoachUsageData.csv"];
    
    
    
    
    //  NSString *eventString = [NSString stringWithFormat:@"Date,Time,Event type,EventDetail1,EventDetails2,Plan-Section name,Plan Situation,Skill-Section name,Skill-Section Detail,Skill-Section2,Skill-Section3,Rating,Feedback"];
    //    NSString *writedStr = [[NSString alloc]initWithContentsOfURL:path encoding:NSUTF8StringEncoding error:nil];
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM/dd/yy";
    NSString *dateString = [dateFormatter stringFromDate: date];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"HH:mm:ss";
    NSString *timeString = [timeFormatter stringFromDate: date];
    NSString *type = @"Skill";
    NSString *ratingName ;
    switch ([[NSNumber numberWithFloat:ratingView.rating] integerValue]) {
        case 0:
            break;
        case 1:
            ratingName =@"1";
            break;
        case 2:
            ratingName =@"2";
            break;
        case 3:
            ratingName =@"3";
            break;
        case 4:
            ratingName =@"4";
            break;
            
        case 5:
            ratingName =@"5";
            break;
        default:
            break;
    }
    //  NSString *str = [[NSNumber numberWithFloat:ratingView.rating] stringValue];
    
    NSString *s = self.textView.text;

    
    NSString * newString = [s stringByReplacingOccurrencesOfString:@"," withString:@"|"];
    
//    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"/:,"];
  //  s = [[s componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @"C"];
    
    
    
    NSString *str = @"Provided Rating";
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"situationName"],[PersistenceStorage getObjectForKey:@"skillName"],[PersistenceStorage getObjectForKey:@"valueName"],[PersistenceStorage getObjectForKey:@"activityName"],@"Do Activity Now",nil,nil,nil,ratingName,newString];
    
    //   writedStr = [finalStr stringByAppendingString:eventString];
    //   writedStr = [writedStr stringByAppendingString:finalStr];
    
    /*  if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithContentsOfURL:path encoding:NSUTF8StringEncoding error:nil]])
     {
     [[NSFileManager defaultManager] removeItemAtURL:path error:nil];
     }
     [writedStr writeToURL:path atomically:YES encoding:NSStringEncodingConversionAllowLossy error:nil];
     
     */
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:documentTXTPath])
    {
        [finalStr writeToFile:documentTXTPath atomically:YES];
    }
    else
    {
        NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:documentTXTPath];
        [myHandle seekToEndOfFile];
        [myHandle writeData:[finalStr dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
}




-(void)ooshowTable{
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:effect];
        blurView.frame = self.view.bounds;
        [self.view addSubview:blurView];
        
    }
    
    self.table = [[UITableView alloc]initWithFrame:CGRectInset(self.view.frame, 20, 170) style:UITableViewStyleGrouped];
    //[self.table setBackgroundColor:[UIColor redColor]];
    [self.table setDelegate:self];
    [self.table setDataSource:self];
    //  [self.view addSubview:self.table];
    
    [self.view addSubview:self.table];
}

//-(void)viewWillAppear:(BOOL)animated{
//  [super viewWillAppear:animated];

//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self animateTextView : YES];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    [self animateTextView:NO];
    
}

- (void) animateTextView:(BOOL) up
{
    const int movementDistance =70; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement= movement = (up ? -movementDistance : movementDistance);
    NSLog(@"%d",movement);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textView resignFirstResponder];
}


#pragma mark Get URL to documents Directory
-(NSURL *)getUrlOfFiles:(NSString *)filename{
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *fileArray = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *path = [fileArray objectAtIndex:0];
    return [path URLByAppendingPathComponent:filename];
}

#pragma mark StarratingDelegate
-(void)ratingAdded{
    [button setUserInteractionEnabled:YES];
}


@end
