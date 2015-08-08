//
//  SupportViewController.m
//  TinnitusCoach
//
//  Created by Jiten on 25/04/15.
//  Copyright (c) 2015 Swipe Video Labs Pvt Ltd. All rights reserved.
//

#import "SupportViewController.h"
#import "SupportTableViewCell.h"
#import "AddressBookData.h"
#import "ProfessionalSupportView.h"
#import "FamilyFriendsView.h"
#import "NookViewController.h"

#import "DBManager.h"

@interface SupportViewController() //<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *familyFriendsArray;
    NSMutableArray *professionalSupportArray;
    DBManager *dbManager;
}
@end
@implementation SupportViewController
-(void)viewDidLoad
{
    self.navigationController.navigationBar.hidden=NO;

    [self.navigationItem setTitle:@"Support"];
    professionalSupportArray = [NSMutableArray new];
    familyFriendsArray = [NSMutableArray new];
    dbManager = [[DBManager alloc] initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    [self setData];
    //[self.supportTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.supportTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.supportTableView.frame.size.width, 1)];

    [self.supportTableView reloadData];
}

-(void)setData
{
    NSString *query = @"SELECT * FROM My_Contacts";
    NSArray *allRecordsArray = [dbManager loadDataFromDB:query];
    [professionalSupportArray removeAllObjects];
    [familyFriendsArray removeAllObjects];
    for (NSDictionary *dict in allRecordsArray) {
        
        if ([[dict valueForKey:@"contactType"] integerValue] == 0 ) {
            
            [professionalSupportArray addObject:dict];
        }
        else
        {
            [familyFriendsArray addObject:dict];
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2; //Family & fRIENDS   and  Professional Support
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return [professionalSupportArray count];
        }
            break;
            case 1:
        {
            return [familyFriendsArray count];
        }
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SupportTableViewCell";
    SupportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[SupportTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.btnDelete.layer.cornerRadius = 3.0f;
    cell.btnMove.layer.cornerRadius = 3.0f;
    
    NSDictionary *contact;
    switch (indexPath.section) {
        case 0:
        {
            contact = [professionalSupportArray objectAtIndex:indexPath.row];
            break;
        }
        case 1:
        {
            contact = [familyFriendsArray objectAtIndex:indexPath.row];
            break;
        }
        default:
            break;
    }
    cell.lblPhoneNumber.text = [contact valueForKey:@"contactName"];

    
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            ProfessionalSupportView *professioNalView = [[[NSBundle mainBundle] loadNibNamed:@"ProfessionalSupportView" owner:self options:nil] objectAtIndex:0];
            professioNalView.btnAddNewContact.layer.cornerRadius = 3.0f;
            professioNalView.btnCall.layer.cornerRadius = 5.0f;
            professioNalView.btnVisitWebsite.layer.cornerRadius = 3.0f;
            
            [professioNalView.btnCall addTarget:self action:@selector(onClickCallingButton) forControlEvents:UIControlEventTouchUpInside];
            [professioNalView.btnAddNewContact addTarget:self action:@selector(openContactsViewForProfessional) forControlEvents:UIControlEventTouchUpInside];
            return professioNalView;

        }
            break;
        case 1:
        {
            FamilyFriendsView *familyFriendsView = [[[NSBundle mainBundle] loadNibNamed:@"FamilyFriendsView" owner:self options:nil] objectAtIndex:0];
            familyFriendsView.btnAddFamilyFriendsContact.layer.cornerRadius = 3.0f;
            
            [familyFriendsView.btnAddFamilyFriendsContact   addTarget:self action:@selector(openContactsViewForFamily) forControlEvents:UIControlEventTouchUpInside];
            return familyFriendsView;
        }
        default:
            break;
    }

    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 225;
    }
    return 130;
}

/*-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}*/

#pragma Mark Calling
- (void)onClickCallingButton
{
    NSString *phNo = @"18002739255";
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
}

#pragma open the contacts view 
/*-(void)openContactsViewForProfessional
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ContactListViewController *contactVC = [ storyBoard instantiateViewControllerWithIdentifier:@"ContactListViewController"];
    contactVC.delegate = self;
    contactVC.contactType = 0;
     [self.navigationController pushViewController:contactVC animated:YES];
}
*/

