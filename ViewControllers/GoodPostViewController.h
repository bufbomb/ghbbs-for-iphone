//
//  GoodPostViewController.h
//  ghbbs
//
//  Created by Chenqun Hang on 12/4/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostViewController.h"

@interface GoodPostViewController : PostViewController{
    BOOL forward;
}

- (id) initWithBid:(NSString *)_bid Post:(Post *)_post;

@end
