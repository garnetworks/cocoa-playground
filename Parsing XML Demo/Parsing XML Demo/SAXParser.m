//
//  XMLParser.m
//  Parsing XML Demo, SAX Style
//
//  Created by kaifeng@github
//  Copyright (c) 2015 kaifeng. All rights reserved.

#import "SAXParser.h"

@implementation SAXParser {
    NSXMLParser *xmlParser;         // NSXMLParser by Foundation.
    NSMutableDictionary *root;      // Save parsing result.
    NSMutableArray *xmlStack;       // Stack used during parsing.
}

-(id)initWithData:(NSData*)data
{
    self = [super init];
    if(self) {
        xmlParser = [[NSXMLParser alloc] initWithData: data];
        root = [[NSMutableDictionary alloc] init];
        xmlStack = [[NSMutableArray alloc] init];
        if(xmlParser == nil || root == nil || xmlStack == nil) {
            xmlParser = nil;
            root = nil;
            xmlStack = nil;
            return nil;
        }
        [xmlParser setDelegate: self];
        [xmlParser setShouldResolveExternalEntities: NO];
    }
    return self;
}

-(NSDictionary*)parse
{
    [xmlParser parse];
    return root;
}

#pragma mark - Delegate implementation for NSXMLParser

-(void)parserDidStartDocument:(NSXMLParser*)parser
{
    [xmlStack addObject:root];
}

-(void)parserDidEndDocument:(NSXMLParser*)parser
{
    NSLog(@"%@", root);
}

-(void)parser:(NSXMLParser*) parser didStartElement:(NSString*) elementName namespaceURI:(NSString*) namespaceURI qualifiedName:(NSString*) qName attributes:(NSDictionary*) attributeDict
{
    // Create XML Node, each node is represented by a dictionary.
    NSMutableDictionary *node = [[NSMutableDictionary alloc] init];
    
    // Save node name.
    [node setValue:elementName forKey:KEY_NODE_NAME];
    
    // Save node attributes.
    [node setValue:attributeDict forKey:KEY_NODE_ATTR];
    
    // Check parent for current node name.
    NSMutableDictionary *parent = [xmlStack lastObject];
    id obj = [parent valueForKey:elementName];
    if(obj == nil) {
        // Node name not exist, just add self to parent.
        [parent setValue:node forKey:elementName];
    } else if([obj isKindOfClass: NSMutableArray.class]) {
        // Already has same child node, add to child array.
        [(NSMutableArray*)obj addObject:node];
    } else if([obj isKindOfClass: NSMutableDictionary.class]) {
        // Already has a child node, replace with array and add self.
        NSMutableDictionary *siblingChild = (NSMutableDictionary*)obj;
        NSMutableArray *childArray = [[NSMutableArray alloc]init];
        [childArray addObject:siblingChild];
        [childArray addObject:node];
        [parent setValue:childArray forKey:elementName];
    }
    
    // Add self to stack for subsequent parsing.
    [xmlStack addObject:node];
}

-(void)parser:(NSXMLParser*) parser foundCharacters:(NSString*)string
{
    NSMutableDictionary *current = [xmlStack lastObject];
    NSMutableString *value = [current valueForKey:KEY_NODE_VALUE];
    if(value == nil) {
        value = [[NSMutableString alloc] init];
        [current setValue:value forKey:KEY_NODE_VALUE];
    }
    [value appendString:string];
}

-(void)parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName
{
    [xmlStack removeLastObject];
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [parser abortParsing];
    root = nil;
}

@end
