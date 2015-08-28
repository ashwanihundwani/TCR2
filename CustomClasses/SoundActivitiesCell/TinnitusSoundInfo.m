//
//  TinnitusSoundInfo.m
//  TinnitusCoach
//
//  Created by Ashwani Hundwani on 14/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "TinnitusSoundInfo.h"

@implementation TinnitusSoundInfo


-(id)initWithDict:(NSDictionary *)dict
{
    TinnitusSoundInfo *sounInfo = [[TinnitusSoundInfo alloc]init];
    
    sounInfo.title = [dict objectForKey:@"soundName"];
    
    sounInfo.dbIdentifier = [dict objectForKey:@"ID"];
    
    sounInfo.typeId = [dict objectForKey:@"soundTypeID"];
    
    return sounInfo;
}

@end
