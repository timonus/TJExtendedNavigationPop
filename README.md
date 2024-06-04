# TJExtendedNavigationPop

This project makes it so that you can extend `UINavigationController` to begin a swipe-to-pop gesture anywhere on the screen.

- To extend swipe-to-pop on a single navigation controller, call `tj_extendInteractivePopGestureRecognizer` on it.
- To extend swipe-to-pop on _all_ navigation controllers in your app, call `UINavigationController.tj_extendAllInteractivePopGestureRecognizers`
