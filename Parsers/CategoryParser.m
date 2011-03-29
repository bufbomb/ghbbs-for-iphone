//
//  CategoryParser.m
//  ghbbs
//
//  Created by Chenqun Hang on 9/7/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "CategoryParser.h"
#import "DataConvertor.h"
#import "ErrorType.h"
#import "ConnectionManager.h"


NSString * kCategory = @"Category";
NSString * kFav = @"Fav";
@implementation CategoryParser
@synthesize delegate;
- (id) init
{
    if (self = [super init])
    {
        static NSString *feedURLString = @"http://bbs.fudan.sh.cn/bbs/sec";
        url = [[NSURL URLWithString:feedURLString] copy];
        categoryList = [[NSMutableArray alloc] init];
        favList = [[NSMutableArray alloc] init];
        favStart = NO;
        delegate = nil;
        errorOccured = NO;
    }
    return self;
}


#pragma mark NSOperation override method.
- (void) main
{
    NSData * data = [ConnectionManager dataOfURL:url];
    if (!data) 
    {
        [delegate onParseFailed:ErrorTypeNetwork];
        return;
    }
    assert(data);
    NSData * utf8data = [DataConvertor convertXMLData:data withEncoding:kCFStringEncodingGB_18030_2000];
    if (!utf8data) 
    {
        [delegate onParseFailed:ErrorTypeEncoding];
        return;
    }
    assert(utf8data);
    NSXMLParser * parser = [[NSXMLParser alloc] initWithData:utf8data];
    [parser setDelegate:self];
    [parser parse];
    [parser release];
}

#pragma mark NSXMLParser delegate method
- (void) parserDidStartDocument:(NSXMLParser *)parser
{
    [categoryList removeAllObjects];
    [favList removeAllObjects];
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"sec"])
    {
        NSString * name = [attributeDict objectForKey:@"desc"];
        NSString * cid = [attributeDict objectForKey:@"id"];
        Category * category = [[Category alloc] initWithName:name Cid:cid];
        [categoryList addObject:category];
        [category release];
    }else if ([elementName isEqualToString:@"b"])
    {
        favStart = YES;
    }

}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"b"])
    {
        favStart = NO;
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (favStart) 
    {
        assert(string);
        [favList addObject:string];
    }
}

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    if (!errorOccured) 
    {
        errorOccured = YES;
    }
}

- (void) parserDidEndDocument:(NSXMLParser *)parser
{
    if (!errorOccured) 
    {
        [delegate onParseSuccessful:[NSDictionary dictionaryWithObjectsAndKeys:categoryList, kCategory, favList, kFav, nil]];
    }
    else
    {
        [delegate onParseFailed:ErrorTypeParse];    
    }
}

- (void) dealloc
{
    [delegate release];
    [url release];
    [categoryList release];
    [super dealloc];
}

@end
