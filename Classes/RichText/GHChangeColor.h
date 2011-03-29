//
//  GHChangeColor.h
//  ghbbs
//
//  Created by hangchenqun on 2/1/11.
//  Copyright 2011 bufbomb.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHGlyph.h"

@interface GHChangeColor : GHGlyph {
	UIColor * _color;
}

@property (nonatomic, assign) UIColor * color;
@end
