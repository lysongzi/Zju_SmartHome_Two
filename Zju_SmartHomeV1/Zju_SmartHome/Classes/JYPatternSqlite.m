//
//  JYPatternSqlite.m
//  Zju_SmartHome
//
//  Created by 顾金跃 on 16/1/8.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import "JYPatternSqlite.h"
#import "sqlite3.h"
#import "JYPattern.h"

@interface JYPatternSqlite()
{
    //声明一个sqlite3的数据库
    sqlite3 *db;
}
@end
@implementation JYPatternSqlite
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


//根据表明创建表
-(void)createTable:(NSString *)tableName
{
    NSString *sql=[NSString stringWithFormat:@"create TABLE if not EXISTS %@(logic_id NSString,name NSString,bkgName NSString,param1 NSString,param2 NSString,param3 NSString);",tableName];
    
    char *errorMesg=NULL;
    int result=sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errorMesg);
    if(result==SQLITE_OK)
    {
        NSLog(@"创建模式表成功");
    }
    else
    {
        NSLog(@"创建模式表失败%s",errorMesg);
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
        NSLog(@"插入数据成功");
    }
    
}

//删除数据
-(void)deleteRecordWithLogicID:(NSString *)logic_ic andWithName:(NSString *)patternName inTable:(NSString *)tableName
{
    
    sqlite3_stmt *stmt;
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where logic_id='%@' and name = '%@'",tableName,logic_ic, patternName];
    
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        sqlite3_step(stmt);
        //觉的应加一个判断, 若有这一行则删除
        if (sqlite3_step(stmt) == SQLITE_DONE)
        {
            NSLog(@"删除数据成功");
            sqlite3_finalize(stmt);
            
        }
    }

}

//修改指定电器，指定模式的背景图
-(void)updateRecordByLogicID:(NSString *)logic_id andByName:(NSString *)patternName withNewBKG:(NSString *)bkgName inTable:(NSString *)tableName
{
    sqlite3_stmt *stmt = nil;
    NSString *sql = [NSString stringWithFormat:@"update %@ set bkgName = '%@' where logic_id='%@' and name = '%@'",tableName,bkgName,logic_id, patternName];
    
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(stmt) == SQLITE_ROW)
        {
            //觉的应加一个判断, 若有这一行则修改
            if (sqlite3_step(stmt) == SQLITE_DONE)
            {
                NSLog(@"修改成功");
                sqlite3_finalize(stmt);
            }
        }
    }

}

//获取指定逻辑id的所有数据
-(void)getAllRecordFromTable:(NSString *)tableName ByLogic_id:(NSString *)logic_id
{
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@ where logic_id='%@'" ,tableName,logic_id];
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            char *logicID=(char *)sqlite3_column_text(statement, 0);
            NSString *logic_id=[[NSString alloc]initWithUTF8String:logicID];
            
            char *patternName=(char *)sqlite3_column_text(statement, 1);
            NSString *name=[[NSString alloc]initWithUTF8String:patternName];
            
            char *backgroundName=(char *)sqlite3_column_text(statement, 2);
            NSString *bkgName=[[NSString alloc]initWithUTF8String:backgroundName];
            
            char *p1 =(char *)sqlite3_column_text(statement, 3);
            NSString *param1=[[NSString alloc]initWithUTF8String:p1];
            
            char *p2 =(char *)sqlite3_column_text(statement, 4);
            NSString *param2=[[NSString alloc]initWithUTF8String:p2];
            
            char *p3 =(char *)sqlite3_column_text(statement, 5);
            NSString *param3=[[NSString alloc]initWithUTF8String:p3];
            
            JYPattern *pattern=[[JYPattern alloc]init];
            pattern.logic_id=logic_id;
            pattern.name=name;
            pattern.bkgName=bkgName;
            pattern.param1=param1;
            pattern.param2=param2;
            pattern.param3=param3;
    
            [self.patterns addObject:pattern];
        }
    }

}

@end
