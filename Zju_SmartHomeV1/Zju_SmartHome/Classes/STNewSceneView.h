//
//  STNewSceneView.h
//  另存为新场景
//
//  Created by 123 on 16/1/6.
//  Copyright © 2016年 HST. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STSaveNewSceneDelegate <NSObject>
@optional

-(void)cancelSaveScene;
-(void)noSave;
-(void)saveNewScene:(NSString *)sceneName;

@end

@interface STNewSceneView : UIView
- (IBAction)cancel:(id)sender;
- (IBAction)noSave:(id)sender;
- (IBAction)save:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *sceneName;

+(instancetype)saveNewSceneView;

@property(nonatomic,weak)id<STSaveNewSceneDelegate> delegate;
@end
