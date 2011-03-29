//
//  main.m
//  ghbbs
//
//  Created by Chenqun Hang on 9/6/10.
//  Copyright bufbomb.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, @"UIApplication", @"ghbbsAppDelegate");
    [pool release];
    return retVal;
}

