//
//  NewPlanSupportViewController.m
//  TinnitusCoach
//
//  Created by Vikram Singh on 3/21/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "NewPlanSupportViewController.h"
#import "NavigationTipsViewController.h"

#import "DDPageControl.h"
#import "IntroPageView.h"
#import "IntroPageInfo.h"

#define TOTAL_SCREENS self.pageInfos.count
#define TINT_COLOR_HEX @"B7CDD8"
#define SELECTED_TINT_COLOR_HEX @"929292"
#define LETS_GET_STARTED_LABEL_HEIGHT 50
#define AVAILABLE_WIDTH_FOR_TEXT 290

@interface NewPlanSupportViewController ()<MYIntroductionDelegate, UIScrollViewDelegate>

@property(nonatomic , strong)UIScrollView *scrollView;
@property(nonatomic, strong)DDPageControl *pageControl;


@end

@implementation NewPlanSupportViewController

-(CGFloat)heightForViewForInfo:(IntroPageInfo *)info
{
    CGFloat constant = 38;
    
    CGFloat titleHeight = [Utils heightForLabelForString:info.title width:AVAILABLE_WIDTH_FOR_TEXT  font:[Utils helveticaNueueFontWithSize:16.5]];
    
    
    CGFloat subtitleHeight = [Utils heightForLabelForString:info.descriptionText width:AVAILABLE_WIDTH_FOR_TEXT font:[Utils helveticaNueueFontWithSize:15]];
    
    
    constant += (titleHeight +subtitleHeight);
    
    return constant;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.pageInfos = [NSMutableArray array];
    
    IntroPageInfo *info = [[IntroPageInfo alloc] initWithimage:nil title: @"What is a \"plan\"?" description:@"A \"plan\" describes what you will do when your tinnitus is bothering you. Your tinnitus can bother you in different situations. You will first identify a bothersome situation you want to work on. \n\n Then you will make a plan specific to that situation. This app will help you make each plan that you would like to try. Then, when your tinnitus is bothering you can use your plan for that situation."];
    
    [self.pageInfos addObject:info];
    
    IntroPageInfo *info2 = [[IntroPageInfo alloc] initWithimage:nil title: @"How will making and using plans help me with my tinnitus?" description:@"Several coping skills can be used to help you feel better when your tinnitus is bothering you. When you make a plan, you will first see a list of coping skills. \n\n If you see a skill you would like to learn, you can add it to your plan. When you use your plan, the app will teach you how to use each skill on your plan. As you practice skills, you will learn which are helpful for you."];
    
    [self.pageInfos addObject:info2];
    
    //self.header = @"Welcome to Guided Meditation";
    
    
    self.tabBarController.tabBar.hidden = TRUE;
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 320, 40)];
    
    headerLabel.text = self.header;
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_3];
    headerLabel.font = pallete.secondObj;
    headerLabel.textColor = pallete.firstObj;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:headerLabel];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - LETS_GET_STARTED_LABEL_HEIGHT)];
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = TRUE;
    self.scrollView.pagingEnabled = TRUE;
    self.scrollView.hidden = FALSE;
    self.scrollView.showsHorizontalScrollIndicator = FALSE;
    self.scrollView.showsVerticalScrollIndicator = FALSE;
    self.scrollView.bounces = YES;
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    
    //Configuring scroll view
    CGRect frame = self.scrollView.frame;
    
    [self.scrollView setContentSize:CGSizeMake(((self.view.frame.size.width) * TOTAL_SCREENS),frame.size.height)];
    
    [self addCloseButton];
    [self addViewsToScrollViewWithFrame:frame];
    
    [self.view addSubview:self.scrollView];
    
    // programmatically add the page control
    self.pageControl = [[DDPageControl alloc] init] ;
    [self.pageControl setCenter: CGPointMake(TOTAL_SCREENS * 12 + 12, self.view.bounds.size.height-30.0f)] ;
    [self.pageControl setNumberOfPages: TOTAL_SCREENS] ;
    [self.pageControl setCurrentPage: 0] ;
    [self.pageControl setDefersCurrentPageDisplay: YES] ;
    [self.pageControl setType: DDPageControlTypeOnFullOffEmpty] ;
    
    [self.pageControl setOnColor: [Utils colorWithHexValue:SELECTED_TINT_COLOR_HEX]] ;
    [self.pageControl setOffColor: [Utils colorWithHexValue:SELECTED_TINT_COLOR_HEX]] ;
    [self.pageControl setIndicatorDiameter: 12.0f] ;
    [self.pageControl setIndicatorSpace: 12.0f] ;
    [self.view addSubview: self.pageControl] ;
    NavigationTipsViewController *ntv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NavigationTipsViewController"];
    [self.navigationController presentViewController:ntv animated:YES completion:nil];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewWillAppear:(BOOL)animated
{[self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{[self.tabBarController.tabBar setHidden:NO];
}




-(void)showTour{
    
    //STEP 1 Construct Panels
    self.navigationController.navigationBar.hidden=YES;
    //You may also add in a title for each panel
    
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithTitle:@"What is a \"plan\"?" description:@"A \"plan\" describes what you will do when your tinnitus is bothering you. Your tinnitus can bother you in different situations. You will first identify a bothersome situation you want to work on. \n\n Then you will make a plan specific to that situation. This app will help you make each plan that you would like to try. Then, when your tinnitus is bothering you can use your plan for that situation. "];
    
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithTitle:@"How will making and using plans help me with my tinnitus?" description:@"Several coping skills can be used to help you feel better when your tinnitus is bothering you. When you make a plan, you will first see a list of coping skills. \n\n If you see a skill you would like to learn, you can add it to your plan. When you use your plan, the app will teach you how to use each skill on your plan. As you practice skills, you will learn which are helpful for you."];
    
    
    //STEP 2 Create IntroductionView
    
    
    /*A more customized version*/
    
    //    NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc] initWithString:@"Welcome to the Party !"];
    //    [string1 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [string1 length])];
    //
    //    NSMutableAttributedString * string2 = [[NSMutableAttributedString alloc] initWithString:@"X a Post"];
    //    [string2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [string2 length])];
    //
    //    NSMutableAttributedString * string3 = [[NSMutableAttributedString alloc] initWithString:@"Check Posts"];
    //    [string3 addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, [string3 length])];
    //
    //    NSMutableAttributedString * string4 = [[NSMutableAttributedString alloc] initWithString:@"Flag a Post"];
    //    [string4 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [string4 length])];
    
    MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(20, 0, self.view.bounds.size.width-40, 500) headerTexts:@[@"What is a \"plan\"?", @"How will making and using plans help me with my tinnitus?"] panels:@[panel1, panel2] languageDirection:MYLanguageDirectionLeftToRight];
    [introductionView setBackgroundColor:[UIColor whiteColor]];
    
    
    [introductionView.BackgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [introductionView.HeaderImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [introductionView.HeaderLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [introductionView.HeaderView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [introductionView.PageControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [introductionView.SkipButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    
    
    
    //Set delegate to self for callbacks (optional)
    introductionView.delegate = self;
    
    //STEP 3: Show introduction view
    [introductionView showInView:self.view animateDuration:0.0];
}

-(void)introductionDidFinishWithType:(MYFinishType)finishType
{
    self.navigationController.navigationBar.hidden=NO;

    [self.navigationController popViewControllerAnimated:NO];
}

- (void)addCloseButton
{
    UILabel *closeButton = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100, self.view.frame.size.height - 45, 80, 30)];
    [closeButton setText:@"Close"];
    [closeButton setFont:[UIFont boldSystemFontOfSize:15]];
    [closeButton setTextColor:[UIColor whiteColor]];
    [closeButton setTextAlignment:NSTextAlignmentCenter];
    [closeButton setBackgroundColor:[Utils colorWithHexValue:@"007Aff"]];
    
    closeButton.layer.cornerRadius = 5;
    closeButton.layer.masksToBounds = YES;
    
    [self.view addSubview:closeButton];
    
    [Utils addTapGestureToView:closeButton target:self selector:@selector(onTapCloseButton:)];
}

- (void)onTapCloseButton:(id)sender
{
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)addViewsToScrollViewWithFrame:(CGRect)frame
{
    for (int index = 0; index < TOTAL_SCREENS; index ++) {
        
        IntroPageView *view = [[[NSBundle mainBundle] loadNibNamed:@"IntroPageView" owner:self options:nil] objectAtIndex:0];
        
        IntroPageInfo *info = [self.pageInfos objectAtIndex:index];
        
        CGFloat viewHeight = [self heightForViewForInfo:info];
        
        [view setPageInfo:info];
        
        CGFloat titleHeight = [Utils heightForLabelForString:info.title width:AVAILABLE_WIDTH_FOR_TEXT font:[Utils helveticaNueueFontWithSize:16]];
        
        view.titleHeightConst.constant = titleHeight;
        
        [view setFrame:CGRectMake(frame.size.width * index, frame.origin.y + 60, frame.size.width, viewHeight)];
        
        [self.scrollView addSubview:view];
    }
}

#pragma mark
#pragma mark ScrollView Delegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollViewWidth = self.scrollView.frame.size.width;
    
    NSInteger nOffsetx = scrollView.contentOffset.x;
    
    NSInteger pageNumber = (nOffsetx / scrollViewWidth) + 1;
    
    self.pageControl.currentPage = pageNumber - 1;
    
    if(scrollView.isDragging)
        [self.pageControl updateCurrentPageDisplay] ;
    
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
