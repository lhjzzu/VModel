//
//  VModelPropertyAttributes.h
//  VModel
//
//  Created by 蚩尤 on 16/6/6.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, VClassEncodeType) {
    VClassEncodeTypeChar = 1,
    VClassEncodeTypeInt,
    VClassEncodeTypeShort,
    VClassEncodeTypeLong,
    VClassEncodeTypeLongLong,
    VClassEncodeTypeUnsignedChar,
    VClassEncodeTypeUnsignedInt,
    VClassEncodeTypeUnsignedShort,
    VClassEncodeTypeUnsignedLong,
    VClassEncodeTypeUnsignedLongLong,
    VClassEncodeTypeFloat,
    VClassEncodeTypeDouble,
    VClassEncodeTypeBool,
    VClassEncodeTypeVoid,
    VClassEncodeTypeCharString,
    VClassEncodeTypeObject,
    VClassEncodeTypeClass,
    VClassEncodeTypeSEL,
    VClassEncodeTypeArray,
    VClassEncodeTypeStructure,
    VClassEncodeTypeUnion,
    VClassEncodeTypeBit,
    VClassEncodeTypePointer,
    VClassEncodeTypeUnknown
};

@interface VModelPropertyAttributes : NSObject
/**
 *  如果属性为对象类型,对象的类名
 */
@property (nonatomic,strong) NSString *className;
/**
 *  属性名
 */
@property (nonatomic,strong,readonly) NSString *name;
/**
 * 如果属性为对象类型,且遵守协议,对象遵守的协议
 */
@property (nonatomic,strong) NSArray *objectProtocols;
/**
 *  属性编码类型
 */
@property(nonatomic,assign) VClassEncodeType encodeType;
/**
 *  初始化方法
 *
 *  @param name            属性名
 *  @param attributeString 属性的属性字符串
 */
- (instancetype)initWithName:(NSString *)name attributeString:(NSString *)attributeString;
@end
