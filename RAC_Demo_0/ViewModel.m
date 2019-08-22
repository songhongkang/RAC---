//
//  ViewModel.m
//  RAC_Demo_0
//
//  Created by 宋宏康 on 2019/8/22.
//  Copyright © 2019 宋宏康. All rights reserved.
//

#import "ViewModel.h"

@implementation ViewModel
- (RACSignal *)request1
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"数据1"];
            [subscriber sendCompleted];
//            NSString *domain = @"com.MyCompany.MyApplication.ErrorDomain";
//            NSString *desc = NSLocalizedString(@"Unable to…", @"");
//            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
//            NSError *error = [NSError errorWithDomain:domain
//                                                 code:-101
//                                             userInfo:userInfo];
//            [subscriber sendError:error];
        });
        return nil;
    }];
}

- (RACSignal *)request2
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"数据2"];
            [subscriber sendCompleted];
        });
        return nil;
    }];
}
@end
