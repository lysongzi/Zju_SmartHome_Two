//
//  JYSqliteViewController.m
//  Zju_SmartHome
//
//  Created by 顾金跃 on 15/12/23.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "JYSqliteViewController.h"
#import "sqlite3.h"
#import "YSPattern.h"

@interface JYSqliteViewController ()
{
    //声明一个sqlite3的数据库
    sqlite3 *db;
}

//数据库文件路径，一般在沙盒的documents里面操作
-(NSString *)filePath;

@end

@implementation JYSqliteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.打开数据库
    [self openDB];
    
    //2.创建表
    [self createTable];
    
    //3.插入测试数据
    [self insertRecordIntoTableName:@"patternTable" withField1:@"name" field1Value:@"温暖模式" andField2:@"desc" field2Value:@"bright" andField3:@"img" field3Value:@"picture"];
    
    //4.查询数据
    [self getAllStudents];
    
    //5.删除数据
    [self deleteRecordWithName:@"温暖模式"];
    
    NSLog(@"**************************");
     [self getAllStudents];

}

//返回数据库在文件夹中的全路径信息
-(NSString *)filePath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir=[paths objectAtIndex:0];
    NSLog(@"我看看路径%@",documentDir);
    return [documentDir stringByAppendingPathComponent:@"/patternTest.sqlite"];
}

//打开数据库的方法
-(void)openDB
{
    if(sqlite3_open([[self filePath]UTF8String], &db)!=SQLITE_OK)
    {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    NSLog(@"数据库打开成功");
}

//创建表
-(void)createTable
{
    //模式名称，模式描述，模式图片
    NSString *sql=@"create TABLE if not EXISTS patternTable(name NSString,desc NSString,img NSString);";
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
{
    NSString *sql=[NSString stringWithFormat:@"INSERT INTO '%@'('%@','%@','%@') VALUES('%@','%@','%@')",tableName,field1,field2,field3,field1Value,field2Value,field3Value];
    char *err;
    if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err)!=SQLITE_OK)
    {
        sqlite3_close(db);
        NSAssert(0,@"插入数据错误！");
    }
    NSLog(@"插入%@信息成功",field1Value);  
}
//删除数据
-(void)deleteRecordWithName:(NSString *)patternName
{
    NSLog(@"进来了吗");
    sqlite3_stmt *stmt;
    //NSString *sql = [NSString stringWithFormat:@"delete from patternTable where name = %@", patternName];
    NSString *sql=@"DELETE * FROM patternTable";
    NSLog(@"看看删除语句：%@",sql);
    
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        NSLog(@"111");
                   //觉的应加一个判断, 若有这一行则删除
            if (sqlite3_step(stmt) == SQLITE_DONE)
            {
                sqlite3_finalize(stmt);
                
            }
    }
}

//查询数据
-(void)getAllStudents
{
    NSLog(@"***************查询所有数据********************");
    NSString *sql=@"SELECT * FROM patternTable";
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            char *name=(char *)sqlite3_column_text(statement, 0);
            NSString *patternName=[[NSString alloc]initWithUTF8String:name];
            
            char *desc=(char *)sqlite3_column_text(statement, 1);
            NSString *descLabel=[[NSString alloc]initWithUTF8String:desc];
            
            char *img=(char *)sqlite3_column_text(statement, 2);
            NSString *imgKey=[[NSString alloc]initWithUTF8String:img];
            
            

            YSPattern *pattern=[[YSPattern alloc]initWithPatternName:patternName desc:descLabel picture:imgKey];
            
            NSString *info=[[NSString alloc]initWithFormat:@"%@-%@-%@",pattern.patternName,pattern.descLabel,pattern.imgKey];
            NSLog(@"====%@",info);
            
        }
    }
}


@end
