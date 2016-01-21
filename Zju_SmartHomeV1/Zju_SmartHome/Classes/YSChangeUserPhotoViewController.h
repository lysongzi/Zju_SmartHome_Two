//
//  YSChangeUserPhotoViewController.h
//  Zju_SmartHome
//
//  Created by lysongzi on 16/1/21.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSChangeUserPhotoViewController <NSObject>

@optional
- (void)changeUserPhoto:(UIImage *)image;

@end

@interface YSChangeUserPhotoViewController : UIViewController

@property (nonatomic,assign)UIImagePickerControllerSourceType openType;
@property (nonatomic,weak)id<YSChangeUserPhotoViewController> delegate;

@end
