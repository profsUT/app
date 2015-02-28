#import "FeedVC.h"

#import "ProfCell.h"
#import "ProfVC.h"

static NSString *kCellIdentifier = @"Cell Identifier";

@implementation FeedVC {
  UITableView *_tableView;
}

- (void)viewDidLoad {
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
  [self.view addSubview:_tableView];
  
  UITapGestureRecognizer *tap =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handleTapGesture:)];
  [self.view addGestureRecognizer:tap];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tap {
  ProfVC *profVC = [[ProfVC alloc] init];
  [self.navigationController pushViewController:profVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ProfCell *cell = (ProfCell *)[_tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
  // THIS DOESN'T WORK YET
  return cell;
}

@end
