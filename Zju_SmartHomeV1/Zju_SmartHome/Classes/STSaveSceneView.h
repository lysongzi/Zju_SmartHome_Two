//
//  STSaveSceneView.h
//  STSaveScene
//
//  Created by 顾金跃 on 15/12/22.
//  Copyright © 2015年 顾金跃. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STSaveSceneViewDelegate <NSObject>

@optional
-(void)saveNewScene:(NSString *)newSceneName;
-(void)noSaveScene;
-(void)cancelSaveScene;
@end

@interface STSaveSceneView : UIView

@property (weak, nonatomic) IBOutlet UITextField *sceneName;

+(instancetype)initWithSaveScene;
@property(nonatomic,weak)id<STSaveSceneViewDelegate> delegate;
@end