/*-(void)openContactsViewForProfessional
{
    
    NookViewController *guided = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NookViewController"];
    [self.navigationController pushViewController:guided animated:YES];
    
    
  //  UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  //  NookViewController *contactVC = [ storyBoard instantiateViewControllerWithIdentifier:@"NookViewController"];
  //  contactVC.delegate = self;
   // contactVC.contactType = 0;
   // [self.navigationController pushViewController:contactVC animated:YES];
}
*/

-(void)openContactsViewForProfessional
{
 //   NSInteger *contactType=0;
    [PersistenceStorage setObject:@"0" andKey:@"contactType"];

    
    ABPeoplePickerNavigationController *personPicker = [ABPeoplePickerNavigationController new];
    
    personPicker.peoplePickerDelegate = self;
    [self presentViewController:personPicker animated:YES completion:nil];
}


-(void)openContactsViewForFamily
{
  [PersistenceStorage setObject:@"1" andKey:@"contactType"];
    ABPeoplePickerNavigationController *personPicker = [ABPeoplePickerNavigationController new];
    
    personPicker.peoplePickerDelegate = self;
    [self presentViewController:personPicker animated:YES completion:nil];
}





- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person {
    
    NSString *firstName;
    NSString *contactType;

    NSString *middleName;
    NSString *lastName;
    NSString *retrievedName;
    NSString *recordID;
    
    NSDate *retrievedDate;
    UIImage *retrievedImage;
    
    
    
    NSNumber *recordId = [NSNumber numberWithInteger: ABRecordGetRecordID(person)];
    
    
    // get the first name
    firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    //get the middle name
    middleName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
    
    // get the last name
    lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    // get the birthday
    retrievedDate = (__bridge_transfer NSDate*)ABRecordCopyValue(person, kABPersonBirthdayProperty);
    
    // get personPicture
    if (person != nil && ABPersonHasImageData(person))
    {
        retrievedImage = [UIImage imageWithData:(__bridge_transfer NSData*)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail)];
    }
    else
    {
        retrievedImage = nil;
    }
    
    //set the name
    if (firstName != NULL && middleName != NULL && lastName != NULL)
    {
        retrievedName = [[NSString alloc] initWithFormat:@"%@ %@ %@",firstName,middleName,lastName];
    }
    
    if (firstName != NULL && middleName != NULL & lastName == NULL)
    {
        retrievedName = [[NSString alloc] initWithFormat:@"%@ %@",firstName, middleName];
    }
    
    if (firstName != NULL && middleName == NULL && lastName != NULL)
    {
        retrievedName = [[NSString alloc] initWithFormat:@"%@ %@",firstName,lastName];
    }
    
    if (firstName != NULL && middleName == NULL && lastName == NULL)
    {
        retrievedName = [[NSString alloc] initWithFormat:@"%@",firstName];
    }
    
    if (firstName == NULL && middleName != NULL && lastName != NULL)
    {
        retrievedName = [[NSString alloc] initWithFormat:@"%@ %@",middleName, lastName];
    }
    
    if (firstName == NULL && middleName != NULL && lastName == NULL)
    {
        retrievedName = [[NSString alloc] initWithFormat:@"%@",middleName];
    }
    
    if (firstName == NULL && middleName == NULL && lastName != NULL)
    {
        retrievedName = [[NSString alloc] initWithFormat:@"%@", lastName];
    }
    
    
    NSString *query = [NSString stringWithFormat:@"insert into My_Contacts (contactName,contactNumber,contactType,createdDate) values('%@','%@','%@','%@')",retrievedName,nil,[PersistenceStorage getObjectForKey:@"contactType"],nil];
    
    // Execute the query.
    [dbManager executeQuery:query];
    [self dismissViewControllerAnimated:NO completion:^(){}];
    [self setData];

    [self.supportTableView reloadData];

}

/*-(void)openContactsViewForFamily
{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ContactListViewController *contactVC = [ storyBoard instantiateViewControllerWithIdentifier:@"ContactListViewController"];
    contactVC.delegate = self;
    contactVC.contactType = 1;
    [self.navigationController pushViewController:contactVC animated:YES];
}

 */
 
#pragma mark delete and move contacts

