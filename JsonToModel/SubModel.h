//
//  SubModel.h
//  JsonToModel
//
//  Created by haogaoming on 2018/5/2.
//  Copyright © 2018年 郝高明. All rights reserved.
//

#import "BaseModel.h"

@protocol myClass @end

@interface myClass: BaseModel
@property (nonatomic,  copy) NSString *str;
@property (nonatomic,assign) float    number;
@end

@interface SubModel : BaseModel

@property (nonatomic,assign) int ID;
@property (nonatomic,  copy) NSString *str1;     //@"NSString"
@property (nonatomic,  copy) NSString *str2;     //@"NSString"
@property (nonatomic,assign) NSInteger str3;     //q
@property (nonatomic,strong) NSDictionary *str4;     //@"NSDictionary"
@property (nonatomic,assign) BOOL str5;     //B
@property (nonatomic,strong) NSNumber *str6;     //@"NSNumber"
@property (nonatomic,strong) NSArray *str7;     //@"NSArray"
@property (nonatomic,strong) NSMutableArray<myClass> *str8;     //@"NSMutableArray<myClass>"
@property (nonatomic,strong) myClass *str9;     //@"myClass"
@property (nonatomic,assign) int str10;     //i
@property (nonatomic,assign) float str11; //f

@end

