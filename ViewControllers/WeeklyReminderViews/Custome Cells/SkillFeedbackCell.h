//
//  SkillFeedbackCell.h
//  TinnitusCoach
 //  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SkillFeedbackCellDelegate<NSObject>

-(void)ratingRecieved:(NSInteger)rating inCell:(id)cell;

@end

@interface SkillFeedbackCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *noatallButton;
@property (weak, nonatomic) IBOutlet UIButton *alittleButton;
@property (weak, nonatomic) IBOutlet UIButton *moderatelyButton;
@property (weak, nonatomic) IBOutlet UIButton *veryMuchButton;
@property (weak, nonatomic) IBOutlet UIView   *secondaryView;
@property (weak, nonatomic) IBOutlet UIView   *primaryView;
@property (weak, nonatomic) IBOutlet UIButton *extremelyButton;
@property (weak, nonatomic) IBOutlet UIButton *itemSelectorBtn;
@property (weak, nonatomic) IBOutlet UILabel  *skillNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemSelctorBtnImage;
@property (weak, nonatomic) id<SkillFeedbackCellDelegate> delegate;

-(IBAction)feedbackBtnPressed:(id)sender;


-(void)reInitialize;
-(void)fillbutton:(id)btn;

@end
