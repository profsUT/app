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
  
  // Variables pertaining to API call
  NSString *_profKey;
  NSString *_requestURL;
  NSURLRequest *_request;
  
  NSString *_first;
  NSString *_last;
  NSMutableArray *_courses;
  
  NSDictionary *_courseDict;
  NSMutableArray *_courseCodes;
  NSMutableArray *_courseNames;
  
  NSMutableData *_responseData;
  
  CGFloat yEdge;
}

- (instancetype)initWithDictionary:(NSDictionary *)prof {
//  self = [super init];
//  if (self) {
//    _courses = [[NSMutableArray alloc] init];
//    courseCode = [[NSMutableArray alloc] init];
//    _courseNames = [[NSMutableArray alloc] init];
//    
//    _prof = prof;
//    
//    _first = _prof[@"first"];
//    _last = [Util intoLowerCaseExceptForFirstLetter:_prof[@"last"]];
//    
//    unsigned long totalCourses = [_prof[@"courses"] count];
//    for (unsigned long i = 0; i < totalCourses; i++) {
//      NSString *courseID = _prof[@"courses"][i][@"courseID"];
//      NSString *courseName = _prof[@"courses"][i][@"courseName"];
//      NSString *course = [NSString stringWithFormat:@"%@: %@", courseID, courseName];
//      
//      [_courses addObject:course];
//      [courseCode addObject:courseID];
//      [_courseNames addObject:courseName];
//      
//    }
//    
//    _courseDict = [NSDictionary dictionaryWithObjects: _courseNames forKeys:courseCode];
//    
//    
//  }
  return self;
}


- (instancetype) initWithProfessorKey:(NSString *)profKey {
  
  self = [super init];
  
  _profKey = profKey;
  
  _requestURL = [NSString stringWithFormat:@"http://djangoprofs-env.elasticbeanstalk.com/profsUT/api/instructors/%@", profKey];
  
  // Change request URL to requestURL
  _request =
  [NSURLRequest requestWithURL:[NSURL URLWithString:_requestURL]];
  
  
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

  [[NSNotificationCenter defaultCenter] postNotificationName:@"NSURLConnectionDidFinish"
                                                      object:nil];
}

