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
  NSString *_courseKey; // Course's Primary Key
  NSString *_courseName;
  NSString *_courseTime;
  NSString *_courseSyllabus;
  NSString *_profName;
  
  NSString *_requestURL;
  NSURLRequest *_request;
  
  CGFloat yEdge;

  NSMutableData *_responseData;
}

-(instancetype)initWithCourseKey:(NSString *)courseKey {
  _courseKey = courseKey;
  
  NSLog(@"fdsafdsa%@", courseKey);
  
  _requestURL = [NSString stringWithFormat:@"http://djangoprofs-env.elasticbeanstalk.com/profsUT/api/courses/%@", courseKey];
  
  // Change request URL to requestURL
  _request =
  [NSURLRequest requestWithURL:[NSURL URLWithString:_requestURL]];
  
  return self;
}


-(instancetype)initWithCourseID:(NSString *)courseID courseName:(NSString *)courseName courseKey:(NSString *)courseKey profName:(NSString *)profName {
  self = [super init];
  if (self) {
    _responseData = [NSMutableData data];

    _courseID = courseID;
    _courseName = courseName;
    _courseKey = courseKey;
    _profName = profName;
    
    _requestURL = [NSString stringWithFormat:@"http://djangoprofs-env.elasticbeanstalk.com/profsUT/api/courses/%@", courseKey];
    
    // Change request URL to requestURL
    _request =
    [NSURLRequest requestWithURL:[NSURL URLWithString:_requestURL]];
  }
  
  return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  NSLog(@"didReceiveResponse");
  [_responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  NSLog(@"didFailWithError");
  NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  NSLog(@"connectionDidFinishLoading");
  NSLog(@"Succeeded! Received %lu bytes of data", [_responseData length]);
  
  // convert to JSON
  NSError *myError = nil;
  NSArray *_courseJSON = [NSJSONSerialization JSONObjectWithData:_responseData
                                                  options:NSJSONReadingMutableLeaves
                                                    error:&myError];
  
  NSLog(@"%@", _courseJSON);
  [[NSNotificationCenter defaultCenter] postNotificationName:@"NSURLConnectionDidFinish"
                                                      object:nil];
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
  
  
  // Description Label
//  UILabel *descriptionLabel = [[UILabel alloc] init];
//  descriptionLabel.text = @"Description";
//  descriptionLabel.font = [UIFont fontWithName:@"Copse" size:kH2FontSize];
//  [descriptionLabel sizeToFit];
//  descriptionLabel.frame = CGRectMake(15.0, yEdge, descriptionLabel.bounds.size.width, descriptionLabel.bounds.size.height);
//  [_scrollView addSubview:descriptionLabel];
//  
//  yEdge += descriptionLabel.frame.size.height + topPadding/4;
  
  
//  UILabel *descriptionTextLabel = [[UILabel alloc] init];
//  descriptionTextLabel.text = @"Lorem ipsum dolor sit amet, in eam assum luptatum vituperata.\n Ipsum graeci sed ut. Eos at habeo integre facilisis, everti expetendis id cum, nihil argumentum in per\n. Ut nam clita homero omnium. Sale nulla electram at eam. Nostro prodesset reprehendunt duo ea, eu eum brute evertitur moderatius. Te sed aliquip concludaturque, eripuit necessitatibus ut nam, est sanctus definitionem ei.";
//  descriptionTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:kPFontSize];
//  descriptionTextLabel.numberOfLines = 0;
//  [descriptionTextLabel sizeToFit];
//  CGSize labelSize = [descriptionTextLabel.text sizeWithFont:descriptionTextLabel.font constrainedToSize:CGSizeMake(300, 300000) lineBreakMode:NSLineBreakByWordWrapping];
//  CGFloat h = labelSize.height;
//  descriptionTextLabel.frame = CGRectMake(15.0, yEdge, widthOfScreen-leftPadding, h);
//  yEdge += h;
//  [_scrollView addSubview:descriptionTextLabel];
//  
//  yEdge += descriptionLabel.frame.size.height + topPadding;
  
  
  // Syllabus label
//  UILabel *syllabusLabel = [[UILabel alloc] init];
//  syllabusLabel.text = @"Syllabus";
//  syllabusLabel.font = [UIFont fontWithName:@"Copse" size:kH2FontSize];
//  [syllabusLabel sizeToFit];
//  syllabusLabel.frame = CGRectMake(15.0, yEdge, syllabusLabel.bounds.size.width, syllabusLabel.bounds.size.height);
//  [_scrollView addSubview:syllabusLabel];
//  
//  yEdge += syllabusLabel.frame.size.height + topPadding;
  
  
  
  NSURLResponse *requestResponse;
  
  NSData *requestHandler = [NSURLConnection sendSynchronousRequest:_request returningResponse:&requestResponse error:nil];
  // optionally update the UI to say 'busy', e.g. placeholders or activity
  // indicators in parts that are incomplete until the response arrives
  [NSURLConnection sendAsynchronousRequest:_request
                                     queue:[NSOperationQueue mainQueue]
                         completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                           if (!error) {
                             NSError *e = nil;
                             NSDictionary *json = [NSJSONSerialization JSONObjectWithData: requestHandler options: NSJSONReadingMutableContainers error: &e];
                             // update the UI here (and only here to the extent it depends on the json)
                             
                             // Course Name
                             UILabel *courseNameLabel = [[UILabel alloc] init];
                             courseNameLabel.text =  json[@"courseName"];
                             courseNameLabel.font = [UIFont fontWithName:@"Copse" size:20];
                             courseNameLabel.numberOfLines = 0;
                             [courseNameLabel sizeToFit];
                             
                             CGSize labelSize = [courseNameLabel.text sizeWithFont:courseNameLabel.font constrainedToSize:CGSizeMake(300, 300000) lineBreakMode:NSLineBreakByWordWrapping];
                             CGFloat h = labelSize.height;
                             courseNameLabel.frame = CGRectMake(15.0, yEdge, widthOfScreen-leftPadding, h);
                             yEdge += h;

                             [_scrollView addSubview:courseNameLabel];
                             
                             // Course ID
                             UILabel *courseIDLabel = [[UILabel alloc] init];
                             courseIDLabel.text = json[@"courseID"];
                             courseIDLabel.text = _courseID;
                             courseIDLabel.font = [UIFont fontWithName:@"Copse" size:20];
                             [courseIDLabel sizeToFit];
                             courseIDLabel.frame = CGRectMake(15.0, yEdge, courseIDLabel.bounds.size.width, courseIDLabel.bounds.size.height);
                           
                             yEdge += courseIDLabel.frame.size.height + 2*topPadding;
                             [_scrollView addSubview:courseIDLabel];
                             
                             // Ratings Label
                             UILabel *ratingsLabel = [[UILabel alloc] init];
                             ratingsLabel.text = @"Course Ratings";
                             ratingsLabel.font = [UIFont fontWithName:@"Copse" size:kH2FontSize];
                             [ratingsLabel sizeToFit];
                             ratingsLabel.frame = CGRectMake(15.0, yEdge, ratingsLabel.bounds.size.width, ratingsLabel.bounds.size.height);
                             yEdge += ratingsLabel.frame.size.height + 2*topPadding;
                             [_scrollView addSubview:ratingsLabel];
                             
                             // Time Label
                             UILabel *timeLabel = [[UILabel alloc] init];
                             timeLabel.text = @"Time";
                             timeLabel.font = [UIFont fontWithName:@"Copse" size:kH2FontSize];
                             [timeLabel sizeToFit];
                             timeLabel.frame = CGRectMake(15.0, yEdge, timeLabel.bounds.size.width, timeLabel.bounds.size.height);
                             yEdge += timeLabel.frame.size.height;
                             [_scrollView addSubview:timeLabel];
                             
                             // To do: Get times from nested JSON
                             UILabel *timeInfo = [[UILabel alloc] init];
                             timeInfo.text = @"5:30-7";
                             timeInfo.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
                             [timeInfo sizeToFit];
                             timeInfo.frame = CGRectMake(15.0, yEdge, timeInfo.bounds.size.width, timeInfo.bounds.size.height);
                             yEdge += timeInfo.frame.size.height + 2*topPadding;
                             [_scrollView addSubview:timeInfo];

                             
                             _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, yEdge + [self.navigationController navigationBar].frame.size.height + 40);

                             
                             
                           } else {
                             // update the UI to indicate error
                           }
                         }];

}

@end
