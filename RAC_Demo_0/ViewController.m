//
//  ViewController.m
//  RAC_Demo_0
//
//  Created by 宋宏康 on 2019/8/20.
//  Copyright © 2019 宋宏康. All rights reserved.
//

#import "ViewController.h"
#import "Calculation.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self test1];
    [self test2];
}


/**
 链式的用法
 */
- (void)test1 {
    int result  = [Calculation makeCalculation:^(Calculation *make) {
        
        make.add(10).muilt(20);
    }];
    NSLog(@"%d",result);
}

/**
 函数式的用法
 */
- (void)test2 {
    
    Calculation *ca = [Calculation.alloc init];
    
   BOOL equal = [[[ca calculation:^int(int result) {
        return result + 2;
    }] equal:^BOOL(int result) {
        return result == 2;
    }] equal];
    
    NSLog(@"%d",equal);
}


@end
