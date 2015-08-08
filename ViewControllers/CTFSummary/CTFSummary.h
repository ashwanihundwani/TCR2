//
//  AddActivityViewController.h
//  TinnitusCoach
//
//  Created by Swipe Video Labs Pvt. Ltd. on 28/03/15.
//  Copyright (c) 2015 Swipe Video Labs Pvt. Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CTFSummary : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *textInfo;

@property (nonatomic,strong) DBManager *manager;
- (IBAction)addButtonTapped:(id)sender;

@end
