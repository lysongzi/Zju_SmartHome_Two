//
//  YSPatternViewCell.h
//  Zju_SmartHome
//
//  Created by lysongzi on 15/12/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YSPatternViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *patternName;
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UIImageView *checkPic;
@property (weak, nonatomic) IBOutlet UIButton *changeRgbGo;


@end
