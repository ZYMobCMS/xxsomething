//
//  BRYSoundEffectPlayer.h
//  BRYSoundEffectPlayer
//
//  Created by Bryan Irace on 12/21/13.
//  Copyright (c) 2013 Bryan Irace. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

/**
 Convenience wrapper around some of Apple's Audio Service functions used for playing sound effects. 
 
 An instance of `BRYSoundEffectPlayer` will cache sounds in memory until a low memory warning occurs, though sounds will also be disposed of in order to play other sounds when `playsSoundsConcurrently` is set to `NO`.
 
 If your needs are more advanced, you probably want to use `AVAudioPlayer` instead.
 */
@interface BRYSoundEffectPlayer : NSObject

/**
 `NO` by default. When set to `YES`, sounds will play simultaneously. When set to `NO`, a sound that is already being played will be disposed of and removed from the in-memory cache in order to play another sound (this is the only way to stop a sound being played by `AudioToolbox` functions).
 */
@property (nonatomic) BOOL playsSoundsConcurrently;

+ (instancetype)sharedInstance;

- (void)playSound:(NSString *)filePath;

@end
