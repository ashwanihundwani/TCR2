//
//  OtherSoundsCell.h
//  TinnitusCoach
//
//  Created by Creospan on 14/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSoundCell.h"
#import "OtherSoundInfo.h"

@protocol OtherSoundsCellDelegate<BaseSoundCellDelegate>

-(void)didTapInformation:(id)sender;

@end

@interface OtherSoundsCell : BaseSoundCell

@property(nonatomic, strong)UITextField *tagField;

@property(nonatomic, strong)IBOutlet UIImageView *infoImageView;


@property(nonatomic, weak)id<OtherSoundsCellDelegate> otherDelegate;

-(void)setSoundInfo:(OtherSoundInfo *)soundInfo;


@end
