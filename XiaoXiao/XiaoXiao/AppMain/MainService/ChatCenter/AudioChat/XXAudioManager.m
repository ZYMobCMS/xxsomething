//
//  XXAudioManager.m
//  AudioRecord
//
//  Created by ZYVincent on 13-12-19.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXAudioManager.h"
#import "VoiceConverter.h"

#define XXAudioManagerTempFileDirectory @"XXAudioTemplateDirectory"

#define XXMaxAudioRecordTime 60  //一分钟

#define XXCacheAudioForRemoteAudioRelationShipListUDFKey @"XXCacheAudioForRemoteAudioRelationShipUDFKey"

@implementation XXAudioManager

#pragma mark - api
+ (XXAudioManager*)shareManager
{
    static XXAudioManager *audioManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!audioManager) {
            audioManager = [[XXAudioManager alloc]init];
            [audioManager createCacheDirectory];
            
        }
    });
    return audioManager;
}

/**
 生成当前时间字符串
 @returns 当前时间字符串
 */
- (NSString*)getCurrentTimeString
{
    NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    return [dateformat stringFromDate:[NSDate date]];
}

/**
 获取录音设置
 @returns 录音设置
 */
- (NSDictionary*)getAudioRecorderSettingDict
{
    NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
                                                                      [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,//音频编码质量
                                   nil];
    return recordSetting;
}
- (void)createCacheDirectory
{
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths lastObject];
    
    NSString *xxAudioDirectory = [docsDir stringByAppendingPathComponent:XXAudioManagerTempFileDirectory];

    BOOL isDir = YES;
    if (![[NSFileManager defaultManager]fileExistsAtPath:xxAudioDirectory isDirectory:&isDir]) {
        
        [[NSFileManager defaultManager]createDirectoryAtPath:xxAudioDirectory withIntermediateDirectories:YES attributes:NO error:nil];
    }
    
    //创建本地录音对远程映射目录
    if (![[NSUserDefaults standardUserDefaults]objectForKey:XXCacheAudioForRemoteAudioRelationShipListUDFKey]) {
        
        NSMutableDictionary *shipList = [NSMutableDictionary dictionary];
        [[NSUserDefaults standardUserDefaults]setObject:shipList forKey:XXCacheAudioForRemoteAudioRelationShipListUDFKey];
    }
    
}
- (NSString*)cacheDirectory
{
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths lastObject];
    
    NSString *xxAudioDirectory = [docsDir stringByAppendingPathComponent:XXAudioManagerTempFileDirectory];

    return xxAudioDirectory;
}

#pragma mark - 获取文件大小
- (NSInteger) getFileSize:(NSString*) path{
    NSFileManager * filemanager = [NSFileManager defaultManager];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue];
        else
            return -1;
    }
    else{
        return -1;
    }
}

- (NSURL*)buildRecordSavePath
{
    //template file name
    NSString *soundFileName = [NSString stringWithFormat:@"%@.wav",[self getCurrentTimeString]] ;
    
    NSString *soundFilePath = [[self cacheDirectory]
                               stringByAppendingPathComponent:soundFileName];
    return [NSURL URLWithString:soundFilePath];
}

- (NSString*)buildCachePathForFileName:(NSString*)fileName
{
    NSString *soundFilePath = [[self cacheDirectory]
                               stringByAppendingPathComponent:fileName];
    return soundFilePath;
}
- (NSString*)getFileNameFromUrl:(NSString*)urlString
{
    NSArray *urlSepratorArray = [urlString componentsSeparatedByString:@"/"];
    NSArray *namesArray = [[urlSepratorArray lastObject]componentsSeparatedByString:@"."];
    
    return [namesArray objectAtIndex:0];
}
- (NSString*)urlToFileName:(NSString*)url
{
    return [url stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
}

- (void)createAudioRecord
{
    NSDictionary *recordSettings = [self getAudioRecorderSettingDict];
    
    NSError *error = nil;
        
    self.audioRecorder = [[AVAudioRecorder alloc]
                          initWithURL:[self buildRecordSavePath]
                     settings:recordSettings
                     error:&error];
    self.audioRecorder.delegate = self;
    
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        self.audioRecorder.meteringEnabled = YES;
        [self.audioRecorder prepareToRecord];
        //开始录音
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [self.audioRecorder recordForDuration:XXMaxAudioRecordTime];
    }
}

