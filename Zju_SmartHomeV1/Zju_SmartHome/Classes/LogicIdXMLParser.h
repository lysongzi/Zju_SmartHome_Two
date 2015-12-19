//
//  LogicIdXMLParser.h
//  Zju_SmartHome
//
//  Created by chenyufeng on 15/11/29.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogicIdXMLParser : NSXMLParser<NSXMLParserDelegate>

@property(nonatomic,copy)NSString *nodeName;


//设备的逻辑ID；
@property(nonatomic,copy)NSString *logicId;
//设备的类型；如40是RGB等；
@property(nonatomic,copy)NSString *deviceType;
@property(nonatomic,copy)NSString *result;


- (instancetype)initWithXMLString:(NSString*)string;
@end
