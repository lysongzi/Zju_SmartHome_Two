//
//  JYPatternSqlite.h
//  Zju_SmartHome
//
//  Created by 顾金跃 on 16/1/8.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYPatternSqlite : NSObject
@property(nonatomic,strong)NSMutableArray *patterns;

//逻辑id
@property(nonatomic,copy)NSString *logic_id;

-(NSString *)filePath;
-(void)openDB;

//创建表
-(void)createTable:(NSString *)tableName;

//根据逻辑id，从指定表中获取数据
-(void)getAllRecordFromTable:(NSString *)tableName ByLogic_id:(NSString *)logic_id;

//插入数据的方法
-(void)insertRecordIntoTableName:(NSString *)tableName
                      withField1:(NSString *)field1 field1Value:(NSString *)field1Value
                       andField2:(NSString *)field2 field2Value:(NSString *)field2Value
                       andField3:(NSString *)field3 field3Value:(NSString *)field3Value
                       andField4:(NSString *)field4 field4Value:(NSString *)field4Value
                       andField5:(NSString *)field5 field5Value:(NSString *)field5Value
                       andField6:(NSString *)field6 field6Value:(NSString *)field6Value;

//删除表中指定逻辑id指定模式的数据
-(void)deleteRecordWithLogicID:(NSString *)logic_ic andWithName:(NSString *)patternName inTable:(NSString *)tableName;


//根据指定逻辑id，指定模式名称来修改该模式的背景图片
-(void)updateRecordByLogicID:(NSString *)logic_id andByName:(NSString *)patternName withNewBKG:(NSString *)bkgName inTable:(NSString *)tableName;


@end
