//
//  ClassFeedVC.m
//  profsUT
//
//  Created by Zac Ioannidis on 14/4/15.
//  Copyright (c) 2015 Teacher's Pet. All rights reserved.
//

#import "ClassFeedVC.h"

#import "CourseCell.h"
#import "Course.h"
#import "CourseVC.h"
#import "ProfVC.h"
#import "Util.h"

static NSString *kCellIdentifier = @"Cell Identifier";

@implementation ClassFeedVC {
  UITableView *_tableView;
  Course *_course;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _course = [Course sharedInstance];

    // Set title for the tab
    self.title = @"Courses";
    // Set the image icon for the tab
    UIImage *tabImage = [UIImage imageNamed:@"courseIcon.png"];
    UIImage *scaledImage = [Util imageWithImage:tabImage scaledToSize:CGSizeMake(25,25)];
    self.tabBarItem.image = scaledImage;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
    
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(refresh)
                                               name:@"NSURLConnectionDidFinish"
                                             object:nil];
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  self.navigationItem.title = @"Courses";
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
  self.navigationItem.backBarButtonItem = backButton;
  
  _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  _tableView.showsVerticalScrollIndicator = NO;
  _tableView.contentInset = UIEdgeInsetsMake(0,
                                             0,
                                             self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height,
                                             0);
  [_tableView registerClass:[CourseCell class] forCellReuseIdentifier:kCellIdentifier];
  [self.view addSubview:_tableView];}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//  NSDictionary *course = _course.coursesArray[indexPath.item];
  
  NSDictionary *course = _course.coursesArray[indexPath.item];
  NSString *courseID = course[@"courseID"];
  NSString *courseName = course[@"courseName"];
  NSString *courseKey = course[@"id"];
  NSLog(@"%@", courseKey);
  
  NSString *profFirst = [[course valueForKey:@"instructor"] valueForKey:@"first"];
  NSString *profLast = [[course valueForKey:@"instructor"] valueForKey:@"last"];
  NSString *profName = [NSString stringWithFormat:@"%@, %@", profLast, profFirst];

  CourseVC *courseVC = [[CourseVC alloc] initWithCourseID:(NSString *)courseID
                                               courseName:(NSString *)courseName
                                                courseKey:(NSString *)courseKey
                                                 profName:(NSString *)profName];
  [self.navigationController pushViewController:courseVC animated:YES];
  [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_course.coursesArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 80.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  CourseCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
  
  NSDictionary *course = _course.coursesArray[indexPath.item];
  NSString *courseID = course[@"courseID"];
  NSString *courseName = course[@"courseName"];

  
  NSString *first = [Util intoLowerCaseExceptForFirstLetter:[[course valueForKey:@"instructor"] valueForKey:@"first"]];
  
  NSString *profFirst = first;
  NSString *profLast = [[course valueForKey:@"instructor"] valueForKey:@"last"];
  
  // Initialize custom CourseCell here
  cell = [[CourseCell alloc] initWithCourseID: courseID
                                   courseName: courseName
                                profFirstName: profFirst
                                 profLastName: profLast];
  
//  cell = [[ProfCell alloc] initWithFirstName:first
//                                    lastName:last
//                                     courses:courseDict
//                                       image:[UIImage imageNamed:@"quigley.png"]];
//  
  return cell;
}

#pragma mark - NSURLConnectionDidFinish
- (void)refresh {
  [_tableView reloadData];
}

@end
