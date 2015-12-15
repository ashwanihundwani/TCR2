//
//  SkillReminderInfo.h
//  TinnitusCoach
//
//  Created by Creospan on 13/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkillReminderInfo : NSObject

@property(nonatomic)BOOL reminderExists;
@property(nonatomic, strong)NSString *tryUsingText;
@property(nonatomic, strong)NSString *reminderDate;
@property(nonatomic, strong)NSString *repeatStr;

@end
