//
//  BoardViewController.h
//  ghbbs
//
//  Created by Chenqun Hang on 9/9/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Board.h"
#import "ViewMode.h"
#import "BBSParserDelegate.h"
#import "PullToRefreshTableViewController.h"

@interface BoardViewController : PullToRefreshTableViewController
{
    Board * board;
    ViewMode viewMode;
    
    NSMutableArray * stickPosts;
    NSMutableArray * posts;
    NSMutableArray * threadPosts;
    NSMutableArray * goodPosts;
    
    int postStart;
    int threadPostStart;
    int goodPostStart;
}

- (id) initWithBoard:(Board *)_board;
- (void) beginPost;
- (void) endPostWithTitle:(NSString *)title Content:(NSString *)content;
#pragma mark -
#pragma mark Mode Change
- (void) changeToNormalMode;
- (void) changeToThreadMode;
- (void) changeToGoodMode;
- (void) modeChanged;
@end
