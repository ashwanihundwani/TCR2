//
//  SupportViewController.m
//  TinnitusCoach
//
//  Created by Jiten on 25/04/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "SupportViewController.h"
#import "SupportTableViewCell.h"
#import "AddressBookData.h"
#import "ProfessionalSupportView.h"
#import "FamilyFriendsView.h"
#import "NookViewController.h"
#import "DeleteCormationManager.h"

#import "DBManager.h"

@interface SupportViewController() //<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *familyFriendsArray;
    NSMutableArray *professionalSupportArray;
    DBManager *dbManager;
}
@end
@implementation SupportViewController

-(void)goToHome
{
    self.tabBarController.selectedIndex = 0;
    
}

-(void)viewDidAppear:(BOOL)animated

{
    [self writeVisitedSupport];
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.supportTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationController.navigationBar.hidden=YES;
    
    // Do any additional setup after loading the view.
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    
    titleView.backgroundColor = [Utils colorWithHexValue:NAV_BAR_BLACK_COLOR];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 320, 44)];
    
    Pair *pallete = [Utils getColorFontPair:eCFS_PALLETE_1];
    
    titleLabel.font = pallete.secondObj;
    titleLabel.textColor = pallete.firstObj;
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //titleLabel.textColor = [UIColor colorWithHexValue:@"797979"];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"Support";
    
    [titleView addSubview:titleLabel];
    
    [self.view addSubview:titleView];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(8, 32, 40, 30)];
    
    UIImageView *backLabel = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 20)];
    
    [backView addSubview:backLabel];
    
    backLabel.image = [UIImage imageNamed:@"Active_Back-Arrow.png"];
    
    [Utils addTapGestureToView:backView target:self
                      selector:@selector(goToHome)];
    
    
    [self.view addSubview:backView];
    
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
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            ProfessionalSupportView *professioNalView = [[[NSBundle mainBundle] loadNibNamed:@"ProfessionalSupportView" owner:self options:nil] objectAtIndex:0];
            professioNalView.btnAddNewContact.layer.cornerRadius = 5.0f;
            professioNalView.btnCall.layer.cornerRadius = 5.0f;
            professioNalView.btnVisitWebsite.layer.cornerRadius = 5.0f;
            
            [professioNalView.btnVisitWebsite addTarget:self action:@selector(visitWebsite:) forControlEvents:UIControlEventTouchUpInside];
            
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
        return 243;
    }
    return 138;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *contactsArray = nil;
    
    if(indexPath.section == 0)
    {
        contactsArray = professionalSupportArray;
    }
    else
    {
        contactsArray = familyFriendsArray;
    }
    
    NSDictionary *contact = [contactsArray objectAtIndex:indexPath.row];
    
    NSString *phoneNumber = [contact objectForKey:@"contactNumber"];
    
    
    NSString *cleanedString = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *phoneURLString = [NSString stringWithFormat:@"telprompt:%@", escapedPhoneNumber];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
    
    
    
    
    
    
//    NSLog(@"%@",phoneNumber);
//    if(phoneNumber && ![phoneNumber isEqualToString:@""])
//    {
//     
//        
//        NSString *strMob = [[NSString alloc] initWithFormat:@"tel://%@",strm];
//        
//        NSString *phoneCallNum = [NSString stringWithFormat:@"tel:%@",phoneNumber];
//        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneCallNum]];
//    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == 0)
    {
        UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
        
        separator.backgroundColor = [UIColor lightGrayColor];
        
        UIView *btmSeparator = [[UIView alloc]initWithFrame:CGRectMake(0, 9, 320, 1)];
        
        btmSeparator.backgroundColor = [UIColor lightGrayColor];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
        view.backgroundColor = [Utils colorWithHexValue:@"EFEFF4"];
        
        [view addSubview:separator];
        [view addSubview:btmSeparator];
        
        return view;
    }
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 10;
    }
    return 0;
}

#pragma Mark Calling

