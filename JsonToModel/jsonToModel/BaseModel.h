//
//  BaseModel.h
//  JsonToModel
//
//  Created by haogaoming on 2018/5/2.
//  Copyright © 2018年 郝高明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

-(instancetype)initWithDictionary:(NSDictionary *)dic;

/**
 model中要替换json数据里的keys
 *例如：+(NSDictionary *)keyMap {
 *        return @{@"model_key":@"json_key"};
 *     }
 */
+(NSDictionary *)keyMap;
@end
