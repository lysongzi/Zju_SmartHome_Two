//
//  CYFImageStore.h
//  Zju_SmartHome
//
//  Created by chenyufeng on 15/12/6.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CYFImageStore : NSObject

+(instancetype)sharedStore;

-(void)setImage:(UIImage *)image forKey:(NSString *)key;
-(UIImage *)imageForKey:(NSString *)key;

@end
