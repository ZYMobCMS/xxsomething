//
//  XXAudioManager.h
//  AudioRecord
//
//  Created by ZYVincent on 13-12-19.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "XXMainDataCenter.h"

typedef void (^XXAudioManagerFinishRecordBlock) (NSString *audioSavePath,NSString *wavSavePath,NSString *timeLength);

@interface XXAudioManager : NSObject <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    XXAudioManagerFinishRecordBlock _finishBlock;
    NSTimeInterval  _currentTimeInterval;
}
@property (nonatomic,strong)AVAudioRecorder *audioRecorder;
@property (nonatomic,strong)AVAudioPlayer *audioPlayer;

+ (XXAudioManager*)shareManager;

- (void)audioManagerStartRecordWithFinishRecordAction:(XXAudioManagerFinishRecordBlock)finishBlock;
- (void)audioManagerEndRecord;

- (void)audioManagerPlayAudioForRemoteAMRUrl:(NSString*)remoteAMRUrl;
- (void)audioManagerPlayLocalWavWithPath:(NSString*)filePath;

- (NSString*)getFileNameFromUrl:(NSString*)urlString;

//自己录音的时候，保存一个与远程服务器的映射
- (void)saveLocalAudioFile:(NSString*)localFilePath forRemoteAMRFile:(NSString*)remoteAMRUrl;
//将服务器的AMR数据下载到本地，保存一份Wav数据，建立映射关系
- (void)saveRemoteAMRToWav:(NSString*)downloadAMRFilePath withRemoteUrl:(NSString*)remoteAMRUrl;
- (void)saveRemoteAMRToWav:(NSString *)downloadAMRFilePath withRemoteUrl:(NSString *)remoteAMRUrl whileFinishShouldPlay:(BOOL)shouldPlay;

@end
