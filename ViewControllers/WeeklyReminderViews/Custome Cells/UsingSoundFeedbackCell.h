//
//  UsingSoundFeedbackCell.h
//  TinnitusCoach
//
//  Created by Amit on 9/12/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedbackTableViewCell.h"

@protocol UsingSoundTableViewDelegate <NSObject>

- (UITableViewCell *)usingSoundTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath inUsingSound:(id)usCell;
- (CGFloat)usingSoundTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath inUsingSound:(id)cell;
- (CGFloat)feeedbackTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath inUsingSound:(id)cell;

- (UIView *)feeedbackTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section inUsingSound:(id)cell;

- (void)feeedbackTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath inUsingSound:(id)cell;

- (NSInteger)feeedbackTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section inUsingSound:(id)cell;

- (NSInteger)numberOfSectionsInFeeedbackTableView:(UITableView *)tableView inUsingSound:(id)cell;
- (UITableViewCell *)feeedbackTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath inUsingSound:(id)cell;
-(NSString *)feedbackTableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section inUsingSound:(id)cell;
@optional
-(void)itemClickedForRating:(NSInteger)ratingIndex inCell:(id)cell inUsingSound:(id)cell;
-(void)deviceItemClickedForRating:(NSInteger)rating :(NSIndexPath*)deviceIndexPath inCell:(id)cell inUsingSound:(id)cell;
-(void)groupItemSelected:(NSIndexPath*)groupIndexPath inCell:(id)usingSoundCell;

@end

@interface UsingSoundFeedbackCell : UITableViewCell<UITableViewDelegate, UITableViewDataSource, FeedbackTableViewCellDelegae>

@property (weak, nonatomic) IBOutlet UITableView* usingSoundTableView;
@property (weak, nonatomic) IBOutlet UILabel  *skillNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *itemSelectorBtn;
@property (weak, nonatomic) IBOutlet UIImageView *itemSelctorBtnImage;
@property (weak, nonatomic) id<UsingSoundTableViewDelegate> delegate;
-(void)reInitialize;
@end
