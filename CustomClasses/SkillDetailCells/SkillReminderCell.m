//
//  SkillReminderCell.m
//  TinnitusCoach
//
//  Created by Ashwani Hundwani on 13/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "SkillReminderCell.h"
#import "SkillReminderInfo.h"

@interface SkillReminderCell()
@property (weak, nonatomic) IBOutlet UILabel *tryUsingLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *activeLabel;

@property (weak, nonatomic) IBOutlet UISwitch *activateSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *trashImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tryUsingTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *repeatLabel;

@end

@implementation SkillReminderCell


-(void)setReminderInfo:(SkillReminderInfo *)info
{
    if(info.reminderExists)
    {
        self.activateSwitch.on = TRUE;
        self.tryUsingTopConstraint.constant = 65;
        self.activateSwitch.hidden = YES;
        self.activeLabel.hidden = YES;
    }
    else
    {
        self.activateSwitch.on = FALSE;
        self.tryUsingTopConstraint.constant = 130;
        self.activateSwitch.hidden = NO;
        self.activeLabel.hidden = NO;
    }
    
    self.tryUsingLabel.text = info.tryUsingText;
    
    self.dateLabel.text = info.reminderDate;
    
    if(info.repeatStr)
    {
        self.repeatLabel.text = info.repeatStr;
        self.repeatLabel.hidden = FALSE;
    }
    else
    {
        self.repeatLabel.hidden = TRUE;
    }
}

-(BOOL)getSkillReminderSwitchState{
    return self.activateSwitch.on;
}

-(void)setSkillReminderSwitchState:(BOOL)state{
    self.activateSwitch.hidden = NO;
    self.activateSwitch.on = state;
}


-(IBAction)onTrash:(id)sender
{
    if(self.delegate
       && [self.delegate respondsToSelector:@selector(didTapTrash:)])
    {
        [self.delegate didTapTrash:self];
    }
}

-(IBAction)onActivateSwitch:(id)sender
{
    if(self.delegate
       && [self.delegate respondsToSelector:@selector(didTapActivate:)])
    {
        [self.delegate didTapActivate:self];
    }
}



- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    
    [Utils addTapGestureToView:self.trashImageView target:self selector:@selector(onTrash:)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
