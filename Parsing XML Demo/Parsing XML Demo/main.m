//
//  main.m
//  Parsing XML Demo
//
//  Created by kaifeng@github
//  Copyright (c) 2015 kaifeng. All rights reserved.

#import <Foundation/Foundation.h>
#import "SAXParser.h"


void saxSample()
{
    NSString *sampleSoapMsg = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>" \
    "<soap:Envelope xmlns:soap=\"http://www.w3.org/2001/12/soap-envelope\" " \
    "soap:encodingStyle=\"http://www.w3.org/2001/12/soap-encoding\">" \
    "<soap:Body><u:Contents>" \
    "<Item>Tiger</Item>" \
    "<Item>Leopard</Item>" \
    "<Item>Snow Leopard</Item>" \
    "<Item>Mavericks</Item>" \
    "<Item>Yosmite</Item>" \
    "</u:Contents></soap:Body></soap:Envelope>";
    
    NSData *data = [sampleSoapMsg dataUsingEncoding:NSUTF8StringEncoding];
    
    SAXParser *parser = [[SAXParser alloc]initWithData:data];
    NSDictionary *result = [parser parse];
    
    // You can use valueForKeyPath to quicky index deep levels
    NSDictionary *contents = [result valueForKeyPath:@"soap:Envelope.soap:Body.u:Contents"];
    assert(contents != nil);
    
    NSArray *items = [contents valueForKey:@"Item"];
    assert(items != nil);
    NSLog(@"OSX codenames:");
    for(NSDictionary *node in items) {
        NSLog(@"%@", [node valueForKey:KEY_NODE_VALUE]);
    }
}

void domSample()
{
    // 1. CREATE NSXMLDOCUMENT
    
    // create items
    NSXMLElement *itemTiger = [NSXMLNode elementWithName:@"Item"];
    itemTiger.stringValue = @"Tiger";
    NSXMLElement *itemLeopard = [NSXMLNode elementWithName:@"Item"];
    itemLeopard.stringValue = @"Leopard";
    NSXMLElement *itemSnowLeopard = [NSXMLNode elementWithName:@"Item"];
    itemSnowLeopard.stringValue = @"Snow Leopard";
    NSXMLElement *itemMavericks = [NSXMLNode elementWithName:@"Item"];
    itemMavericks.stringValue = @"Mavericks";
    NSXMLElement *itemYosmite = [NSXMLNode elementWithName:@"Item"];
    itemYosmite.stringValue = @"Yosmite";

    // create contents node
    NSXMLElement *contents = [NSXMLNode elementWithName:@"u:Contents"];
    [contents addChild:itemTiger];
    [contents addChild:itemLeopard];
    [contents addChild:itemSnowLeopard];
    [contents addChild:itemMavericks];
    [contents addChild:itemYosmite];
    
    // create body node
    NSXMLElement *body = [NSXMLNode elementWithName:@"s:Body"];
    
    // add content to body
    [body addChild:contents];
    
    // attribute xmlns
    NSXMLNode *namespace = [[NSXMLNode alloc] initWithKind:NSXMLAttributeKind];
    namespace.name = @"xmlns:s";
    namespace.stringValue = @"http://www.w3.org/2001/12/soap-envelope";
    
    // attribute encodingStyle
    NSXMLNode *encodingStyle = [[NSXMLNode alloc] initWithKind:NSXMLAttributeKind];
    encodingStyle.name = @"s:encodingStyle";
    encodingStyle.stringValue = @"http://www.w3.org/2001/12/soap-encoding";
    
    // create envelope and add body as child
    NSXMLElement *envelope = [[NSXMLElement alloc]initWithName:@"s:Envelope"];
    [envelope addAttribute: namespace];
    [envelope addAttribute: encodingStyle];
    [envelope addChild:body];
    
    // create document
    NSXMLDocument *xmlDocument = [[NSXMLDocument alloc]initWithRootElement:envelope];
    [xmlDocument setVersion:@"1.0"];
    [xmlDocument setCharacterEncoding:@"UTF-8"];
    xmlDocument.standalone = TRUE;
    xmlDocument.documentContentKind = NSXMLDocumentXMLKind;
    
    // 2. GET REQUEST DATA

    NSData *data = xmlDocument.XMLData;
    NSLog(@"Created XML: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    // 3. PARSE XML DATA BY NSXMLDocument

    NSXMLDocument *parsedXmlDoc = [[NSXMLDocument alloc]initWithData:data options:NSXMLDocumentTidyXML|NSXMLDocumentValidate error:nil];
    
    // easily find child node by nextNode
    NSXMLNode *node = parsedXmlDoc.rootElement;
    while(node != nil) {
        if([node.name isEqualToString:@"u:Contents"]) {
            break;
        }
        node = [node nextNode];
    }
    NSLog(@"OSX codenames:");
    if(node != nil && node.childCount != 0) {
        for(NSXMLNode *n in node.children) {
            NSLog(@"%@", [n nextNode].stringValue);
        }
    }

}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSLog(@"SAX Sampled Output:");
        
        saxSample();
        
        NSLog(@"DOM Sampled Output:");
        
        domSample();
        
    }
    
    return 0;
}
