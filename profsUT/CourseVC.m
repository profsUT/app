#import "CourseVC.h"

#import "Course.h"
#import "Constants.h"
#import "Util.h"

static CGFloat leftPadding = 15.0;
static CGFloat topPadding = 10.0;
static CGFloat sectionBreak = 20.0;

@implementation CourseVC {

  UIScrollView *_scrollView;
  NSInteger _index;
  NSDictionary *_prof;

  NSString *_first;
  NSString *_last;
  NSMutableArray *_courses;

  NSDictionary *_courseDict;
  NSString *_courseID;
  NSString *_courseName;
  NSString *_courseTime;
  NSString *_courseSyllabus;
  NSString *_profName;

  CGFloat yEdge;
}

-(instancetype)initWithCourseID:(NSString *)courseID courseName:(NSString *)courseName profName:(NSString *)profName {
  self = [super init];
  if (self) {
    _courseID = courseID;
    _courseName = courseName;
    _profName = profName;
  }
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  self.navigationItem.title = _last;
  
  _scrollView = [[UIScrollView alloc] init];
  _scrollView.frame = self.view.frame;
  _scrollView.showsVerticalScrollIndicator = NO;
  [self.view addSubview:_scrollView];
  
  yEdge = sectionBreak;
  CGFloat widthOfScreen  =  [[UIScreen mainScreen] bounds].size.width;
  CGFloat heightOfScreen = [[UIScreen mainScreen] bounds].size.height;
  
  // Course Name
  UILabel *courseNameLabel = [[UILabel alloc] init];
  courseNameLabel.text = _courseName;
  courseNameLabel.font = [UIFont fontWithName:@"Copse" size:20];
  [courseNameLabel sizeToFit];
  courseNameLabel.numberOfLines = 2;
  courseNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
  courseNameLabel.frame = CGRectMake(leftPadding, yEdge,
                               widthOfScreen-leftPadding, courseNameLabel.bounds.size.height);
  [_scrollView addSubview:courseNameLabel];
  
  yEdge += courseNameLabel.frame.size.height + topPadding/2;
  

  
  UILabel *courseIDLabel = [[UILabel alloc] init];
  courseIDLabel.text = _courseID;
  courseIDLabel.font = [UIFont fontWithName:@"Copse" size:20];
  [courseIDLabel sizeToFit];
  courseIDLabel.frame = CGRectMake(15.0, yEdge, courseIDLabel.bounds.size.width, courseIDLabel.bounds.size.height);
  [_scrollView addSubview:courseIDLabel];
  
  yEdge += courseIDLabel.frame.size.height + 2*topPadding;
  
  UILabel *descriptionLabel = [[UILabel alloc] init];
  descriptionLabel.text = @"Description";
  descriptionLabel.font = [UIFont fontWithName:@"Copse" size:kH2FontSize];
  [descriptionLabel sizeToFit];
  descriptionLabel.frame = CGRectMake(15.0, yEdge, descriptionLabel.bounds.size.width, descriptionLabel.bounds.size.height);
  [_scrollView addSubview:descriptionLabel];
  
  yEdge += descriptionLabel.frame.size.height + topPadding/4;
  
  
  UILabel *descriptionTextLabel = [[UILabel alloc] init];
  descriptionTextLabel.text = @"Lorem ipsum dolor sit amet, in eam assum luptatum vituperata.\n Ipsum graeci sed ut. Eos at habeo integre facilisis, everti expetendis id cum, nihil argumentum in per\n. Ut nam clita homero omnium. Sale nulla electram at eam. Nostro prodesset reprehendunt duo ea, eu eum brute evertitur moderatius. Te sed aliquip concludaturque, eripuit necessitatibus ut nam, est sanctus definitionem ei.";
  descriptionTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:kPFontSize];
  [descriptionTextLabel sizeToFit];
  descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
  descriptionLabel.numberOfLines = 0;
  descriptionTextLabel.frame = CGRectMake(15.0, yEdge, widthOfScreen-leftPadding, descriptionTextLabel.bounds.size.height);
  [_scrollView addSubview:descriptionTextLabel];
  
  yEdge += descriptionLabel.frame.size.height + topPadding;
  
  UILabel *syllabusLabel = [[UILabel alloc] init];
  syllabusLabel.text = @"Syllabus";
  syllabusLabel.font = [UIFont fontWithName:@"Copse" size:kH2FontSize];
  [syllabusLabel sizeToFit];
  syllabusLabel.frame = CGRectMake(15.0, yEdge, syllabusLabel.bounds.size.width, syllabusLabel.bounds.size.height);
  [_scrollView addSubview:syllabusLabel];
  
  yEdge += syllabusLabel.frame.size.height + topPadding;
  
  UILabel *ratingsLabel = [[UILabel alloc] init];
  ratingsLabel.text = @"Course Ratings";
  ratingsLabel.font = [UIFont fontWithName:@"Copse" size:kH2FontSize];
  [ratingsLabel sizeToFit];
  ratingsLabel.frame = CGRectMake(15.0, yEdge, ratingsLabel.bounds.size.width, ratingsLabel.bounds.size.height);
  [_scrollView addSubview:ratingsLabel];
  
  _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, yEdge + [self.navigationController navigationBar].frame.size.height + 40);
}

@end
