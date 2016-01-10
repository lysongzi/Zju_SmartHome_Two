//
//  STSliderCell.m
//  sliderDemo
//
//  Created by 123 on 16/1/1.
//  Copyright © 2016年 HST. All rights reserved.
//

#import "STUserInfoCell.h"


@implementation STUserInfoCell


+(instancetype)initWithUserInfoCell
{
    STUserInfoCell *userInfoCell=[[[NSBundle mainBundle]loadNibNamed:@"STUserInfoCell" owner:nil options:nil]lastObject];
    userInfoCell.descBtn.userInteractionEnabled=NO;
//    userInfoCell.cellView.layer.cornerRadius=16;
//    userInfoCell.cellView.layer.masksToBounds=YES;
    
    return userInfoCell;
}
- (void)awakeFromNib {
    // Initialization code
}

-(void)setHighlighted:(BOOL)highlighted
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
