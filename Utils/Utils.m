//
//  Utils.m
//
//  Created by Creospan on 19/04/13.
//  Copyright (c) 2013 Creospan. All rights reserved.
//

#import "Utils.h"
#import "TabBarController.h"

@implementation Utils


+(UIBarButtonItem *) barButton:(NSString *)title andSelector:(SEL) selector target:(id) target;
{
    return  [[UIBarButtonItem alloc]
             initWithTitle:title
             style:UIBarButtonItemStyleDone
             target:target
             action:selector];
}


+(UIBarButtonItem *) BarButton:(NSString *)title image:(UIImage *)image Selector:(SEL) selector Frame:(CGRect) frame andTarget:(id) target ;
{
    
    UIButton *btn =[Utils Button:@"" image:image Selector:selector Frame:frame font:nil color:nil andTarget:target];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}


+(UIButton *) Button:(NSString *)title image:(UIImage *)image Selector:(SEL) selector Frame:(CGRect) frame font:(UIFont *)font color:(UIColor *)color andTarget:(id) target
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:frame];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font=font;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    return btn;
}

+(void) setBarButtonApperance:(UIColor *)color
{
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                color,
                                NSForegroundColorAttributeName,nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes: attributes
                                                forState: UIControlStateNormal];
}

+(NSString *)jsonStringFromDict:(NSDictionary * )dict
{
    NSError *error;
    NSData * data = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&error];
    NSString* jsonString = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (UIImage *) imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    //  [[UIColor colorWithRed:222./255 green:227./255 blue: 229./255 alpha:1] CGColor]) ;
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+(UIImage*) drawText:(NSString*)text inImage:(UIImage*)image atPoint:(CGPoint)point
{
    
    UIFont *font =[UIFont boldSystemFontOfSize: 8.0];
    
    
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    //[[UIColor whiteColor] set];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, [NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName, [UIColor whiteColor],NSForegroundColorAttributeName, nil];
    [[NSString stringWithFormat:@"%@0",text ] drawInRect:CGRectIntegral(rect) withAttributes:attributes];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}




+(NSData *)dataFromImage:(UIImage *)image {
    return UIImageJPEGRepresentation(image,0.4);
}

+(UIImage *)imageFromData:(NSData *)imageData {
    return [UIImage imageWithData:imageData];
}

+ (UIImage *) imageByScalingToSize:(CGSize)targetSize forImage:(UIImage *)sourceImage
{
    UIImage *generatedImage = nil;
    UIGraphicsBeginImageContextWithOptions(targetSize,NO,1.0);
    
    [sourceImage drawInRect:CGRectMake(0, 0,targetSize.width,targetSize.height)];
    generatedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return generatedImage;
}

+(CGSize )frame:(UIImage *)image withMaxFrame:(CGSize) maxFrame
{
    CGSize frame;
    
    float height,width;
    if(image.size.width>image.size.height)
    {
        height=maxFrame.height;
        width=(image.size.width/image.size.height)*height;
        
        if(width>maxFrame.width)
        {
            float factor=maxFrame.width/width;
            height =factor*height;
            width=maxFrame.width;
        }
    }
    else
    {
        width=maxFrame.width;
        height=(image.size.height/image.size.width)*width;
        if(height>maxFrame.height)
        {
            float factor=maxFrame.height/height;
            width =factor*width;
            height=maxFrame.height;
        }
    }
    
    frame=CGSizeMake(width, height);
    return frame;
}

