//
//  FeedbackTableViewCell.h
//  TinnitusCoach
 //  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FeedbackTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *noatallButton;
@property (weak, nonatomic) IBOutlet UIButton *alittleButton;
@property (weak, nonatomic) IBOutlet UIButton *moderatelyButton;
@property (weak, nonatomic) IBOutlet UIButton *veryMuchButton;

@property (weak, nonatomic) IBOutlet UIButton *extremelyButton;

@end
