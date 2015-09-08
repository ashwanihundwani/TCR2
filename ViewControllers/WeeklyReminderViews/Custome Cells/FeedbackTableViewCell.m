//
//  FeedbackTableViewCell.m
//  TinnitusCoach
//
 //  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "FeedbackTableViewCell.h"

#define DOT_VIEW_TAG 121132

@interface FeedbackTableViewCell()

@property(nonatomic, weak)UIButton *selectedButton;

@end

@implementation FeedbackTableViewCell

- (void)awakeFromNib {
    // Initialization code
    //self.secondaryView.backgroundColor = [UIColor lightGrayColor];
    //self.secondaryView.layer.cornerRadius = 5.0;
    //self.secondaryView.layer.masksToBounds = YES;
    self.feedbackTableView.delegate =self;
    self.feedbackTableView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)reInitialize{
    self.feedbackTableView.hidden = YES;
    self.secondaryView.hidden = YES;
    self.itemSelectorBtn.hidden = YES;
    self.itemSelctorBtnImage.hidden = YES;
    
 

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
    [self.delegate itemClickedForRating:((UIButton*)sender).tag inCell:self];
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self.delegate feeedbackTableView:tableView viewForHeaderInSection:section];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.delegate feedbackTableView:tableView titleForHeaderInSection:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.delegate feeedbackTableView:tableView numberOfRowsInSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.delegate numberOfSectionsInFeeedbackTableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.delegate feeedbackTableView:tableView cellForRowAtIndexPath:indexPath];
}







@end
