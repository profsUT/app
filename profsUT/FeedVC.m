#import "FeedVC.h"

#import "Professor.h"
#import "ProfVC.h"

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
  [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
  _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  ProfVC *profVC = [[ProfVC alloc] initWithIndex:indexPath.item];
  [self.navigationController pushViewController:profVC animated:YES];
  [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//- (void)handleTapGesture:(UITapGestureRecognizer *)tap {
//  ProfVC *profVC = [[ProfVC alloc] init];
//  [self.navigationController pushViewController:profVC animated:YES];
//}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_professor.profsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
  
  cell.textLabel.text = _professor.profsArray[indexPath.item];
  
  return cell;
}

@end
