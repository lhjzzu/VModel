//
//  Car.h
//  VModel
//
//  Created by 蚩尤 on 16/6/8.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+VModel.h"
#import <Foundation/Foundation.h>
@interface Car : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) CGFloat price;
@property (nonatomic,assign) BOOL isRed;
@property (nonatomic,strong) NSString *carId;//在.m中carId做映射

@end
