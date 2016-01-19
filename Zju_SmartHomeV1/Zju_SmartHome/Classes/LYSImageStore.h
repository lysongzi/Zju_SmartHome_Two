//
//  LYSImageStore.h
//  Homepwen
//
//  Created by lysongzi on 15/11/25.
//  Copyright © 2015年 lysongzi. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface LYSImageStore : NSObject

+(instancetype)sharedStore;

-(void)setImage:(UIImage *)image forKey:(NSString *)key;
-(UIImage *)imageForKey:(NSString *)key;
-(void)deleteImageForKey:(NSString *)key;
-(NSString *)imagePathForKey:(NSString *)key;

@end
