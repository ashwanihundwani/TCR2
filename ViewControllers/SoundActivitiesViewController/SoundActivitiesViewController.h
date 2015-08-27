//
//  SoundActivitiesViewController.h
//  TinnitusCoach
//
//  Created by Vikram Singh on 3/29/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSkilDetailViewController.h"

@interface SoundActivitiesViewController : BaseSkilDetailViewController
@property (nonatomic, strong) NSString *skillName;

@property(nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) DBManager *dbManagerMySounds;
@property(nonatomic, strong)NSMutableArray *soundUICompleteInfo;

@property(nonatomic, strong)NSDictionary *otherDevicesPopupMessageDict;

-(void)prepareData;

-(NSDictionary *)getSoundDetailForTypeID:(NSInteger)typeID andSoundID:(NSInteger)soundID;
@end
