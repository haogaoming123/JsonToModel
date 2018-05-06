//
//  BaseModel.m
//  JsonToModel
//
//  Created by haogaoming on 2018/5/2.
//  Copyright © 2018年 郝高明. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>
#import "ModelManager.h"
#import "BaseModel+category.h"

#pragma mark - 存储model的propertys
static NSMutableDictionary * classPropertys;
#pragma mark - 存储OC对象的类型
static NSArray * staticOCObjectTypes = nil;
#pragma mark - 存储非OC对象的类型
static NSArray * staticNOObjectTypes = nil;

@implementation BaseModel

+ (void)initialize
{
    if (self == [self class]) {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            classPropertys = [NSMutableDictionary dictionary];
            staticOCObjectTypes = @[@"NSArray",@"NSString",@"NSNumber",@"NSDictionary",
                                    @"NSMutableArray",@"NSMutableDictionary"
                                    ];
            staticNOObjectTypes = @[@"int",@"float",@"double",@"BOOL",@"NSInteger"];
        });
    }
}

-(instancetype)initWithDictionary:(NSDictionary *)dic {
    if (self = [self init]) {
        if (dic == NULL || dic.count == 0) {
            return self;
        }
        
        //解析model的属性
        [self setUp];
        
        //解析
        [self propertyWithDictionary:dic];
    }
    return self;
}

#pragma mark - keyMap methods：替换关键字声明
+(NSDictionary *)keyMap {
    return nil;
}

#pragma mark - setUp methods：解析model的属性
//解析model的属性
-(void)setUp {
    Class class = [self class];
    if ([classPropertys objectForKey:NSStringFromClass(class)]) {
        return;
    }
    //存储一个类以及父类所有的propertys
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    //循环遍历子类、父类property
    while (class != [BaseModel class]) {
        //解析要替换的keys
        NSDictionary *replaceKeyMap = [class keyMap];
        NSArray *replaceKeyMap_keys = [replaceKeyMap allKeys];
        //解析class中的propertys
        unsigned int count = 0;
        objc_property_t *propertys = class_copyPropertyList(class, &count);
        if (propertys != NULL && count != 0) {
            for (unsigned int i=0; i<count; i++) {
                objc_property_t property = propertys[i];
                
                //创建model管理
                ModelManager *manager = [ModelManager new];
                
                //分析property_name
                const char *name = property_getName(property);
                NSString *propertyName = [NSString stringWithUTF8String:name];
                manager.property_name = propertyName;
                if ([replaceKeyMap_keys containsObject:propertyName]) {
                    manager.isReplace = YES;
                    manager.replaceByKey = replaceKeyMap[propertyName];
                }
                
                //分析property_type
                unsigned int attributsCount = 0;
                objc_property_attribute_t *attributes  = property_copyAttributeList(property, &attributsCount);
                if (attributes == NULL || attributsCount == 0) {
                    free(attributes);
                    continue;
                }
                for (unsigned int j=0; j<attributsCount; j++) {
                    objc_property_attribute_t attribute = attributes[j];
                    NSString *attribute_name = [NSString stringWithUTF8String:attribute.name];
                    if ([attribute_name isEqual: @"T"]) {
                        [self chageTypeToString:attribute.value withManager:manager];
                        break;
                    }
                }
                [mutDic setObject:manager forKey:propertyName];
                free(attributes);
            }
        }
        class = [class superclass];
        free(propertys);
    }
    [classPropertys setObject:mutDic forKey:NSStringFromClass([self class])];
}

