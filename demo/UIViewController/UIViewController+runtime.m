//
//  UIViewController+runtime.m
//
//  Created by wangkan on 17/10/13.
//

#import "UIViewController+runtime.h"
#import <objc/runtime.h>

const  char *viewDidAppearTimeIntervalKey = "viewDidAppearTimeIntervalKey";


/**
 UIViewController Category 执行 swizzle 方法
 用分类为类添加方法（Add Methods to Classes）
 
 通过在interface中声明一个额外的方法并且在implementation 中定义相同名字的方法即可。
 分类的名字（也就是括号括起来的CustomView）表示的是：对于声明于其他地方的这个类（UIViewController），在此处添加的方法是额外的，而不是表示这是一个新的类。
 Category包含类的所有成员变量，即使是@private的。
 Category可以重新定义新方法，也可以override继承过来的方法。
 类添加新的成员变量时必须实现set方法。
 */
@implementation UIViewController (runtime)

static NSString *logTag = @"";

/**
 load 调用时机
 - 对于加入运行期系统的每个类以及它的分类来说,必定会调用此方法,而且只会被调用一次,通常是在应用程序启动的时候,执行时机在main函数之前!并且先调用父类的+load再调用子类的.
 - 如果分类Category中也实现了该方法,那么先调用本类的再调用分类的。
 - 如果两个没有继承关系的类都实现了+load方法,那么它的调用顺序取决于谁先被加到运行期环境中.
 
 在+load的调用时机,系统还处于”脆弱”状态,虽然系统的库已经被加载进运行期系统,但是我们自己编写的类,或者引用的其他的类库中的类不一定已经可以使用,所以在+load中要尽量避免初始化其他的对象.
 
 +load方法不像普通的方法那样遵循继承规则,如果一个类本身没有实现+load方法,那么无论其各级超类是否实现此方法系统都不会调动.这句话应该这样理解:正常我们给一个对象或者类发消息,如果这个对象(或类)本身没有实现该方法,那么系统会通过isa指针找到父类的实现.但是+load方法不同,子类如果没有实现该方法那么也不会去父类中找.也就是说你实现了系统就调用,你没实现就算了.但是如果在+load中显式的调用[super load];那么就会去调用父类方法了.
 
 在+load方法中的实现务必精简,尽量减少里面所执行的操作,因为整个应用在执行+load方法时都会阻塞,如果在+load中进行繁杂的代码,那么应用程序在执行期间就会变得无响应,不要调用可能会加锁的方法.实际上但凡是通过+load方法实现的某些任务,基本上都做得不对,真正的用途仅在于调试程序,比如可以再分类中实现+load来看该分类是否已经正确载入系统中.
 */
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelectorVWA = @selector(viewWillAppear:);
        SEL swizzleSelectorVWA = @selector(swizzleViewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelectorVWA);
        Method swizzledMethod = class_getInstanceMethod(class, swizzleSelectorVWA);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelectorVWA,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzleSelectorVWA,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
    
    SEL systemDidAppearSel = @selector(viewDidAppear:);
    SEL customDidAppearSel = @selector(swizzleViewDidAppear:);
    [UIViewController swizzleSystemSel:systemDidAppearSel implementationCustomSel:customDidAppearSel];
    
    SEL sysDidDisappearSel =@selector(viewDidDisappear:);
    SEL customwDidDisappearSel =@selector(swizzleViewDidDisappear:);
    [UIViewController swizzleSystemSel:sysDidDisappearSel implementationCustomSel:customwDidDisappearSel];
}

+ (void)swizzleSystemSel:(SEL)systemSel implementationCustomSel:(SEL)customSel
{
    Class cls = [self class];
    Method systemMethod =class_getInstanceMethod(cls, systemSel);
    Method customMethod =class_getInstanceMethod(cls, customSel);
    
    /// BOOL class_addMethod(Class cls, SEL name, IMP imp,const char *types) cls被添加方法的类，name: 被增加Method的name, imp 被添加的Method的实现函数，types被添加Method的实现函数的返回类型和参数的字符串
    BOOL didAddMethod =class_addMethod(cls, systemSel, method_getImplementation(customMethod), method_getTypeEncoding(customMethod));
    if (didAddMethod)
    {
        class_replaceMethod(cls, customSel, method_getImplementation(systemMethod), method_getTypeEncoding(customMethod));
    }
    else
    {
        method_exchangeImplementations(systemMethod, customMethod);
    }
}

- (void)swizzleViewWillAppear:(BOOL )animated
{
    NSString *className = [NSString stringWithFormat:@"%@", self.class];
    if ([className containsString:@"MOL"]) {
        if ([className rangeOfString:@"UIAlert"].location == NSNotFound) {
            NSLog(@"************************ viewDidLoad : %-35s ************************", className.UTF8String);
        }
    }
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden: self.interactiveNavigationBarHidden animated:animated];
    }
    [self swizzleViewWillAppear:animated];
}

- (void)swizzleViewDidAppear:(BOOL )animated
{
    NSLog(@" class =%@ 访问一次 在这里实现用户统计用埋点\n",[self class] );
    
    [self setDate:[NSDate new]];
    NSLog(@"访问时间 ＝%@",[self date]);
    
    [self swizzleViewDidAppear:animated];
}

- (void)swizzleViewDidDisappear:(BOOL )animated
{
    [self swizzleViewDidDisappear:animated];
    NSDate  *date=[NSDate new];
    NSLog(@"访问时间%@  离开时间＝%@ \n ", date,self.date);
    NSLog(@"%@访问时间TimeInterval ＝%f秒", [self class],[date timeIntervalSinceDate:self.date]);
}

/**
 GET interactiveNavigationBarHidden

 @return BOOL
 */
- (BOOL)interactiveNavigationBarHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

/**
 SET interactiveNavigationBarHidden
 
 @param hidden 是否隐藏
 */
- (void)setInteractiveNavigationBarHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, @selector(interactiveNavigationBarHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDate *)date
{
    return  objc_getAssociatedObject(self, viewDidAppearTimeIntervalKey);
}

- (void)setDate:(NSDate *)date
{
    objc_setAssociatedObject(self, viewDidAppearTimeIntervalKey, date, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


/**
 将VC层级输出到log

 @param level vc层级
 */
- (void)logWithLevel:(NSUInteger)level
{
    NSString *paddingItems = @"";
    for (NSUInteger i = 0; i<=level; i++)
    {
        paddingItems = [paddingItems stringByAppendingFormat:@"--"];
    }
    
    NSLog(@"%@%@-> %@", logTag, paddingItems, [self.class description]);
}

/**
 获取parentViewController的层级
 */
- (void)printPath
{
    if ([self parentViewController] == nil)
    {
        [self logWithLevel:0];
    }
    else if([[self parentViewController] isMemberOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = (UINavigationController *)[self parentViewController];
        NSInteger integer = [[nav viewControllers] indexOfObject:self];
        [self logWithLevel:integer];
    }
    else if ([[self parentViewController] isMemberOfClass:[UITabBarController class]])
    {
        [self logWithLevel:1];
    }
}

@end


