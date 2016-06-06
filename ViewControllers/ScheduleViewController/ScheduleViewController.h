//
//  ScheduleViewController.h
//  TinnitusCoach
//
//  Created by Creospan on 30/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum ReminderType
{
    eRT_NEVER,
    eRT_DAILY,
    eRT_WEEKLY,
}EReminderType;

@interface ScheduleInfo : NSObject

@property(nonatomic, strong)NSString *startDateLabelText;
@property(nonatomic, strong)NSString *endDateLabelText;
@property(nonatomic, strong)NSString *startDate;
@property(nonatomic, strong)NSString *endDate;
@property(nonatomic)EReminderType remType;


@end


@protocol ScheduleViewControllerDelegate <NSObject>


-(void)didTapDelete:(id)sender;


@end


@interface ScheduleViewController : UIViewController <UIActionSheetDelegate,UIAlertViewDelegate>

@property(nonatomic, weak)id<ScheduleViewControllerDelegate> delegate;
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

@property (nonatomic, strong)NSDate *inputDate;
@property (nonatomic, strong)NSString *repeatText;

@property(nonatomic, strong)NSString *activityText;

@property (weak, nonatomic) IBOutlet UITableView *scheduleTableView;
@end
