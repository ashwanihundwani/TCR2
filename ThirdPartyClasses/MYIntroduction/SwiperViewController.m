//
//  ViewController.m
//  SwiperDemo
//
//  Created by Ashwani Hundwani on 28/04/14.
//  Copyright (c) 2014 Ashwani Hundwani. All rights reserved.
//

#import "SwiperViewController.h"

#import "DDPageControl.h"
#import "IntroPageView.h"
#import "IntroPageInfo.h"

#define TOTAL_SCREENS self.pageInfos.count
#define TINT_COLOR_HEX @"B7CDD8"
#define SELECTED_TINT_COLOR_HEX @"929292"
#define LETS_GET_STARTED_LABEL_HEIGHT 50
#define AVAILABLE_WIDTH_FOR_TEXT 290
#define TITLE_FONT_SIZE 16


@interface SwiperViewController ()<UIScrollViewDelegate, UIAlertViewDelegate>

@property(nonatomic , strong)UIScrollView *scrollView;
@property(nonatomic, strong)DDPageControl *pageControl;

@end

@implementation SwiperViewController

-(CGFloat)heightForViewForInfo:(IntroPageInfo *)info
{
    CGFloat constant = 208;
    
    CGFloat titleHeight = [Utils heightForLabelForString:info.title width:AVAILABLE_WIDTH_FOR_TEXT  font:[Utils helveticaNueueFontWithSize:TITLE_FONT_SIZE]];
    
    
    CGFloat subtitleHeight = [Utils heightForLabelForString:info.descriptionText width:AVAILABLE_WIDTH_FOR_TEXT font:[Utils helveticaNueueFontWithSize:15]];
    
    
    constant += (titleHeight +subtitleHeight);
    
    return constant;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
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
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)addViewsToScrollViewWithFrame:(CGRect)frame
{
    for (int index = 0; index < TOTAL_SCREENS; index ++) {
        
        IntroPageView *view = [[[NSBundle mainBundle] loadNibNamed:@"IntroPageView" owner:self options:nil] objectAtIndex:0];
        
        IntroPageInfo *info = [self.pageInfos objectAtIndex:index];
        
        CGFloat viewHeight = [self heightForViewForInfo:info];
        
        [view setPageInfo:info];
        
        CGFloat titleHeight = [Utils heightForLabelForString:info.title width:AVAILABLE_WIDTH_FOR_TEXT font:[Utils helveticaNueueFontWithSize:TITLE_FONT_SIZE]];
        
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
@end
