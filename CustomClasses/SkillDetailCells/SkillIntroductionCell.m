//
//  SkillIntroductionCell.m
//  TinnitusCoach
//
//  Created by Ashwani Hundwani on 13/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "SkillIntroductionCell.h"
#import "SkillIntroInfo.h"

@interface SkillIntroductionCell()
@property (weak, nonatomic) IBOutlet UIImageView *skillImageView;
@property (weak, nonatomic) IBOutlet UIView *descriptionContainer;
@property (weak, nonatomic) IBOutlet UIView *learnMoreView;

@property (weak, nonatomic) IBOutlet UIView *introView;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIButton *introButton;

@end

@implementation SkillIntroductionCell


-(void)setSkillIntroInfo:(SkillIntroInfo *)info
{
    self.descriptionLabel.text = info.descriptionText;
    self.skillImageView.image = info.skillImage;
}

-(IBAction)onTapIntro:(id)sender
{
    
    if(self.delegate
       && [self.delegate respondsToSelector:@selector(didTapIntro:)])
    {
        [self.delegate didTapIntro:self];
    }
}

-(void)onTapLearnMore:(id)sender
{
    if(self.delegate
       && [self.delegate respondsToSelector:@selector(didTapLearnMore:)])
    {
        [self.delegate didTapLearnMore:self];
    }
}



- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    
    [Utils addTapGestureToView:self.learnMoreView target:self selector:@selector(onTapLearnMore:)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
