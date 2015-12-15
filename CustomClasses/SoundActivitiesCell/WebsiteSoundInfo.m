//
//  WebsiteSoundsInfo.m
//  TinnitusCoach
//
//  Created by Creospan on 14/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "WebsiteSoundInfo.h"

@implementation WebsiteSoundInfo


-(id)initWithDict:(NSDictionary *)dict
{
    WebsiteSoundInfo *info = [[WebsiteSoundInfo alloc]init];
    
    
    info.title = [dict objectForKey:@"waName"];
    info.descriptionStr = [dict objectForKey:@"waDetail"];
    info.userTag = [dict objectForKey:@"comments"];
    info.dbIdentifier = [dict objectForKey:@"websiteID"];
    info.url = [dict objectForKey:@"URL"];
    info.typeId = [dict objectForKey:@"soundTypeID"];
    
    return info;
}

@end
