//
//  NewPostViewController.h
//  ghbbs
//
//  Created by Chenqun Hang on 12/1/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSParserDelegate.h"
#import "Post.h"
#import "BoardPermission.h"

@interface NewPostViewController : UIViewController <BBSParserDelegate, UITextViewDelegate>{
    UITextField * _titleView;
    UITextView * _postView;
    UIActivityIndicatorView * _indicatorView;
    id _target;
    SEL _selector;
    
    NSString * _bid;
    NSString * _pid;
    BoardPermission * _boardPermission;
    

}

- (void) setTarget:(id)target Selector:(SEL)selector;
- (void) setBid:(NSString *)bid;
- (void) setPid:(NSString *)pid;

- (void) fetch;
- (void) setEnableInput:(BOOL)enabled;
- (void) enableInput;
- (void) disableInput;

- (void) popUpRetryAlertWithTitle:(NSString *)title Message:(NSString *)message;
- (void) popUpConfirmAlertWithTitle:(NSString *)title Message:(NSString *)message;

- (void) beginPost;
- (void) endPost;

- (BOOL) isReplyPost;
@end
