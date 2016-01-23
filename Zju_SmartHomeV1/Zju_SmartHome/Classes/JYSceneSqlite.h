//
//  JYSceneSqlite.h
//  Zju_SmartHome
//
//  Created by 顾金跃 on 16/1/8.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYSceneSqlite : NSObject
//存放场景数组(包括电器参数值)
@property(nonatomic,strong)NSMutableArray *patterns;
//单纯存放场谨防数组
@property(nonatomic,strong)NSMutableArray *scenesOnly;

//区域
@property(nonatomic,copy)NSString *area;
//场景名称
@property(nonatomic,copy)NSString *sceneName;
//逻辑id
@property(nonatomic,copy)NSString *logic_id;

-(NSString *)filePath;
-(void)openDB;

//创建表(sceneTable)
-(void)createTable:(NSString *)tableName;

//根据区域，获取该区域下的所有数据
-(void)getAllRecordFromTable:(NSString *)tableName ByArea:(NSString *)area;


//插入数据的方法
-(void)insertRecordIntoTableName:(NSString *)tableName
                      withField1:(NSString *)field1 field1Value:(NSString *)field1Value
                       andField2:(NSString *)field2 field2Value:(NSString *)field2Value
                       andField3:(NSString *)field3 field3Value:(NSString *)field3Value
                       andField4:(NSString *)field4 field4Value:(NSString *)field4Value
                       andField5:(NSString *)field5 field5Value:(NSString *)field5Value
                       andField6:(NSString *)field6 field6Value:(NSString *)field6Value
                       andField7:(NSString *)field7 field7Value:(NSString *)field7Value
                       andField8:(NSString *)field8 field8Value:(NSString *)field8Value;

//根据区域和场景名称来删除场景
-(void)deleteRecordWithArea:(NSString *)area andWithScene:(NSString *)sceneName inTable:(NSString *)tableName;

//根据指定区域,指定场景,指定逻辑id，删除电器
-(void)deleteRecordInArea:(NSString *)area andInScene:(NSString *)sceneName andInLogicID:(NSString *)logic_id inTable:(NSString *)tableName;

//根据区域和场景名称,修改场景名称
-(void)updateRecordInArea:(NSString *)area andInScene:(NSString *)oldScene withNewScene:(NSString *)newScene inTable:(NSString *)tableName;

//根据区域和场景名称,修改场景背景图片
-(void)updateRecordBKGInArea:(NSString *)area andInScene:(NSString *)scene withNewBKG:(NSString *)newBKG inTable:(NSString *)tableName;

//根据区域和场景名称和电器逻辑id,修改电器的值
-(void)updateRecordParamInArea:(NSString *)area andInScene:(NSString *)scene andInLogicID:(NSString *)logic_id withNewP1:(NSString *)param1 withNewP2:(NSString *)param2 withNewP3:(NSString *)param3 inTable:(NSString *)tableName;
@end
