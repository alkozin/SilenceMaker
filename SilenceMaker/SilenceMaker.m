//
//  SilenceMaker.m
//  SilenceMaker
//
//  Created by Alexander Kozin on 13.03.15.
//  Copyright (c) 2015 MyDay. All rights reserved.
//

#import "SilenceMaker.h"

@import AudioToolbox;

@implementation SilenceMaker

#define kSecondsInHour                  3600.0

#define kSampleRate                     8000
#define kBufferSizeForOneSecond         kSampleRate

+ (void)makeSilenceWithLength:(NSTimeInterval)timeInterval atPath:(NSString *)path
{
    // Use  macerror 'result' to see errors description
    OSStatus result;

    NSLog(@"Start to make silence at: %@", path);

    // Create URL for file
    CFURLRef destinationURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                                            (__bridge   CFStringRef)path,
                                                            kCFURLPOSIXPathStyle,
                                                            false);

    //
    AudioStreamBasicDescription destinationFormat;
    memset(&destinationFormat, 0, sizeof(destinationFormat));
    destinationFormat.mChannelsPerFrame = 1;
    destinationFormat.mFormatID = kAudioFormatMPEG4AAC;

    ExtAudioFileRef extAudioFileRef;
    result = ExtAudioFileCreateWithURL(destinationURL,
                                       kAudioFileM4AType,
                                       &destinationFormat,
                                       NULL,
                                       kAudioFileFlags_EraseFile,
                                       &extAudioFileRef);
    if(result)
        printf("ExtAudioFileCreateWithURL %d \n", (int)result);

    AudioStreamBasicDescription clientFormat;
    memset(&clientFormat, 0, sizeof(clientFormat));
    clientFormat.mFormatID          = kAudioFormatLinearPCM;
    clientFormat.mFormatFlags       = kAudioFormatFlagIsFloat | kAudioFormatFlagIsPacked | kAudioFormatFlagIsNonInterleaved;
    clientFormat.mChannelsPerFrame  = 1;
    clientFormat.mBytesPerPacket    = sizeof(float);
    clientFormat.mFramesPerPacket   = 1;
    clientFormat.mBytesPerFrame     = sizeof(float);
    clientFormat.mBitsPerChannel    = 8 * sizeof(float);
    clientFormat.mSampleRate        = kSampleRate;

    result = ExtAudioFileSetProperty(extAudioFileRef, kExtAudioFileProperty_ClientDataFormat, sizeof(clientFormat), &clientFormat);
    if(result)
        printf("ExtAudioFileSetProperty %d \n", (int)result);

    UInt32 codec = kAppleHardwareAudioCodecManufacturer;

    UInt32 size = sizeof(codec);
    result = ExtAudioFileSetProperty(extAudioFileRef,
                                     kExtAudioFileProperty_CodecManufacturer,
                                     size,
                                     &codec);
    if(result)
        printf("ExtAudioFileSetProperty %d \n", (int)result);

    NSTimeInterval numberOfHours = floor(timeInterval / kSecondsInHour);
    NSTimeInterval numberOfSeconds = timeInterval - numberOfHours * kSecondsInHour;

    NSDate *start = [NSDate date];
    NSLog(@"Start writing:");

    for (NSUInteger i = 0; i < numberOfHours; i++) {
        [self addSilenceWithLength:kSecondsInHour toFile:&extAudioFileRef];
    }

    [self addSilenceWithLength:numberOfSeconds toFile:&extAudioFileRef];

    NSLog(@"End writing: %f", [[NSDate date] timeIntervalSinceDate:start]);

    ExtAudioFileDispose(extAudioFileRef);
    CFRelease(destinationURL);
}

// This is a second version with kAudioFormatiLBC. iLBC files has a very small size. But this code is don't work now
// See https://developer.apple.com/library/ios/samplecode/iPhoneExtAudioFileConvertTest/Introduction/Intro.html
// Improvements and contributions are always welcome.

