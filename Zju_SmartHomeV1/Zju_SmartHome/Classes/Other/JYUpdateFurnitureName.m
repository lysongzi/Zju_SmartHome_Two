//
//  JYUpdateFurnitureName.m
//  Zju_SmartHome
//
//  Created by 顾金跃 on 15/12/6.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "JYUpdateFurnitureName.h"

@interface JYUpdateFurnitureName()



- (IBAction)okUpdate:(id)sender;

- (IBAction)cancel:(id)sender;

@end
@implementation JYUpdateFurnitureName

+(instancetype)updateFurnitureNameView
{
    JYUpdateFurnitureName *updateFurnitureNameView=[[[NSBundle mainBundle]loadNibNamed:@"JYUpdateFurnitureName" owner:nil options:nil]lastObject];
    return updateFurnitureNameView;
}

- (IBAction)okUpdate:(id)sender
{
    if([self.delegate respondsToSelector:@selector(updateGoGoGo:)])
    {
        [self.delegate updateGoGoGo:self.furnitureName.text];
    }
}

- (IBAction)cancel:(id)sender
{
    if([self.delegate respondsToSelector:@selector(cancelUpdate)])
    {
        [self.delegate cancelUpdate];
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.furnitureName resignFirstResponder];
    [self.okUPdate resignFirstResponder];
}
@end