+(UIStoryboard *)storyboard
{
    return [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
}

+ (UIImage*)imageByCropping:(CGRect)rect withImage:(UIImage *)oldImage
{
    //    //create a context to do our clipping in
    //    UIGraphicsBeginImageContext(rect.size);
    //    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //
    //    //create a rect with the size we want to crop the image to
    //    //the X and Y here are zero so we start at the beginning of our
    //    //newly created context
    //    CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    //    CGContextClipToRect( currentContext, clippedRect);
    //
    //    //create a rect equivalent to the full size of the image
    //    //offset the rect by the X and Y we want to start the crop
    //    //from in order to cut off anything before them
    //    CGRect drawRect = CGRectMake(rect.origin.x * -1,
    //                                 rect.origin.y * -1,
    //                                 image.size.width/2,
    //                                 image.size.height/2);
    //
    //    //draw the image to our clipped context using our offset rect
    //    CGContextDrawImage(currentContext, drawRect, image.CGImage);
    //
    //    //pull the image from our cropped context
    //    UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
    //
    //    //pop the context to get back to the default
    //    UIGraphicsEndImageContext();
    //
    //
    //    //Note: this is autoreleased
    //    return cropped;
    
    // Create rectangle that represents a cropped image
    // from the middle of the existing image
    CGRect oldRect = CGRectMake(rect.origin.x , rect.size.height*1.5,
                                (rect.size.width * 8), (rect.size.height * 2.5));
    
    // Create bitmap image from original image data,
    // using rectangle to specify desired crop area
    CGImageRef imageRef = CGImageCreateWithImageInRect([oldImage CGImage], oldRect);
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return img;
}

+(TabBarController *)rootTabBarController
{
    return (TabBarController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
}

+ (UIColor*)colorWithHexValue:(NSString*)hexValue
{
    //Default
    UIColor *defaultResult = [UIColor blackColor];
    
    //Strip prefixed # hash
    if ([hexValue hasPrefix:@"#"] && [hexValue length] > 1) {
        hexValue = [hexValue substringFromIndex:1];
    }
    
    //Determine if 3 or 6 digits
    NSUInteger componentLength = 0;
    if ([hexValue length] == 3)
    {
        componentLength = 1;
    }
    else if ([hexValue length] == 6)
    {
        componentLength = 2;
    }
    else
    {
        return defaultResult;
    }
    
    BOOL isValid = YES;
    CGFloat components[3];
    
    //Seperate the R,G,B values
    for (NSUInteger i = 0; i < 3; i++) {
        NSString *component = [hexValue substringWithRange:NSMakeRange(componentLength * i, componentLength)];
        if (componentLength == 1) {
            component = [component stringByAppendingString:component];
        }
        
        NSScanner *scanner = [NSScanner scannerWithString:component];
        unsigned int value;
        isValid &= [scanner scanHexInt:&value];
        components[i] = (CGFloat)value / 255.0f;
    }
    
    if (!isValid) {
        return defaultResult;
    }
    
    return [UIColor colorWithRed:components[0]
                           green:components[1]
                            blue:components[2]
                           alpha:1.0];
}


+(void)addTapGestureToView:(UIView *)view
                    target:(id)target
                  selector:(SEL)selector
{
    view.userInteractionEnabled = true;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:selector];
    
    tap.numberOfTapsRequired = 1;
    
    [view addGestureRecognizer:tap];
}

+(void)addSwipeGestureToView:(UIView *)view
                    target:(id)target
                  selector:(SEL)selector
{
    view.userInteractionEnabled = true;
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:target action:selector];
    
    swipe.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    
    [view addGestureRecognizer:swipe];
}

+(UIFont *)helveticaNueueFontWithSize:(NSInteger)size
{
    
    return [UIFont fontWithName:@"Helvetica Neue" size:size];
}

+(UIFont *)helveticaNueueItalicFontWithSize:(NSInteger)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Italic" size:size];
}
+(UIFont *)helveticaNueueMediumFontWithSize:(NSInteger)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}

