#import "ProfVC.h"

@implementation ProfVC

- (void)viewDidLoad {
  self.view.backgroundColor = [UIColor blueColor];
  UITapGestureRecognizer *tap =
  [[UITapGestureRecognizer alloc] initWithTarget:self
                                          action:@selector(handleTapGesture:)];
  [self.view addGestureRecognizer:tap];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tap {
  [self.navigationController popViewControllerAnimated:YES];
}

@end
