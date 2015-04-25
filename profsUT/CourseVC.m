#import "CourseVC.h"

#import "Course.h"
#import "Constants.h"
#import "Util.h"
#import "ProfCell.h"
#import "ProfVC.h"

static CGFloat leftPadding = 15.0;
static CGFloat topPadding = 10.0;
static CGFloat sectionBreak = 20.0;
static CGFloat cellHeight = 40.0;

static NSString *kCellIdentifier = @"Cell Identifier";



@implementation CourseVC {

  UIScrollView *_scrollView;
  UITableView *_tableView;
  NSInteger _index;
  NSDictionary *_prof;

  NSString *_first;
  NSString *_last;
  NSMutableArray *_courses;
  
//  BOOL *_showInstructor;

  NSDictionary *_courseDict;
  NSString *_courseID;
  NSString *_courseKey; // Course's Primary Key
  NSString *_courseName;
  NSString *_courseTime;
  NSString *_courseSyllabus;
  NSString *_profName;
  NSString *_profKey;
  
  NSString *_requestURL;
  NSURLRequest *_request;
  
  CGFloat yEdge;

  NSMutableData *_responseData;
}

-(instancetype)initWithCourseKey:(NSString *)courseKey {
  
  self = [super init];
  
  [self setShowInstructor:YES];
  
  _courseKey = courseKey;
  
  _requestURL = [NSString stringWithFormat:@"http://djangoprofs-env.elasticbeanstalk.com/profsUT/api/courses/%@", courseKey];
  
  // Change request URL to requestURL
  _request =
  [NSURLRequest requestWithURL:[NSURL URLWithString:_requestURL]];
  
  return self;
  
}

-(instancetype)initWithCourseKey:(NSString *)courseKey showInstructor:(int)showInstructor {
  
  self = [super init];
  
  // Define when to show instructors and when not in order to avoid infinite controller transitions
  // on the navigation stack when going from instructor-courses-instructor-etc...
  
  if (showInstructor) {
    [self setShowInstructor:YES];
  }
  else {
    [self setShowInstructor:NO];
  }

  
  _courseKey = courseKey;
  
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
  NSLog(@"Succeeded! Received %lu bytes of data", (unsigned long)[_responseData length]);
  
  // convert to JSON
  NSError *myError = nil;
  NSArray *_courseJSON = [NSJSONSerialization JSONObjectWithData:_responseData
                                                  options:NSJSONReadingMutableLeaves
                                                    error:&myError];

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
           
           self.navigationItem.title = json[@"courseID"];
           NSLog(@"%@", json);
           
           NSString *firstName = json[@"instructor"][@"first"];
           NSString *lastName = json[@"instructor"][@"last"];
           NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
           
           _profName = [Util intoLowerCaseExceptForFirstLetter:fullName];
           _profKey = json[@"instructor"][@"id"];
           
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
           courseIDLabel.font = [UIFont fontWithName:@"Copse" size:20];
           [courseIDLabel sizeToFit];
           courseIDLabel.frame = CGRectMake(15.0, yEdge, courseIDLabel.bounds.size.width, courseIDLabel.bounds.size.height);
         
           yEdge += courseIDLabel.frame.size.height + 2*topPadding;
           [_scrollView addSubview:courseIDLabel];
           
//           // Ratings Label
//           UILabel *ratingsLabel = [[UILabel alloc] init];
//           ratingsLabel.text = @"Course Ratings";
//           ratingsLabel.font = [UIFont fontWithName:@"Copse" size:kH2FontSize];
//           [ratingsLabel sizeToFit];
//           ratingsLabel.frame = CGRectMake(15.0, yEdge, ratingsLabel.bounds.size.width, ratingsLabel.bounds.size.height);
//           yEdge += ratingsLabel.frame.size.height + 2*topPadding;
//           [_scrollView addSubview:ratingsLabel];
           
           // Time Label
           UILabel *timeLabel = [[UILabel alloc] init];
           timeLabel.text = @"Time";
           timeLabel.font = [UIFont fontWithName:@"Copse" size:kH2FontSize];
           [timeLabel sizeToFit];
           timeLabel.frame = CGRectMake(15.0, yEdge, timeLabel.bounds.size.width, timeLabel.bounds.size.height);
           yEdge += timeLabel.frame.size.height;
           [_scrollView addSubview:timeLabel];
           
           // To do: Get times from nested JSON
           
           unsigned long totalTimes = [json[@"times"] count];
           
           for (unsigned long i=0; i<totalTimes; i++) {
             UILabel *timeInfo = [[UILabel alloc] init];
             NSMutableString *daysText = [NSMutableString stringWithCapacity:100];
             
             NSNumber *num = [NSNumber numberWithInt:1];
             NSArray *days = [json[@"times"][i] allKeysForObject:num];
             NSLog(@"%@", days);
             int counter = 0;
             for (NSString *day in days) {
               if (counter != 0) {
                 [daysText appendString:@", "];
               }
               [daysText appendString:[Util intoLowerCaseExceptForFirstLetter:day]];
               counter++;
             }
             
             NSString *startTime = json[@"times"][i][@"time"];
             NSString *endTime = json[@"times"][i][@"endTime"];
             
             timeInfo.text = [NSString stringWithFormat:@"%@: %@—%@", daysText, startTime, endTime];
             timeInfo.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
             [timeInfo sizeToFit];
             timeInfo.frame = CGRectMake(15.0, yEdge, timeInfo.bounds.size.width, timeInfo.bounds.size.height);
             yEdge += timeInfo.frame.size.height;
             [_scrollView addSubview:timeInfo];

           }
           
           yEdge += 2*topPadding;
           
           
           if ([self showInstructor]) {
             // Instructor Label
             UILabel *instructorLabel = [[UILabel alloc] init];
             instructorLabel.text = @"Instructor";
             instructorLabel.font = [UIFont fontWithName:@"Copse" size:kH2FontSize];
             [instructorLabel sizeToFit];
             instructorLabel.frame = CGRectMake(15.0, yEdge, instructorLabel.bounds.size.width, timeLabel.bounds.size.height);
             yEdge += instructorLabel.frame.size.height;
             [_scrollView addSubview:instructorLabel];
             
             //           yEdge += 20;
             _tableView  = [[UITableView alloc] init];
             _tableView.dataSource = self;
             _tableView.delegate = self;
             _tableView.showsVerticalScrollIndicator = NO;
             _tableView.alwaysBounceVertical = NO;
             _tableView.frame = CGRectMake(0, yEdge, self.view.frame.size.width, cellHeight);
             [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
             [_scrollView addSubview:_tableView];
           }
           
           _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, yEdge + [self.navigationController navigationBar].frame.size.height + 40);

           
           
         } else {
           // update the UI to indicate error
         }
       }];

}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  ProfVC *profVC = [[ProfVC alloc] initWithProfessorKey:_profKey];
  [self.navigationController pushViewController:profVC animated:YES];
  [_tableView deselectRowAtIndexPath:indexPath animated:NO];
  

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
  
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  
  NSLog(@"profName is %@", _profName);
  cell = [[ProfCell alloc] initWithFullName:_profName];
  
  return cell;
}


@end
