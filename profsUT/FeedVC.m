#import "FeedVC.h"

#import "ProfCell.h"
#import "Professor.h"
#import "ProfVC.h"
#import "Util.h"

static NSString *kCellIdentifier = @"Cell Identifier";

@implementation FeedVC {
  UITableView *_tableView;
  Professor *_professor;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _professor = [Professor sharedInstance];
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
  
  self.navigationItem.title = @"profsUT";
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
  ProfVC *profVC = [[ProfVC alloc] initWithDictionary:prof];
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
  NSString *first = prof[@"first"];
  NSString *last = [Util intoLowerCaseExceptForFirstLetter:prof[@"last"]];
  NSDictionary *courseDict = prof[@"courses"];
  NSMutableArray *courses = [[NSMutableArray alloc] init];
    for(NSString *course in courseDict) {
        NSLog(@"%@, %@", last, course);
    }

  
  for (NSString *course in courseDict) {
    NSString *courseID = course;
    [courses addObject:courseID];
  }
  
  cell = [[ProfCell alloc] initWithFirstName:first
                                    lastName:last
                                     courses:courses
                                       image:[UIImage imageNamed:@"quigley.png"]];
  
  return cell;
}

#pragma mark - NSURLConnectionDidFinish
- (void)refresh {
  [_tableView reloadData];
}

@end
