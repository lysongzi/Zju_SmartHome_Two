//
//  JYUpdateFurnitureName.h
//  Zju_SmartHome
//
//  Created by 顾金跃 on 15/12/6.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYUpdateFurnitureNameDelegate <NSObject>

@optional
-(void)updateGoGoGo:(NSString *)furnitureName;
-(void)cancelUpdate;
@end

@interface JYUpdateFurnitureName : UIView
//更改的电器名称
@property (weak, nonatomic) IBOutlet UITextField *furnitureName;
@property (weak, nonatomic) IBOutlet UIButton *okUPdate;
+(instancetype)updateFurnitureNameView;
@property(nonatomic,weak)id<JYUpdateFurnitureNameDelegate>delegate;
@end