+(Pair *)getColorFontPair:(EPallete)pallete
{
    UIColor *color = nil;
    UIFont *font = nil;
    switch (pallete) {
        case eCFS_PALLETE_1:
        {
            color = [Utils colorWithHexValue:@"000000"];
            font = [Utils helveticaNueueMediumFontWithSize:17];
        }
            break;
            
        case eCFS_PALLETE_2:
        {
            color = [Utils colorWithHexValue:@"58595B"];
            font = [Utils helveticaNueueFontWithSize:14];
        }
            break;
        case eCFS_PALLETE_3:
        {
            color = [Utils colorWithHexValue:@"007AFF"];
            font = [Utils helveticaNueueMediumFontWithSize:17];
        }
            break;
        case eCFS_PALLETE_4:
        {
            color = [Utils colorWithHexValue:@"000000"];
            font = [Utils helveticaNueueFontWithSize:15];
        }
            break;
            
        case eCFS_PALLETE_5:
        {
            color = [Utils colorWithHexValue:@"929292"];
            font = [Utils helveticaNueueFontWithSize:14];
        }
            break;
        case eCFS_PALLETE_6:
        {
            color = [Utils colorWithHexValue:@"000000"];
            font = [Utils helveticaNueueFontWithSize:12];
        }
            break;
            
        case eCFS_PALLETE_7:
        {
            color = [Utils colorWithHexValue:@"929292"];
            font = [Utils helveticaNueueItalicFontWithSize:14];
        }
            break;
        case eCFS_PALLETE_8:
        {
            color = [Utils colorWithHexValue:@"BCBEC0"];
            font = [Utils helveticaNueueFontWithSize:12];
        }
            break;
            
        case eCFS_PALLETE_9:
        {
            color = [Utils colorWithHexValue:@"929292"];
            font = [Utils helveticaNueueFontWithSize:12];
        }
            break;
            
        case eCFS_PALLETE_10:
        {
            color = [Utils colorWithHexValue:@"231F20"];
            font = [Utils helveticaNueueFontWithSize:36];
        }
            break;
            
        case eCFS_PALLETE_11:
        {
            color = [Utils colorWithHexValue:@"000000"];
            font = [Utils helveticaNueueMediumFontWithSize:14];
        }
            break;
        case eCFS_PALLETE_12:
        {
            color = [Utils colorWithHexValue:@"58595B"];
            font = [Utils helveticaNueueFontWithSize:12];
        }
            break;
        case eCFS_PALLETE_13:
        {
            color = [Utils colorWithHexValue:@"000000"];
            font = [Utils helveticaNueueMediumFontWithSize:17];
        }
            break;
        case eCFS_PALLETE_14:
        {
            color = [Utils colorWithHexValue:@"000000"];
            font = [Utils helveticaNueueFontWithSize:14];
        }
            break;
        case eCFS_PALLETE_15:
        {
            color = [Utils colorWithHexValue:@"58595B"];
            font = [Utils helveticaNueueFontWithSize:15];
        }
            break;
        default:
            break;
            
            
    }
    
    return [Pair pairWithFirstObject:color secondObject:font];
    
}


+(NSDate *)dateWithString:(NSString *)strDate
                 inFormat:(NSString *)strFormat
{
    NSDate *pDate = nil;
    
    if (strDate && strFormat) {
        
        NSDateFormatter *pDateFormatter = [[NSDateFormatter alloc]init];
        [pDateFormatter setDateFormat:strFormat];
        pDate = [pDateFormatter dateFromString:strDate];
        
    }
    
    return pDate;
}

+(NSString *)stringFromDate:(NSDate *)pDate
                   inFormat:(NSString *)strFormat
{
    NSString *strDate = nil;
    
    if (pDate && strFormat) {
        
        NSDateFormatter *pDateFormatter = [[NSDateFormatter alloc]init];
        [pDateFormatter setDateFormat:strFormat];
        strDate = [pDateFormatter stringFromDate:pDate];
        
    }
    
    return strDate;
}


+(CGFloat)heightForTitleLabel:(NSString *)string
                        width:(CGFloat)width
{
    NSMutableAttributedString* textToMeasure = [[NSMutableAttributedString alloc] initWithString:string];
    [textToMeasure addAttribute:NSFontAttributeName value:TITLE_LABEL_FONT range:NSMakeRange(0, textToMeasure.length)];
    
    CGRect boundingRect = [textToMeasure boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                      context:nil];
    
    return boundingRect.size.height;
    
}

+(CGFloat)heightForSubtitleLabel:(NSString *)string
                           width:(CGFloat)width
{
    NSMutableAttributedString* textToMeasure = [[NSMutableAttributedString alloc] initWithString:string];
    [textToMeasure addAttribute:NSFontAttributeName value:SUB_TITLE_LABEL_FONT range:NSMakeRange(0, textToMeasure.length)];
    
    CGRect boundingRect = [textToMeasure boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                      context:nil];
    
    return boundingRect.size.height;
}


+(CGFloat)heightForLabelForString:(NSString *)string
                            width:(CGFloat)width
                             font:(UIFont *)font
{
    NSMutableAttributedString* textToMeasure = [[NSMutableAttributedString alloc] initWithString:string];
    [textToMeasure addAttribute:NSFontAttributeName
                          value:font
                          range:NSMakeRange(0, textToMeasure.length)];
    
    CGRect boundingRect = [textToMeasure boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                      context:nil];
    return boundingRect.size.height;
}


+(NSInteger)getNumDaysToNextMonday{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday fromDate:now];
    
    NSUInteger weekdayToday = [components weekday];
    NSInteger daysToMonday = (9 - weekdayToday) % 7;
    return daysToMonday;
}



@end
