//
//  UsingSoundFeedbackCell.m
//  TinnitusCoach
//
//  Created by Creospan on 9/12/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "UsingSoundFeedbackCell.h"

@implementation UsingSoundFeedbackCell

- (void)awakeFromNib {
    // Initialization code
    self.usingSoundTableView.delegate = self;
    self.usingSoundTableView.dataSource = self;
    self.usingSoundTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.usingSoundTableView registerNib:[UINib nibWithNibName:@"FeedbackTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FeedbackCellIdentifier"];
    self.usingSoundTableView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)reInitialize{
    self.usingSoundTableView.hidden = YES;
    self.itemSelectorBtn.hidden = YES;
    self.itemSelctorBtnImage.hidden = YES;
    //[self.usingSoundTableView setBackgroundColor:[UIColor]]
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.delegate usingSoundTableView:tableView heightForRowAtIndexPath:indexPath inUsingSound:self];
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self.delegate feeedbackTableView:tableView viewForHeaderInSection:section];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.delegate feedbackTableView:tableView titleForHeaderInSection:section];
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.delegate usingSoundTableView:tableView numberOfRowsInSection:section inUsingSound:self];
    //return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FeedbackTableViewCell* cell = (FeedbackTableViewCell*)[self.delegate usingSoundTableView:tableView cellForRowAtIndexPath:indexPath inUsingSound:self];
    cell.delegate = self;
    cell.feedbackTableView.tag = 1000 + indexPath.row;
    return cell;
}


#pragma mark - 

- (CGFloat)feeedbackTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.delegate feeedbackTableView:tableView heightForRowAtIndexPath:indexPath inUsingSound:self];
}

- (UIView *)feeedbackTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self.delegate feeedbackTableView:tableView viewForHeaderInSection:section inUsingSound:self];
}

- (void)feeedbackTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate feeedbackTableView:tableView didSelectRowAtIndexPath:indexPath inUsingSound:self];
}

- (NSInteger)feeedbackTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.delegate feeedbackTableView:tableView numberOfRowsInSection:section inUsingSound:self];
}

- (NSInteger)numberOfSectionsInFeeedbackTableView:(UITableView *)tableView{
    return [self.delegate numberOfSectionsInFeeedbackTableView:tableView inUsingSound:self];
}
- (UITableViewCell *)feeedbackTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.delegate feeedbackTableView:tableView cellForRowAtIndexPath:indexPath inUsingSound:self];
}
-(NSString *)feedbackTableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.delegate feedbackTableView:tableView titleForHeaderInSection:section inUsingSound:self];
}
-(void)itemClickedForRating:(NSInteger)ratingIndex inCell:(id)cell{
    [self.delegate itemClickedForRating:ratingIndex inCell:cell inUsingSound:self];
}
-(void)deviceItemClickedForRating:(NSInteger)rating :(NSIndexPath*)deviceIndexPath inCell:(id)cell{
    
}

-(void)deviceItemSelected:(NSIndexPath*)deviceIndexPath inCell:(id)feedbackCell{
    [self.delegate  deviceItemClickedForRating:0 :deviceIndexPath inCell:feedbackCell inUsingSound:self];
}
-(void)groupItemSelected:(id)feedbackCell{
    NSIndexPath* groupIndexPath = [self.usingSoundTableView indexPathForCell:feedbackCell];
    [self.delegate groupItemSelected:groupIndexPath inCell:self];
    
}



@end
