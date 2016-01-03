//
//  CYFCollectionViewCell.h
//  Zju_SmartHome
//
//  Created by 123 on 15/11/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYFCollectionViewCell : UICollectionViewCell



//每一个cell就是一个UIView,一个cell里面包含了一个图片和文本；
//@property(nonatomic,strong)UIView *cellView;

@property (strong, nonatomic) UIImageView *imageButton;
@property (strong, nonatomic) UILabel *descLabel;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIImageView *lightImage;

@end
