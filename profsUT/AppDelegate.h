#import <UIKit/UIKit.h>

#import "TabBarController.h"
#import "FeedVC.h"
#import "ClassFeedVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TabBarController *tabBarController;

@property (strong, nonatomic) FeedVC *firstViewController;
@property (strong, nonatomic) ClassFeedVC *secondViewController;


@end

