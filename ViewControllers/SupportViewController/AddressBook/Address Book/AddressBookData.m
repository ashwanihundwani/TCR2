//
//  AddressBookJson.m
//  Chain
//
//  Created by Andrei Boulgakov on 12/09/14.
//  Copyright (c) 2014 MoshiachTimes. All rights reserved.
//

#import "AddressBookData.h"

@implementation AddressBookData
@synthesize contact_name, contact_number;

- (id) initWithJSONDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        [self parseJSONDictionary:dict];
    }
    return self;
}

- (void) parseJSONDictionary:(NSDictionary *)dict
{
    self.contact_name         =            [dict objectForKey:@"name"];
    self.contact_number       =            [dict objectForKey:@"Phone"];
}

//-(void) populateObjectFromCorData:(id)coreData
//{
//	SubscribedContactCD *cData = (SubscribedContactCD *) coreData;
//    self.contact_name = cData.contact_name;
//    self.contact_number = cData.contact_number;
//}
//
//-(void)populateCoreDataObject:(SubscribedContactCD *) coreData;
//{
//    coreData.contact_name = self.contact_name;
//    coreData.contact_number = self.contact_number;
//}
//
//-(void)populateDataFromDB:(SubscribedContactCD *) coreData
//{
//    self.contact_number = coreData.contact_number;
//    self.contact_name = coreData.contact_name;
//}
@end
