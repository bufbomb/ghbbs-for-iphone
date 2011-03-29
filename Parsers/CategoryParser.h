//
//  CategoryParser.h
//  ghbbs
//
//  Created by Chenqun Hang on 9/7/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Category.h"
#import "BBSParserDelegate.h"

extern NSString * kCategory;
extern NSString * kFav;

@interface CategoryParser : NSOperation <NSXMLParserDelegate> {
    NSURL * url;
    NSMutableArray * categoryList;
    NSMutableArray * favList;
    BOOL favStart;
    id<BBSParserDelegate> delegate;
    BOOL errorOccured;
}

@property (nonatomic, retain) id<BBSParserDelegate> delegate;

@end
