//
//  ScheduleViewController.h
//  TinnitusCoach
//
//  Created by Creospan on 30/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScheduleViewController : UIViewController <UIActionSheetDelegate,UIAlertViewDelegate>

 @property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *endButton;
- (IBAction)startButtonTapped:(id)sender;
- (IBAction)repeatButtonTapped:(id)sender;
@property (nonatomic,strong) DBManager *manager;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *activityName;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
-(void)doneClicked;
@property (nonatomic,strong) NSString *name;
@end
