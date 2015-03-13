//
//  AppDelegate.m
//  SilenceMaker
//
//  Created by Alexander Kozin on 13.03.15.
//  Copyright (c) 2015 MyDay. All rights reserved.
//

#import "AppDelegate.h"

#import "SilenceMaker.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *file = [documentsDirectory stringByAppendingPathComponent: @"audio.m4a"];

    [SilenceMaker makeSilenceWithLength:60 * 60 * 23.5 atPath:file];

    return YES;
}

@end
