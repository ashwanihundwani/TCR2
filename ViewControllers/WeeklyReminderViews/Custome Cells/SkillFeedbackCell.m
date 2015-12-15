//
//  SkillFeedbackCell.m
//  TinnitusCoach
//
 //  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "SkillFeedbackCell.h"

#define DOT_VIEW_TAG 121132

@interface SkillFeedbackCell()

@property(nonatomic, weak)UIButton *selectedButton;

@end

@implementation SkillFeedbackCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)reInitialize{
    self.secondaryView.hidden = YES;
    self.itemSelectorBtn.hidden = YES;
    self.itemSelctorBtnImage.hidden = YES;
    self.selectedButton.backgroundColor = [UIColor whiteColor];
    [[self.selectedButton viewWithTag:DOT_VIEW_TAG] removeFromSuperview];
    self.selectedButton = nil;

 

}

-(void)fillbutton:(id)button{
    UIButton *btn = (UIButton *)button;
    if(btn != self.selectedButton){
        
        btn.backgroundColor = [Utils colorWithHexValue:BUTTON_BLUE_COLOR_HEX_VALUE];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(6, 6, btn.width - 12, btn.height - 12)];
        
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = (btn.width - 12) / 2;
        view.layer.masksToBounds = YES;
        view.tag = DOT_VIEW_TAG;
        
        [btn addSubview:view];
        
        self.selectedButton.backgroundColor = [UIColor whiteColor];
        [[self.selectedButton viewWithTag:DOT_VIEW_TAG] removeFromSuperview];
        
        self.selectedButton = btn;
        
    }
}


-(IBAction)feedbackBtnPressed:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    if(btn != self.selectedButton){
        
        btn.backgroundColor = [Utils colorWithHexValue:BUTTON_BLUE_COLOR_HEX_VALUE];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(6, 6, btn.width - 12, btn.height - 12)];
        
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = (btn.width - 12) / 2;
        view.layer.masksToBounds = YES;
        view.tag = DOT_VIEW_TAG;
        
        [btn addSubview:view];
        
        self.selectedButton.backgroundColor = [UIColor whiteColor];
        [[self.selectedButton viewWithTag:DOT_VIEW_TAG] removeFromSuperview];
        
        self.selectedButton = btn;
        
    }
    
    NSLog(@"Feedback btn pressed having tag: %ld", ((UIButton*)sender).tag);
    [self.delegate ratingRecieved:((UIButton*)sender).tag inCell:self];
}







@end
