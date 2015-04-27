#import "MainNavigationController.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate
{
  return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
  if ([[[self.viewControllers lastObject] presentedViewController] isKindOfClass:[MoviePlayerController class]])
  {
    return UIInterfaceOrientationMaskAll;
  }
  else
  {
    return UIInterfaceOrientationMaskPortrait;
  }
  
}
@end
