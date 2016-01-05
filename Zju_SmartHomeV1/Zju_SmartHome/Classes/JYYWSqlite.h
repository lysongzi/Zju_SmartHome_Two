//
//  JYYWSqlite.h
//  Zju_SmartHome
//
//  Created by 顾金跃 on 16/1/3.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYYWSqlite : NSObject
@property(nonatomic,strong)NSMutableArray *patterns;
-(NSString *)filePath;
-(void)openDB;
//创建表
-(void)createTable;
//根据表名创建表
-(void)createTable:(NSString *)tableName;

-(void)getAllRecord;
//根据表名获取全部数据
-(void)getAllRecord:(NSString *)tableName;

//插入数据的方法
-(void)insertRecordIntoTableName:(NSString *)tableName
                      withField1:(NSString *)field1 field1Value:(NSString *)field1Value
                       andField2:(NSString *)field2 field2Value:(NSString *)field2Value
                       andField3:(NSString *)field3 field3Value:(NSString *)field3Value
                       andField4:(NSString *)field4 field4Value:(NSString *)field4Value
                       andField5:(NSString *)field5 field5Value:(NSString *)field5Value;

-(void)deleteRecordWithName:(NSString *)patternName;
//在指定表删除模式
-(void)deleteRecordWithName:(NSString *)patternName inTable:(NSString *)tableName;

//更新y
-(void)updateRecordByY:(NSString *)patternName rValue:(NSString *)rValue;
//在指定表更新Y
-(void)updateRecordByY:(NSString *)patternName rValue:(NSString *)rValue inTable:(NSString *)tableName;
//更新W
-(void)updateRecordByW:(NSString *)patternName rValue:(NSString *)gValue;
//在指定表更新w
-(void)updateRecordByW:(NSString *)patternName rValue:(NSString *)gValue inTable:(NSString *)tableName;
@end
