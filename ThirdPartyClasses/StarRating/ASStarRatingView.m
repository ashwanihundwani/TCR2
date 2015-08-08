//
//  ASRatingView.m
//  AppShike
//
//  Created by yanguango on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ASStarRatingView.h"

#define DOT_VIEW_TAG 23233

@implementation ASStarRatingView
@synthesize notSelectedStar = _notSelectedStar;
@synthesize selectedStar = _selectedStar;
@synthesize halfSelectedStar = _halfSelectedStar;
@synthesize canEdit = _canEdit;
@synthesize maxRating = _maxRating;
@synthesize midMargin = _midrMargin;
@synthesize leftMargin = _leftMargin;
@synthesize rightMargin = _rightMargin;
@synthesize minStarSize = _minStarSize;
@synthesize rating = _rating;
@synthesize minAllowedRating = _minAllowedRating;
@synthesize maxAllowedRating = _maxAllowedRating;

- (void)refreshStars {
    for(int i = 0; i < _starViews.count; ++i) {
        UIView *view = [_starViews objectAtIndex:i];
        if (_rating == i+1) {
            view.backgroundColor = [Utils colorWithHexValue:LABEL_BLUE_TEXT_COLOR_HEX_VALUE];
            
            self.dotView.center = view.center;
            [view addSubview:self.dotView];
        } else {
            view.backgroundColor = [UIColor whiteColor];
        }
        
    }
    [[self delegate]ratingAdded];
}

- (void)setupView {
    
    float x = 20;
    for(int i = 0; i < _maxRating; ++i) {
        UIView *view = [[UIView alloc] init];
        
        view.layer.cornerRadius = 11;
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColor grayColor].CGColor;
        
        UIView *dot = [[UIView alloc]initWithFrame:CGRectMake(7, 7, 8, 8)];
        
        dot.backgroundColor = [UIColor whiteColor];
        
        dot.layer.cornerRadius = 4;
        
        [view addSubview:dot];
        
        //imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_starViews addObject:view];
        [self addSubview:view];
        // = imageView.frame.origin.x + 20;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x-20, view.frame.origin.y + 44, 62,30)];
        
        CGRect frame;
        switch (i) {
            case 0:
                label.text = @"not at \nall";
                label.numberOfLines = 2;
                
                frame = label.frame;
                frame.origin.y += 6;
                label.frame = frame;
                
                break;
            case 1:
                label.text = @"a little";
                break;
            case 2:
                label.text = @"moderately";
                break;
            case 3:
                label.text = @"very \nmuch";
                label.numberOfLines = 2;
                
                CGRect frame = label.frame;
                frame.origin.y += 6;
                label.frame = frame;
                
                break;
            case 4:
                label.text = @"extremely";
                break;
            default:
                break;
        }
        
        label.textAlignment = NSTextAlignmentCenter;
        
        Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_6];
        
        label.font = pallete.secondObj;
        label.textColor = pallete.firstObj;
        
        [self addSubview:label];
        x += 62;
        
    }
    
    [self refreshStars];
}

- (void)baseInit {
    
    _notSelectedStar = [UIImage imageNamed:@"whitecircle"] ;
    _selectedStar = [UIImage imageNamed:@"bluecircle"];
    //    _notSelectedStar = [UIImage imageNamed:@"not_selected_star"] ;
    //    _selectedStar = [UIImage imageNamed:@"selected_star"];
    _halfSelectedStar = [UIImage imageNamed:@"half_selected_star"];
    _starViews = [NSMutableArray array];
    _maxRating = kDefaultMaxRating;
    _midMargin = kDefaultMidMargin;
    _leftMargin = kDefaultLeftMargin;
    _rightMargin = kDefaultRightMargin;
    _minStarSize = kDefaultMinStarSize;
    _minAllowedRating = kDefaultMinAllowedRating;
    _maxAllowedRating = kDefaultMaxAllowedRating;
    _rating = _minAllowedRating;
    _canEdit = YES;
    [self setupView];
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];
    }
    return self;
}

- (void)dealloc {
    //  [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSLog(@"%f, %f, %f, %d", self.frame.size.width, _leftMargin, _midMargin, _starViews.count);
    
    float imageWidth = 22;
    float imageHeight = 22;
    
    for (int i = 0; i < _starViews.count; ++i) {
        
        UIView *view = [_starViews objectAtIndex:i];
        //CGRect imageFrame = CGRectMake(_leftMargin + i*(_midMargin+imageWidth), 0, imageWidth, imageHeight);
        CGRect imageFrame = CGRectMake(22 + i * 61, 14, 22, 22);
        view.frame = imageFrame;
    }
    
}

- (void)setMaxRating:(int)maxRating {
    if (_maxAllowedRating == _maxRating) {
        _maxAllowedRating = maxRating;
    }
    _maxRating = maxRating;
    
    
    // Remove old image views
    for(int i = 0; i < _starViews.count; ++i) {
        UIView *view = (UIView *) [_starViews objectAtIndex:i];
        [view removeFromSuperview];
    }
    [_starViews removeAllObjects];
    
    // Add new image views
    [self setupView];
    // Relayout and refresh
    [self setNeedsLayout];
    [self refreshStars];
}

- (void)setRating:(float)rating {
    _rating = rating;
    [self refreshStars];
}

#pragma mark - Touch Detection

- (void)handleTouchAtLocation:(CGPoint)touchLocation {
    if (!_canEdit) return;
    
    _rating = 0;
    for(int i = _starViews.count - 1; i >= 0; i--) {
        UIView *view = [_starViews objectAtIndex:i];
        if (touchLocation.x > view.frame.origin.x) {
            _rating = i+1;
            break;
        }
    }
    _rating = MAX(_minAllowedRating, _rating);
    _rating = MIN(_maxAllowedRating, _rating);
    [self refreshStars];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}


@end
