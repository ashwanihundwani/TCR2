//
//  OtherSoundsInfo.m
//  TinnitusCoach
//
//  Created by Creospan on 14/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "OtherSoundInfo.h"


@implementation OtherSoundInfo

-(id)initWithDict:(NSDictionary *)dict
{
    OtherSoundInfo *info = [[OtherSoundInfo alloc]init];
    info.title = [dict objectForKey:@"deviceName"];
    info.userTag = [dict objectForKey:@"comments"];
    info.dbIdentifier = [dict objectForKey:@"deviceID"];
    info.typeId = [dict objectForKey:@"soundTypeID"];
    
    return info;
}


@end
