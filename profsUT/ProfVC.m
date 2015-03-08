#import "ProfVC.h"

#import "Constants.h"
#import "Professor.h"
@import MediaPlayer;

@implementation ProfVC {
  UIScrollView *_scrollView;
  NSInteger _index;
}

- (instancetype)initWithIndex:(NSInteger)index {
  self = [super init];
  if (self) {
    _index = index;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  CGFloat yEdge;
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  Professor *p = [Professor sharedInstance];
  
  self.navigationItem.title = p.profsArray[_index];
  
  _scrollView = [[UIScrollView alloc] init];
  _scrollView.frame = self.view.frame;
  _scrollView.showsVerticalScrollIndicator = NO;
//  _scrollView.bounces = NO;
  [self.view addSubview:_scrollView];
  
  UILabel *nameLabel = [[UILabel alloc] init];
  nameLabel.text = p.profsArray[_index];
  nameLabel.font = [UIFont fontWithName:@"Helvetica" size:kH1FontSize];
  [nameLabel sizeToFit];
  nameLabel.frame = CGRectMake(15.0, 20.0, nameLabel.bounds.size.width, nameLabel.bounds.size.height);
  [_scrollView addSubview:nameLabel];
  
  yEdge = nameLabel.frame.origin.y + nameLabel.frame.size.height;
  
  NSString *path = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"mov"];
  MPMoviePlayerController *player =
      [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
  player.view.frame = CGRectMake(15.0, yEdge + 15.0, self.view.bounds.size.width - 30.0, 200);
  [_scrollView addSubview:player.view];
  
  yEdge = player.view.frame.origin.y + player.view.frame.size.height;
  
  UILabel *bioLabel = [[UILabel alloc] init];
  bioLabel.text = @"Bio";
  bioLabel.font = [UIFont fontWithName:@"Helvetica" size:kH2FontSize];
  [bioLabel sizeToFit];
  bioLabel.frame = CGRectMake(15.0, yEdge + 20.0, bioLabel.bounds.size.width, bioLabel.bounds.size.height);
  [_scrollView addSubview:bioLabel];
  
  yEdge = bioLabel.frame.origin.y + bioLabel.frame.size.height;
  
  UITextView *bioText = [[UITextView alloc] init];
  bioText.text = @"Robert Quigley, a senior lecturer who focuses on new media, is a 16-year veteran of the print journalism industry. In the last few years of his newspaper career, he helped the Austin American-Statesman reach national prominence with its use of new media and social media.";
  bioText.font = [UIFont fontWithName:@"Helvetica" size:kPFontSize];
  bioText.scrollEnabled = NO;
  bioText.editable = NO;
  CGSize newSize = [bioText sizeThatFits:CGSizeMake(self.view.bounds.size.width - 30.0, MAXFLOAT)];
  bioText.frame = CGRectMake(15.0, yEdge + 10.0, self.view.bounds.size.width - 30.0, newSize.height);
  bioText.textContainer.lineFragmentPadding = 0;
  bioText.textContainerInset = UIEdgeInsetsZero;
  [_scrollView addSubview:bioText];
  
  yEdge = bioText.frame.origin.y + bioText.frame.size.height;
  
  UILabel *courseLabel = [[UILabel alloc] init];
  courseLabel.text = @"Courses";
  courseLabel.font = [UIFont fontWithName:@"Helvetica" size:kH2FontSize];
  [courseLabel sizeToFit];
  courseLabel.frame = CGRectMake(15.0, yEdge, courseLabel.bounds.size.width, courseLabel.bounds.size.height);
  [_scrollView addSubview:courseLabel];

  yEdge = courseLabel.frame.origin.y + courseLabel.frame.size.height;
  
  UILabel *DEMO1 = [[UILabel alloc] init];
  DEMO1.text = @"J 336F - Social Media Journalism";
  DEMO1.font = [UIFont fontWithName:@"Helvetica" size:kPFontSize];
  [DEMO1 sizeToFit];
  DEMO1.frame = CGRectMake(15.0, yEdge + 10.0, DEMO1.bounds.size.width, DEMO1.bounds.size.height);
  [_scrollView addSubview:DEMO1];
  
  yEdge = DEMO1.frame.origin.y + DEMO1.frame.size.height;
  
  UILabel *DEMO2 = [[UILabel alloc] init];
  DEMO2.text = @"J 339G - Mobile News App Design";
  DEMO2.font = [UIFont fontWithName:@"Helvetica" size:kPFontSize];
  [DEMO2 sizeToFit];
  DEMO2.frame = CGRectMake(15.0, yEdge + 10.0, DEMO2.bounds.size.width, DEMO2.bounds.size.height);
  [_scrollView addSubview:DEMO2];
  
  yEdge = DEMO2.frame.origin.y + DEMO2.frame.size.height;
  
//  UIView *test = [[UIView alloc] initWithFrame:CGRectMake(0, yEdge, self.view.bounds.size.width, 1)];
//  test.layer.borderColor = [[UIColor blackColor] CGColor];
//  test.layer.borderWidth = 1.0f;
//  [_scrollView addSubview:test];
  
//  _scrollView.layer.borderColor = [[UIColor redColor] CGColor];
//  _scrollView.layer.borderWidth = 2.0f;
  
  _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, yEdge + [self.navigationController navigationBar].frame.size.height + 40);
}

@end
