//
//  AccountFormView.m
//  ghbbs
//
//  Created by Chenqun Hang on 11/4/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "AccountFormView.h"
#import "AuthenticationUtility.h"

#import "StorageManager.h"

@implementation AccountFormView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        CGRect rect = CGRectMake(20.0f, 0.0f, 280.0f, 35.0f);
        usernameLbl = [[UILabel alloc] initWithFrame:rect];
        rect.origin.y += 40;
        usernameFld = [[UITextField alloc] initWithFrame:rect];
        rect.origin.y += 40;
        passwordLbl = [[UILabel alloc] initWithFrame:rect];
        rect.origin.y += 40;
        passwordFld = [[UITextField alloc] initWithFrame:rect];
        
        usernameLbl.text = @"用户名";
        usernameFld.borderStyle = UITextBorderStyleRoundedRect;
        usernameFld.placeholder = @"填入用户名";
        usernameFld.autocapitalizationType = UITextAutocapitalizationTypeNone;
        usernameFld.autocorrectionType = UITextAutocorrectionTypeNo;
        usernameFld.keyboardType = UIKeyboardTypeAlphabet;
        usernameFld.returnKeyType = UIReturnKeyJoin;
        
        passwordLbl.text = @"密码";
        passwordFld.borderStyle = UITextBorderStyleRoundedRect;
        passwordFld.placeholder = @"填入密码";
        passwordFld.secureTextEntry = YES;
        passwordFld.keyboardType = UIKeyboardTypeAlphabet;
        passwordFld.returnKeyType = UIReturnKeyJoin;
        
        usernameFld.delegate = self;
        passwordFld.delegate = self;
        markImage = [[UIImageView alloc] initWithFrame:CGRectMake(140.0f, 160.0f, 40.0f, 40.0f)];
        markImage.contentMode = UIViewContentModeScaleAspectFit;
        
        spinView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinView.hidesWhenStopped = YES;
        spinView.frame = CGRectMake(140.0f, 160.0f, 40.0f, 40.0f);

        [self addSubview:usernameLbl];
        [self addSubview:usernameFld];
        [self addSubview:passwordLbl];
        [self addSubview:passwordFld];
        [self addSubview:markImage];
        [self addSubview:spinView];
    }
    return self;
}

- (NSString *) getUsername
{
    return [usernameFld text];
}

- (NSString *) getPassword
{
    return [passwordFld text];
}
- (void) setUsername:(NSString *)name
{
    usernameFld.text = name;
}

- (void) setPassword:(NSString *)password
{
    passwordFld.text = password;
}

- (void) updateUI
{
    AuthStatus status = [AuthenticationUtility sharedInstance].status;
    switch (status) {
        case SignedIn:
            [spinView stopAnimating];
            markImage.image = [UIImage imageNamed:@"success.png"]; 
            break;
        case SignInFailed:
            [spinView stopAnimating];
            markImage.image = [UIImage imageNamed:@"fail.png"];
            break;
        case SigningIn:
            markImage.image = nil;
            [spinView startAnimating];
            break;
        default:
            [spinView stopAnimating];
            markImage.image = nil;
            break;
    }
}

- (void) signin
{
    [[AuthenticationUtility sharedInstance] signin];
    [self updateUI];        
}

- (void) saveUsernameAndPassword
{    
    [[StorageManager sharedInstance] saveUserName:usernameFld.text Password:passwordFld.text];
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    [self signin];
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [self saveUsernameAndPassword];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (void)dealloc {
    [spinView release];
    [markImage release];
    [usernameFld release];
    [usernameLbl release];
    [passwordFld release];
    [passwordLbl release];
    [super dealloc];
}


@end
