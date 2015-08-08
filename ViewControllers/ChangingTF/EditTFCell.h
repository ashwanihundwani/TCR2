//
//  EditTipsCell.h
//  TinnitusCoach
//
 //  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTFCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnToggleCategory;
@property (weak, nonatomic) IBOutlet UIView *baseView;

@end
