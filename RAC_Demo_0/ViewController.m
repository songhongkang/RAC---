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
#import <ReactiveObjC/ReactiveObjC.h>

@interface ViewController () <UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) RACDisposable *disposable;
@property (nonatomic, strong) NSMutableDictionary <NSString *,RACDisposable *>*timerDic;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self test1];
    [self test2];
    
//    NSLog(@"1111");
    [self kvo];
    [self targetAction];
    [self notification];
    [self delegate];
    [self tap];
    [self timer];
    [self signalForSelector];
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
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"x:%@",x);
    }];
}

- (void)kvo {
    [RACObserve(self, name) subscribeNext:^(id  _Nullable x) {
        NSLog(@"x:%@",x);
    }];
    
    [self addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionOld| NSKeyValueObservingOptionNew context:NULL];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
   
}

- (void)signalForSelector
{
    [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"xx------%@",x);
    }];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"name"];
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
@end
