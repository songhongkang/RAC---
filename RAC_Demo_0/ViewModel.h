//
//  ViewModel.h
//  RAC_Demo_0
//
//  Created by 宋宏康 on 2019/8/22.
//  Copyright © 2019 宋宏康. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewModel : NSObject

/**
 网络请求1

 @return RACSignal
 */
- (RACSignal *)request1;

/**
 网络请求2

 @return RACSignal
 */
- (RACSignal *)request2;

@end

NS_ASSUME_NONNULL_END
