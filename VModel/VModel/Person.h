//
//  Person.h
//  VModel
//
//  Created by 蚩尤 on 16/6/7.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+VModel.h"
#import <Foundation/Foundation.h>
@protocol Person <NSObject>

@end
@interface Person : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *sex;
@end

@protocol Company <NSObject>

@end

@interface Company :NSObject
@property (nonatomic,strong) NSArray<Person> *persons;
@end


@interface Office :NSObject
@property (nonatomic,strong) NSArray<Person> *persons;
@property (nonatomic, assign) CGFloat width;
@end



@interface CompanyS :NSObject

@property (nonatomic,strong) NSArray<Company> *companys;
@property (nonatomic,strong) NSString *name;
@end







