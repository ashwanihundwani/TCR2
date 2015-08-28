//
//  OtherSoundsInfo.h
//  TinnitusCoach
//
//  Created by Ashwani Hundwani on 14/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OtherSoundInfo : NSObject

@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *userTag;
@property(nonatomic, strong)NSString *dbIdentifier;
@property(nonatomic, strong)NSString *typeId;

-(id)initWithDict:(NSDictionary *)dict;

@end
