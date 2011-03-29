//
//  AccountFormView.h
//  ghbbs
//
//  Created by Chenqun Hang on 11/4/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AccountFormView : UIView<UITextFieldDelegate>{
    UILabel * usernameLbl;
    UILabel * passwordLbl;
    UITextField * usernameFld;
    UITextField * passwordFld;
    
    UIImageView * markImage;
    UIActivityIndicatorView * spinView;
}

- (NSString *) getUsername;
- (NSString *) getPassword;
- (void) setUsername:(NSString *)name;
- (void) setPassword:(NSString *)password;
- (void) signin;
- (void) saveUsernameAndPassword;
- (void) updateUI;

@end
