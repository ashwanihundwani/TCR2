//
//  AddActivityViewController.h
//  TinnitusCoach
//
//  Created by Creospan on 28/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmotionsCell.h"

@interface CTF03 : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *lblEmotionName;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *lblRating;
@property (nonatomic,strong) DBManager *dbManager;

@property (weak, nonatomic) IBOutlet UITableView *EmotionsTableView;


- (IBAction)addButtonTapped:(id)sender;

@end
