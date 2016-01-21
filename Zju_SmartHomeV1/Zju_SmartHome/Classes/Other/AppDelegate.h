//
//  AppDelegate.h
//  Zju_SmartHome
//
//  Created by 123 on 15/10/31.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#define DeviceWidth ([UIScreen mainScreen].bounds.size.width)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//全局变量；判断是否是内网IP；
@property(nonatomic,assign)BOOL isInternalNetworkGate;

//内网IP地址前缀；
@property(nonatomic,copy)NSString *globalInternalIP;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

//用户名
@property(nonatomic,copy)NSString *username;
//用户email
@property(nonatomic,copy)NSString *email;
//用户id
@property(nonatomic,copy)NSString *user_id;
//用户头像
@property(nonatomic,copy)NSString *avator;

@end

