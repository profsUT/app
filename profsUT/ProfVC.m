// To Do: When transitioning from instructor view to course view and then
// back again, the video fast forwards.

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
  
  NSURL *URL = [NSURL URLWithString:streamURL];

  _moviePlayer = [[MoviePlayerController alloc]
                  initWithContentURL:URL];
  
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(moviePlayBackDidFinish:)
                                               name:MPMoviePlayerPlaybackDidFinishNotification
                                             object:_moviePlayer];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(doneButtonPressed:)
                                               name:MPMoviePlayerDidExitFullscreenNotification
                                             object:_moviePlayer];
  
  
  _moviePlayer.view.frame = CGRectMake(leftPadding, yEdge,
                                  self.view.bounds.size.width - 30.0, 200);
  _moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
  [_scrollView addSubview:_moviePlayer.view];

  
  UIImage *playBtnImage = [UIImage imageNamed:@"playButton.png"];
  
  UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [playButton setImage:playBtnImage forState:UIControlStateNormal];
  [playButton addTarget:self
                 action:@selector(playButtonPressed:)
       forControlEvents:UIControlEventTouchUpInside];
  playButton.frame = CGRectMake(leftPadding, yEdge,
                                self.view.bounds.size.width - 30.0, 200);
  [_scrollView addSubview:playButton];

  yEdge += _moviePlayer.view.frame.size.height + sectionBreak;
}

#pragma mark - button handling
-(void)playButtonPressed : (id)sender
{
  _moviePlayer.shouldAutoplay = YES;
  [_moviePlayer setFullscreen:YES animated:YES];
  _moviePlayer.controlStyle = MPMovieControlStyleDefault;
  
  // Rotate
  NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
  [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
//  NSLog(@"Play pressed");
}


- (void) moviePlayBackDidFinish:(NSNotification*)notification {
  MoviePlayerController *player = [notification object];
  [[NSNotificationCenter defaultCenter]
   removeObserver:self
   name:MPMoviePlayerPlaybackDidFinishNotification
   object:player];
  
  _moviePlayer.controlStyle = MPMovieControlStyleNone;
  
//  NSLog(@"Movie playback did finish");
  if ([player
       respondsToSelector:@selector(setFullscreen:animated:)])
  {
//    [player.view removeFromSuperview];
  }
}

-(void) doneButtonPressed:(NSNotification *)notification {
//  NSLog(@"Done pressed");
  _moviePlayer.controlStyle = MPMovieControlStyleNone;

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
                 
                 unsigned long totalCourses = [_prof[@"courses"] count];
                 
                 for (unsigned long i = 0; i < totalCourses; i++) {
                   NSString *courseID = _prof[@"courses"][i][@"courseID"];
                   NSString *courseName = _prof[@"courses"][i][@"courseName"];
                   NSString *course = [NSString stringWithFormat:@"%@: %@", courseID, courseName];
                   
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

                 } else {
                   yEdge += topPadding;
                 }
                 
                 
                 if ([_prof[@"average_rating"] isEqual:[NSNull null]] != 1) {
                   // Ratings Label
                   UILabel *ratingsLabel = [[UILabel alloc] init];
                   ratingsLabel.text = @"Instructor Rating";
                   ratingsLabel.font = [UIFont fontWithName:@"Copse" size:kH2FontSize];
                   [ratingsLabel sizeToFit];
                   ratingsLabel.frame = CGRectMake(15.0, yEdge, ratingsLabel.bounds.size.width, ratingsLabel.bounds.size.height);
                   yEdge += ratingsLabel.frame.size.height;
                   [_scrollView addSubview:ratingsLabel];
                   
                   UILabel *ratingInfo = [[UILabel alloc] init];
                   ratingInfo.text = [NSString stringWithFormat:@"%.2f/5", [_prof[@"average_rating"] floatValue]];
                   ratingInfo.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
                   [ratingInfo sizeToFit];
                   ratingInfo.frame = CGRectMake(15.0, yEdge, ratingInfo.bounds.size.width, ratingInfo.bounds.size.height);
                   yEdge += ratingInfo.frame.size.height + 2*topPadding;
                   [_scrollView addSubview:ratingInfo];


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
  
  // Don't show the instructor table cell when moving from professors to their courses
  CourseVC *courseVC = [[CourseVC alloc] initWithCourseKey:courseKey showInstructor:(int) 0];
  
  // To do: Stop video playback when changing transitioning controllers.
  
  [self.navigationController pushViewController:courseVC animated:YES];
  [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
