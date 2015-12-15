//
//  Pair.h
//  TinnitusCoach
//
//  Created by Creospan on 06/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pair : NSObject


@property(nonatomic, strong)id firstObj;
@property(nonatomic, strong)id secondObj;


+(Pair *)pairWithFirstObject:(id)firstObj
                secondObject:(id)secondObj;


@end
