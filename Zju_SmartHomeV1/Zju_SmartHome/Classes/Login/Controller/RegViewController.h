//
//  RegViewController.h
//  SMS_SDKDemo
//
//  Created by TooWalker on 15/11/21.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionsViewController.h"

@protocol SecondViewControllerDelegate;

@interface RegViewController : UIViewController
<
UIAlertViewDelegate,
UITableViewDataSource,
UITableViewDelegate,
SecondViewControllerDelegate,
UITextFieldDelegate
>

@property(nonatomic,strong) UITableView* tableView;
@property(nonatomic,strong) UITextField* areaCodeField;
@property(nonatomic,strong) UITextField* telField;
@property(nonatomic,strong) UIWindow* window;
@property(nonatomic,strong) UIButton* next;

-(void)nextStep;

@end
