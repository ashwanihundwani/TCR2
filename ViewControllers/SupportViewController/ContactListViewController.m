//
//  ContactListViewController.m
//  TinnitusCoach
//
//  Created by Creospan on 25/04/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "ContactListViewController.h"


@interface ContactListViewController ()
{
    NSMutableArray *contactList;
    NSMutableSet *subscribedContactList;
    NSMutableArray *upsetSubscribedContactList;
    NSMutableSet *upsertArray;
    AddressBook *addressBookObj;
    
    NSMutableArray *dataStore;
    BOOL isSearching;
    NSMutableArray *filteredList;
}
@end

@implementation ContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    addressBookObj = [[AddressBook alloc] init];
    contactList = [NSMutableArray arrayWithArray:[addressBookObj getAllContacts]];
    if(contactList && [contactList isKindOfClass:[NSArray class]])
    {
        NSMutableArray *array = [NSMutableArray array];
        for(NSDictionary *itemDic in contactList)
        {
            AddressBookData *item = [[AddressBookData alloc] initWithJSONDictionary:itemDic];
            [array addObject:item];
        }
        contactList = [NSMutableArray arrayWithArray:array];
        
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"contact_name"
                                                     ascending:YES comparator:^(id firstDocumentName, id secondDocumentName)
                          {
                              static NSStringCompareOptions comparisonOptions =
                              NSCaseInsensitiveSearch | NSNumericSearch |
                              NSWidthInsensitiveSearch | NSForcedOrderingSearch;
                              
                              return [firstDocumentName compare:secondDocumentName options:comparisonOptions];
                          }];
        NSArray * descriptors =    [NSArray arrayWithObjects:sortDescriptor, nil];
        [contactList sortUsingDescriptors:descriptors];
        
        contactList = [[NSMutableArray alloc] initWithArray:contactList];
        
        [self.contactTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contactList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    AddressBookData *addressBook = [contactList objectAtIndex:indexPath.row];
    [cell.textLabel setText:addressBook.contact_name];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(didSelectContact:withType:)]) {
        AddressBookData *addressBook = [contactList objectAtIndex:indexPath.row];
    
        [self.delegate didSelectContact:addressBook withType:self.contactType];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
