//
//  PleasantActivityViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 28/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

//#import "PleasantActivityViewController.h"
#import "ValueAndActivitiesViewController.h"
#import "NookUsingSoundViewControllerOne.h"
#import "NookUsingSoundViewController.h"
#import "NookUS.h"

@interface NookUsingSoundViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *paArray;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation NookUsingSoundViewController

- (void)viewDidLoad {
    [self setUpView];
    [super viewDidLoad];
    self.title = @"Nook Sound";
    // Do any additional setup after loading the view.
    
}

-(void)setUpView{
    self.pleasantActivityImageView.image = [UIImage imageNamed:@"5PleasantActivities"];
    paArray = [[NSArray alloc]initWithObjects:@"Whaat is Sound",@"Value & activities", nil];
    [self.scheduleTableView setDelegate:self];
    [self.scheduleTableView setDataSource:self];
    [self.scheduleTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.learnMoreButton.layer setCornerRadius:3.5f];
    [self.viewIntroButton.layer setCornerRadius:3.5f];
}



-(void)viewDidAppear:(BOOL)animated
{
    [self.scrollView setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.scrollView setContentSize:CGSizeMake(320,800)];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [paArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [paArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:15.0];
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]init];
    label.text = @"Schedule Pleasant Activities";
    label.font = [UIFont fontWithName:@"Helvetica Neue" size:15.0];
    return label;
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NookUS *favc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookUS"];
        [self.navigationController pushViewController:favc animated:YES];
    }else{
        ValueAndActivitiesViewController *vaavc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ValueAndActivitiesViewController"];
        [self.navigationController pushViewController:vaavc animated:YES];
    }
}


@end
