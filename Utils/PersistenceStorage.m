//
//  PersistenceStorage.m
//
//  Created by Creospan on 07/05/13.
//  Copyright (c) 2014 Creospan. All rights reserved.
//

#import "PersistenceStorage.h"

@implementation PersistenceStorage



+(void) setObject:(id) obj andKey:(NSString *)key;
{
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void) removeObjectForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(id) getObjectForKey:(NSString *)key
{
    id obj=  [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return obj;
}

+(void) setBool:(BOOL) obj andKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setBool:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL) getBoolForKey:(NSString *)key
{
    BOOL obj=  [[NSUserDefaults standardUserDefaults] boolForKey:key];
    return obj;
}

+(void) setInteger:(NSInteger) obj andKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setInteger:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSInteger) getIntegerForKey:(NSString *)key
{
    NSInteger obj=  [[NSUserDefaults standardUserDefaults] integerForKey:key];
    return obj;
}

+(void) setFloat:(float) obj andKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setFloat:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(float) getFloatForKey:(NSString *)key
{
    float obj=  [[NSUserDefaults standardUserDefaults] floatForKey:key];
    return obj;
}



@end
