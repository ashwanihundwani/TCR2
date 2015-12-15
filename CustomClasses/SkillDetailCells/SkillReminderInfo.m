//
//  SkillReminderInfo.m
//  TinnitusCoach
//
//  Created by Creospan on 13/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "SkillReminderInfo.h"

@interface SkillReminderInfo(){
    
    @private
    NSString *reminderDate_;
    
}

@end

@implementation SkillReminderInfo

-(void)setReminderDate:(NSString *)reminderDate{
    
    NSArray *parts = [reminderDate componentsSeparatedByString:@"\n"];
    
    if(parts.count == 2){
        
        self.repeatStr = [parts lastObject];
        self->reminderDate_ = [parts firstObject];
        
    }
    else{
        self->reminderDate_ = reminderDate;
    }
    
}

-(NSString *)reminderDate
{
    return self->reminderDate_;
}

@end
