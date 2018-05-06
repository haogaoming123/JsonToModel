//
//  BaseModel+category.m
//  JsonToModel
//
//  Created by haogaoming on 2018/5/4.
//  Copyright © 2018年 郝高明. All rights reserved.
//

#import "BaseModel+category.h"

@implementation BaseModel (category)

+(Class)classFromeJsonValueClass:(Class)sourceClass {
    if ([sourceClass isSubclassOfClass:[NSString class]]) {
        return [NSString class];
    }
    if ([sourceClass isSubclassOfClass:[NSNumber class]]) {
        return [NSNumber class];
    }
    if ([sourceClass isSubclassOfClass:[NSDictionary class]]) {
        return [NSDictionary class];
    }
    if ([sourceClass isSubclassOfClass:[NSArray class]]) {
        return [NSArray class];
    }
    return nil;
}

-(NSString *)NSStringBYNSNumber:(NSNumber *)number {
    return [number stringValue];
}

-(NSNumber *)floatBYNSNumber:(NSNumber *)number {
    return [NSNumber numberWithFloat:[number floatValue]];
}

-(NSNumber *)floatBYNSString:(NSString *)string {
    if (string.length > 0) {
        return [NSNumber numberWithFloat:[string intValue]];
    }
    return [NSNumber numberWithFloat:0.0];
}

-(NSNumber *)intBYNSNumber:(NSNumber *)number {
    return [NSNumber numberWithInt:[number intValue]];
}

-(NSNumber *)intBYNSString:(NSString *)string {
    if (string.length > 0) {
        return [NSNumber numberWithInt:[string intValue]];
    }
    return [NSNumber numberWithInt:0];
}

-(NSNumber *)doubleBYNSNumber:(NSNumber *)number {
    return [NSNumber numberWithDouble:[number doubleValue]];
}

-(NSNumber *)NSIntegerBYNSNumber:(NSNumber *)number {
    return number;
}

-(NSNumber *)BOOLBYNSNumber:(NSNumber *)number {
    return number;
}

-(NSNumber *)BOOLBYNSString:(NSString *)string {
    if ([string isEqualToString:@"1"] || [string isEqualToString:@"0"]) {
        return [NSNumber numberWithBool:[string boolValue]];
    }
    return [NSNumber numberWithBool:NO];
}

-(NSNumber *)NSIntegerBYNSString:(NSString *)string {
    if (string.length > 0 && [string integerValue] != NSNotFound) {
        return [NSNumber numberWithInteger:[string integerValue]];
    }
    return [NSNumber numberWithInteger:0];
}

@end
