//
//  BaseSkilDetailViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 13/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "BaseSkilDetailViewController.h"
#import "ChangingThoughtsViewController.h"

@interface BaseSkilDetailViewController ()

@end

@implementation BaseSkilDetailViewController

-(void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 180, 44)];
    
    titleView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 25)];
    
    titleLabel.adjustsFontSizeToFitWidth=YES;
    titleLabel.minimumScaleFactor=0.5;
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_1];
    
    titleLabel.font = pallete.secondObj;
    titleLabel.textColor = pallete.firstObj;
    
    titleLabel.backgroundColor = [UIColor clearColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //titleLabel.textColor = [UIColor colorWithHexValue:@"797979"];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = [self planText];
    
    
    CGFloat width = 180;
    CGFloat origin = 0;
    
    if([self isKindOfClass:[ChangingThoughtsViewController class]]){
        width = 200;
        origin = -10;
    }
    
    UILabel *situationLabel = [[UILabel alloc]initWithFrame:CGRectMake(origin, 20
                                                                    , width, 20)];
    
    pallete = [Utils getColorFontPair:eCFS_PALLETE_2];
    
    situationLabel.font = pallete.secondObj;
    situationLabel.textColor = pallete.firstObj;
    
    situationLabel.textAlignment = NSTextAlignmentCenter;
    
    //titleLabel.textColor = [UIColor colorWithHexValue:@"797979"];
    situationLabel.backgroundColor = [UIColor clearColor];
    situationLabel.text = [self activityText];
    
    [titleView addSubview:titleLabel];
    [titleView addSubview:situationLabel];
    
    self.navigationItem.titleView = titleView;
    
    UIImageView *backLabel = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 15, 20)];
    
    backLabel.image = [UIImage imageNamed:@"Active_Back-Arrow.png"];
    
    [Utils addTapGestureToView:backLabel target:self
                      selector:@selector(cancel)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backLabel];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -8;
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, item, nil];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Abstract Methods
-(NSString *)activityText
{
    return nil;
}

-(NSString *)planText
{
    return @"Plan";
}

@end
