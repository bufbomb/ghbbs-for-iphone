//
//  GHPrintableGlyph.h
//  ghbbs
//
//  Created by hangchenqun on 2/1/11.
//  Copyright 2011 bufbomb.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHGlyph.h"

@interface GHPrintableGlyph : GHGlyph {
	CGRect _rect;
	UIColor * _color;
}
- (void) draw;
@property CGRect rect;
@property (nonatomic, retain) UIColor * color;

@end
