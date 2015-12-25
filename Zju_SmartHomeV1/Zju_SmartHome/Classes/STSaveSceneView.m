//
//  STSaveSceneView.m
//  STSaveScene
//
//  Created by 顾金跃 on 15/12/22.
//  Copyright © 2015年 顾金跃. All rights reserved.
//

#import "STSaveSceneView.h"

@interface STSaveSceneView()
@property (weak, nonatomic) IBOutlet UIView *middleView;

- (IBAction)noSave:(id)sender;
- (IBAction)saveScene:(id)sender;
- (IBAction)cancel:(id)sender;

@end
@implementation STSaveSceneView

+(instancetype)initWithSaveScene
{
    STSaveSceneView *sceneView=[[[NSBundle mainBundle]loadNibNamed:@"STSaveSceneView" owner:nil options:nil]lastObject];
    sceneView.middleView.layer.cornerRadius=3;
    sceneView.middleView.layer.masksToBounds=YES;
    return sceneView;
}

- (IBAction)noSave:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(noSaveScene)])
    {
        [self.delegate noSaveScene];
    }
}

- (IBAction)saveScene:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(saveNewScene:)])
    {
        [self.delegate saveNewScene:self.sceneName.text];
    }
}

- (IBAction)cancel:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cancelSaveScene)])
    {
        [self.delegate cancelSaveScene];
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.sceneName resignFirstResponder];
}
@end
