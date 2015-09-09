//
//  FeedbackTableViewCell.h
//  TinnitusCoach
 //  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedbackDeviceTableViewCell.h"
@protocol FeedbackTableViewCellDelegae <NSObject>

@required

- (CGFloat)feeedbackTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (UIView *)feeedbackTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;

- (void)feeedbackTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)feeedbackTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (NSInteger)numberOfSectionsInFeeedbackTableView:(UITableView *)tableView;
- (UITableViewCell *)feeedbackTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSString *)feedbackTableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
@optional
-(void)itemClickedForRating:(NSInteger)ratingIndex inCell:(id)cell;
-(void)deviceItemClickedForRating:(NSInteger)rating :(NSIndexPath*)deviceIndexPath inCell:(id)cell;

@end

@interface FeedbackTableViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource, FeedBackDeviceTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *noatallButton;
@property (weak, nonatomic) IBOutlet UIButton *alittleButton;
@property (weak, nonatomic) IBOutlet UIButton *moderatelyButton;
@property (weak, nonatomic) IBOutlet UIButton *veryMuchButton;
@property (weak, nonatomic) IBOutlet UIView   *secondaryView;
@property (weak, nonatomic) IBOutlet UIView   *primaryView;
@property (weak, nonatomic) IBOutlet UITableView* feedbackTableView;
@property (weak, nonatomic) IBOutlet UIButton *extremelyButton;
@property (weak, nonatomic) IBOutlet UIButton *itemSelectorBtn;
@property (weak, nonatomic) IBOutlet UILabel  *skillNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemSelctorBtnImage;

-(IBAction)feedbackBtnPressed:(id)sender;


@property (weak, nonatomic) id<FeedbackTableViewCellDelegae> delegate;

-(void)reInitialize;

-(void)fillbutton:(id)btn;

@end
