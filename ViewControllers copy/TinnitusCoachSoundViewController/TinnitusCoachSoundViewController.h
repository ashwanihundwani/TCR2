//
//  TinnitusCoachSoundViewController.h
//  TinnitusCoach
//
 //  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TinnitusCoachSoundViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSString *soundType;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end
