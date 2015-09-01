//
//  PleasantActivityViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 28/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "InfoPopup.h"
#import "CTF03.h"

#import "CTF04.h"
#import "CTF05.h"
#import "ChangingThoughtsViewController.h"
#import "ThoughtErrorCell.h"


@interface CTF04 ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *paArray;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation CTF04

- (void)viewDidLoad {
    [self setUpView];
    [super viewDidLoad];
    self.title = @"Add New Entry";
    // Do any additional setup after loading the view.
    [self.scheduleTableView setContentInset:UIEdgeInsetsMake(-50,0,0,0)];
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
    
    
    
    self.pleasantActivityImageView.image = [UIImage imageNamed:@"5PleasantActivities"];
    paArray = [[NSArray alloc]initWithObjects:@"All-or-nothing Thinking",@"Assuming the Worst",@"Blaming",@"Emotional Thoughts",@"Focusing on Wrong Details",@"Jumping to Conclusions",@"Labeling",@"Making Things Personal",@"Over-Simplifying",@"\"Should\" Statements", nil];
    [self.scheduleTableView setDelegate:self];
    [self.scheduleTableView setDataSource:self];
    [self.scheduleTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.learnMoreButton.layer setCornerRadius:3.5f];
    [self.viewIntroButton.layer setCornerRadius:3.5f];
}

- (void)cancelTapped  {
    for (UIViewController* vc in self.navigationController.viewControllers) {
        if([vc isKindOfClass:[ChangingThoughtsViewController class]]){
            [self.navigationController popToViewController:vc animated:YES];
        }
    }

}

-(IBAction)nextTapped:(id)sender
{
    CTF05 *favc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CTF05"];
    [self.navigationController pushViewController:favc animated:YES];

}


-(void)viewDidAppear:(BOOL)animated
{
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)cancelTapped:(id)sender {
    for (UIViewController* vc in self.navigationController.viewControllers) {
        if([vc isKindOfClass:[ChangingThoughtsViewController class]]){
            [self.navigationController popToViewController:vc animated:YES];
        }
    }

}



- (IBAction)backTapped:(id)sender {
    CTF03 *ratingsView = [[UIStoryboard storyboardWithName:@"Main"bundle:nil]instantiateViewControllerWithIdentifier:@"CTF03"];
    
    
    [self.navigationController pushViewController:ratingsView animated:NO];
}




#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [paArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CellIdentifier";
    ThoughtErrorCell *cell = (ThoughtErrorCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ThoughtErrorCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    
    cell.lblTitle.text  = [paArray objectAtIndex:indexPath.row];
    cell.lblTitle.font = [UIFont fontWithName:@"Helvetica Neue" size:15.0];
    
    cell.btnInfoCategory.tag = indexPath.row;
    /*
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Active_Information_icon_28px" ofType:@"png"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:path];
    cell.imageView.image = theImage;
    cell.imageView.frame = CGRectMake(0,0,32,32);
    
    cell.imageView.userInteractionEnabled = YES;
    
     cell.imageView.tag = indexPath.row;
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myFunction:)];
    tapped.numberOfTapsRequired = 1;
    [cell.imageView addGestureRecognizer:tapped];
    */
    /*
// cell.accessoryView = cell.imageView;
    cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"Active_Information_icon28px.png"]];;
    [cell.accessoryView setFrame:CGRectMake(0, 0, 24, 24)];
     */
    return cell;
}


-(IBAction)myFunction :(id) sender
{
    //UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    //NSInteger *tgesture= gesture.view.tag;
    UIButton *infoButton = (UIButton *) sender;
    if (infoButton.tag ==0)
    { [PersistenceStorage setObject:@"thoughterror0.html" andKey:@"infopopupfile"];
        [self viewedInfo:@"All-or-nothing Thinking"];}

    if (infoButton.tag ==1)
    { [PersistenceStorage setObject:@"thoughterror1.html" andKey:@"infopopupfile"];
        //Assuming the Worst ("Catastrophizing")
        [self viewedInfo:@"Assuming the Worst ('Catastrophizing')"];}

    if (infoButton.tag ==2)
    { [PersistenceStorage setObject:@"thoughterror2.html" andKey:@"infopopupfile"];
        [self viewedInfo:@"Blaming"];}

    
    if (infoButton.tag ==3)
    { [PersistenceStorage setObject:@"thoughterror3.html" andKey:@"infopopupfile"];
        [self viewedInfo:@"Emotional Thoughts"];}

    if (infoButton.tag ==4)
    { [PersistenceStorage setObject:@"thoughterror4.html" andKey:@"infopopupfile"];
        [self viewedInfo:@"Focusing on Wrong Details"];}

    if (infoButton.tag ==5)
    { [PersistenceStorage setObject:@"thoughterror5.html" andKey:@"infopopupfile"];
        [self viewedInfo:@"Jumping to Conclusions"];}

    if (infoButton.tag ==6)
    { [PersistenceStorage setObject:@"thoughterror6.html" andKey:@"infopopupfile"];
        [self viewedInfo:@"Labeling"];}

    if (infoButton.tag ==7)
    { [PersistenceStorage setObject:@"thoughterror7.html" andKey:@"infopopupfile"];
        [self viewedInfo:@"Making Things Personal"];}
    if (infoButton.tag ==8)
    { [PersistenceStorage setObject:@"thoughterror8.html" andKey:@"infopopupfile"];
        [self viewedInfo:@"Over-simplifying"];}

    if (infoButton.tag ==9)
    { [PersistenceStorage setObject:@"thoughterror9.html" andKey:@"infopopupfile"];
        [self viewedInfo:@"'Should' Statements"];}

    if (infoButton.tag ==10)
    { [PersistenceStorage setObject:@"thoughterror10.html" andKey:@"infopopupfile"];
        [self viewedInfo:@"All-or-nothing Thinking"];}

    if (infoButton.tag ==11)
    { [PersistenceStorage setObject:@"thoughterror11.html" andKey:@"infopopupfile"];
        [self viewedInfo:@"All-or-nothing Thinking"];}


    InfoPopup *ip = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"InfoPopup"];
    
        [self.navigationController presentModalViewController:ip animated:NO];
    
}





-(void)viewedInfo:itemName
{
  //  NSURL *path = [self getUrlOfFiles:@"TinnitusCoachUsageData.csv"];
    
    
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
    NSString *optionName = [PersistenceStorage getObjectForKey:@"optionName"];
    NSString *str = @"Viewed Info";
    
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,[PersistenceStorage getObjectForKey:@"planName"],[PersistenceStorage getObjectForKey:@"situationName"],[PersistenceStorage getObjectForKey:@"skillName"],itemName,nil,nil,nil,nil,nil,nil,nil];
    
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


/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]init];
    label.text = @"";
    label.font = [UIFont fontWithName:@"Helvetica Neue-Bold" size:15.0];
    return label;
}
*/
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
/*if (indexPath.row == 0) {
        FavoritesViewController *favc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"FavoritesViewController"];
        [self.navigationController pushViewController:favc animated:YES];
    }else{
        ValueAndActivitiesViewController *vaavc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ValueAndActivitiesViewController"];
        [self.navigationController pushViewController:vaavc animated:YES];
    }*/
    
    
    
    
    [PersistenceStorage setObject:[paArray objectAtIndex:indexPath.row] andKey:@"ctf04text"];

    
    
    
   
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
