//
//  XMLParser.h
//  Parsing XML Demo, SAX Style
//
//  Created by kaifeng@github
//  Copyright (c) 2015 kaifeng. All rights reserved.

#import <Foundation/Foundation.h>

#define KEY_NODE_NAME   @"elementName"
#define KEY_NODE_ATTR   @"attributeDict"
#define KEY_NODE_VALUE  @"value"

/*!
 SAXParser use NSDictionary and NSArray for parsing result storage, each node is represented by NSDictionary, and NSArray for child nodes.
 
 Use KEY_NODE_NAME for node name, KEY_NODE_ATTR for node attributes and KEY_NODE_VALUE for node value, you can change the three key name in occasion of duplicate with child node name. Child node name act as a key in parent node dictionary.
 */
@interface SAXParser : NSObject <NSXMLParserDelegate>
-(id)initWithData:(NSData*)data;
-(NSDictionary*)parse;
@end
