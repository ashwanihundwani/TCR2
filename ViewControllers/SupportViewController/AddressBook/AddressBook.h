//
//  ViewController.h
//  AddressBook
//
//  Created by JK on 01/08/13.
//  Copyright (c) 2013 Fafadia Tech, Mumbai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface AddressBook : NSObject {

    NSMutableArray *contactList;

}
- (NSArray *)getAllContacts;
@end
