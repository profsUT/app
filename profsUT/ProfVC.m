#import "ProfVC.h"
#import "CourseVC.h"

#import "Professor.h"
#import "Constants.h"
#import "Util.h"
#import "CourseCell.h"

@import MediaPlayer;

static CGFloat leftPadding = 15.0;
static CGFloat rightPadding = 15.0;
static CGFloat topPadding = 10.0;
static CGFloat sectionBreak = 20.0;
static CGFloat cellHeight = 50.0;

static NSString *kCellIdentifier = @"Cell Identifier";

@implementation ProfVC {
  UIScrollView *_scrollView;
  UITableView *_tableView;
  NSInteger _index;
  NSDictionary *_prof;
  
  NSString *_first;
  NSString *_last;
  NSMutableArray *_courses;
  
  NSDictionary *_courseDict;
  NSMutableArray *courseCode;
  NSMutableArray *_courseNames;
  
  CGFloat yEdge;
}

- (instancetype)initWithDictionary:(NSDictionary *)prof {
  self = [super init];
  if (self) {
    _courses = [[NSMutableArray alloc] init];
    courseCode = [[NSMutableArray alloc] init];
    _courseNames = [[NSMutableArray alloc] init];
    
    _prof = prof;
    
    _first = _prof[@"first"];
    _last = [Util intoLowerCaseExceptForFirstLetter:_prof[@"last"]];

    unsigned long totalCourses = [_prof[@"courses"] count];
    for (unsigned long i = 0; i < totalCourses; i++) {
      NSString *courseID = _prof[@"courses"][i][@"courseID"];
      NSString *courseName = _prof[@"courses"][i][@"courseName"];
      NSString *course = [NSString stringWithFormat:@"%@: %@", courseID, courseName];
      
      [_courses addObject:course];
      [courseCode addObject:courseID];
      [_courseNames addObject:courseName];

    }
    
    _courseDict = [NSDictionary dictionaryWithObjects: _courseNames forKeys:courseCode];

    
  }
  return self;
}


