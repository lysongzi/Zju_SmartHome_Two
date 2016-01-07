//
//  JYNewSqlite.m
//  Zju_SmartHome
//
//  Created by 顾金跃 on 16/1/2.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import "JYNewSqlite.h"
#import "sqlite3.h"
#import "YSNewPattern.h"
@interface JYNewSqlite()
{
    //声明一个sqlite3的数据库
    sqlite3 *db;
}
@end
@implementation JYNewSqlite
//返回数据库在文件夹中的全路径信息
-(NSString *)filePath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir=[paths objectAtIndex:0];
    return [documentDir stringByAppendingPathComponent:@"/patternTest.sqlite"];
}

//打开数据库的方法
-(void)openDB
{
    if(sqlite3_open([[self filePath]UTF8String], &db)!=SQLITE_OK)
    {
        sqlite3_close(db);
    }
}

//创建表
-(void)createTable
{
    //模式名称，模式描述，模式图片
    NSString *sql=@"create TABLE if not EXISTS patternTable(name NSString,logoName NSString,bkgName NSString,rValue NSString,gValue NSString,bValue NSString);";
    char *errorMesg=NULL;
    int result=sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errorMesg);
    if(result==SQLITE_OK)
    {
        //NSLog(@"创建模式表成功");
    }
    else
    {
        //NSLog(@"创建模式表失败%s",errorMesg);
    }
}
//根据不同电器创建不同表
-(void)createTable:(NSString *)tableName
{
    NSString *sql=[NSString stringWithFormat:@"create TABLE if not EXISTS %@(name NSString,logoName NSString,bkgName NSString,rValue NSString,gValue NSString,bValue NSString);",tableName];

    char *errorMesg=NULL;
    int result=sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errorMesg);
    if(result==SQLITE_OK)
    {
        //NSLog(@"创建模式表成功");
    }
    else
    {
        //NSLog(@"创建模式表失败%s",errorMesg);
    }
}
//插入数据的方法
-(void)insertRecordIntoTableName:(NSString *)tableName
                      withField1:(NSString *)field1 field1Value:(NSString *)field1Value
                       andField2:(NSString *)field2 field2Value:(NSString *)field2Value
                       andField3:(NSString *)field3 field3Value:(NSString *)field3Value
                       andField4:(NSString *)field4 field4Value:(NSString *)field4Value
                       andField5:(NSString *)field5 field5Value:(NSString *)field5Value
                       andField6:(NSString *)field6 field6Value:(NSString *)field6Value
{
    NSString *sql=[NSString stringWithFormat:@"INSERT INTO '%@'('%@','%@','%@','%@','%@','%@') VALUES('%@','%@','%@','%@','%@','%@')",tableName,field1,field2,field3,field4,field5,field6,field1Value,field2Value,field3Value,field4Value,field5Value,field6Value];
    char *err;
    if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err)!=SQLITE_OK)
    {
        sqlite3_close(db);
        NSAssert(0,@"插入数据错误！");
    }
    else
    {
        //NSLog(@"插入数据成功");
    }
    
}

//删除数据
-(void)deleteRecordWithName:(NSString *)patternName inTable:(NSString *)tableName
{
    sqlite3_stmt *stmt;
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where name = '%@'",tableName, patternName];
    
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        sqlite3_step(stmt);
        //觉的应加一个判断, 若有这一行则删除
        if (sqlite3_step(stmt) == SQLITE_DONE)
        {
            sqlite3_finalize(stmt);
            
        }
    }
}

-(void)updateRecordByRGB:(NSString *)patternName rValue:(NSString *)rValue gValue:(NSString *)gValue bValue:(NSString *)bValue inTable:(NSString *)tableName
{
    sqlite3_stmt *stmt = nil;
    NSString *sql = [NSString stringWithFormat:@"update %@ set rValue = '%@',gValue='%@',bValue='%@'  where name = '%@'",tableName, rValue,gValue,bValue,patternName];
    
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(stmt) == SQLITE_ROW)
        {
            //觉的应加一个判断, 若有这一行则修改
            if (sqlite3_step(stmt) == SQLITE_DONE)
            {
                sqlite3_finalize(stmt);
            }
        }
    }
}
//更新背景图片
-(void)updateRecordBKGImage:(NSString *)pattern andNewBKGImage:(NSString *)bkgName inTable:(NSString *)tableName
{
    sqlite3_stmt *stmt = nil;
      NSString *sql = [NSString stringWithFormat:@"update %@ set bkgName = '%@' where name = '%@'",tableName,bkgName,pattern];
    
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(stmt) == SQLITE_ROW)
        {
            //觉的应加一个判断, 若有这一行则修改
            if (sqlite3_step(stmt) == SQLITE_DONE)
            {
                sqlite3_finalize(stmt);
            }
        }
    }
}

//从表中查询所有数据
-(void)getAllRecordFromTable:(NSString *)tableName
{
     NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@",tableName];
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            char *name=(char *)sqlite3_column_text(statement, 0);
            NSString *patternName=[[NSString alloc]initWithUTF8String:name];
            
            char *logoName=(char *)sqlite3_column_text(statement, 1);
            NSString *logoName1=[[NSString alloc]initWithUTF8String:logoName];
            
            char *bkgName=(char *)sqlite3_column_text(statement, 2);
            NSString *bkgName1=[[NSString alloc]initWithUTF8String:bkgName];
            
            char *r =(char *)sqlite3_column_text(statement, 3);
            NSString *rValue=[[NSString alloc]initWithUTF8String:r];
            
            char *g =(char *)sqlite3_column_text(statement, 4);
            NSString *gValue=[[NSString alloc]initWithUTF8String:g];
            
            char *b =(char *)sqlite3_column_text(statement, 5);
            NSString *bValue=[[NSString alloc]initWithUTF8String:b];
            
            
            YSNewPattern *newPattern=[[YSNewPattern alloc]init];
            newPattern.name=patternName;
            newPattern.logoName=logoName1;
            newPattern.bkgName=bkgName1;
            newPattern.rValue=rValue;
            newPattern.gValue=gValue;
            newPattern.bValue=bValue;
            [self.patterns addObject:newPattern];
        }
    }
}


@end