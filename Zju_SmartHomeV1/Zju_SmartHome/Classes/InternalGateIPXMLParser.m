

//
//  InternalGateIPXMLParser.m
//  Zju_SmartHome
//
//  Created by chenyufeng on 15/11/30.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "InternalGateIPXMLParser.h"
#import "AppDelegate.h"

@implementation InternalGateIPXMLParser

- (instancetype)initWithXMLString:(NSString*)string {
  
  //需要删除前后的空格；
  NSString *str = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
  NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:true];
  InternalGateIPXMLParser *parser = [[InternalGateIPXMLParser alloc] initWithData:data];
  parser.delegate = self;
  [parser parse];
  
  return self;
}


//第一个代理方法：
- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
  
  self.nodeName = elementName;
  
}

//第二个代理方法：
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
  
  NSString *str = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if (![str  isEqual: @""]) {
    
    if ([self.nodeName isEqualToString:@"message"]) {
      //获取内网IP；
      self.internalIP = str;
      //并将这个内网IP放到全局变量中
//      NSLog(@"目前的内网IP是：%@",str);
    }
    
  
  }
  
}

@end
