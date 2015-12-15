//
//  TinnitusCoachSoundCell.m
//  TinnitusCoach
//
//  Created by Creospan on 3/30/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "TinnitusCoachSoundCell.h"

@implementation TinnitusCoachSoundCell

- (void)awakeFromNib {
    // Initialization code
    self.player = [[CEPlayer alloc] init];
    self.player.delegate = self;
    
    UIColor *tintColor = [UIColor blueColor];
    [[UISlider appearance] setMinimumTrackTintColor:tintColor];
    [[CERoundProgressView appearance] setTintColor:tintColor];
    
    self.progressView.trackColor = [UIColor colorWithWhite:0.80 alpha:1.0];
    
    self.progressView.startAngle = (3.0*M_PI)/2.0;
}

-(void)resetView{
    self.playPauseButton.selected = NO;
    [self.player pause];
    self.player.position = 0.0;
    self.progressView.progress = 0.0;
}

- (IBAction)playPauseButton:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectPlayPauseButton:)]) {
        [self.delegate didSelectPlayPauseButton:self];
    }

}



// MARK: CEPlayerDelegate methods

- (void) player:(CEPlayer *)player didReachPosition:(float)position
{
    self.player.position = [self.audioPlayer currentTime]/[self.audioPlayer duration];
    self.progressView.progress = [self.audioPlayer currentTime]/[self.audioPlayer duration];
}

- (void) playerDidStop:(CEPlayer *)player
{
    self.playPauseButton.selected = NO;
    self.progressView.progress = 0.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end
