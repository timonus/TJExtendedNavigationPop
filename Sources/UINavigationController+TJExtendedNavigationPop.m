//
//  UINavigationController+TJAdditions.m
//  OpenerCore
//
//  Created by Tim Johnsen.
//

#import "UINavigationController+TJExtendedNavigationPop.h"
#import <objc/runtime.h>

@interface TJExtendedInteractivePopGestureRecognizer : UIPanGestureRecognizer <UIGestureRecognizerDelegate>

- (instancetype)initWithTarget:(id)target action:(SEL)action NS_UNAVAILABLE;
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController NS_DESIGNATED_INITIALIZER;
@property (nullable,nonatomic,weak) id <UIGestureRecognizerDelegate> delegate NS_UNAVAILABLE;

@end

__attribute__((objc_direct_members))
@implementation TJExtendedInteractivePopGestureRecognizer {
    UINavigationController *__weak _navigationController;
}

@dynamic delegate;

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
{
    if (self = [super initWithTarget:nil action:nil]) {
        [super setDelegate:self];
        _navigationController = navigationController;
        
        self.maximumNumberOfTouches = 1; // https://github.com/jaredsinclair/JTSSloppySwiping/blob/master/JTSSloppySwiping/JTSSloppySwiping.swift#L88
        
        NSString *const str = [NSString stringWithFormat:@"%car%@t%s", 't', @"ge", "s"]; // "targets"
        [self setValue:[navigationController.interactivePopGestureRecognizer valueForKey:str]
                forKey:str];
        
        // Trying to fix "flash" bug
        // https://bit.ly/3Fa97cf
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // Starting a tap on bar button items when the nav controller is at root, then dragging out, then attempting to tap the nav bar button is broken due to this GR. Don't recognize unless we need to!
    return (!_navigationController.interactivePopGestureRecognizer.delegate || ([_navigationController.interactivePopGestureRecognizer.delegate respondsToSelector:@selector(gestureRecognizerShouldBegin:)] && [_navigationController.interactivePopGestureRecognizer.delegate gestureRecognizerShouldBegin:_navigationController.interactivePopGestureRecognizer])) && _navigationController.viewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // Fixes cells with swipable actions.
    if ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer.view isKindOfClass:[UITableView class]] && [(UITableView *)otherGestureRecognizer.view panGestureRecognizer] != otherGestureRecognizer) {
        return YES;
    }
    return NO;
}

@end

@implementation UINavigationController (TJExtendedNavigationPop)

+ (void)tj_extendAllInteractivePopGestureRecognizers
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#if !defined(__IPHONE_14_0) || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_14_0
        if (@available(iOS 14.0, *))
#endif
        {
            if ([[NSProcessInfo processInfo] isiOSAppOnMac]) {
                return;
            }
        }
        Class class = [UINavigationController class];
        SEL originalSelector = @selector(viewDidLoad);
        SEL swizzledSelector = @selector(tj_viewDidLoad);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    });
}

- (void)tj_extendInteractivePopGestureRecognizer
{
#if !defined(__IPHONE_14_0) || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_14_0
    if (@available(iOS 14.0, *))
#endif
    {
        if ([[NSProcessInfo processInfo] isiOSAppOnMac]) {
            return;
        }
    }
    for (UIGestureRecognizer *const gestureRecognizer in self.view.gestureRecognizers) {
        if ([gestureRecognizer isKindOfClass:[TJExtendedInteractivePopGestureRecognizer class]]) {
            return;
        }
    }
    TJExtendedInteractivePopGestureRecognizer *pan = [[TJExtendedInteractivePopGestureRecognizer alloc] initWithNavigationController:self];
    [self.view addGestureRecognizer:pan];
}

- (void)tj_viewDidLoad
{
    [self tj_viewDidLoad];
    [self tj_extendInteractivePopGestureRecognizer];
}

@end
