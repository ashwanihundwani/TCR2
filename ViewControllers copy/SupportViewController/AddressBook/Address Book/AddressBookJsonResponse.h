//
//  AddressBookJsonResponse.h
//  Chain
//
//  Created by Andrei Boulgakov on 12/09/14.
//  Copyright (c) 2014 MoshiachTimes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressBookData.h"

@interface AddressBookJsonResponse : NSObject
@property (nonatomic,strong) NSArray * contactList;
- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;
@end
