//
//  ViewController.m
//  TestForTffFont
//
//  Created by new on 16-4-29.
//  Copyright (c) 2016年 new. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "NSObject+Name.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface ViewController ()
{
    UIImageView *scanLineIV;
    CALayer *myLayer;
}
@end

@implementation ViewController

@synthesize tffLabel = tffLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // 打印所有字体类型
    /*for(NSString *fontfamilyname in [UIFont familyNames])
    {
        NSLog(@"family:'%@'",fontfamilyname);
        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
        {
            NSLog(@"\tfont:'%@'",fontName);
        }
        NSLog(@"-------------");
    }*/
    // 测试使用新字体
    tffLabel.text = @"Don't Starve";
    tffLabel.textAlignment = NSTextAlignmentCenter;
    tffLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tffLabel.numberOfLines = 0;
    tffLabel.font = [UIFont fontWithName:@"AmaticSC-Regular" size:26];
    
    
    // test For runtime
 
    // 获取两个类的类方法
    Method method1 = class_getClassMethod([Person class], @selector(play));
    Method method2 = class_getClassMethod([Person class], @selector(study));
    // 交换方法实现
    method_exchangeImplementations(method2, method1);
    
    [Person play];
    [Person study];

    // 测试target场景下，categor文件漏勾选导致应用崩溃。
    [Person testForCategory];
    
    [self testForRunTimeFunction];
    
    // test for Animation
    scanLineIV = [[UIImageView alloc] initWithFrame:CGRectMake(100, 300, 48, 48)];
    scanLineIV.center = CGPointMake(self.view.frame.size.width/2, scanLineIV.center.y);
    [scanLineIV setImage:[UIImage imageNamed:@"greenDot.png"]];
    [self.view addSubview:scanLineIV];
    [self addAnimate];
    [self addLayerAnimate];
    [self addKeyFrameAnimation];
    [self addTransitionAnimation];
    
}

#pragma mark - TestForRuntime
- (void)testForRunTimeFunction {
    Person *person = [[Person alloc] init];
    // 1. 动态变量控制
    unsigned int count;
    // 获取Person类中的所有属性
    Ivar *ivar = class_copyIvarList([person class], &count);
    for (int i = 0; i < count; i++) {
        // 遍历Person类中所有属性
        Ivar var = ivar[i];
        const char *propertyName = ivar_getName(var);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        if ([name isEqual:@"_gender"]) {
            object_setIvar(person, var, @"male");
            break;
        }
    }
    NSLog(@"person's gender is :%@",person.gender);
    // 添加方法addMethod
    // (IMP)guessAnswer 意思是guessAnswer的地址指针;
    // "v@:" 意思是，v代表无返回值void，如果是i则代表int；@代表 id sel; : 代表 SEL _cmd;
    // “v@:@@” 意思是，两个参数的没有返回值。
    class_addMethod([Person class], @selector(addMethod), (IMP)newMethod, "v@:");
    Method *methodList = class_copyMethodList([person class], &count);
    for (int i = 0; i < count; i++) {
        SEL currentSel = method_getName(methodList[i]);
        NSString *string = NSStringFromSelector(currentSel);
        NSLog(@"person's method :%@",string);
    }
}

void newMethod(id self, SEL _cmd) {
    NSLog(@"add new method to Person class");
}

#pragma mark - TestForAnimation
- (void)addAnimate {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    //        animation.fromValue = @(0);
    animation.toValue = [NSNumber numberWithFloat:240-24];
    animation.duration = 2.0;
    animation.autoreverses = YES;
    animation.repeatCount = FLT_MAX;
    [scanLineIV.layer addAnimation:animation forKey:@"transform"];
}

- (void)addLayerAnimate {
    CALayer *layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, 48, 48);
    layer.position = CGPointMake(200, 200);
    layer.cornerRadius = 24;
//    layer.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.2].CGColor;
    layer.contents = (id)[UIImage imageNamed:@"greenDot.png"].CGImage;
    [self.view.layer addSublayer:layer];
    myLayer = layer;
}

- (void)addKeyFrameAnimation {
    /* 
    // backgroundcolor
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"backgroundColor"];
    animation.values = @[(id)myLayer.backgroundColor,(id)[UIColor redColor].CGColor,(id)[UIColor blueColor].CGColor,(id)[UIColor greenColor].CGColor];
    //关键帧value和time对应，第一个开始时间，运动下一个地址的时间。（总时间乘以时间比）
    animation.keyTimes = @[@0,@0.3,@0.5,@0.8];
    animation.duration = 2;
    animation.repeatCount = CGFLOAT_MAX;
    animation.autoreverses = YES;
    [myLayer addAnimation:animation forKey:nil];*/
    
    /*
    // position
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue *value0 = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(200, 100)];
    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(200, 200)];
    NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(100, 200)];
    NSValue *value4 = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
    animation.values = @[value0,value1,value2,value3,value4];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = 4;
    // 设置动画的节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = CGFLOAT_MAX;
    [myLayer addAnimation:animation forKey:nil];*/
    
    /*
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, nil, CGRectMake(50, 50, 100, 300));
    animation.path = path;
    CGPathRelease(path);
    animation.duration = 2;
    animation.repeatCount = CGFLOAT_MAX;
    [myLayer addAnimation:animation forKey:nil];*/
    
    // 抖动
    /*CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration = 0.1;
    CGFloat angle = 0.08/M_PI_2;
    NSNumber *number = [NSNumber numberWithFloat:angle];
    NSNumber *num = [NSNumber numberWithFloat:-0.08/M_PI_2];
    animation.values = @[num,number,num];
    animation.duration = 0.25;
    animation.repeatCount = MAXFLOAT;
    animation.autoreverses = YES;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [myLayer addAnimation:animation forKey:nil];*/
    
    // 以某点为圆心旋转
//    CAKeyframeAnimation *orbit = [CAKeyframeAnimation animation];
//    orbit.keyPath = @"position";
//    orbit.path = CFAutorelease(CGPathCreateWithEllipseInRect(CGRectMake(0, 0, 100, 100), NULL));
//    orbit.duration = 4;
//    orbit.additive = YES;
//    orbit.repeatCount = HUGE_VALF;
//    orbit.calculationMode = kCAAnimationPaced;
//    orbit.rotationMode = kCAAnimationRotateAuto;
//    [myLayer addAnimation:orbit forKey:@"orbit"];
    
    // 自转360
    CABasicAnimation * transformAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    transformAnim.toValue = @(360 * M_PI/180);
    transformAnim.duration = 4;
    transformAnim.fillMode = kCAFillModeBoth;
    transformAnim.repeatCount = MAXFLOAT;
    [myLayer addAnimation:transformAnim forKey:@"transformAnim"];
}

- (void)addTransitionAnimation {
    CATransition *animation=[CATransition animation];
    animation.duration=0.8;
    animation.type=@"rippleEffect";
    UIImage *image=[UIImage imageNamed:@"star.png"];
    
    [myLayer setContents:(id)image.CGImage];
    [myLayer addAnimation:animation forKey:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
