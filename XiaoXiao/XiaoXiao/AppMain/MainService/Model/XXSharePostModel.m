//
//  XXSharePostModel.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-18.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXSharePostModel.h"

@implementation XXSharePostModel
@synthesize postAudio,postContent,postImages,postType,attributedContent;

- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super init]) {
        
        self.postAudio = [aDecoder decodeObjectForKey:@"postAudio"];
        self.postType = [aDecoder decodeIntegerForKey:@"postType"];
        self.postImages = [aDecoder decodeObjectForKey:@"postImages"];
        self.postContent = [aDecoder decodeObjectForKey:@"postContent"];
        self.attributedContent = [aDecoder decodeObjectForKey:@"attributedContent"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:self.postAudio forKey:@"postAudio"];
    [aCoder encodeInteger:self.postType forKey:@"postType"];
    [aCoder encodeObject:self.postContent forKey:@"postContent"];
    [aCoder encodeObject:self.postImages forKey:@"postImages"];
    [aCoder encodeObject:self.attributedContent forKey:@"attributedContent"];
}

@end
