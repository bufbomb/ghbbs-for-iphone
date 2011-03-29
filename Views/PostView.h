//
//  PostView.h
//  ghbbs
//
//  Created by Chenqun Hang on 10/8/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostViewDelegate.h"
#import "GHDocument.h"

@interface PostView : UIView 
{
    CGPoint touchPoint;
    id<PostViewDelegate> _delegate;
    NSString * _text;
    UIFont * _font;
	GHDocument * _document;
}
- (void) setText:(NSString *)text;
- (void) resizeView;

@property (nonatomic, retain) UIFont * font;
@property (nonatomic, retain) id delegate;
@end
