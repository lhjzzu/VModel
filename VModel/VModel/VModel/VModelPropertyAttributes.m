//
//  VModelPropertyAttributes.m
//  VModel
//
//  Created by 蚩尤 on 16/6/6.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import "VModelPropertyAttributes.h"
static NSDictionary *encodeTypeMap = nil;
@interface VModelPropertyAttributes ()
{
    NSString *propertyName;
}
@end
@implementation VModelPropertyAttributes
+ (NSDictionary *)encodeTypeMap {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        encodeTypeMap = @{@"c":@1,@"i":@2,@"s":@3,@"l":@4,
                          @"q":@5,@"C":@6,@"I":@7,@"S":@8,
                          @"L":@9,@"Q":@10,@"f":@11,@"d":@12,
                          @"B":@13,@"v":@14,@"*":@15,@"@":@16,
                          @"#":@17,@":":@18,@"[":@19,@"{":@20,
                          @"(":@21,@"b":@22,@"^":@23,@"?":@24};
    });
    return encodeTypeMap;
}

- (instancetype)initWithName:(NSString *)name attributeString:(NSString *)attributeString
{
    self = [super init];
    if (self) {
        [self.class encodeTypeMap];
        propertyName = name;
        NSArray *subAttributeStrings = [attributeString componentsSeparatedByString:@","];
        if ([subAttributeStrings count] > 0) {
            NSString *subAttributeString = [subAttributeStrings firstObject];
            NSScanner *scanner = [NSScanner scannerWithString:subAttributeString];
            [scanner scanUpToString:@"T" intoString:NULL];
            [scanner scanString:@"T" intoString:NULL];
            NSUInteger scanLocation = scanner.scanLocation;
            if (scanLocation < subAttributeString.length) {
                NSString *encodeType = [subAttributeString substringWithRange:NSMakeRange(scanLocation, 1)];
                self.encodeType = [[encodeTypeMap objectForKey:encodeType] integerValue];
                if (self.encodeType == VClassEncodeTypeObject) {
                    scanner.scanLocation++;
                    if ([scanner scanString:@"\"" intoString:NULL]) {
                        NSString *className = nil;
                        [scanner scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet] intoString:&className];
                        self.className = className;
                        NSMutableArray *protocols = [NSMutableArray array];
                        while ([scanner scanString:@"<" intoString:NULL]) {
                            NSString *protocolName = nil;
                            [scanner scanUpToString:@">" intoString:&protocolName];
                            if (protocolName) {
                                [protocols addObject:protocolName];
                            }
                            [scanner scanString:@">" intoString:NULL];
                        }
                        if (protocols.count > 0) {
                            self.objectProtocols = protocols;
                        }
                    }
                }
            }
        }
    }
    return self;
}

- (NSString *)name
{
    return propertyName;
}
@end
