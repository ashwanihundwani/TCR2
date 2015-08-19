//
//  NookViewController.h
//  TinnitusCoach
//
//  Created by Creospan on 23/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NookViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *faqsButton;
@property (weak, nonatomic) IBOutlet UIButton *changingThoughtsButton;
@property (weak, nonatomic) IBOutlet UIButton *pleasantButton;
@property (weak, nonatomic) IBOutlet UIButton *tipsButton;
@property (weak, nonatomic) IBOutlet UIButton *meditationButton;
@property (weak, nonatomic) IBOutlet UIButton *soundButton;
@property (weak, nonatomic) IBOutlet UIButton *breathingButton;
@property (weak, nonatomic) IBOutlet UIButton *imageryButton;
@property (weak, nonatomic) IBOutlet UIButton *rsourcesButton;

- (IBAction)breathingTapped:(id)sender;
- (IBAction)guidedTapped:(id)sender;
- (IBAction)soundTapped:(id)sender;
- (IBAction)imageryTapped:(id)sender;
@end
