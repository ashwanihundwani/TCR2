//
//  Pair.m
//  TinnitusCoach
//
//  Created by Ashwani Hundwani on 06/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "Pair.h"

@implementation Pair


+(Pair *)pairWithFirstObject:(id)firstObj
                secondObject:(id)secondObj
{
    Pair *pair = [[Pair alloc]init];
    
    pair.firstObj = firstObj;
    pair.secondObj = secondObj;
    
    return pair;
}

@end
