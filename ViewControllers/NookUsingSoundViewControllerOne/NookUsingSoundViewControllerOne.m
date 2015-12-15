//
//  PleasantActivityViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 28/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

//#import "PleasantActivityViewController.h"
#import "ValueAndActivitiesViewController.h"
#import "FavoritesViewController.h"
#import "NookUsingSoundViewControllerOne.h"
#import "DBManager.h"

@interface NookUsingSoundViewControllerOne ()<UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate>{
    NSArray *paArray;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIDocumentInteractionController *controller;
@property (nonatomic, strong) DBManager *manager;

@end

@implementation NookUsingSoundViewControllerOne

- (void)viewDidLoad {
    [self setUpView];
    [super viewDidLoad];
    self.title = @"Sample Help Page";
    // Do any additional setup after loading the view.
    
}

-(void)setUpView{
    self.pleasantActivityImageView.image = [UIImage imageNamed:@"5PleasantActivities"];
    paArray = [[NSArray alloc]initWithObjects:@"What is Sound",@"Value & activities", nil];
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


- (IBAction)openPDF:(id)sender
{
    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"deep_breathing" withExtension:@"mp4"];
    if (URL)
    {
        self.controller = [UIDocumentInteractionController interactionControllerWithURL:URL];
        self.controller.delegate = self;
        // Present "Open In Menu"
        [self.controller presentOpenInMenuFromRect:[sender frame] inView:self.view animated:YES];
    } 
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
        FavoritesViewController *favc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookUsingSoundsViewControllerOne"];
        [self.navigationController pushViewController:favc animated:YES];
    }else{
        ValueAndActivitiesViewController *vaavc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ValueAndActivitiesViewController"];
        [self.navigationController pushViewController:vaavc animated:YES];
    }
}

- (IBAction)deleteAll:(id)sender {
    self.manager = [[DBManager alloc] initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    NSString *query = [NSString stringWithFormat:@"delete from MySkills"];
    NSString *query1 = [NSString stringWithFormat:@"delete from MyPlans"];
    NSString *query5 = [NSString stringWithFormat:@"delete from MyWebsites"];
    NSString *query3 = [NSString stringWithFormat:@"delete from MyReminders"];
    NSString *query4 = [NSString stringWithFormat:@"delete from MySkillReminders"];
    NSString *query6 = [NSString stringWithFormat:@"delete from MyActivities"];
    NSString *query7 = [NSString stringWithFormat:@"delete from My_Tips"];
    NSString *query8 = [NSString stringWithFormat:@"delete from My_Contacts"];
    NSString *query9 = [NSString stringWithFormat:@"delete from MyDevices"];
    [self.manager executeQuery:query];
    [self.manager executeQuery:query1];
    [self.manager executeQuery:query3];
    [self.manager executeQuery:query4];
    [self.manager executeQuery:query5];
    [self.manager executeQuery:query6];
    [self.manager executeQuery:query7];
    [self.manager executeQuery:query8];
    [self.manager executeQuery:query9];
    
}




@end
