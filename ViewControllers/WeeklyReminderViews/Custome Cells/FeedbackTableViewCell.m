//
//  FeedbackTableViewCell.m
//  TinnitusCoach
//
 //  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "FeedbackTableViewCell.h"

#define DOT_VIEW_TAG 121132

@interface FeedbackTableViewCell()

@property(nonatomic, weak)UIButton *selectedButton;

@end

@implementation FeedbackTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.feedbackTableView.delegate =self;
    self.feedbackTableView.dataSource = self;
    [self.feedbackTableView registerNib:[UINib nibWithNibName:@"FeedbackDeviceTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FeedbackDeviceCellIdentifier"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)reInitialize{
    self.feedbackTableView.hidden = YES;
    self.secondaryView.hidden = YES;
    self.itemSelectorBtn.hidden = YES;
    self.itemSelctorBtnImage.hidden = YES;
    self.selectedButton.backgroundColor = [UIColor whiteColor];
    [[self.selectedButton viewWithTag:DOT_VIEW_TAG] removeFromSuperview];
    self.selectedButton = nil;

}

-(void)fillbutton:(id)button{
    UIButton *btn = (UIButton *)button;
    if(btn != self.selectedButton){
        btn.backgroundColor = [Utils colorWithHexValue:BUTTON_BLUE_COLOR_HEX_VALUE];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(6, 6, btn.width - 12, btn.height - 12)];
        
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = (btn.width - 12) / 2;
        view.layer.masksToBounds = YES;
        view.tag = DOT_VIEW_TAG;
        [btn addSubview:view];
        self.selectedButton.backgroundColor = [UIColor whiteColor];
        [[self.selectedButton viewWithTag:DOT_VIEW_TAG] removeFromSuperview];
        self.selectedButton = btn;
    }
}


-(IBAction)feedbackBtnPressed:(id)sender{
    
    NSLog(@"Feedback btn pressed having tag: %ld", ((UIButton*)sender).tag);
    [self.delegate itemClickedForRating:((UIButton*)sender).tag inCell:self];
}

-(IBAction)itemSelected:(id)sender{
    
    [self.delegate groupItemSelected:self];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.delegate feeedbackTableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self.delegate feeedbackTableView:tableView viewForHeaderInSection:section];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.delegate feedbackTableView:tableView titleForHeaderInSection:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.delegate feeedbackTableView:tableView numberOfRowsInSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.delegate numberOfSectionsInFeeedbackTableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedbackDeviceTableViewCell* cell = (FeedbackDeviceTableViewCell*)[self.delegate feeedbackTableView:tableView cellForRowAtIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}


#pragma mark - FeedBackDeviceTableViewCellDelegate

-(void) ratingRecieved:(NSInteger)rating inCell:(id)cell{
    // get the index path of the cell
    // and pass the same to controller
    NSIndexPath* indexPath = [self.feedbackTableView indexPathForCell:cell];
    [self.delegate deviceItemClickedForRating:rating :indexPath inCell:self];
}

-(void)onToggleSelectionInCell:(id)cell{
    NSIndexPath* indexPath = [self.feedbackTableView indexPathForCell:cell];
    [self.delegate deviceItemSelected:indexPath inCell:self];
}




@end
