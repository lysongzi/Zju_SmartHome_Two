//
//  CYFCollectionReusableView.h
//  Zju_SmartHome
//
//  Created by 123 on 15/11/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYFCollectionReusableView : UICollectionReusableView
//头部显示的view
@property(nonatomic,strong)UIView *view;
//头部文字
@property(nonatomic,strong)UILabel *title;

@property(nonatomic,strong)UIView *topView;
@end
