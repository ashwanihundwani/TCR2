//
//  SkillIntroductionCell.h
//  TinnitusCoach
//
//  Created by Creospan on 13/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SkillIntroInfo;

@protocol SkillIntroductionCellDelegate<NSObject>

-(void)didTapIntro:(id)sender;
-(void)didTapLearnMore:(id)sender;



@end

@interface SkillIntroductionCell : UITableViewCell

@property(nonatomic, weak)id<SkillIntroductionCellDelegate> delegate;

-(void)setSkillIntroInfo:(SkillIntroInfo *)info;

@end
