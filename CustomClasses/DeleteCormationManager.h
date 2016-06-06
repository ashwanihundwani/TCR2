//
//  DeleteCormationManager.h
//  TinnitusCoach
//
//  Created by Creospan on 14/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeleteCormationManager : NSObject

+(DeleteCormationManager *)getInstance;


-(void)showAlertwithPositiveBlock:(void (^)(BOOL positive))positiveBlock
                    negativeBlock:(void (^)(BOOL negative))negativeBlock;

@end
