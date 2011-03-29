//
//  GHHyperLink.h
//  ghbbs
//
//  Created by hangchenqun on 2/1/11.
//  Copyright 2011 bufbomb.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHPrintableGlyph.h"

@interface GHHyperLink : GHPrintableGlyph {
	NSMutableData * _data;
	NSURL * _url;
}
- (id) initWithUrl:(NSURL *)urlstr;
@property (nonatomic, copy) NSURL * url;

@end
