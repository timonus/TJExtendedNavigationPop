//
//  UINavigationController+TJAdditions.h
//  OpenerCore
//
//  Created by Tim Johnsen.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (TJExtendedNavigationPop)

+ (void)tj_extendAllInteractivePopGestureRecognizers; // TODO: Make direct
- (void)tj_extendInteractivePopGestureRecognizer __attribute__((objc_direct));

@end

NS_ASSUME_NONNULL_END
