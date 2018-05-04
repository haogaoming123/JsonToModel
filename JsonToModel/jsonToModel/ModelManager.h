//
//  ModelManager.h
//  JsonToModel
//
//  Created by haogaoming on 2018/5/4.
//  Copyright © 2018年 郝高明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tool.h"

@interface ModelManager : NSObject

PROPERTYCOPY     NSString   *property_name;
PROPERTYCOPY     NSString   *property_type;
PROPERTYCOPY     NSString   *property_subType;
PROPERTYASSIGN   BOOL       isMutable;

@end
