//
//  PersistenceStorage.h
//
//  Created by Creospan on 07/05/13.
//  Copyright (c) 2014 Creospan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersistenceStorage : NSObject
{
    
}
/**
 *	@functionName	: setObject
 *	@parameters		: obj,key
 *	@return			:
 *	@description	: Stores the object for the key in the peristence storage
 */
+(void) setObject:(id) obj andKey:(NSString *)key;

/**
 *	@functionName	: removeObjectForKey
 *	@parameters		: key
 *	@return			:
 *	@description	: Remove the object for the key in the peristence storage
 */
+(void) removeObjectForKey:(NSString *)key;
/**
 *	@functionName	: getObjectForKey
 *	@parameters		: key
 *	@return			:
 *	@description	: Get the object for the key in the peristence storage
 */
+(id) getObjectForKey:(NSString *)key;


+(void) setBool:(BOOL) obj andKey:(NSString *)key;

+(BOOL) getBoolForKey:(NSString *)key;

+(void) setInteger:(NSInteger) obj andKey:(NSString *)key;

+(NSInteger) getIntegerForKey:(NSString *)key;

+(void) setFloat:(float) obj andKey:(NSString *)key;

+(float) getFloatForKey:(NSString *)key;

@end