#pragma mark - audio record delegate
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder
{
    
}
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (flag) {
        NSLog(@"record success!");
        //转换成AMR
        NSString *amrFile = [NSString stringWithFormat:@"%@.amr",[self getFileNameFromUrl:self.audioRecorder.url.absoluteString]];
        [VoiceConverter wavToAmr:self.audioRecorder.url.absoluteString amrSavePath:[self buildCachePathForFileName:amrFile]];
        if (_finishBlock) {
            _finishBlock([self buildCachePathForFileName:amrFile],self.audioRecorder.url.absoluteString);
        }
    }
}

- (void)checkIsWavAudioCached:(NSString*)amrFile
{
    
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    
}

- (void)audioManagerStartRecordWithFinishRecordAction:(XXAudioManagerFinishRecordBlock)finishBlock
{
    _finishBlock = [finishBlock copy];
    [self createAudioRecord];
    [VoiceConverter changeStu];
    
}
- (void)audioManagerEndRecord
{
    if (self.audioRecorder.isRecording) {
        [VoiceConverter changeStu];
        [self.audioRecorder stop];
    }
}

- (void)audioManagerPlayAudioForRemoteAMRUrl:(NSString *)remoteAMRUrl
{
    //一定是存储了的
    NSMutableDictionary *shipList = [[NSUserDefaults standardUserDefaults]objectForKey:XXCacheAudioForRemoteAudioRelationShipListUDFKey];
    if ([shipList objectForKey:remoteAMRUrl]) {
        [self audioManagerPlayLocalWav:[shipList objectForKey:remoteAMRUrl]];
    }
}
- (void)audioManagerPlayLocalWavWithPath:(NSString *)filePath
{
    [self audioManagerPlayLocalWav:filePath];
}

- (void)audioManagerPlayLocalWav:(NSString*)filePath
{
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:filePath] error:nil];
    self.audioPlayer.volume = 0.8f;
    [self.audioPlayer play];
}

- (void)saveLocalAudioFile:(NSString *)localFilePath forRemoteAMRFile:(NSString *)remoteAMRUrl
{
    NSMutableDictionary *shipList = [[NSUserDefaults standardUserDefaults]objectForKey:XXCacheAudioForRemoteAudioRelationShipListUDFKey];
    [shipList setObject:localFilePath forKey:remoteAMRUrl];
    [[NSUserDefaults standardUserDefaults]setObject:shipList forKey:XXCacheAudioForRemoteAudioRelationShipListUDFKey];
}
- (void)saveRemoteAMRToWav:(NSString *)downloadAMRFilePath withRemoteUrl:(NSString *)remoteAMRUrl
{
    [self saveRemoteAMRToWav:downloadAMRFilePath withRemoteUrl:remoteAMRUrl whileFinishShouldPlay:NO];
}

- (void)saveRemoteAMRToWav:(NSString *)downloadAMRFilePath withRemoteUrl:(NSString *)remoteAMRUrl whileFinishShouldPlay:(BOOL)shouldPlay
{    
    NSMutableDictionary *shipList = [[NSUserDefaults standardUserDefaults]objectForKey:XXCacheAudioForRemoteAudioRelationShipListUDFKey];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
        NSString *amrFileName = [self urlToFileName:remoteAMRUrl];
        NSString *cachePath = [self buildCachePathForFileName:amrFileName];
        
        [VoiceConverter amrToWav:downloadAMRFilePath wavSavePath:cachePath];
        
        //建立关系
        [shipList setObject:remoteAMRUrl forKey:cachePath];
        
        //立即播放
        if (shouldPlay) {
            
            [self audioManagerPlayLocalWav:cachePath];
        }
        
    });
}

//录音结束立马发送
- (void)audioManagerStartRecordWithFinishRecordAction
{
    
}


@end
