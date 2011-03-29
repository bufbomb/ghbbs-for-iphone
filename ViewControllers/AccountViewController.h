//
//  AccountViewController.h
//  ghbbs
//
//  Created by Chenqun Hang on 9/6/10.
//  Copyright bufbomb.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountFormView.h"

@interface AccountViewController : UITableViewController<UITextFieldDelegate> {
    UITabBarItem * tabBarItem;
    
    UITextField * usernameFld;
    UITextField * passwordFld;
    UISwitch * boardNameSwitch;
	UISwitch * showPictureSwitch;
	UISwitch * ansiColorSwitch;
}
- (NSString *) getUsername;
- (NSString *) getPassword;
- (void) refresh;
@end
