//
//  WebsiteSoundCell.m
//  TinnitusCoach
//
//  Created by Ashwani Hundwani on 14/06/2015.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "WebsiteSoundCell.h"
#import "WebsiteSoundInfo.h"

@interface WebsiteSoundCell(){
    @private
    id<WebsiteSoundCellDelegate> webDelegate_;
}

@end

@implementation WebsiteSoundCell

- (void)awakeFromNib {
    // Initialization code
    
    self.tagField.userInteractionEnabled = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setSoundInfo:(WebsiteSoundInfo *)soundInfo
{
    self.titleLabel.text = soundInfo.title;
    self.tagField.text = soundInfo.userTag;
    self.descriptionLabel.text = soundInfo.descriptionStr;
}

-(void)setWebDelegate:(id<WebsiteSoundCellDelegate>)webDelegate
{
    [super setDelegate:webDelegate];
    self->webDelegate_ = webDelegate;
    
}

-(id<WebsiteSoundCellDelegate>)webDelegate
{
    return self->webDelegate_;
}



@end