- (IBAction)onClickCloseContact:(id)sender {
       CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.supportTableView];
        NSIndexPath *indexPath = [self.supportTableView indexPathForRowAtPoint:buttonPosition];
    NSDictionary *selectedContactDict;
    switch (indexPath.section) {
        case 0:
            
            selectedContactDict =[professionalSupportArray objectAtIndex:indexPath.row];
            
            break;
        case 1:
            
            selectedContactDict =[familyFriendsArray objectAtIndex:indexPath.row];
            
            break;
        default:
            selectedContactDict = nil;
            break;
    }
    
    if (selectedContactDict != nil) {
        
        NSString *deletedQuery = [NSString stringWithFormat:@"delete from My_Contacts where contactName='%@' and contactType==%ld",[selectedContactDict valueForKey:@"contactName"],(long)[[selectedContactDict valueForKey:@"contactType"] integerValue]];
        if ([dbManager executeQuery:deletedQuery]) {
            [self setData];
            [self.supportTableView reloadData];
        }
    }
}

- (IBAction)onClickMoveContact:(id)sender {
}

#pragma mark - contact selected delegate
-(void)didSelectContact:(AddressBookData *)contact withType:(int)contactType
{
    if ([self insertContact:contact withType:contactType])
    {
        [self setData];
        [self.supportTableView reloadData];
    }
//    if (contactType == 0) {
//        
//        [professionalSupportArray addObject:contact];
//        
//    }
//    else
//    {
//        [familyFriendsArray addObject:contact];
//    }
    ;
}



-(BOOL)insertContact:(AddressBookData*)contact withType:(int)contactType
{
    if (![self isExistContact:contact type:contactType]) {
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *dateString = [formatter stringFromDate:date];
        NSDate *currentDate = [formatter dateFromString:dateString];
        
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activity startAnimating];
        //    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.activityTableView];
        //    NSIndexPath *indexPath = [self.activityTableView indexPathForRowAtPoint:buttonPosition];
        //    if (indexPath != nil)
        //    {
        //        NSDictionary *dict = [activityArray objectAtIndex:indexPath.row];
         NSString *query = [NSString stringWithFormat:@"insert into My_Contacts (contactName,contactNumber,contactType,createdDate) values('%@','%@','%d',%lf)",contact.contact_name,contact.contact_number,contactType,[currentDate timeIntervalSince1970]];
        
        // Execute the query.
        [dbManager executeQuery:query];
        
        // If the query was successfully executed then pop the view controller.
        if (dbManager.affectedRows != 0) {
             [activity stopAnimating];
            // Pop the view controller.
        }
        else{
             return NO;
        }
        
    }
    
    return YES;
    
    //    }
    
}













/*
-(BOOL)insertContact:(AddressBookData*)contact withType:(int)contactType
{
    if (![self isExistContact:contact type:contactType]) {
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *dateString = [formatter stringFromDate:date];
        NSDate *currentDate = [formatter dateFromString:dateString];
        
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activity startAnimating];
        //    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.activityTableView];
        //    NSIndexPath *indexPath = [self.activityTableView indexPathForRowAtPoint:buttonPosition];
        //    if (indexPath != nil)
        //    {
        //        NSDictionary *dict = [activityArray objectAtIndex:indexPath.row];
         NSString *query = [NSString stringWithFormat:@"insert into My_Contacts (contactName,contactNumber,contactType,createdDate) values('%@','%@','%d',%lf)",contact.contact_name,contact.contact_number,contactType,[currentDate timeIntervalSince1970]];
        
        // Execute the query.
        [dbManager executeQuery:query];
        
        // If the query was successfully executed then pop the view controller.
        if (dbManager.affectedRows != 0) {
             [activity stopAnimating];
            // Pop the view controller.
        }
        else{
             return NO;
        }
        
    }
   
    return YES;
        
//    }

}
 */
 
-(BOOL)isExistContact:(AddressBookData *)contact type:(int)contactType
{
//    
//    switch (contactType) {
//        case 0:
//        {
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"self.contactNumber == %@ AND self.contactType == %d",contact.contact_number,contactType]];
//            if ([[professionalSupportArray filteredArrayUsingPredicate:predicate] count] == 0) {
//                return NO;
//            }
//            break;
//        }
//        case 1:
//        {
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"self.contactNumber == %@ AND self.contactType == %d",contact.contact_number,contactType]];
//            if ([[familyFriendsArray filteredArrayUsingPredicate:predicate] count] == 0) {
//                return NO;
//            }
//            break;
//        }
//        default:
//            break;
//    }
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM My_Contacts where contactNumber='%@' and contactType=%d ",contact.contact_number,contactType];
    NSArray *allRecordsArray = [dbManager loadDataFromDB:query];
    if ([allRecordsArray count] == 0) {
        return NO;
    }
    
    return YES;
}
@end
