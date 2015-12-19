//
//  InternalGateIPXMLParser.h
//  Zju_SmartHome
//
//  Created by chenyufeng on 15/11/30.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InternalGateIPXMLParser : NSXMLParser<NSXMLParserDelegate>

//节点名；
@property(nonatomic,copy)NSString *nodeName;

@property(nonatomic,copy)NSString* internalIP;

@property(nonatomic,copy)NSString *result;

- (instancetype)initWithXMLString:(NSString*)string;

@end
