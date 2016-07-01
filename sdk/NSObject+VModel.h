//
//  NSObject+VModel.h
//  VModel
//
//  Created by 蚩尤 on 16/6/6.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (VModel)
/**
 *  用json数据来初始化这个model
 *
 *  @param json json数据
 *
 *  @return 赋值后的model
 */

- (instancetype)initVModelWithJSON:(id)json;

/**
 *  用json数据来给这个model赋值
 *
 */
- (void)v_injectWithJSON:(id)json;

/**
 *  JSON字段和model属性的映射
 *  解释：1 例如JSON字典中有{@"id":@"123"}
 *       2 而在OC中id为占用字符，所以在model中创建属性时不能直接用id
 *       3 假设model对应的字段为carId,那么在数据解析时需要做一个映射，将id的值赋值给carId
 *       4 返回的映射的字典就可以这样写 @{@"carId":@"id"}
 *
 *  @return 映射字典
 */
- (NSDictionary *)v_modelPropertyMapper;
@end
