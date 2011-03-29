//
//  PostViewController.h
//  ghbbs
//
//  Created by Chenqun Hang on 9/10/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostViewController.h"

@interface ThreadPostViewController : PostViewController{
    NSString * boardName;
}

- (id) initWithBoardName:(NSString *)_name Pid:(NSString *)_pid;

@end