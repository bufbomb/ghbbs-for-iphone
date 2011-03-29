//
//  PostViewController.h
//  ghbbs
//
//  Created by Chenqun Hang on 9/10/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "PostParser.h"
#import "ViewMode.h"
#import "BBSParserDelegate.h"
#import "PostViewDelegate.h"
#import "PostView.h"

@interface PostViewController : UIViewController<PostViewDelegate, BBSParserDelegate, UIActionSheetDelegate> {
    
    NSMutableArray * posts;
    Post * currentPost;
    PostView * postView;
    UIScrollView * scrollView;
    UIImageView * instrView;
    
    NSString * bid;
    NSString * pid;
    
    NSURL * currentURL;
    
//    BOOL isSticky;
//    BOOL forward;
}

//- (id) initWithBid:(NSString *)_bid Post:(Post *)_post;

- (void) loadData:(NSArray *)_posts;
- (void) refresh;
- (void) viewPrevious;
- (void) viewNext;

- (void) popUpRetryAlertWithTitle:(NSString *)title Message:(NSString *)message;
- (void) popUpConfirmAlertWithTitle:(NSString *)title Message:(NSString *)message;
- (void) showActionSheet;
- (void) beginPost;
- (void) endPostWithTitle:(NSString *)title Content:(NSString *)content;

- (void) dismissInstructView;
- (void) fetch;
- (void) fetchFirstPost;
- (void) fetchPostWithURL:(NSURL *)url;

@end