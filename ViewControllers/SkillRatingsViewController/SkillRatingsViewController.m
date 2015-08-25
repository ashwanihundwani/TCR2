//
//  RatingsViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 18/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "SkillRatingsViewController.h"
#import "ASStarRatingView.h"
#import "ImageryViewController.h"
#import "DeepBreathingViewController.h"
#import "NookUsingSoundViewControllerOne.h"

@interface SkillRatingsViewController ()<UITextViewDelegate,ASStarRatingViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    ASStarRatingView *ratingView;
    UIButton *button;
    NSArray *tableArray;
}
@property(nonatomic,strong)  UITextView *textView;
@property(nonatomic,strong) UITableView *table;

// -(IBAction)textFieldReturn:(id)sender;


@end

@implementation SkillRatingsViewController





-(void)dismissKeyboard {
//[self.view endEditing:YES];
}




- (void)viewDidLoad {
    [super viewDidLoad];
      self.title = @"Your Thoughts";
    
    //self.skillSection = [self.skillDict valueForKey:@"skillName"];
    
    self.skillSection = [PersistenceStorage getObjectForKey:@"skillName"];

    
    
    //  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
      //                             initWithTarget:self
        //                           action:@selector(dismissKeyboard)];
    
    //[self.view addGestureRecognizer:tap];
    
    
    
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
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, self.view.frame.size.width -20, 80)];
    label.text = @"How helpful was the skill you just completed? (select one)";
    label.numberOfLines = 2;
    label.font = [UIFont fontWithName:@"Helvetica Neue" size:15.0];

    [self.view addSubview:label];
    
     ratingView = [[ASStarRatingView alloc]initWithFrame:CGRectMake(0, 140, 320, 90)];
    [ratingView setMaxAllowedRating:5.0];
    [ratingView setMinAllowedRating:0.0];
    [ratingView setDelegate:self];
    [self.view addSubview:ratingView];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 240, 300, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.098/255.0 alpha:0.22];
    [self.view addSubview:lineView];
 
    
    
    UILabel *addlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, ratingView.frame.origin.y + ratingView.frame.size.height, self.view.frame.size.width -20, 80)];
    addlabel.text = @"Additional comments or thoughts (optional):";
    addlabel.font = [UIFont fontWithName:@"Helvetica Neue" size:15.0];
    addlabel.numberOfLines = 2;
    [self.view addSubview:addlabel];
    
   self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, addlabel.frame.origin.y+ addlabel.frame.size.height-15, self.view.frame.size.width -20 , 80 )];
    
     
    
    
    
    
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.textView setDelegate:self];
    [self.view addSubview:self.textView];
    
    button = [[UIButton alloc]initWithFrame:CGRectMake(120, self.textView.frame.origin.y + self.textView.frame.size.height + 10, 100, 30)];
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


-(void)buttonTapped{
    
    [PersistenceStorage setObject:@"SkillRatingsViewController" andKey:@"Referer"];

       
    
    if ([[PersistenceStorage getObjectForKey:@"skillDetail1"] isEqualToString:@"Timer for Practice"])
        
    {        [self writeTimerSoundSelected];
    }
    else
        
    {
        [self writeWithRating];
        
    }
    
    

    if ([[PersistenceStorage getObjectForKey:@"ItsMondayShowWR"] isEqualToString:@"SomeOtherDay"])
        
        
    {    [PersistenceStorage setObject:@"" andKey:@"Referer"];
        [PersistenceStorage setObject:@"No" andKey:@"ItsMondayShowWR"];
        
        [self dismissViewControllerAnimated:YES completion:^{}];
        
    }

    
    
    
    
    
    
    if ([[PersistenceStorage getObjectForKey:@"ItsMondayShowWR"] isEqualToString:@"Yes"])

    
    {    [PersistenceStorage setObject:@"OK" andKey:@"Referer"];

        [self dismissViewControllerAnimated:YES completion:^{
         [PersistenceStorage setObject:@"No" andKey:@"ItsMondayShowWR"];

     
    UIStoryboard *storyBoard = [ UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mySleepsViewCotroller = [storyBoard instantiateViewControllerWithIdentifier:@"WeeklyViewController"];
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows firstObject];
    [currentWindow.rootViewController presentViewController:mySleepsViewCotroller animated:YES completion:nil];
    }];
    
}
        else
            
        {    [self dismissModalViewControllerAnimated:YES];
        }


}





