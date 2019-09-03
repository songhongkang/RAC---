//
//  ViewController.m
//  RAC_Demo_0
//
//  Created by 宋宏康 on 2019/8/20.
//  Copyright © 2019 宋宏康. All rights reserved.
//

#import "ViewController.h"
#import "Calculation.h"
#import <Masonry/Masonry.h>
#import "ViewModel.h"
#import "TestViewController.h"
#import <ReactiveObjC/RACReturnSignal.h>

//#define lianjie(a,b) a#b

//#define NUMBER   10
//#define ADD(...) [NSString stringWithFormat:@"%d",__VA_ARGS__]

//#define ADD(...) NSLog(@"%d",__VA_ARGS__);

//
//#define STRINGIFY(S) #S
//
//#define CALCULATE(A,B)   _CALCULATE(A,B)   // 转换宏


//#define _CALCULATE(A,B)  STRINGIFY(A)##STRINGIFY(10)##STRINGIFY(B)

//#define _CALCULATE(A,B)  A##B


//#define TEST(...) ADD(10,__VA_ARGS__)


@interface ViewController () <UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) RACDisposable *disposable;
@property (nonatomic, strong) NSMutableDictionary <NSString *,RACDisposable *>*timerDic;

@property (nonatomic, strong) ViewModel *viewModel;


@property (nonatomic, strong) TestViewController *testVc;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
//    NSLog(@"str:%@",str);
//    [self test1];
//    [self test2];
//    NSLog(@"1111");
//    [self kvo];
//    [self targetAction];
//    [self notification];
//    [self delegate];
//    [self tap];
//    [self timer];
//    [self signalForSelector];
//    [self signal];
//    [self fetch1];
//    "aaa"
//    [self muilticas];
//    [self subject];
//    [self racReturnSignal];
//    [self map];
//    [self flattenMap];
//    [self testStrongDefine];
    
    
//    TEST(5)
//    NSLog(@"%@",TEST(5));
//    TEST(5)
    
    
        NSLog(@"%d",metamacro_argcount(@"1",@"2",@"3"));

}


- (void)testStrongDefine
{
    @weakify(self);
    [RACObserve(self, name) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSLog(@"---------%@",x);
    }];
}


- (void)flattenMap
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"网络请求1的数据"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    [[signal flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        NSLog(@"%@",value);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"网络请求2的数据"];
            [subscriber sendCompleted];
            return nil;
        }];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"网络请求2的数据");
    }];
}

- (void)map
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"1"];
        return nil;
    }];
    
    [[signal map:^id _Nullable(id  _Nullable value) {
        NSLog(@"-------%@",value);
        return [NSString stringWithFormat:@"map映射%@",value];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)racReturnSignal
{
    [[RACReturnSignal return:@10] subscribeNext:^(id  _Nullable x) {
        NSLog(@"--------:%@",x);
    }];
}

- (void)subject
{
    RACSubject *subject = [RACSubject subject];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"111-----:%@",x);
    }];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"222-----:%@",x);
    }];
    
    [subject sendNext:@"1"];
}


- (void)fine
{
    
}

- (void)muilticas
{
    /// 解决多次订阅的问题，。 `副作用`
    /// 会把didsubscriber 保存到RACSubscriber中的去
    /// signal 就是 RACDynamicSignal
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        //// 这里的 subscriber 就是内部创建的RACSubject
        NSLog(@"发送网络请求");
        ///  遍历里面的subscribers数组，得到RACPassthroughSubscriber对象
        //// 然后执行nextblock
        [subscriber sendNext:@"111"];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"销毁啦");
        }];
    }];
    
    
    //    _sourceSignal = source;
    //    _serialDisposable = [[RACSerialDisposable alloc] init];
    //    _signal = subject;
    ///  _sourceSignal 就是 RACDynamicSignal 也就是 signal
    ///   _signal subject 内部创建的
    
    RACMulticastConnection *connect = [signal publish];
    
    //// connect.signal 其实就是内部创建的 subject
    /// 会把`RACPassthroughSubscriber`保存到`RACSubject`的subscriber数组中去
    /// `RACPassthroughSubscriber `中保存了`RACSubscriber`和`RACSubject`对象，
    [connect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"1======%@",x);
    }];
    
    [connect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"2======%@",x);
    }];
    
    /// 
    [connect connect];
}




