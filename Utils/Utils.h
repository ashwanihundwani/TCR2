//
//  Utils.h
//
//  Created by Creospan on 19/04/13.
//  Copyright (c) 2013 Creospan. All rights reserved.
//  This class contains all the generic methods that can be accessed from other classes

#import <Foundation/Foundation.h>
#import "TabBarController.h"
#import "Pair.h"

typedef enum
{
    eCFS_PALLETE_1,
    eCFS_PALLETE_2,
    eCFS_PALLETE_3,
    eCFS_PALLETE_4,
    eCFS_PALLETE_5,
    eCFS_PALLETE_6,
    eCFS_PALLETE_7,
    eCFS_PALLETE_8,
    eCFS_PALLETE_9,
    eCFS_PALLETE_10,
    eCFS_PALLETE_11,
    eCFS_PALLETE_12,
    eCFS_PALLETE_13,
    eCFS_PALLETE_14,
    eCFS_PALLETE_15,
    
    
    
}EPallete;

@interface Utils : NSObject


+(UIBarButtonItem *) barButton:(NSString *)title andSelector:(SEL) selector target:(id) target;


+(UIButton *) Button:(NSString *)title image:(UIImage *)image Selector:(SEL) selector Frame:(CGRect) frame font:(UIFont *)font color:(UIColor *)color andTarget:(id) target  ;

+(UIBarButtonItem *) BarButton:(NSString *)title image:(UIImage *)image Selector:(SEL) selector Frame:(CGRect) frame andTarget:(id) target ;
+(void) setBarButtonApperance:(UIColor *)color;

+(NSString *)jsonStringFromDict:(NSDictionary * )dict;



+(NSData *)dataFromImage:(UIImage *)image;

+(UIImage *)imageFromData:(NSData *)imageData;

+ (UIImage *) imageByScalingToSize:(CGSize)targetSize forImage:(UIImage *)sourceImage;

+(CGSize )frame:(UIImage *)image withMaxFrame:(CGSize) maxFrame;

+(UIStoryboard *)storyboard;

+ (UIImage *) imageFromColor:(UIColor *)color;

+(UIImage*) drawText:(NSString*)text inImage:(UIImage*)image atPoint:(CGPoint)point;

+ (UIImage*)imageByCropping:(CGRect)rect withImage:(UIImage *)image;

+(TabBarController *)rootTabBarController;

+ (UIColor*)colorWithHexValue:(NSString*)hexValue;

+(void)addTapGestureToView:(UIView *)view
                    target:(id)target
                  selector:(SEL)selector;

+(void)addSwipeGestureToView:(UIView *)view
                      target:(id)target
                    selector:(SEL)selector;

+(UIFont *)helveticaNueueFontWithSize:(NSInteger)size;

+(UIFont *)helveticaNueueMediumFontWithSize:(NSInteger)size;

+(Pair *)getColorFontPair:(EPallete)pallete;


+(NSString *)stringFromDate:(NSDate *)pDate
                   inFormat:(NSString *)strFormat;

+(NSDate *)dateWithString:(NSString *)strDate
                 inFormat:(NSString *)strFormat;


+(CGFloat)heightForTitleLabel:(NSString *)string
                        width:(CGFloat)width;

+(CGFloat)heightForSubtitleLabel:(NSString *)string
                           width:(CGFloat)width;

+(CGFloat)heightForLabelForString:(NSString *)string
                            width:(CGFloat)width
                             font:(UIFont *)font;

+(NSInteger)getNumDaysToNextMonday;

@end
