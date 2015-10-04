//
//  AddActivityViewController.h
//  TinnitusCoach
//
//  Created by Creospan on 28/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBAutoGrowingTextView.h"
@interface CTF02 : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *textInfo;
@property (weak, nonatomic) IBOutlet MBAutoGrowingTextView *nameTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TextViewHeightConstraint;

@property (nonatomic,strong) DBManager *manager;
- (IBAction)addButtonTapped:(id)sender;

@end
