//
//  ContactListViewController.h
//  TinnitusCoach
//
//  Created by Creospan on 25/04/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBook.h"
#import "AddressBookData.h"


@protocol ContactSelectedProtocol<NSObject>
-(void)didSelectContact:(AddressBookData *)contact withType:(int)contactType;
@end
@interface ContactListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *contactTableView;
@property(weak,nonatomic)id<ContactSelectedProtocol> delegate;
@property(nonatomic)int contactType;


@end
