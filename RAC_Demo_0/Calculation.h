//
//  Calculation.h
//  QiFileManager
//
//  Created by 宋宏康 on 2019/8/20.
//  Copyright © 2019 QiShare. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Calculation : NSObject
/** 结果 */
@property(nonatomic, assign) BOOL equal;
/**
 加
 */
- (Calculation *(^)(int))add;
/**
 减
 */
- (Calculation *(^)(int))sub;
/**
 乘
 */
- (Calculation *(^)(int))muilt;
/**
 除
 */
- (Calculation *(^)(int))divide;

- (Calculation *)calculation:(int(^)(int result))calculation;

- (Calculation *)equal:(BOOL(^)(int result))operation;



@end

NS_ASSUME_NONNULL_END



@interface NSObject (Calculation)
+ (int)makeCalculation:(void(^_Nullable)(Calculation *))calculation;
@end