// To-Do Access HLS video from our back-end
-(void)playVideoFromURL:(NSString *) streamURL {
  
  NSLog(@"Called playVideoFromURL\n");
  NSURL *URL = [NSURL URLWithString:streamURL];

  _moviePlayer = [[MPMoviePlayerController alloc]
                  initWithContentURL:URL];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(moviePlayBackDidFinish:)
                                               name:MPMoviePlayerPlaybackDidFinishNotification
                                             object:_moviePlayer];
  
  _moviePlayer.view.frame = CGRectMake(leftPadding, yEdge,
                                  self.view.bounds.size.width - 30.0, 200);
  _moviePlayer.controlStyle = MPMovieControlStyleDefault;
  _moviePlayer.shouldAutoplay = NO;
  [_scrollView addSubview:_moviePlayer.view];
  [_moviePlayer setFullscreen:NO animated:YES];
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
  
  self.view.backgroundColor = [UIColor whiteColor];
  

  
  NSURLResponse *requestResponse;
  
  NSData *requestHandler = [NSURLConnection sendSynchronousRequest:_request returningResponse:&requestResponse error:nil];
  // optionally update the UI to say 'busy', e.g. placeholders or activity
  // indicators in parts that are incomplete until the response arrives
  [NSURLConnection sendAsynchronousRequest:_request
                                     queue:[NSOperationQueue mainQueue]
                         completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
               if (!error) {
                 // update the UI here (and only here to the extent it depends on the json)
                 NSError *e = nil;
                 NSDictionary *json = [NSJSONSerialization JSONObjectWithData: requestHandler options: NSJSONReadingMutableContainers error: &e];
                 
                 _scrollView = [[UIScrollView alloc] init];
                 _scrollView.frame = self.view.frame;
                 _scrollView.showsVerticalScrollIndicator = NO;
                 _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, yEdge + [self.navigationController navigationBar].frame.size.height + 40);
                 [self.view addSubview:_scrollView];
                 
                 yEdge = sectionBreak;
                 
                 _courses = [[NSMutableArray alloc] init];
                 _courseCodes = [[NSMutableArray alloc] init];
                 _courseNames = [[NSMutableArray alloc] init];
                 
                 // Populate courses dictionary
                 
                 _prof = json;
                 NSLog(@"%@", _prof);
                 
                 unsigned long totalCourses = [_prof[@"courses"] count];
                 NSLog(@"Total courses are: %lu", totalCourses);
                 
                 for (unsigned long i = 0; i < totalCourses; i++) {
                   NSString *courseID = _prof[@"courses"][i][@"courseID"];
                   NSString *courseName = _prof[@"courses"][i][@"courseName"];
                   NSString *course = [NSString stringWithFormat:@"%@: %@", courseID, courseName];
                   NSLog(@"Course ID, Course Name: %@, %@", courseID, courseName);
                   
                   [_courses addObject:course];
                   [_courseCodes addObject:courseID];
                   [_courseNames addObject:courseName];
                 }
                 
                 _courseDict = [NSDictionary dictionaryWithObjects: _courseNames forKeys:_courseCodes];
                 
                 _first = _prof[@"first"];
                 _last = _prof[@"last"];
                 
                 // Add last name to navigation bar
                 self.navigationItem.title = _last;

                 UILabel *nameLabel = [[UILabel alloc] init];
                 nameLabel.text = [Util intoLowerCaseExceptForFirstLetter:[NSString stringWithFormat:@"%@ %@", _first, _last]];
                 nameLabel.font = [UIFont fontWithName:@"Copse" size:kH2FontSize];
                 [nameLabel sizeToFit];
                 nameLabel.frame = CGRectMake(leftPadding, yEdge,
                                              nameLabel.bounds.size.width, nameLabel.bounds.size.height);
                 [_scrollView addSubview:nameLabel];
                 
                 yEdge += nameLabel.frame.size.height + topPadding;
                 
                 // If at least one video for this professor exists
                 if ([_prof[@"video"] count] > 0) {
                   NSString *videoURL = _prof[@"video"][0][@"video_url"];
                   [self playVideoFromURL:videoURL];

                 }
              
                 
                 UILabel *courseLabel = [[UILabel alloc] init];
                 courseLabel.text = @"Courses";
                 courseLabel.font = [UIFont fontWithName:@"Copse" size:kH2FontSize];
                 [courseLabel sizeToFit];
                 courseLabel.frame = CGRectMake(15.0, yEdge, courseLabel.bounds.size.width, courseLabel.bounds.size.height);
                 [_scrollView addSubview:courseLabel];
               
                 yEdge += courseLabel.frame.size.height + topPadding;
                 
                 yEdge -= 10;
                 _tableView  = [[UITableView alloc] init];
                 _tableView.dataSource = self;
                 _tableView.delegate = self;
                 _tableView.showsVerticalScrollIndicator = NO;
                 _tableView.alwaysBounceVertical = NO;
                 _tableView.frame = CGRectMake(0, yEdge, self.view.frame.size.width, cellHeight*[_prof[@"courses"] count]);
                 [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
                 [_scrollView addSubview:_tableView];


                 _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, yEdge + [self.navigationController navigationBar].frame.size.height + 40 + _tableView.frame.size.height);
                 
               } else {
                 // update the UI to indicate error
                 UILabel *errorLabel = [[UILabel alloc] init];
                 errorLabel.text = @"Error: The professor could not be loaded.";
                 errorLabel.font = [UIFont fontWithName:@"Copse" size:16];
                 [errorLabel sizeToFit];
                 errorLabel.frame = CGRectMake(15.0, self.view.frame.size.height/2, errorLabel.bounds.size.width, errorLabel.bounds.size.height);
                 
                 
                 [_scrollView addSubview:errorLabel];

               }
            }];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  // To Do: Get correct primary key for course here when API is updated
  NSString *courseKey = _prof[@"courses"][indexPath.item][@"id"];
  
  CourseVC *courseVC = [[CourseVC alloc] initWithCourseKey:courseKey showInstructor:(int) 0];
  
  // To do: Stop video playback when changing transitioning controllers.
  
  [self.navigationController pushViewController:courseVC animated:YES];
  [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSLog(@"Total count is: %lu", [_prof[@"courses"] count]);
  return [_prof[@"courses"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
  
  NSString *courseKey = _courseCodes[indexPath.item];
  NSString *courseName = [_courseDict objectForKey:courseKey];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  
  cell = [[CourseCell alloc] initWithCourseID: courseKey
                                   courseName: courseName];

  return cell;
}

@end
