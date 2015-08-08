//
//  ViewController.m
//  AddressBook
//
//  Created by JK on 01/08/13.
//  Copyright (c) 2013 Fafadia Tech, Mumbai. All rights reserved.
//

#import "AddressBook.h"
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface AddressBook ()

@end

@implementation AddressBook

- (NSArray *)getAllContacts
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);// ABAddressBookCreate();
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // We are on iOS 6
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(semaphore);
        });
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        //dispatch_release(semaphore);
    }
    
    else
    { // We are on iOS 5 or Older
        accessGranted = YES;
        NSArray *contactList1 = [[NSArray alloc ] initWithArray:[self getContactsWithAddressBook:addressBook]];
        return contactList1;
    }
    if (accessGranted)
    {
        NSArray *contactList2 = [[NSArray alloc ] initWithArray:[self getContactsWithAddressBook:addressBook]];
        return contactList2;
    }
    return nil;
}

// Get the contacts.
- (NSArray *) getContactsWithAddressBook:(ABAddressBookRef )addressBook
{
    contactList = [[NSMutableArray alloc] init];
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
	CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    for (int i=0;i < nPeople;i++) {
		
        
		ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        
		//For username and surname
		ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty));
		
        CFStringRef firstName, lastName;
		firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
		lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        NSString *lastName1 = (__bridge NSString *)lastName;
		//For Email ids
		/*ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
		if(ABMultiValueGetCount(eMail) > 0) {
			[dOfPerson setObject:(__bridge NSString *)ABMultiValueCopyValueAtIndex(eMail, 0) forKey:@"email"];
		}*/
		
		//For Phone number
		NSString* mobileLabel;
        
		for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++)
        {
            NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
            if(![lastName1 isEqualToString:@"null"] && lastName1 && ![lastName1 isEqualToString:@""])
                [dOfPerson setObject:[NSString stringWithFormat:@"%@ %@", firstName, lastName] forKey:@"name"];
            else
                [dOfPerson setObject:[NSString stringWithFormat:@"%@", firstName] forKey:@"name"];
			mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
			if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
			{
                NSString *mobileNumber = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i);
				[dOfPerson setObject:mobileNumber forKey:@"Phone"];
                [contactList addObject:dOfPerson];
                continue ;
			}
			else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
			{
                NSString *mobileNumber = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i);
                [dOfPerson setObject:mobileNumber forKey:@"Phone"];
                [contactList addObject:dOfPerson];
				continue ;
			}
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneMainLabel])
			{
                NSString *mobileNumber = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i);
                [dOfPerson setObject:mobileNumber forKey:@"Phone"];
                [contactList addObject:dOfPerson];
				continue ;
			}
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneWorkFAXLabel])
			{
                NSString *mobileNumber = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i);
                [dOfPerson setObject:mobileNumber forKey:@"Phone"];
                [contactList addObject:dOfPerson];
				continue ;
			}
            else if ([mobileLabel isEqualToString:(NSString*)kABWorkLabel])
			{
                NSString *mobileNumber = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i);
                [dOfPerson setObject:mobileNumber forKey:@"Phone"];
                [contactList addObject:dOfPerson];
				continue ;
			}
            else if ([mobileLabel isEqualToString:(NSString*)kABHomeLabel])
			{
                NSString *mobileNumber = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i);
                [dOfPerson setObject:mobileNumber forKey:@"Phone"];
                [contactList addObject:dOfPerson];
				continue ;
			}
            else if ([mobileLabel isEqualToString:(NSString*)kABOtherLabel])
			{
				[dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"Phone"];
                [contactList addObject:dOfPerson];
				continue ;
			}
        }
    }
    return contactList;
}
@end