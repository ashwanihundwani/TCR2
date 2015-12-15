//
//  SupportTableViewCell.h
//  TinnitusCoach
//
//  Created by Creospan on 25/04/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBook.h"

@interface SupportTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnMove;
- (IBAction)onClickCloseContact:(id)sender;
- (IBAction)onClickMoveContact:(id)sender;

-(void)populateData:(AddressBook *)aBook;
@end
