#import "ProfVC.h"

#import "Professor.h"
#import "Constants.h"
#import "Util.h"

@import MediaPlayer;

static CGFloat leftPadding = 15.0;
static CGFloat topPadding = 10.0;
static CGFloat sectionBreak = 20.0;

@implementation ProfVC {
  UIScrollView *_scrollView;
  NSInteger _index;
  NSDictionary *_prof;
  
  NSString *_first;
  NSString *_last;
  NSArray *_courses;
}

- (instancetype)initWithDictionary:(NSDictionary *)prof {
  self = [super init];
  if (self) {
    _prof = prof;
    
    _first = _prof[@"first"];
    _last = [Util intoLowerCaseExceptForFirstLetter:_prof[@"last"]];
    _courses = _prof[@"courses"];
    NSLog(@"%@", _courses);
  }
  return self;
}

- (void)playVideoWithId:(NSString *)videoId {
    
    NSString *youTubeVideoHTML = @"<html><head><style>body{margin:0px 0px 0px 0px;}</style></head> <body> <div id=\"player\"></div> <script> var tag = document.createElement('script'); tag.src = 'http://www.youtube.com/player_api'; var firstScriptTag = document.getElementsByTagName('script')[0]; firstScriptTag.parentNode.insertBefore(tag, firstScriptTag); var player; function onYouTubePlayerAPIReady() { player = new YT.Player('player', { width:'300', height:'300', videoId:'OCpSqs6AqoU', events: { 'onReady': onPlayerReady } }); } function onPlayerReady(event) { event.target.playVideo(); } </script> </body> </html>";
    
    NSString *html = [NSString stringWithFormat:youTubeVideoHTML, videoId];
    
    UIWebView *videoView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    videoView.backgroundColor = [UIColor clearColor];
    videoView.opaque = NO;
    //videoView.delegate = self;
    [self.view addSubview:videoView];
    
    videoView.mediaPlaybackRequiresUserAction = NO;
    
    [videoView loadHTMLString:youTubeVideoHTML baseURL:[[NSBundle mainBundle] resourceURL]];
}

- (void)viewDidLoad {
  [super viewDidLoad];
    [self playVideoWithId:@"sLVGweQU7rQ"];
  
  CGFloat yEdge;
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  self.navigationItem.title = _last;
  
  _scrollView = [[UIScrollView alloc] init];
  _scrollView.frame = self.view.frame;
  _scrollView.showsVerticalScrollIndicator = NO;
  [self.view addSubview:_scrollView];
  
  yEdge = sectionBreak;
  
  UILabel *nameLabel = [[UILabel alloc] init];
  nameLabel.text = [NSString stringWithFormat:@"%@ %@", _first, _last];
  nameLabel.font = [UIFont fontWithName:@"Helvetica" size:kH1FontSize];
  [nameLabel sizeToFit];
  nameLabel.frame = CGRectMake(leftPadding, yEdge,
                               nameLabel.bounds.size.width, nameLabel.bounds.size.height);
  [_scrollView addSubview:nameLabel];
  
  yEdge += nameLabel.frame.size.height + topPadding;
  
//  NSString *path = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"mov"];
//  MPMoviePlayerController *player =
//      [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
//  player.view.frame = CGRectMake(leftPadding, yEdge,
//                                 self.view.bounds.size.width - 30.0, 200);//arbitrary, fix
//  [_scrollView addSubview:player.view];
//    yEdge += player.view.frame.size.height + sectionBreak;
    
  
  UILabel *courseLabel = [[UILabel alloc] init];
  courseLabel.text = @"Courses";
  courseLabel.font = [UIFont fontWithName:@"Helvetica" size:kH2FontSize];
  [courseLabel sizeToFit];
  courseLabel.frame = CGRectMake(15.0, yEdge, courseLabel.bounds.size.width, courseLabel.bounds.size.height);
  [_scrollView addSubview:courseLabel];

  yEdge += courseLabel.frame.size.height + topPadding;
  
  for (NSString *course in _courses) {
//    NSString *courseID = course[@"courseID"];
    NSString *courseID = course;
    NSString *courseName = @"Intro to stuff";
   
    UILabel *courseIDLabel = [[UILabel alloc] init];
//    courseIDLabel.text = courseID;
    courseIDLabel.text = [NSString stringWithFormat:@"%@", course];
    courseIDLabel.font = [UIFont fontWithName:@"Helvetica" size:kPFontSize];
    [courseIDLabel sizeToFit];
    courseIDLabel.frame = CGRectMake(15.0, yEdge,
                                   courseIDLabel.bounds.size.width, courseIDLabel.bounds.size.height);
    [_scrollView addSubview:courseIDLabel];
    
    yEdge += courseIDLabel.frame.size.height;
    
    UILabel *courseNameLabel = [[UILabel alloc] init];
    courseNameLabel.text = courseName;
    courseNameLabel.font = [UIFont fontWithName:@"Helvetica" size:kPFontSize];
    [courseNameLabel sizeToFit];
    courseNameLabel.frame = CGRectMake(15.0, yEdge,
                                     courseNameLabel.bounds.size.width, courseNameLabel.bounds.size.height);
    [_scrollView addSubview:courseNameLabel];
    
    yEdge += courseNameLabel.frame.size.height + topPadding;
  }
  
  _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, yEdge + [self.navigationController navigationBar].frame.size.height + 40);
}

@end
