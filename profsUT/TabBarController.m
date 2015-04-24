//
//  TabBarController.m
//  profsUT
//
//  Created by Zac Ioannidis on 15/4/15.
//  Copyright (c) 2015 Teacher's Pet. All rights reserved.
//

#import "TabBarController.h"
#import "Constants.h"
#import "UIColor+profsUT.h"
#import "Util.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.title = @"profsUT";
  CGRect frame = CGRectMake(0.0, -1.0, self.view.bounds.size.width, 50);
  UIView *v = [[UIView alloc] initWithFrame:frame];
  [v setBackgroundColor:[UIColor burntOrangeColor]];
  [v setAlpha:1];
  [[self tabBar] addSubview:v];
  
  //set the tab bar title appearance for normal state
  [[UITabBarItem appearance]
   setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                            NSFontAttributeName:[UIFont fontWithName:@"Copse" size:14.0f]}
   forState:UIControlStateNormal];
  
  //set the tab bar title appearance for selected state
  [[UITabBarItem appearance]
   setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor],
                             NSFontAttributeName:[UIFont fontWithName:@"Copse" size:14.0f]}
   forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