//解析property的type
-(void)chageTypeToString:(const char *)value withManager:(ModelManager *)manager {
    NSString *changeStr = [NSString stringWithUTF8String:value];
    if ([changeStr hasPrefix:@"@"] && ![changeStr containsString:@"<"]) {
        changeStr = [changeStr substringFromIndex:2];
        changeStr = [changeStr substringToIndex:changeStr.length-1];
        manager.property_type = changeStr;
    }else if ([changeStr hasPrefix:@"@"] && [changeStr containsString:@"<"]) {
        NSRange range_start = [changeStr rangeOfString:@"<"];
        NSRange range_end = [changeStr rangeOfString:@">"];
        NSString *subStr = [changeStr substringWithRange:NSMakeRange(range_start.location+1, range_end.location-range_start.location-1)];
        NSString *typeStr = [changeStr substringWithRange:NSMakeRange(2, range_start.location-2)];
        manager.property_subType = subStr;
        manager.property_type = typeStr;
    }else if ([changeStr isEqualToString:@"i"]) {
        manager.property_type = @"int";
    }else if ([changeStr isEqualToString:@"f"]) {
        manager.property_type = @"float";
    }else if ([changeStr isEqualToString:@"d"]) {
        manager.property_type = @"double";
    }else if ([changeStr isEqualToString:@"B"]) {
        manager.property_type = @"BOOL";
    }else if ([changeStr isEqualToString:@"q"]) {
        manager.property_type = @"NSInteger";
    }
    if ([manager.property_type containsString:@"Mutable"]) {
        manager.isMutable = YES;
    }
}

#pragma mark - propertyWithDictionary methods：解析property
//解析property
-(void)propertyWithDictionary:(NSDictionary *)dic {
    NSDictionary *propertyDic = [classPropertys objectForKey:NSStringFromClass([self class])];
    NSArray *keysArray = [propertyDic allKeys];
    //赋值
    for (int i = 0; i<keysArray.count; i++) {
        NSString *key = keysArray[i];
        //propertyDic的value值
        ModelManager *manager = propertyDic[key];
        
        //dic的value值
        id jsonValue = nil;
        if (manager.isReplace) {
            jsonValue = dic[manager.replaceByKey];
        }else {
            jsonValue = dic[key];
        }
        if (jsonValue == NULL && jsonValue == nil) {
            continue;
        }
        
        if ([NSClassFromString(manager.property_type) isSubclassOfClass:[BaseModel class]]) {
            id objc = [[NSClassFromString(manager.property_type) alloc] initWithDictionary:dic[key]];
            [self setValue:objc forKey:key];
            continue;
        }
        if ([staticOCObjectTypes containsObject:manager.property_type]) {
            //OC对象类型
            if (manager.isMutable) {
                //Mutable类型
                jsonValue = [jsonValue mutableCopy];
            }
            if ([jsonValue isKindOfClass:NSClassFromString(manager.property_type)]) {
                //是一个类型
                if (manager.property_subType.length > 0 && [jsonValue isKindOfClass:[NSArray class]]) {
                    //数组
                    NSMutableArray *mutArray = [NSMutableArray array];
                    NSArray *jsonValueArray = (NSArray *)jsonValue;
                    for (int i=0; i<jsonValueArray.count; i++) {
                        id objc = [[NSClassFromString(manager.property_subType) alloc] initWithDictionary:jsonValueArray[i]];
                        [mutArray addObject:objc];
                    }
                    [self setValue:mutArray forKey:key];
                }else {
                    [self setValue:jsonValue forKey:key];
                }
            }else {
                [self changeJsonValueTypeToPropertyType:manager.property_type with:jsonValue with:key];
            }
        }else if ([staticNOObjectTypes containsObject:manager.property_type]) {
            [self changeJsonValueTypeToPropertyType:manager.property_type with:jsonValue with:key];
        }
    }
}

// 将jsonvalue转换为model的类型：property_type：类型的type   jsonvalue：json的value   property_name的value
-(void)changeJsonValueTypeToPropertyType:(NSString *)property_type with:(id)jsonValue with:(NSString *)property_name {
    Class changeClass = [BaseModel classFromeJsonValueClass:[jsonValue class]];
    NSString *selName = [NSString stringWithFormat:@"%@BY%@:",property_type,NSStringFromClass(changeClass)];
    SEL sel = NSSelectorFromString(selName);
    if ([self respondsToSelector:sel]) {
        IMP imp = [self methodForSelector:sel];
        id (* func)(id,SEL,id) = (void *)imp;
        id obc = func(self,sel,jsonValue);
        if (obc != NULL && obc != nil) {
            [self setValue:obc forKey:property_name];
        }
    }else {
        NSString *error = [NSString stringWithFormat:@"无法预估的类型转换：%@-->%@",property_type,changeClass];
        @throw [NSException exceptionWithName:@"解析错误" reason:error userInfo:nil];
    }
}

-(void)dealloc {
    [classPropertys removeObjectForKey:NSStringFromClass([self class])];
}
@end
