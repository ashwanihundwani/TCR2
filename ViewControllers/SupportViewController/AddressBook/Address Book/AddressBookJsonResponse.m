//
//  AddressBookJsonResponse.m
//  Chain
//
//  Created by Andrei Boulgakov on 12/09/14.
//  Copyright (c) 2014 MoshiachTimes. All rights reserved.
//

#import "AddressBookJsonResponse.h"

@implementation AddressBookJsonResponse

- (id) initWithJSONDictionary:(NSDictionary *)dic
{
	if(self = [super init])
	{
		[self parseJSONDictionary:dic];
	}
    
	return self;
}

- (void) parseJSONDictionary:(NSDictionary *)dic
{
	id Data_ = [dic objectForKey:@"Data"];
	if([Data_ isKindOfClass:[NSArray class]])
	{
		NSMutableArray *array = [NSMutableArray array];
		for(NSDictionary *itemDic in Data_)
		{
			AddressBookData *item = [[AddressBookData alloc] initWithJSONDictionary:itemDic];
			[array addObject:item];
		}
		self.contactList = [NSArray arrayWithArray:array];
	}
}
@end
