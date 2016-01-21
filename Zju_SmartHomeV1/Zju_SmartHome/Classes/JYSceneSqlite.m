//
//  JYSceneSqlite.m
//  Zju_SmartHome
//
//  Created by 顾金跃 on 16/1/8.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import "JYSceneSqlite.h"
#import "sqlite3.h"
#import "YSScene.h"
#import "JYSceneOnly.h"


@interface JYSceneSqlite()
{
    //声明一个sqlite3的数据库
    sqlite3 *db;
}
@end

@implementation JYSceneSqlite
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
    NSString *sql=[NSString stringWithFormat:@"create TABLE if not EXISTS %@(area NSString,scene NSString,bkgName NSString,logic_id NSString, param1 NSString,param2 NSString,param3 NSString);",tableName];
    NSLog(@"看看创建场景表的sql语句:%@",sql);
    
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
                       andField7:(NSString *)field7 field7Value:(NSString *)field7Value
{
    NSString *sql=[NSString stringWithFormat:@"INSERT INTO '%@'('%@','%@','%@','%@','%@','%@','%@') VALUES('%@','%@','%@','%@','%@','%@','%@')",tableName,field1,field2,field3,field4,field5,field6,field7,field1Value,field2Value,field3Value,field4Value,field5Value,field6Value,field7Value];
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

//根据指定区域和指定场景,删除场景
-(void)deleteRecordWithArea:(NSString *)area andWithScene:(NSString *)sceneName inTable:(NSString *)tableName
{
    sqlite3_stmt *stmt;
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where area='%@' and scene = '%@'",tableName,area,sceneName];
    
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        sqlite3_step(stmt);
        //觉的应加一个判断, 若有这一行则删除
        if (sqlite3_step(stmt) == SQLITE_DONE)
        {
            NSLog(@"删除场景成功");
            sqlite3_finalize(stmt);
            
        }
    }
}

-(void)deleteRecordInArea:(NSString *)area andInScene:(NSString *)sceneName andInLogicID:(NSString *)logic_id inTable:(NSString *)tableName
{
    sqlite3_stmt *stmt;
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where area='%@' and scene = '%@' and logic_id='%@'",tableName,area,sceneName,logic_id];
    
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        sqlite3_step(stmt);
        //觉的应加一个判断, 若有这一行则删除
        if (sqlite3_step(stmt) == SQLITE_DONE)
        {
            NSLog(@"删除场景下某电器成功");
            sqlite3_finalize(stmt);
        }
    }

}

//根据指定区域,指定场景,修改场景背景图片
-(void)updateRecordBKGInArea:(NSString *)area andInScene:(NSString *)scene withNewBKG:(NSString *)newBKG inTable:(NSString *)tableName
{
    sqlite3_stmt *stmt = nil;
    NSString *sql = [NSString stringWithFormat:@"update %@ set bkgName = '%@' where area='%@' and scene = '%@'",tableName,newBKG,area,scene];
    
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(stmt) == SQLITE_ROW)
        {
            //觉的应加一个判断, 若有这一行则修改
            if (sqlite3_step(stmt) == SQLITE_DONE)
            {
                NSLog(@"修改场景背景图片成功");
                sqlite3_finalize(stmt);
            }
        }
        
    }
}

//根据指定区域,指定场景,修改场景名称
-(void)updateRecordInArea:(NSString *)area andInScene:(NSString *)oldScene withNewScene:(NSString *)newScene inTable:(NSString *)tableName
{
    sqlite3_stmt *stmt = nil;
    NSString *sql = [NSString stringWithFormat:@"update %@ set scene = '%@' where area='%@' and scene = '%@'",tableName,newScene,area,oldScene];
    
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(stmt) == SQLITE_ROW)
        {
            //觉的应加一个判断, 若有这一行则修改
            if (sqlite3_step(stmt) == SQLITE_DONE)
            {
                NSLog(@"修改场景名称成功");
                sqlite3_finalize(stmt);
            }
        }
        
    }
}

//根据指定区域,指定场景,指定逻辑id,修改电器的param
-(void)updateRecordParamInArea:(NSString *)area andInScene:(NSString *)scene andInLogicID:(NSString *)logic_id withNewP1:(NSString *)param1 withNewP2:(NSString *)param2 withNewP3:(NSString *)param3 inTable:(NSString *)tableName
{
    sqlite3_stmt *stmt = nil;
    NSString *sql = [NSString stringWithFormat:@"update %@ set param1 = '%@',param2='%@',param3='%@' where area='%@' and scene = '%@' and logic_id='%@'",tableName,param1,param2,param3,area,scene,logic_id];
    
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(stmt) == SQLITE_ROW)
        {
            //觉的应加一个判断, 若有这一行则修改
            if (sqlite3_step(stmt) == SQLITE_DONE)
            {
                NSLog(@"修改场景中电器的值成功");
                sqlite3_finalize(stmt);
            }
        }
    }
    
}

//获取指定区域的值
-(void)getAllRecordFromTable:(NSString *)tableName ByArea:(NSString *)area
{
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@ where area='%@'" ,tableName,area];
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            char *area1=(char *)sqlite3_column_text(statement, 0);
            NSString *area=[[NSString alloc]initWithUTF8String:area1];
            
            char *scene1=(char *)sqlite3_column_text(statement, 1);
            NSString *scene=[[NSString alloc]initWithUTF8String:scene1];
            
            char *bkgName1=(char *)sqlite3_column_text(statement, 2);
            NSString *bkgName=[[NSString alloc]initWithUTF8String:bkgName1];
            
            char *logic_id1 =(char *)sqlite3_column_text(statement, 3);
            NSString *logic_id=[[NSString alloc]initWithUTF8String:logic_id1];
            
            char *param11 =(char *)sqlite3_column_text(statement, 4);
            NSString *param1=[[NSString alloc]initWithUTF8String:param11];
            
            char *param22 =(char *)sqlite3_column_text(statement, 5);
            NSString *param2=[[NSString alloc]initWithUTF8String:param22];
            
            char *param33 =(char *)sqlite3_column_text(statement, 5);
            NSString *param3=[[NSString alloc]initWithUTF8String:param33];
            
            
            JYSceneOnly *jysceneOnly=[[JYSceneOnly alloc]init];
            jysceneOnly.area=area;
            jysceneOnly.name=scene;
            jysceneOnly.bkgName=bkgName;
            
            int i=0;
            for(i=0;i<self.scenesOnly.count;i++)
            {
                JYSceneOnly *jysceneOnly=self.scenesOnly[i];
                if ([jysceneOnly.name isEqualToString:scene])
                {
                    break;
                }
            }
            if(i>=self.scenesOnly.count)
            {
                [self.scenesOnly addObject:jysceneOnly];
                
            }
            
            YSScene *ysScene=[[YSScene alloc]init];
            ysScene.area=area;
            ysScene.name=scene;
            ysScene.bkgName=bkgName;
            ysScene.logic_id=logic_id;
            ysScene.param1=param1;
            ysScene.param2=param2;
            ysScene.param3=param3;
            
            [self.patterns addObject:ysScene];
        }
    }
    
}
@end