- (void)fetch1
{
    [[self.viewModel request1] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [[[self.viewModel request1] zipWith:[self.viewModel request2]] subscribeNext:^(id  _Nullable x) {
        RACTupleUnpack(NSString * key,NSString * value) = x;
        NSLog(@"key:%@\nvalue:%@",key,value);
    }];
    
    [[[self.viewModel request1] zipWith:[self.viewModel request2]] subscribeNext:^(id  _Nullable x) {
        NSLog(@"x");
    } error:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
    
    [[[self.viewModel request1] concat:[self.viewModel request2]] subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@",x);
    } error:^(NSError * _Nullable error) {
            NSLog(@"%@",error);
    }];
    
}


- (void)signal
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"网络请求中..");
        [subscriber sendNext:@"111"];
        return nil;
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"-----%@",x);
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"-------%@",x);
    }];
}

- (void)tap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [self.view addGestureRecognizer:tap];
    
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        NSLog(@"%@",x);
    }];
}


- (void)addTimerWithCountDown:(NSTimeInterval)countDown
{
   RACDisposable *disposable = [self.timerDic objectForKey:NSStringFromSelector(_cmd)];
    if (disposable) {
        [disposable dispose];
    }
    __block NSTimeInterval coundown = countDown;
    self.disposable = [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        NSLog(@"%@",x);
        coundown --;
        if (coundown == 0) {
            [self.disposable dispose];
        }
    }];
    [self.timerDic setValue:self.disposable forKey: NSStringFromSelector(_cmd)];
}


- (void)timer
{
  self.disposable = [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        NSLog(@"%@",x);
      [self.disposable dispose];
    }];
    

}

- (void)delegate
{
    [[self rac_signalForSelector:@selector(textFieldDidBeginEditing:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        
        NSLog(@"%@",x);
    }];
    
    
    [[self rac_signalForSelector:@selector(textViewDidChange:) fromProtocol:@protocol(UITextViewDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"%@",x);
    }];

    self.textView.delegate = self;
    self.textField.delegate = self;
}

- (void)notification
{
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)targetAction
{
    @weakify(self);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"x:%@",x);
        self.name = @"向金梦";
        
        TestViewController *test = [[TestViewController alloc] init];
        self.testVc = test;
        test.subject = [RACSubject subject];
        @strongify(self);
        [test.subject subscribeNext:^(id  _Nullable x) {
            NSLog(@"按钮被点击了");
        }];
        [self.navigationController pushViewController:[TestViewController new] animated:YES];
    }];
}

- (void)kvo {
//    [RACObserve(self, name) subscribeNext:^(id  _Nullable x) {
//        NSLog(@"x:%@",x);
//    }];
//
    
    [[RACObserve(self, name) distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        NSLog(@"x:%@",x);
    }];
    
    
//    [self addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionOld| NSKeyValueObservingOptionNew context:NULL];
}


//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    NSLog(@"change:%@",change);
//}


- (void)dealloc
{
//    [self removeObserver:self forKeyPath:@"name"];
}
- (void)signalForSelector
{
    [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"xx------%@",x);
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.name = @"songhongkang";
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

- (NSMutableDictionary<NSString *,RACDisposable *> *)timerDic
{
    if (_timerDic == nil) {
        _timerDic = [NSMutableDictionary dictionary];
    }
    return _timerDic;
}

- (ViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [[ViewModel alloc] init];
    }
    return _viewModel;
}
@end
