//
//  NSDictionary+UrlEncodedString.m
//  TicketSystem
//
//  Created by ZYVincent on 12-2-28.
//  Copyright (c) 2012年 __ZYProSoft__. All rights reserved.

#import "NSDictionary+UrlEncodedString.h"

static NSString *toString(id object) {
    return [NSString stringWithFormat: @"%@", object];
}

// 转化为UTF8编码
static NSString *urlEncode(id object) {
    NSString *string = toString(object);
    NSString *encodedValue = (__bridge NSString*)CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                (CFStringRef)string,
                                                                                nil,
                                                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                kCFStringEncodingUTF8);
    return encodedValue;
}

@implementation NSDictionary(UrlString)

-(NSString*) urlEncodedString {
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in self) {
        id value = [self objectForKey: key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", urlEncode(key), urlEncode(value)];
        [parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];//拼装字符串
}


@end
