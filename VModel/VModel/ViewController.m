//
//  ViewController.m
//  VModel
//
//  Created by 蚩尤 on 16/6/6.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import "Car.h"
#import "Person.h"
#import "Special.h"
#import <objc/runtime.h>
#import "ViewController.h"
@interface ViewController ()

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    /**
     * 1 普通的字典@{@"xxx":@"xxx",@"xxx":@"xxx"}
     */
    NSDictionary *carDic = @{@"name":@"法拉利",
                             @"price":@(123.5),
                             @"isRed":@(1),
                             @"id":@"ouer123"};
    Car *car = [[Car alloc] initVModelWithJSON:carDic];
    NSLog(@"car: %@,%@,%@,%@",car.name,@(car.price),@(car.isRed),car.carId);
    
    /**
     * 2 数组里面元素为字典@[@{},@{}...]
     */
    NSArray *companyJson =  @[@{@"name":@"蚩尤",@"sex":@(1)},@{@"name":@"仓颉",@"sex":@(0)}];
    Company *company = [[Company alloc] init];
    [company v_injectWithJSON:companyJson];
    
    for (Person *person in company.persons) {
        NSLog(@"company person: %@ %@",person.name,person.sex);
    }
    
    /**
     *  3 字典里面包含数组,数组里又包含字典 @{@"xxx":@[@{},@{}],@"xxx":@"xxx"}
     */
    NSDictionary *officeJson = @{@"persons":@[@{@"name":@"clio",@"sex":@(0)},@{@"name":@"降龙",@"sex":@(1)}],
                                 @"width":@(100)};
    Office *office = [[Office alloc] initVModelWithJSON:officeJson];
    
    for (Person *person in office.persons) {
        NSLog(@"office person: %@ %@",person.name,person.sex);
    }
    NSLog(@"office width: %@",@(office.width));    
    
    /**
     *  4 字典里包含数组，数组里又包含数组
     */
    NSDictionary *companySJson = @{@"name":@"公司联盟",
                                   @"companys":
  @[
  @[@{@"name":@"炎帝",@"sex":@(1)},@{@"name":@"少昊",@"sex":@(1)}],
  @[@{@"name":@"通玄",@"sex":@(1)},@{@"name":@"阿修罗",@"sex":@(1)}]
  ]};
    CompanyS *companys = [[CompanyS alloc] initVModelWithJSON:companySJson];
    for (Company *company in companys.companys) {
        for (Person *person in company.persons) {
            NSLog(@"companys person: %@ %@",person.name,person.sex);
        }
    }
    NSLog(@"companys name: %@",companys.name);

    /**
     *  兼容
     */
    Special *sepcial = [[Special alloc] initVModelWithJSON:@"兼容传入单个字符串"];
    NSLog(@"sepcial name: %@",sepcial.name);
    
    Special2 *sepcial2 = [[Special2 alloc] initVModelWithJSON:@(123456)];
    NSLog(@"sepcial2 number(兼容传入单个number对象): %@",sepcial2.number);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
