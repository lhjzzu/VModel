//
//  NSObject+VModel.m
//  VModel
//
//  Created by 蚩尤 on 16/6/6.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+VModel.h"
#import "VModelPropertyAttributes.h"
@implementation NSObject (VModel)
- (instancetype)initVModelWithJSON:(id)json
{
    self = [self init];
    if (self) {
        [self v_injectWithJSON:json];
    }
    return self;
}

- (void)v_injectWithJSON:(id)json
{
    [self v_setupCachedPropertyMapper];
    [self v_setupPropertyAttributesDic];
    [self v_injectJson:json];
}

- (void)v_setupCachedPropertyMapper {
    if (!objc_getAssociatedObject(self, _cmd)) {
        NSDictionary *dic = [self v_modelPropertyMapper];
        if (dic.count > 0) {
            objc_setAssociatedObject(self, _cmd, dic, OBJC_ASSOCIATION_RETAIN);
        }
    }
}
- (void)v_setupPropertyAttributesDic {
    if (!objc_getAssociatedObject(self, _cmd)) {
        NSMutableDictionary *propertyAttributesDic = [NSMutableDictionary dictionary];
        unsigned int outCount = 0;
        objc_property_t *propertys = class_copyPropertyList([self class], &outCount);
        for (int i = 0; i < outCount; i++) {
            objc_property_t property_t = propertys[i];
            const char *name = property_getName(property_t);
            const char *attributes = property_getAttributes(property_t);
            NSString *propertyName = [NSString stringWithUTF8String:name];
            NSString *propertyAttributes = [NSString stringWithUTF8String:attributes];
            VModelPropertyAttributes *attributeModel = [[VModelPropertyAttributes alloc] initWithName:propertyName attributeString:propertyAttributes];
            [propertyAttributesDic setObject:attributeModel forKey:propertyName];
        }
        free(propertys);
        if (propertyAttributesDic.count > 0) {
            objc_setAssociatedObject(self, _cmd, propertyAttributesDic, OBJC_ASSOCIATION_RETAIN);
        }
    }
}
- (NSDictionary *)v_modelPropertyMapper
{
    return @{};
}
- (void)v_injectJson:(id)json {
    NSDictionary *propertyMapper = objc_getAssociatedObject(self, @selector(v_setupCachedPropertyMapper));
    NSDictionary *propertyAttributesDic = objc_getAssociatedObject(self, @selector(v_setupPropertyAttributesDic));
    NSArray *attributeModels = [propertyAttributesDic allValues];
    if ([json isKindOfClass:[NSDictionary class]]) {
        for (VModelPropertyAttributes *attributeModel in attributeModels) {
            NSString *propertyName = attributeModel.name;
            NSString *jsonKey = [propertyMapper objectForKey:propertyName];
            jsonKey = jsonKey ?:propertyName;
            id jsonVaule = [json objectForKey:jsonKey];
            id propertyValue = [self v_valueWithAttributeModel:attributeModel withJsonVaule:jsonVaule];
            if (!propertyValue) {
                 propertyValue = attributeModel.encodeType == VClassEncodeTypeObject? nil:@(0);
            }
            [self setValue:propertyValue forKey:propertyName];
        }
    } else if ([json isKindOfClass:[NSArray class]]) {
        VModelPropertyAttributes *attributeModel = attributeModels.firstObject;
        id propertyValue = [self v_valueWithAttributeModel:attributeModel withJsonVaule:json];
        if (!propertyValue) {
            propertyValue = attributeModel.encodeType == VClassEncodeTypeObject? nil:@(0);
        }
        [self setValue:propertyValue forKey:attributeModel.name];
    } else if ([json isKindOfClass:[NSString class]] || [json isKindOfClass:[NSNumber class]]) {
        for (VModelPropertyAttributes *attributeModel in attributeModels) {
            NSString *propertyName = attributeModel.name;
            NSString *jsonKey = [propertyMapper objectForKey:propertyName];
            jsonKey = jsonKey ?:propertyName;
            id jsonVaule = json;
            id propertyValue = [self v_valueWithAttributeModel:attributeModel withJsonVaule:jsonVaule];
            if (!propertyValue) {
                propertyValue = attributeModel.encodeType == VClassEncodeTypeObject? nil:@(0);
            }
            [self setValue:propertyValue forKey:propertyName];
        }
    }
}
- (id)v_valueWithAttributeModel:(VModelPropertyAttributes *)attributeModel withJsonVaule:(id)value {
    id returnValue = nil;
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        returnValue = nil;
    } else {
        if (attributeModel.encodeType != VClassEncodeTypeObject) {
            if (attributeModel.encodeType == VClassEncodeTypeInt || attributeModel.encodeType == VClassEncodeTypeShort || attributeModel.encodeType == VClassEncodeTypeUnsignedInt || attributeModel.encodeType == VClassEncodeTypeUnsignedShort) {
                returnValue = [NSNumber numberWithInteger:[value integerValue]];
            } else if (attributeModel.encodeType == VClassEncodeTypeLong || attributeModel.encodeType ==VClassEncodeTypeUnsignedLong) {
                returnValue = [NSNumber numberWithLong:[value longValue]];
            } else if (attributeModel.encodeType == VClassEncodeTypeLongLong || attributeModel.encodeType ==VClassEncodeTypeUnsignedLongLong) {
                returnValue = [NSNumber numberWithLongLong:[value longLongValue]];
            } else if (attributeModel.encodeType == VClassEncodeTypeFloat) {
                returnValue = [NSNumber numberWithFloat:[value floatValue]];
            } else if (attributeModel.encodeType == VClassEncodeTypeDouble) {
                returnValue = [NSNumber numberWithDouble:[value doubleValue]];
            } else if (attributeModel.encodeType == VClassEncodeTypeBool) {
                returnValue = [NSNumber numberWithBool:[value boolValue]];
            }
        } else {
            NSString *className = attributeModel.className;
            Class class = NSClassFromString(className);
            NSString *protocolName = [attributeModel.objectProtocols firstObject];
            Class protocolClass = NSClassFromString(protocolName);
            if (![className isKindOfClass:[NSDictionary class]] && [value isKindOfClass:[NSDictionary class]]) {
                returnValue = [[class alloc] initVModelWithJSON:value];
            } else if ([className isKindOfClass:[NSDictionary class]] && [value isKindOfClass:[NSDictionary class]]){
                returnValue = value;
            } else if ([value isKindOfClass:[NSArray class]] && protocolName == nil){
                returnValue = value;
            } else if ([value isKindOfClass:[NSArray class]] && protocolName) {
                NSMutableArray *modelArr = [NSMutableArray array];
                for (id subValue in value) {
                    if ([subValue isKindOfClass:[NSArray class]]) {
                        [modelArr addObject:[[protocolClass alloc] initVModelWithJSON:subValue]];
                    } else if ([subValue isKindOfClass:[NSDictionary class]]) {
                        [modelArr addObject:[[protocolClass alloc] initVModelWithJSON:subValue]];
                    }
                    returnValue = modelArr;
                }
            }
            else {
                if ([class isSubclassOfClass:[NSString class]]) {
                    returnValue = [NSString stringWithFormat:@"%@",value];
                } else if ([class isSubclassOfClass:[NSNumber class]]) {
                    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                    returnValue = [numberFormatter numberFromString:value];
                }
            }
        }
    }
    return returnValue;
}
@end
