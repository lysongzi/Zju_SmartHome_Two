//
//  STNewSceneView.m
//  另存为新场景
//
//  Created by 123 on 16/1/6.
//  Copyright © 2016年 HST. All rights reserved.
//

#import "STNewSceneView.h"

@implementation STNewSceneView

+(instancetype)saveNewSceneView
{
    STNewSceneView *sceneView=[[[NSBundle mainBundle]loadNibNamed:@"STNewSceneView" owner:nil options:nil]lastObject];
    return sceneView;
}

- (IBAction)cancel:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cancelSaveScene)]) {
        [self.delegate cancelSaveScene];
    }
}

- (IBAction)noSave:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(noSave)]) {
        [self.delegate noSave];
    }
}

- (IBAction)save:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(saveNewScene:)]) {
        [self.delegate saveNewScene:self.sceneName.text];
    }
}
@end
