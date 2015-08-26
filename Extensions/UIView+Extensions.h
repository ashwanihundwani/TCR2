//
//  UIView+Capture.h
//  Tradus
//
//  Created by Ashwani Hundwani on 15/12/13.
//  Copyright (c) 2013 Vijay Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extensions)


-(UIView *)subViewWithTag:(NSInteger)nTag;

@property(nonatomic)UIEdgeInsets edgeInsets;

@property(nonatomic)CGFloat height;
@property(nonatomic)CGFloat width;
@property(nonatomic)CGFloat x;
@property(nonatomic)CGFloat y;

@property(nonatomic)CGPoint origin;
@property(nonatomic)CGSize size;



@end
