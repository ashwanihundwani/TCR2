//
//  TinnitusSoundCell.h
//  TinnitusCoach
//
//  Created by Ashwani Hundwani on 14/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSoundCell.h"
@class TinnitusSoundInfo;

@protocol TinnitusSoundCellDelegate <BaseSoundCellDelegate>


@end

@interface TinnitusSoundCell : BaseSoundCell

-(void)setTinnitusInfo:(TinnitusSoundInfo *)info;



@end
