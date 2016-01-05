//
//  JYNewSqlite.h
//  Zju_SmartHome
//
//  Created by 顾金跃 on 16/1/2.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYNewSqlite : NSObject
@property(nonatomic,strong)NSMutableArray *patterns;
//电器名称
@property(nonatomic,copy)NSString *furnitureName;
//逻辑id
@property(nonatomic,copy)NSString *logic_id;

-(NSString *)filePath;
-(void)openDB;
//创建表
-(void)createTable:(NSString *)tableName;

//从表中查询所有数据
-(void)getAllRecordFromTable:(NSString *)tableName;

//插入数据的方法
-(void)insertRecordIntoTableName:(NSString *)tableName
                      withField1:(NSString *)field1 field1Value:(NSString *)field1Value
                       andField2:(NSString *)field2 field2Value:(NSString *)field2Value
                       andField3:(NSString *)field3 field3Value:(NSString *)field3Value
                       andField4:(NSString *)field4 field4Value:(NSString *)field4Value
                       andField5:(NSString *)field5 field5Value:(NSString *)field5Value
                       andField6:(NSString *)field6 field6Value:(NSString *)field6Value;

//删除指定表指定模式数据
-(void)deleteRecordWithName:(NSString *)patternName inTable:(NSString *)tableName;

//更新rgb
-(void)updateRecordByRGB:(NSString *)patternName rValue:(NSString *)rValue gValue:(NSString *)gValue bValue:(NSString *)bValue inTable:(NSString *)tableName;

//更新背景图片
-(void)updateRecordBKGImage:(NSString *)pattern andNewBKGImage:(NSString *)bkgName inTable:(NSString *)tableName;

////更新模式名称,模式描述,背景图标识
//-(void)updateRecordByOldPatternName:(NSString *)oldPatternName andNewPatternName:(NSString *)newPatternName andLogoName:(NSString *)logoName andBkgName:(NSString *)BkgName;

@end
