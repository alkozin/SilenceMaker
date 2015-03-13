//
//  SilenceMaker.h
//  SilenceMaker
//
//  Created by Alexander Kozin on 13.03.15.
//  Copyright (c) 2015 MyDay. All rights reserved.
//

@import UIKit;

@interface SilenceMaker : NSObject

/**
 *  Creates a m4a files with silence
 *
 *  @param timeInterval Duration of audio file in seconds
 *  @param path         Path to create audio file
 */
+ (void)makeSilenceWithLength:(NSTimeInterval)timeInterval atPath:(NSString *)path;

@end
