//
//  TinnitusCoachSoundCell.h
//  TinnitusCoach
//
//  Created by Creospan on 3/30/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CEPlayer.h"
#import "CERoundProgressView.h"
//static AVAudioPlayer *audioPlayer;
@protocol TinnitusCoachSoundCellProtocol <NSObject>
@optional
-(void)didSelectPlayPauseButton:(id)cell;

@end

@interface TinnitusCoachSoundCell : UITableViewCell<CEPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addToPlanButton;
@property (weak, nonatomic) IBOutlet CERoundProgressView *progressView;
- (IBAction)playPauseButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (nonatomic, weak) IBOutlet UILabel *songTitleLabel;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) NSString *soundURL;

@property (retain, nonatomic)  CEPlayer *player;

@property(weak,nonatomic)id <TinnitusCoachSoundCellProtocol> delegate;

@end
