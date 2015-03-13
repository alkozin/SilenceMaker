# SilenceMaker
Easy to use class that creates audio file with silence

To make it work you should just call `makeSilenceWithLength:atPath:` with silence duration and path.

```objective-c
NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
NSString *documentsDirectory = [paths objectAtIndex:0];
NSString *file = [documentsDirectory stringByAppendingPathComponent: @"audio.m4a"];

[SilenceMaker makeSilenceWithLength:60 * 60 * 23.5 atPath:file];
```

In code you can see a commented second version with kAudioFormatiLBC. iLBC files has a very small size. But second version of code is don't work now.
See [Apple sample](https://developer.apple.com/library/ios/samplecode/iPhoneExtAudioFileConvertTest/Introduction/Intro.html) as a tutorial.

Improvements and contributions are always welcome.