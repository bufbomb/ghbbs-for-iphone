//
//  ghbbsAppDelegate.h
//  ghbbs
//
//  Created by Chenqun Hang on 9/6/10.
//  Copyright bufbomb.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ghbbsAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

- (BOOL)checkNetwork;
- (BOOL)checkSiteAvailablity: (NSString *)host;

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;

@end
