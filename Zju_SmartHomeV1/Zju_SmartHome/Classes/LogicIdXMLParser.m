
//
//  LogicIdXMLParser.m
//  Zju_SmartHome
//
//  Created by chenyufeng on 15/11/29.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "LogicIdXMLParser.h"

@implementation LogicIdXMLParser


- (instancetype)initWithXMLString:(NSString*)string {
  
  NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:true];
  LogicIdXMLParser *parser = [[LogicIdXMLParser alloc] initWithData:data];
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
    
    if ([self.nodeName isEqualToString:@"logic_id"]) {
      
      
      self.logicId = str;
    }else if ([self.nodeName isEqualToString:@"type"]){
      self.deviceType = str;
    }
      else if([self.nodeName isEqualToString:@"message"])
      {
          self.result=str;
          
          NSLog(@",,,,,,,%@",str);
      }
          
  }
  
}

@end
