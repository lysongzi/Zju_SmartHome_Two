//
//  STLeftSliderView.h
//  sliderDemo
//
//  Created by 123 on 16/1/1.
//  Copyright © 2016年 HST. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STEditSceneViewDelegate <NSObject>

@optional
-(void)goBack;

@end
@interface STEditSceneView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *sceneIcon;
//场景名称
@property (weak, nonatomic) IBOutlet UITextField *sceneName;

@property (weak, nonatomic) IBOutlet UITableView *devicesTableView;

+(instancetype)initWithEditSceneView;

@property(nonatomic,weak)id<STEditSceneViewDelegate> delegate;

@end
