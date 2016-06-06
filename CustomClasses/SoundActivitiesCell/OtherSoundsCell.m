//
//  OtherSoundsCell.m
//  TinnitusCoach
//
//  Created by Creospan on 14/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "OtherSoundsCell.h"
#import "OtherSoundInfo.h"

@interface OtherSoundsCell(){
    
@private
    id<OtherSoundsCellDelegate> otherDelegate_;
}

@end

@implementation OtherSoundsCell

-(void)onInfoTap:(id)sender
{
    if(self.otherDelegate
       && [self.otherDelegate respondsToSelector:@selector(didTapInformation:)])
    {
        [self.otherDelegate didTapInformation:self];
    }
}

- (void)awakeFromNib {
    // Initialization code
    
    self.tagField.userInteractionEnabled = false;
    
    [Utils addTapGestureToView:self.infoImageView target:self selector:@selector(onInfoTap:)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)setSoundInfo:(OtherSoundInfo *)soundInfo
{
    self.titleLabel.text = soundInfo.title;
    self.tagField.text = soundInfo.userTag;
}

-(void)setOtherDelegate:(id<OtherSoundsCellDelegate>)otherDelegate
{
    [super setDelegate:otherDelegate];
    self->otherDelegate_ = otherDelegate;
    
}

-(id<OtherSoundsCellDelegate>)otherDelegate
{
    return self->otherDelegate_;
}



@end
