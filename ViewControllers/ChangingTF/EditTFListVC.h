//
//  EditTipListVC.h
//  TinnitusCoach
//
 //  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"


@protocol EditRipsListDelegate1<NSObject>
@optional
-(void)didSaveTF;
@end

@interface EditTFListVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableViewOutlet;
@property(weak,nonatomic)id <EditRipsListDelegate1> delegate;
@end