//+ (void)makeSilenceWithLength:(NSTimeInterval)timeInterval atPath:(NSString *)path
//{
//    // Use  macerror 'result' to see errors description
//    OSStatus result = noErr;
//
//    NSLog(@"Start to make silence at: %@", path);
//
//    // Create URL for file
//    CFURLRef destinationURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
//                                                            (__bridge   CFStringRef)path,
//                                                            kCFURLPOSIXPathStyle,
//                                                            false);
//
//    ExtAudioFileRef destinationFile = 0;
//
//    AudioStreamBasicDescription dstFormat;
//
//    // setup the output file format
//    dstFormat.mSampleRate = kSampleRate;
//    dstFormat.mFormatID = kAudioFormatiLBC;
//    dstFormat.mChannelsPerFrame =  1;
//
//    // use AudioFormat API to fill out the rest of the description
//    UInt32 size = sizeof(dstFormat);
//    AudioFormatGetProperty(kAudioFormatProperty_FormatInfo, 0, NULL, &size, &dstFormat);
//    //
//
//        // create the destination file
//    ExtAudioFileCreateWithURL(destinationURL, kAudioFileCAFType, &dstFormat, NULL, kAudioFileFlags_EraseFile, &destinationFile);
//
//        // set the client format - The format must be linear PCM (kAudioFormatLinearPCM)
//        // You must set this in order to encode or decode a non-PCM file data format
//        // You may set this on PCM files to specify the data format used in your calls to read/write
//
//
//    UInt32 sampleSize = sizeof(float);
//
//    AudioStreamBasicDescription clientFormat;
//    clientFormat.mFormatID = kAudioFormatLinearPCM;
//    clientFormat.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked;
//    clientFormat.mBitsPerChannel = 8 * sampleSize;
//    clientFormat.mChannelsPerFrame = 1;
//    clientFormat.mFramesPerPacket = 1;
//    clientFormat.mBytesPerFrame = 1 * sampleSize;
//    clientFormat.mBytesPerPacket = clientFormat.mBytesPerFrame;
//    clientFormat.mSampleRate = kSampleRate;
//
//    size = sizeof(clientFormat);
//    ExtAudioFileSetProperty(destinationFile, kExtAudioFileProperty_ClientDataFormat, size, &clientFormat);
//
//
//    ExtAudioFileRef extAudioFileRef;
//    result = ExtAudioFileCreateWithURL(destinationURL,
//                                       kAudioFileM4AType,
//                                       &dstFormat,
//                                       NULL,
//                                       kAudioFileFlags_EraseFile,
//                                       &extAudioFileRef);
//    if(result)
//        printf("ExtAudioFileCreateWithURL %d \n", (int)result);
//
//    UInt32 codec = kAppleHardwareAudioCodecManufacturer;
//    size = sizeof(codec);
//    result = ExtAudioFileSetProperty(extAudioFileRef,
//                                     kExtAudioFileProperty_CodecManufacturer,
//                                     size,
//                                     &codec);
//    if(result)
//        printf("ExtAudioFileSetProperty %d \n", (int)result);
//
//    NSTimeInterval numberOfHours = floor(timeInterval / kSecondsInHour);
//    NSTimeInterval numberOfSeconds = timeInterval - numberOfHours * kSecondsInHour;
//
//    NSDate *start = [NSDate date];
//    NSLog(@"Start writing:");
//
//    for (NSUInteger i = 0; i < numberOfHours; i++) {
//        [self addSilenceWithLength:kSecondsInHour toFile:&extAudioFileRef];
//    }
//
//    [self addSilenceWithLength:numberOfSeconds toFile:&extAudioFileRef];
//
//    NSLog(@"End writing: %f", [[NSDate date] timeIntervalSinceDate:start]);
//
//    ExtAudioFileDispose(extAudioFileRef);
//    CFRelease(destinationURL);
//}

+ (void)addSilenceWithLength:(NSTimeInterval)timeInterval toFile:(ExtAudioFileRef *)file
{
    OSStatus result;

    size_t bufferSizeInFrames = (size_t)(kBufferSizeForOneSecond * timeInterval);
    size_t bufferSize = (bufferSizeInFrames * sizeof(float));
    UInt8 * buffer = (UInt8 *)malloc( bufferSize );
    AudioBufferList bufferList;
    bufferList.mNumberBuffers = 1;
    bufferList.mBuffers[0].mNumberChannels = 1;
    bufferList.mBuffers[0].mData = buffer;
    bufferList.mBuffers[0].mDataByteSize = (UInt32)bufferSize;

    NSDate *start = [NSDate date];
    NSLog(@"Start writing bufferSizeInFrames");
    result = ExtAudioFileWrite((*file), (UInt32)bufferSizeInFrames, &bufferList);
    if (result) {NSLog(@"write %d", (int)result);}
    NSLog(@"End writing bufferSizeInFrames in: %f", [[NSDate date] timeIntervalSinceDate:start]);
    
    free(bufferList.mBuffers[0].mData);
}

@end
