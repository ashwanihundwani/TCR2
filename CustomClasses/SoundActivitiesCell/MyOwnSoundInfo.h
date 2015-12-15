//
//  MyOwnSoundInfo.h
//  TinnitusCoach
//
//  Created by Creospan on 02/09/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOwnSoundInfo : NSObject

@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *url;
@property(nonatomic, strong)NSString *dbIdentifier;
@property(nonatomic, strong)NSString *typeId;

-(id)initWithDict:(NSDictionary *)dict;

@end
