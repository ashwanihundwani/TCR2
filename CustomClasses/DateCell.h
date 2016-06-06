//
//  DateCell.h
//  TinnitusCoach
//
//  Created by Creospan on 10/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScheduleInfo;

@interface DateCell : UITableViewCell

@property(nonatomic, weak)IBOutlet UILabel *dateLabel;

@property(nonatomic, weak)IBOutlet UILabel *dateTypeLabel;

@end
