//
//  CYFCollectionReusableView.h
//  Zju_SmartHome
//
//  Created by 123 on 15/11/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  CYFCollectionReusableViewDelegate<NSObject>

@required


@end

@interface CYFCollectionReusableView : UICollectionReusableView
//头部显示的view
@property(nonatomic,strong)UIImageView *view;
//头部文字
@property(nonatomic,strong)UILabel *title;
@end
