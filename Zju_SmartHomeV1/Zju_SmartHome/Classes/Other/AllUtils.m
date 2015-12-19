
//
//  AllUtils.m
//  Oncenote
//
//  Created by chenyufeng on 15/11/15.
//  Copyright © 2015年 chenyufengweb. All rights reserved.
//

#import "AllUtils.h"

@implementation AllUtils

#pragma mark - 弹出提示对话框
+ (UIAlertController*)showPromptDialog:(NSString*)title andMessage:(NSString*)message OKButton:(NSString*)OKButtonTitle OKButtonAction:(void (^)(UIAlertAction *action))OKButtonHandler cancelButton:(NSString*)cancelButtonTitle cancelButtonAction:(void (^)(UIAlertAction *action))cancelButtonHandler contextViewController:(UIViewController*)contextViewController{
  
  //尝试使用新的弹出对话框；
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
  [alertController addAction:[UIAlertAction actionWithTitle:OKButtonTitle style:UIAlertActionStyleDefault handler:OKButtonHandler]];
  
  if ([cancelButtonTitle isEqualToString:@""]) {
    //表示不需要“取消”按钮；
  }else{
  //需要“取消”按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleDefault handler:cancelButtonHandler]];
  }

  //弹出提示框；
  [contextViewController presentViewController:alertController animated:true completion:nil];
  
  return alertController;
}



#pragma mark - 界面跳转封装
//该方法的界面跳转不能传递数据；
+ (void)jumpToViewController:(NSString*)viewControllerIdentifier contextViewController:(UIViewController*)contextViewController handler:(void (^)(void))handler{

  UIViewController *viewController = [[UIViewController alloc] init];
  viewController = [contextViewController.storyboard instantiateViewControllerWithIdentifier:viewControllerIdentifier];
  [contextViewController presentViewController:viewController animated:true completion:handler];
  
  
}

@end