-(void)writeTimerSoundSelected
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentTXTPath = [documentsDirectory stringByAppendingPathComponent:@"TinnitusCoachUsageData.csv"];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM/dd/yy";
    NSString *dateString = [dateFormatter stringFromDate: date];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"HH:mm:ss";
    NSString *timeString = [timeFormatter stringFromDate: date];
    NSString *type = @"Skill";
    NSString *str = @"Provided a Rating";
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

    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"situationName"],[PersistenceStorage getObjectForKey:@"skillName"],[PersistenceStorage getObjectForKey:@"skillDetail1"],[PersistenceStorage getObjectForKey:@"skillDetail2"],nil,nil,nil,nil,ratingName,newString];
    
     [PersistenceStorage setObject:nil andKey:@"skillDetail1"];
    
    NSLog(@"%@",finalStr);
    
    
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
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"/:,"];
    s = [[s componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @"|"];
    NSString *str = @"Provided Rating";

    
    if ([[PersistenceStorage getObjectForKey:@"skillName"] isEqualToString:@"Changing Thoughts & Feelings"])
    
    {
       // NSLog(@"%@",[PersistenceStorage getObjectForKey:@"ctf06textRating"]);

        NSString *s = self.textView.text;
        
        
        NSString * newString = [s stringByReplacingOccurrencesOfString:@"," withString:@"|"];

        NSString *ctf01TextRating = [PersistenceStorage getObjectForKey:@"ctf01textRating"];
        NSString *ctf02TextRating = [PersistenceStorage getObjectForKey:@"ctf02textRating"];   ///BUG
        NSString *ctf05TextRating = [PersistenceStorage getObjectForKey:@"ctf05textRating"];
        NSLog(@"%@",ctf02TextRating);

        
        NSString * ctf01TextRatingModified = [ctf01TextRating stringByReplacingOccurrencesOfString:@"," withString:@"|"];
        NSString * ctf02TextRatingModified = [ctf02TextRating stringByReplacingOccurrencesOfString:@"," withString:@"|"];
        NSString * ctf05TextRatingModified = [ctf05TextRating stringByReplacingOccurrencesOfString:@"," withString:@"|"];

        
        
        
        NSString *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"situationName"],[PersistenceStorage getObjectForKey:@"skillName"],ctf01TextRatingModified,ctf02TextRatingModified,[PersistenceStorage getObjectForKey:@"ctf03textRating"],[PersistenceStorage getObjectForKey:@"ctf04textRating"],ctf05TextRatingModified,[PersistenceStorage getObjectForKey:@"ctf06textRating"],ratingName,newString];
        

        NSLog(@"%@",finalStr);
        
        
        
   //     NSString *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"situationName"],[PersistenceStorage getObjectForKey:@"skillName"],[PersistenceStorage getObjectForKey:@"ctf01textRating"],[PersistenceStorage getObjectForKey:@"ctf02textRating"],[PersistenceStorage getObjectForKey:@"ctf03textRating"],[PersistenceStorage getObjectForKey:@"ctf04textRating"],[PersistenceStorage getObjectForKey:@"ctf05textRating"],[PersistenceStorage getObjectForKey:@"ctf06textRating"],ratingName,newString];
        
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

    } else
        
        if ([[PersistenceStorage getObjectForKey:@"skillName"] isEqualToString:@"Using Sound"])
        {
        
            NSString *s = self.textView.text;
            
            NSString *type = @"Skill";

            NSString * newString = [s stringByReplacingOccurrencesOfString:@"," withString:@"|"];
            
            NSString *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"situationName"],[PersistenceStorage getObjectForKey:@"skillName"],[PersistenceStorage getObjectForKey:@"skillDetail1"],[PersistenceStorage getObjectForKey:@"skillDetail2"],[PersistenceStorage getObjectForKey:@"deviceArray"],nil,nil,nil,ratingName,newString];
            
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

        
    
        else
        
    {
        
        NSString *s = self.textView.text;
        
        
        NSString * newString = [s stringByReplacingOccurrencesOfString:@"," withString:@"|"];

        NSString *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"situationName"],[PersistenceStorage getObjectForKey:@"skillName"],[PersistenceStorage getObjectForKey:@"skillDetail1"],nil,nil,nil,nil,nil,ratingName,newString];
        
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

    
 //   writedStr = [finalStr stringByAppendingString:eventString];
 //   writedStr = [writedStr stringByAppendingString:finalStr];
    
  /*  if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithContentsOfURL:path encoding:NSUTF8StringEncoding error:nil]])
    {
        [[NSFileManager defaultManager] removeItemAtURL:path error:nil];
    }
    [writedStr writeToURL:path atomically:YES encoding:NSStringEncodingConversionAllowLossy error:nil];

   */
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
    return @"Where would you like to go now?";
}



- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.text = [tableViewHeaderFooterView.textLabel.text capitalizedString];
    }
}




#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
     switch (indexPath.row) {
        case 0:{
            
//[self dismissModalViewControllerAnimated:YES];
            
            [self.navigationController popViewControllerAnimated:YES];

        }
        
            break;
   //     case 2:{
            
//[self dismissModalViewControllerAnimated:YES];
            
 
       /*
            
            [PersistenceStorage setObject:str andKey:@"sskillname"];

            
  //[self.skillDict valueForKey:@"skillName"]
            
            if ([PersistenceStorage getIntegerForKey:@"currentSkillID"] == 2)
            {
                
                
              //  [self.skillDict valueForKey:[PersistenceStorage getObjectForKey:@"currentSkillID"]]
 
            DeepBreathingViewController *samplerView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"DeepBreathingViewController"];
            [self.navigationController pushViewController:samplerView animated:NO];
            }
            
            

            if ([PersistenceStorage getIntegerForKey:@"currentSkillID"] == 3)
            {
                 ImageryViewController *samplerView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ImageryViewController"];
                [self.navigationController pushViewController:samplerView animated:NO];
            }
            
         */
     //   }
            
      //      break;
             
        case 1:{
            
            NookUsingSoundViewControllerOne *samplerView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookUsingSoundViewControllerOne"];
            [self.navigationController pushViewController:samplerView animated:NO];

            
        }
            
            break;
        
        case 2:{
           
        [self.navigationController popToRootViewControllerAnimated:YES];

        }
            
            break;
             
         case 3:{
 //            [self.navigationController popToRootViewControllerAnimated:YES];

             
             
             
             
             
             
             
             
             [[self tabBarController] setSelectedIndex:0];
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
