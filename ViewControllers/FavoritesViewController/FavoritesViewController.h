//
//  FavoritesViewController.h
//  TinnitusCoach
//
//  Created by Creospan on 28/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoriteActivityCell.h"
@interface FavoritesViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *removeFavoriteButton;
@property (weak, nonatomic) IBOutlet UITableView *favoriteTableView;
@property (nonatomic,strong) DBManager *manager;
@end
