//
//  AddressBookJson.h
//  Chain
//
//  Created by Andrei Boulgakov on 12/09/14.
//  Copyright (c) 2014 MoshiachTimes. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "SubscribedContactCD.h"

@interface AddressBookData : NSObject
{
    NSString * contact_name, *contact_number;
}

@property (nonatomic, strong)  NSString * contact_name, *contact_number;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

//-(void) populateObjectFromCorData:(id)coreData;
//
//
//-(void)populateCoreDataObject:(SubscribedContactCD *) coreData;
//-(void)populateDataFromDB:(SubscribedContactCD *) coreData;
@end
