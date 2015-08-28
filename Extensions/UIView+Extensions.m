//
//  UIView+Extensions.m
//  Tradus
//
//  Created by Ashwani Hundwani on 15/12/13.
//  Copyright (c) 2013 Vijay Singh. All rights reserved.
//

#import "UIView+Extensions.h"

@implementation UIView (Extensions)

-(UIView *)subViewWithTag:(NSInteger)nTag
{
    UIView *viewWithTag = nil;
    for(UIView *pView in self.subviews)
    {
        if(pView.tag == nTag)
        {
            viewWithTag = pView;
            break;
        }
    }
    
    return viewWithTag;
}

-(void)setEdgeInsets:(UIEdgeInsets)edgeInsets
{
    if(self.superview)
    {
        CGRect superframe = self.superview.bounds;
        
        CGRect selfFrame = CGRectMake(edgeInsets.left, edgeInsets.top, superframe.size.width - (edgeInsets.left + edgeInsets.right) ,superframe.size.height - (edgeInsets.top + edgeInsets.bottom));
        
        self.frame = selfFrame;
    }
    
}

-(UIEdgeInsets)edgeInsets
{
    return UIEdgeInsetsZero;
}

#pragma mark
#pragma mark Property implementation
#pragma mark

-(CGFloat)height
{
    return self.frame.size.height;
}

-(void)setHeight:(CGFloat)height
{
    CGSize size = self.size;
    size.height = height;
    
    self.size = size;
    
}

-(CGFloat)width
{
    return self.frame.size.width;
}

-(void)setWidth:(CGFloat)width
{
    CGSize size = self.size;
    size.width = width;
    
    self.size = size;
    
}

-(CGFloat)x
{
    return self.frame.origin.x;
}

-(void)setX:(CGFloat)x
{
    CGPoint origin = self.origin;
    
    origin.x = x;
    
    self.origin = origin;
}

-(CGFloat)y
{
    return self.frame.origin.y;
}

-(void)setY:(CGFloat)y
{
    CGPoint origin = self.origin;
    
    origin.y = y;
    
    self.origin = origin;
}

-(CGPoint)origin
{
    return self.frame.origin;
}

-(void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    
    frame.origin = origin;
    
    self.frame = frame;
}

-(CGSize)size
{
    return self.frame.size;
}



-(void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    
    frame.size = size;
    
    self.frame = frame;
}



@end
