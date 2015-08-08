//
//  SoundTypeView.h
//  testUIChanges
//
//  Created by Creospan   on 01/04/15.
//  Copyright (c) 2015 Creospan  . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SoundTypeViewProtocol <NSObject>
@required
- (void) tableViewCellClicked:(NSDictionary *)soundDict;
- (void) tableViewCellDeleted:(NSDictionary *)soundDict;
 @end

@interface SoundTypeView : UIView <UITableViewDataSource, UITableViewDelegate>
- (id)initWithFrame:(CGRect)frame andData:(NSArray *)dataArray;

@property (nonatomic,strong) id <SoundTypeViewProtocol> delegate;


@property (weak, nonatomic) IBOutlet UITableView *soundActivitiesTableView;
@property (weak, nonatomic) IBOutlet UILabel *soundDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *exploreAndAddButton;
@property (weak, nonatomic) IBOutlet UILabel *soundActivityTableStatus;
@property (weak, nonatomic) IBOutlet UILabel *soundTitleLabel;


@end