// To-Do Access HLS video from our back-end
-(void)playVideoFromURL {
  
  NSLog(@"Called playVideoFromURL\n");
//  NSString *path = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"mov"];
  NSURL *streamURL = [NSURL URLWithString:@"https://s3.amazonaws.com/django-profs-prod/video/hls/5.m3u8"];
//  _moviePlayer =  [[MPMoviePlayerController alloc]
//                   initWithContentURL:[NSURL fileURLWithPath:path]];
  _moviePlayer = [[MPMoviePlayerController alloc]
                  initWithContentURL:streamURL];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(moviePlayBackDidFinish:)
                                               name:MPMoviePlayerPlaybackDidFinishNotification
                                             object:_moviePlayer];
  
  _moviePlayer.view.frame = CGRectMake(leftPadding, yEdge,
                                  self.view.bounds.size.width - 30.0, 200);
  _moviePlayer.controlStyle = MPMovieControlStyleDefault;
  _moviePlayer.shouldAutoplay = NO;
  [_scrollView addSubview:_moviePlayer.view];
  [_moviePlayer setFullscreen:YES animated:YES];
  yEdge += _moviePlayer.view.frame.size.height + sectionBreak;
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
  MPMoviePlayerController *player = [notification object];
  [[NSNotificationCenter defaultCenter]
   removeObserver:self
   name:MPMoviePlayerPlaybackDidFinishNotification
   object:player];
  
  if ([player
       respondsToSelector:@selector(setFullscreen:animated:)])
  {
//    [player.view removeFromSuperview];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  //  [self playVideoWithId:@"sLVGweQU7rQ"];
  
  // Position video on view
  
//  CGFloat yEdge;
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  self.navigationItem.title = _last;
  
  _scrollView = [[UIScrollView alloc] init];
  _scrollView.frame = self.view.frame;
  _scrollView.showsVerticalScrollIndicator = NO;
  [self.view addSubview:_scrollView];
  
  yEdge = sectionBreak;
  
  
  UILabel *nameLabel = [[UILabel alloc] init];
  nameLabel.text = [NSString stringWithFormat:@"%@ %@", _first, _last];
  nameLabel.font = [UIFont fontWithName:@"Copse" size:kH1FontSize];
  [nameLabel sizeToFit];
  nameLabel.frame = CGRectMake(leftPadding, yEdge,
                               nameLabel.bounds.size.width, nameLabel.bounds.size.height);
  [_scrollView addSubview:nameLabel];
  
  yEdge += nameLabel.frame.size.height + topPadding;
  
  [self playVideoFromURL];
    
  
  UILabel *courseLabel = [[UILabel alloc] init];
  courseLabel.text = @"Courses";
  courseLabel.font = [UIFont fontWithName:@"Copse" size:kH2FontSize];
  [courseLabel sizeToFit];
  courseLabel.frame = CGRectMake(15.0, yEdge, courseLabel.bounds.size.width, courseLabel.bounds.size.height);
  [_scrollView addSubview:courseLabel];

  yEdge += courseLabel.frame.size.height + topPadding;
  
//  int currentIdx = 0; // Keep track of current index
//  for (NSString *course in _courseDict) {
//
//    NSString *courseName = [_courseDict objectForKey:course];
//    UILabel *courseIDLabel = [[UILabel alloc] init];
//
//    courseIDLabel.numberOfLines = 0;
//    courseIDLabel.text = [NSString stringWithFormat:@"%@", course];
//    courseIDLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:kPFontSize];
//    [courseIDLabel sizeToFit];
//    courseIDLabel.frame = CGRectMake(15.0, yEdge,
//                                   courseIDLabel.bounds.size.width, courseIDLabel.bounds.size.height);
//    [_scrollView addSubview:courseIDLabel];
//    
//    yEdge += courseIDLabel.frame.size.height;
//    
//    UILabel *courseNameLabel = [[UILabel alloc] init];
//    courseNameLabel.text = courseName;
//    courseNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:kPFontSize];
//    [courseNameLabel sizeToFit];
//    courseNameLabel.frame = CGRectMake(15.0, yEdge,
//                                     courseNameLabel.bounds.size.width, courseNameLabel.bounds.size.height);
//    [_scrollView addSubview:courseNameLabel];
//    
//    yEdge += courseNameLabel.frame.size.height + topPadding;
//    
//    currentIdx++;
//  }
  
  yEdge -= 10;
  _tableView  = [[UITableView alloc] init];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  _tableView.showsVerticalScrollIndicator = NO;
  _tableView.frame = CGRectMake(0, yEdge, self.view.frame.size.width-15.0, 100.0*[_courseDict count]);
  [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
  [_scrollView addSubview:_tableView];
  
//  UITableView *coursesTable = [[UITableView alloc] init];
  
  
  _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, yEdge + [self.navigationController navigationBar].frame.size.height + 40 + _tableView.frame.size.height/2);
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSString *courseKey = _prof[@"courses"][indexPath.item][@"id"];
  
//  NSLog(@"%@", _prof[@"courses"][indexPath.item]);
  CourseVC *courseVC = [[CourseVC alloc] initWithCourseKey:courseKey];
  [self.navigationController pushViewController:courseVC animated:YES];
  [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_courseDict count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
  
  NSArray *allKeys = [_courseDict allKeys];
  NSLog(@"%@", _prof[@"courses"][0]);
  NSString *courseKey = courseCode[indexPath.item];
  NSString *courseName = [_courseDict objectForKey:courseKey];
  
  
  // Number of courses
  unsigned long numCourses = [_courses count];
  for (unsigned long i = 0; i < numCourses; i++) {
  
  }
  
//  for (NSString *course in _courseDict) {
//    
//    NSString *courseName = [_courseDict objectForKey:course];
//  }


  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  cell = [[CourseCell alloc] initWithCourseID: courseKey
                                   courseName: courseName];
//
//  cell.textLabel.text = courseCode;
//  cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:kPFontSize];
//  cell.detailTextLabel.text = @"fdsafads";
  
  return cell;
}

@end
