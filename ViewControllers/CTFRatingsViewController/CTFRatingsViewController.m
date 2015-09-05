//
//  RatingsViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 18/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "CTFRatingsViewController.h"
#import "NookUsingSoundViewControllerOne.h"
#import "ASStarRatingView.h"
#import "DBManager.h"

@interface CTFRatingsViewController ()<UITextViewDelegate,ASStarRatingViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    ASStarRatingView *ratingView;
    UIButton *button;
    NSArray *tableArray;
}
@property(nonatomic,strong)DBManager *dbManager;
@property (weak, nonatomic) IBOutlet UILabel *textInfo;

@property(nonatomic,strong)  UITextView *textView;
@property(nonatomic,strong) UITableView *table;
@end

@implementation CTFRatingsViewController


-(void)dismissKeyboard {
  //  [self.view endEditing:YES];}
}


- (void)viewDidLoad {
    [super viewDidLoad];
      self.title = @"Your Thoughts";
    self.dbManager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
 //   [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
    [self setUpView];
   

}



- (void)viewWillAppear:(BOOL)animated
{//[super viewWillAppear:animated];
    
    self.title = @"Your Thoughts";
[self.navigationItem setTitle:@"Your Thoughts"];
    
    
    NSString *infoLabel = [NSString stringWithFormat:@"How strongly do you feel '%@'? (Providing a rating will save the emotion to the list of selected automatic emotions.)",[PersistenceStorage getObjectForKey:@"emotionName"]];
    
    self.textInfo.text = infoLabel;
    
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{[self.tabBarController.tabBar setHidden:NO];
}






-(void)setUpView{
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    tableArray = @[@{@"name":@"Repeat this exercise",@"image":@"refresh37"},@{@"name":@"Learn about this exercise",@"image":@"lightbulb32"},@{@"name":@"Try another exercise",@"image":@"archive32"},@{@"name":@"Return Home",@"image":@"home32"}];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, self.view.frame.size.width -20, 80)];
    label.text = @" ";
    label.numberOfLines = 2;
    label.font = [UIFont fontWithName:@"Helvetica Neue" size:15.0];

    [self.view addSubview:label];
    
     ratingView = [[ASStarRatingView alloc]initWithFrame:CGRectMake(0, 220, 320, 90)];
    [ratingView setMaxAllowedRating:5.0];
    [ratingView setMinAllowedRating:0.0];
    [ratingView setDelegate:self];
    [self.view addSubview:ratingView];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 340, 300, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.098/255.0 alpha:0.22];
    [self.view addSubview:lineView];
 
    
    
    UILabel *addlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, ratingView.frame.origin.y + ratingView.frame.size.height, self.view.frame.size.width -20, 80)];
    addlabel.text = @"Additional comments or thoughts (optional):";
    addlabel.font = [UIFont fontWithName:@"Helvetica Neue" size:15.0];
    addlabel.numberOfLines = 2;
 //   [self.view addSubview:addlabel];
    
   self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, addlabel.frame.origin.y+ addlabel.frame.size.height-15, self.view.frame.size.width -20 , 80 )];
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.textView setDelegate:self];
//[self.view addSubview:self.textView];
    
    
    
    button = [[UIButton alloc]initWithFrame:CGRectMake(40, self.textView.frame.origin.y + self.textView.frame.size.height + 10, 100, 30)];
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.font = [UIFont fontWithName:@"Helvetica Neue" size:15.0];
    [button addTarget:self action:@selector(cancelTappedCTF) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
    
    button.layer.cornerRadius = 5.0f;
    [button setUserInteractionEnabled:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.view addSubview:button];
    
    

    
    
    
    button = [[UIButton alloc]initWithFrame:CGRectMake(180, self.textView.frame.origin.y + self.textView.frame.size.height + 10, 100, 30)];
    [button setTitle:@"Submit" forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.font = [UIFont fontWithName:@"Helvetica Neue" size:15.0];
    [button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
    
    button.layer.cornerRadius = 5.0f;
    [button setUserInteractionEnabled:NO];
    [self.navigationItem setHidesBackButton:YES];
    [self.view addSubview:button];

    
    
    
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [self.textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)buttonTapped{
    
    
    [PersistenceStorage setObject:@"CTFRatingsVC" andKey:@"Referer"];

    [self dismissModalViewControllerAnimated:YES];

    
       [self writeWithRating];
     //[self showTable];
}


-(void)cancelTappedCTF{
    
    
    
    [self dismissModalViewControllerAnimated:YES];
    
    NSLog(@"%@",@"jasdadss");;     //[self showTable];
}



-(void)writeWithRating{
     NSURL *path = [self getUrlOfFiles:@"TinnitusCoachUsageData.csv"];
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentTXTPath = [documentsDirectory stringByAppendingPathComponent:@"TinnitusCoachUsageData.csv"];
    
    
    
    
    NSString *eventString = [NSString stringWithFormat:@"Date,Time,Event type,EventDetail1,EventDetails2,Plan-Section name,Plan Situation,Skill-Section name,Skill-Section Detail,Skill-Section2,Skill-Section3,Rating,Feedback"];
    NSString *writedStr = [[NSString alloc]initWithContentsOfURL:path encoding:NSUTF8StringEncoding error:nil];
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM/dd/yy";
    NSString *dateString = [dateFormatter stringFromDate: date];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"HH:mm:ss";
    NSString *timeString = [timeFormatter stringFromDate: date];
    NSString *type = @"Sampler";
    NSString *ratingName ;
    switch ([[NSNumber numberWithFloat:ratingView.rating] integerValue]) {
        case 0:
            break;
        case 1:
            ratingName =@"Not at All";
            break;
        case 2:
            ratingName =@"A Little";
            break;
        case 3:
            ratingName =@"Moderately";
            break;
        case 4:
            ratingName =@"Very Much";
            break;
            
        case 5:
            ratingName =@"Extremely";
            break;
        default:
            break;
    }
    
    
//[PersistenceStorage getObjectForKey:@"soundName"]
  //  [PersistenceStorage getObjectForKey:@"soundURL"]]
    
    
    
    int planID = (int)[PersistenceStorage getIntegerForKey:@"currentPlanID"];
    int skillID = (int)[PersistenceStorage getIntegerForKey:@"currentSkillID"];
    int grouID = (int)[PersistenceStorage getIntegerForKey:@"currentGroupID"];
    
    
    
    if ([[PersistenceStorage getObjectForKey:@"ctfCategory"] isEqualToString:@"ctf03"])
    {
    
    NSString *deleteQuery = [NSString stringWithFormat:@"delete from My_TF where where  thoughtCategory = 'step3' and thoughtText='%@'",[PersistenceStorage getObjectForKey:@"emotionName"]];

    
    
    NSString *inserQquery = [NSString stringWithFormat:@"insert into My_TF (planID,groupID,skillID,thoughtTypeID,thoughtTypeCategoryID,thoughtText,rating, thoughtCategory) values(%d,%d,%d,'%@','%@','%@','%@','%@')",planID,grouID,skillID,@"",@"",[PersistenceStorage getObjectForKey:@"emotionName"],ratingName,@"step3"];
        NSLog(@"%@",deleteQuery);
        NSLog(@"%@",inserQquery);
        // Execute the query.
        [self.dbManager executeQuery:deleteQuery];
        
        [self.dbManager executeQuery:inserQquery];
}
    else
        
    {
        
        NSString *deleteQuery = [NSString stringWithFormat:@"delete from My_TF where where  thoughtCategory = 'step6' and thoughtText='%@'",[PersistenceStorage getObjectForKey:@"emotionName"]];
        
        
        
        NSString *inserQquery = [NSString stringWithFormat:@"insert into My_TF (planID,groupID,skillID,thoughtTypeID,thoughtTypeCategoryID,thoughtText,rating, thoughtCategory) values(%d,%d,%d,'%@','%@','%@','%@','%@')",planID,grouID,skillID,@"",@"",[PersistenceStorage getObjectForKey:@"emotionName"],ratingName,@"step6"];
        NSLog(@"%@",deleteQuery);
        NSLog(@"%@",inserQquery);
        // Execute the query.
        [self.dbManager executeQuery:deleteQuery];
        
        [self.dbManager executeQuery:inserQquery];
}
    
        
        
        
        
        
    //    [selectedTipsCategories valueForKey:@"ID"]
    
    
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        //        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
    }

    
    
    
    NSString *s = self.textView.text;
    
    
    NSString * newString = [s stringByReplacingOccurrencesOfString:@"," withString:@"|"];
    
    
    
    NSString *str = [[NSNumber numberWithFloat:ratingView.rating] stringValue];
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,@"Provided Rating",nil,nil,nil,[PersistenceStorage getObjectForKey:@"SamplerType"], [PersistenceStorage getObjectForKey:@"SamplerSoundName"],nil,nil,nil,nil,nil,ratingName,newString];
    
 //   writedStr = [finalStr stringByAppendingString:eventString];
 //   writedStr = [writedStr stringByAppendingString:finalStr];
    
  /*  if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithContentsOfURL:path encoding:NSUTF8StringEncoding error:nil]])
    {
        [[NSFileManager defaultManager] removeItemAtURL:path error:nil];
    }
    [writedStr writeToURL:path atomically:YES encoding:NSStringEncodingConversionAllowLossy error:nil];

   */

    
    
    
//    NOT WRITING THE FINAL FILE
    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if(![fileManager fileExistsAtPath:documentTXTPath])
//    {
//        [finalStr writeToFile:documentTXTPath atomically:YES];
//    }
//    else
//    {
//        NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:documentTXTPath];
//        [myHandle seekToEndOfFile];
//        [myHandle writeData:[finalStr dataUsingEncoding:NSUTF8StringEncoding]];
// 
//    }
   
   }


-(void)showTable{
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

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [tableArray objectAtIndex:indexPath.row];
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
    }
    cell.imageView.image = [UIImage imageNamed:[dict valueForKey:@"image"]];
    cell.textLabel.text = [dict valueForKey:@"name"];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Where would you like to go now";
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    switch (indexPath.row) {
        case 0:{
            

            
            [self.navigationController popViewControllerAnimated:YES];

        }
        
            break;
        case 1:{
            
            
            NookUsingSoundViewControllerOne *samplerView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookUsingSoundViewControllerOne"];
            [self.navigationController pushViewController:samplerView animated:NO];

            
           
        }
            
            break;
        case 2:{
//            SamplerViewController *samplerView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SamplerViewController"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            
            break;
        
        case 3:{
            
            [[self tabBarController] setSelectedIndex:0];

            
           
/* HomeViewController *samplerView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"HomeViewController"];
            [self.navigationController pushViewController:samplerView animated:NO];
     //       [self.navigationController popToRootViewControllerAnimated:YES]; */

        }
            
            break;
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
