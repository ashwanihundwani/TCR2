//
//  SoundIntroCell.h
//  TinnitusCoach
//
//  Created by Creospan on 14/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SoundIntroInfo;

@protocol SoundIntroCellDelegate <NSObject>

-(void)didTapOnExplore:(id)sender;

@end

@interface SoundIntroCell : UITableViewCell

@property(nonatomic, strong)IBOutlet UILabel *titleLabel;
@property(nonatomic, strong)IBOutlet UILabel *descriptionLabel;

@property(nonatomic, weak)id<SoundIntroCellDelegate> delegate;

-(IBAction)onExplore:(id)sender;


-(void)setIntroInfo:(SoundIntroInfo *)info;


@end
