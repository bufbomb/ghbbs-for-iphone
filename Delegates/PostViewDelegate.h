//
//  PostDelegate.h
//  ghbbs
//
//  Created by Chenqun Hang on 10/8/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PostViewDelegate <NSObject>
-(void) onViewNext;
-(void) onViewPrevious;

@end
