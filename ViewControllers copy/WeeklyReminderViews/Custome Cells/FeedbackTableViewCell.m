//
//  FeedbackTableViewCell.m
//  TinnitusCoach
//
 //  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "FeedbackTableViewCell.h"

@implementation FeedbackTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.secondaryView.backgroundColor = [UIColor lightGrayColor];
    self.secondaryView.layer.cornerRadius = 5.0;
    self.secondaryView.layer.masksToBounds = YES;
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
    
    //resetting indicators
    [self.noatallButton setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    [self.alittleButton setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    [self.moderatelyButton setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    [self.veryMuchButton setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    [self.extremelyButton setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
 

}


-(IBAction)feedbackBtnPressed:(id)sender{
    
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