-(void)visitWebsite:(id)sender
{
    NSString *url = @"http://www.suicidepreventionlifeline.org/";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

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
    NSString *contactNumber = @"";
    
    ABMultiValueRef phonesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, 0);
    
    NSString *string = (__bridge id)(currentPhoneValue);
    
    
    NSMutableString *strippedString = [NSMutableString
                                       stringWithCapacity:string.length];
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:string];
    
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    while (![scanner isAtEnd]) {
        NSString *bufferString;
        
        if ([scanner scanCharactersFromSet:numbers intoString:&bufferString]) {
            [strippedString appendString:bufferString];
        }
        else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    
    if(string)
    {
        contactNumber = string;
    }
    
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
    
    NSString *query = @"SELECT * FROM My_Contacts";
    
    NSArray *allRecordsArray = [dbManager loadDataFromDB:query];
    
    
    for(NSDictionary *dict in allRecordsArray)
    {
        NSString *name = [dict objectForKey:@"contactName"];
        NSString *number = [dict objectForKey:@"contactNumber"];
        NSInteger contactType = [[dict objectForKey:@"contactType"] integerValue];
        
        if([[PersistenceStorage getObjectForKey:@"contactType"] integerValue] == contactType
           && [name isEqualToString:retrievedName]
           && [number isEqualToString:contactNumber])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"This contact is already listed." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:
                                  nil];
            
            [alert show];
            
            return;
            
        }
    }
    
    
    query = [NSString stringWithFormat:@"insert into My_Contacts (contactName,contactNumber,contactType,createdDate) values('%@','%@','%@','%@')",retrievedName,contactNumber,[PersistenceStorage getObjectForKey:@"contactType"],nil];
    
    // Execute the query.
    [dbManager executeQuery:query];
    [self dismissViewControllerAnimated:NO completion:^(){}];
    [self setData];
    [self addedContact];
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
    
    DeleteCormationManager *manager = [DeleteCormationManager getInstance];
    
    [manager showAlertwithPositiveBlock:^(BOOL positive) {
        
     
        [self deletedContact];
        
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
        
    } negativeBlock:^(BOOL negative) {
        
        //TODO - do nothing.
        
    }];
    
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
          //  [activity stopAnimating];
            
            [self addedContact];
            
            
            
            // Pop the view controller.
        }
        else{
            return NO;
        }
        
    }
    
    return YES;
    
    //    }
    
}


-(void)deletedContact
{
         //  NSURL *path = [self getUrlOfFiles:@"TinnitusCoachUsageData.csv"];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *documentTXTPath = [documentsDirectory stringByAppendingPathComponent:@"TinnitusCoachUsageData.csv"];
        
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"MM/dd/yy";
        NSString *dateString = [dateFormatter stringFromDate: date];
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
        timeFormatter.dateFormat = @"HH:mm:ss";
        NSString *timeString = [timeFormatter stringFromDate: date];
        NSString *type = @"Find Support";
        
        NSString *str = @"Removed Contact";
    NSString *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil];
    
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:documentTXTPath])
        {
            [finalStr writeToFile:documentTXTPath atomically:YES];
        }
        else
        {
            NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:documentTXTPath];
            [myHandle seekToEndOfFile];
            [myHandle writeData:[finalStr dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
        
   
    
}

-(void)addedContact
{

         //  NSURL *path = [self getUrlOfFiles:@"TinnitusCoachUsageData.csv"];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *documentTXTPath = [documentsDirectory stringByAppendingPathComponent:@"TinnitusCoachUsageData.csv"];
        
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"MM/dd/yy";
        NSString *dateString = [dateFormatter stringFromDate: date];
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
        timeFormatter.dateFormat = @"HH:mm:ss";
        NSString *timeString = [timeFormatter stringFromDate: date];
        NSString *type = @"Find Support";
        
     NSString *str = @"Added Contact";
    NSString *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:documentTXTPath])
        {
            [finalStr writeToFile:documentTXTPath atomically:YES];
        }
        else
        {
            NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:documentTXTPath];
            [myHandle seekToEndOfFile];
            [myHandle writeData:[finalStr dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
        
    
    
}

-(void)writeVisitedSupport{
    //  NSURL *path = [self getUrlOfFiles:@"TinnitusCoachUsageData.csv"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentTXTPath = [documentsDirectory stringByAppendingPathComponent:@"TinnitusCoachUsageData.csv"];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM/dd/yy";
    NSString *dateString = [dateFormatter stringFromDate: date];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"HH:mm:ss";
    NSString *timeString = [timeFormatter stringFromDate: date];
    NSString *type = @"Navigation";
    
    NSString *str = @"Support";
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,nil,str,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:documentTXTPath])
    {
        [finalStr writeToFile:documentTXTPath atomically:YES];
    }
    else
    {
        NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:documentTXTPath];
        [myHandle seekToEndOfFile];
        [myHandle writeData:[finalStr dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
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
