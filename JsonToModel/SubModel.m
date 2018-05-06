//
//  SubModel.m
//  JsonToModel
//
//  Created by haogaoming on 2018/5/2.
//  Copyright © 2018年 郝高明. All rights reserved.
//

#import "SubModel.h"

@implementation myClass
+ (NSDictionary *)keyMap {
    return @{@"number":@"Number"};
}
@end

@implementation SubModel

/**
 * 要替换的key
 */
+ (NSDictionary *)keyMap {
    return @{@"ID":@"id"};
}
@end

