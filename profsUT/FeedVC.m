#import "FeedVC.h"

#import "ProfCell.h"
#import "Professor.h"
#import "ProfVC.h"
#import "Util.h"

@import CoreGraphics;

static NSString *kCellIdentifier = @"Cell Identifier";

@implementation FeedVC {
  UITableView *_tableView;
  Professor *_professor;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _professor = [Professor sharedInstance];
    // Set the title for the tab
    self.title = @"Professors";
    // Set the image icon for the tab
    UIImage *tabImage = [UIImage imageNamed:@"profIcon.png"];
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
  
  self.navigationItem.title = @"Professors";
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
  [_tableView registerClass:[ProfCell class] forCellReuseIdentifier:kCellIdentifier];
  [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSDictionary *prof = _professor.profsArray[indexPath.item];
  NSString *profKey = prof[@"id"];
  ProfVC *profVC = [[ProfVC alloc] initWithProfessorKey:profKey];
  [self.navigationController pushViewController:profVC animated:YES];
  [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_professor.profsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 100.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ProfCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
  
  NSDictionary *prof = _professor.profsArray[indexPath.item];
  NSString *first = [Util intoLowerCaseExceptForFirstLetter:prof[@"first"]];
  NSString *last = prof[@"last"];
  NSDictionary *courseDict;
//  NSURL *profPicURL = prof[@"profile_photo"];
//  NSData *data = [NSData dataWithContentsOfURL:profPicURL];
//  UIImage *img = [[UIImage alloc] initWithData:data];


  unsigned long totalCourses = [prof[@"courses"] count];
  NSMutableArray *courseIDs = [[NSMutableArray alloc] init];
  NSMutableArray *courseNames = [[NSMutableArray alloc] init];
  for (unsigned long i = 0; i < totalCourses; i++) {
    NSString *courseID = prof[@"courses"][i][@"courseID"];
    NSString *courseName = prof[@"courses"][i][@"courseName"];
    
    [courseIDs addObject:courseID];
    [courseNames addObject:courseName];
  }
  
  courseDict = [NSDictionary dictionaryWithObjects: courseNames forKeys:courseIDs];
  
  cell = [[ProfCell alloc] initWithFirstName:first
                                    lastName:last
                                     courses:courseDict
                                       image:[UIImage imageNamed:@"quigley.png"]];
  
  return cell;
}

#pragma mark - NSURLConnectionDidFinish
- (void)refresh {
  [_tableView reloadData];
}

@end
