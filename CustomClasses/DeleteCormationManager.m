//
//  DeleteCormationManager.m
//  TinnitusCoach
//
//  Created by Ashwani Hundwani on 14/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "DeleteCormationManager.h"

@interface DeleteCormationManager()<UIAlertViewDelegate>

@property(nonatomic, strong)void (^positiveBlock)(BOOL positive);
@property(nonatomic, strong)void (^negativeBlock)(BOOL negative);


@end

@implementation DeleteCormationManager

static DeleteCormationManager *manager = nil;

+(DeleteCormationManager *)getInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (id)init
{
    if (manager) {
        return manager;
    }
    return manager = [super init];
}

-(void)showAlertwithPositiveBlock:(void (^)(BOOL positive))positiveBlock
                    negativeBlock:(void (^)(BOOL negative))negativeBlock
{
    
    self.positiveBlock = positiveBlock;
    self.negativeBlock = negativeBlock;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:DELETE_ALERT_TITLE delegate:self cancelButtonTitle:DELETE_ALERT_NEGATIVE_BUTTON_TITLE otherButtonTitles:DELETE_ALERT_POSITIVE_BUTTON_TITLE, nil];
    
    [alert show];
}



#pragma mark Alert Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        
        self.negativeBlock(YES);
    }
    else
    {
        self.positiveBlock(YES);
    }
}
@end
