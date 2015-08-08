//
//  SkillDetailViewController.m
//  TinnitusCoach
//
//  Created by Vikram on 3/22/15.
//  Copyright (c) 2015 Swipe Video Labs Pvt. Ltd.. All rights reserved.
//

#import "SkillDetailViewController.h"
#import "SkillIntroductionViewController.h"


@interface SkillDetailViewController ()

@property (nonatomic, strong) DBManager *dbManagerMySkills;

@end

@implementation SkillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.skillDict valueForKey:@"skillName"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

-(IBAction)viewIntroductionAgainClicked:(id)sender{
    SkillIntroductionViewController *siv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SkillIntroductionViewController"];
    [self.navigationController pushViewController:siv animated:YES];

}

-(void)writeToMySkills
{
    self.dbManagerMySkills = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    
    NSString *query = [NSString stringWithFormat:@"insert into MySkills ('planID', 'groupID', 'skillID', 'timeStamp') values ('%@', '%@', '%@', '%@')",[PersistenceStorage getObjectForKey:@"currentPlanID"], [self.skillDict valueForKey:@"groupID"], [self.skillDict valueForKey:@"ID"], [NSDate date]];
    
    BOOL isDone = [self.dbManagerMySkills executeQuery:query];
    if (isDone == YES)
    {
        NSLog(@"Success");
    }
    else{
        NSLog(@"Error");
    }
}

-(IBAction)addSkillToPlan:(id)sender
{
    [self writeToMySkills];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3] animated:YES];

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
