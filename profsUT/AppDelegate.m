#import "AppDelegate.h"

//#import "FeedVC.h"
//#import "ClassFeedVC.h"
//#import "TabBarController.h"
#import "Constants.h"
#import "UIColor+profsUT.h"

@interface AppDelegate ()
@property (nonatomic, assign) BOOL landscapeOnlyOrientation;
@end

@implementation AppDelegate


@synthesize tabBarController;
@synthesize firstViewController, secondViewController, thirdViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//  self.landscapeOnlyOrientation = NO;
  
  self.window.backgroundColor = [UIColor whiteColor];
  
  // Tab bar stuff
  self.firstViewController = [[FeedVC alloc] init];
  self.secondViewController = [[ClassFeedVC alloc] init];
//  self.thirdViewController = [[ProfVC alloc] init];
  
  NSArray *myViewControllers = [[NSArray alloc] initWithObjects:
                                self.firstViewController,
                                self.secondViewController, nil];
  
  
  // Initialize the tab bar controller
  self.tabBarController = [[TabBarController alloc] init];
  
  // Set the view controllers for the tab bar controller
  [self.tabBarController setViewControllers:myViewControllers];
  
  // Add the tab bar controllers view to the window
  [self.window addSubview:self.tabBarController.view];
  // End tab bar stuff
  
//  ClassFeedVC *feedVC = [[ClassFeedVC alloc] init];
//  UINavigationController *navController =
//      [[UINavigationController alloc] initWithRootViewController:feedVC];
  UINavigationController *navController =
  [[UINavigationController alloc] initWithRootViewController:tabBarController];
  UINavigationBar *navBar = navController.navigationBar;
  navBar.barTintColor = [UIColor burntOrangeColor];
  navBar.tintColor = [UIColor whiteColor];
  navBar.translucent = NO;
  navBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                 NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:kNavFontSize]};
  self.window.rootViewController = navController;
  
  [self.window makeKeyAndVisible];
  

  
//  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerWillEnterFullscreenNotification:) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
//  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerWillExitFullscreenNotification:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
  return YES;
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
  
  return UIInterfaceOrientationMaskPortrait;
}
//
//-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
//  if (self.landscapeOnlyOrientation) {
//    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
//  }
//  return UIInterfaceOrientationMaskPortrait;
//}
//
//- (void)moviePlayerWillEnterFullscreenNotification:(NSNotification*)notification {
//  self.landscapeOnlyOrientation = YES;
//}
//
//- (void)moviePlayerWillExitFullscreenNotification:(NSNotification*)notification {
//  self.landscapeOnlyOrientation = NO;
//}


- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
