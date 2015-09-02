//
//  MyOwnSoundCell.m
//  TinnitusCoach
//
//  Created by Ashwani Hundwani on 02/09/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "MyOwnSoundCell.h"
#import "MyOwnSoundInfo.h"

@implementation MyOwnSoundCell

-(void)setSoundInfo:(MyOwnSoundInfo *)soundInfo
{
    self.titleLabel.text = soundInfo.title;
}

@end
