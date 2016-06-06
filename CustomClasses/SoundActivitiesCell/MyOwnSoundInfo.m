//
//  MyOwnSoundInfo.m
//  TinnitusCoach
//
//  Created by Creospan on 02/09/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "MyOwnSoundInfo.h"

@implementation MyOwnSoundInfo

-(id)initWithDict:(NSDictionary *)dict
{
    MyOwnSoundInfo *info = [[MyOwnSoundInfo alloc]init];
    
    info.title = [dict objectForKey:@"comments"];
    info.dbIdentifier = [dict objectForKey:@"MyOwnSoundID"];
    info.typeId = [dict objectForKey:@"soundTypeID"];
    info.url = [dict objectForKey:@"URL"];
    
    return info;
}


@end
