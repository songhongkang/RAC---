//
//  Calculation.m
//  QiFileManager
//
//  Created by 宋宏康 on 2019/8/20.
//  Copyright © 2019 QiShare. All rights reserved.
//

#import "Calculation.h"


@interface Calculation()
/** 结果 */
@property(nonatomic, assign) int result;



@end

@implementation Calculation

- (Calculation *(^)(int))add{
    __weak Calculation *weakSelf = self;
    return ^Calculation *(int value){
        weakSelf.result += value;
        return self;
    };
}

- (Calculation * _Nonnull (^)(int))sub
{
    __weak Calculation *weakSelf = self;
    return ^Calculation *(int value){
        weakSelf.result -= value;
        return self;
    };
}

- (Calculation * _Nonnull (^)(int))muilt
{
    __weak Calculation *weakSelf = self;
    return ^Calculation *(int value){
        weakSelf.result *= value;
        return self;
    };
}

- (Calculation * _Nonnull (^)(int))divide
{
    __weak Calculation *weakSelf = self;
    return ^Calculation *(int value){
        weakSelf.result /= value;
        return self;
    };
}


- (Calculation *)calculation:(int(^)(int result))calculation
{
    _result = calculation(self.result);
    return self;
}

- (Calculation *)equal:(BOOL(^)(int result))operation
{
    _equal = operation(self.result);
    return self;
}
@end


@implementation NSObject (Calculation)

+ (int)makeCalculation:(void (^)(Calculation *))calculation{
    Calculation *cal = [[Calculation alloc] init];
    if (calculation) {
        calculation(cal);
    }
    return cal.result;
}

@end
