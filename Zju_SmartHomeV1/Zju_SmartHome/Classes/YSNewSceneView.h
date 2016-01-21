//
//  STLeftSliderView.h
//  sliderDemo
//
//  Created by 123 on 16/1/1.
//  Copyright © 2016年 HST. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol YSNewSceneViewDelegate <NSObject>
//
//@optional
//-(void)getNewSceneName:(NSString *)xinSceneName;
//
//@end

@interface YSNewSceneView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *sceneIcon;

@property (weak, nonatomic) IBOutlet UITableView *devicesTableView;

@property (weak, nonatomic) IBOutlet UITextField *xinSceneName;

+(instancetype)initWithNewSceneView;

//@property(nonatomic,weak)id<YSNewSceneViewDelegate> delegate;

@end
