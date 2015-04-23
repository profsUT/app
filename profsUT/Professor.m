#import "Professor.h"

@implementation Professor {
  NSMutableData *_responseData;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _responseData = [NSMutableData data];
    NSURLRequest *request =
        [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://djangoprofs-env.elasticbeanstalk.com/profsUT/api/instructors/"]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

  }
  return self;
}

+ (instancetype)sharedInstance {
  static Professor *sharedProfessor = nil;
  @synchronized(self) {
    if (sharedProfessor == nil)
      sharedProfessor = [[self alloc] init];
  }
  return sharedProfessor;
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
  _profsArray = [NSJSONSerialization JSONObjectWithData:_responseData
                                                      options:NSJSONReadingMutableLeaves
                                                        error:&myError];
  
//  NSLog(@"%@", _profsArray);
  
  // sort by last name
  NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"last" ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
  _profsArray = [_profsArray sortedArrayUsingDescriptors:sortDescriptors];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"NSURLConnectionDidFinish"
                                                      object:nil];
  
//  NSLog(@"------------------------------------");
//  NSLog(@"------------------------------------");
//  NSLog(@"------------------------------------");
//  NSLog(@"%@", _profsArray);
  
//  for (id object in res) {
//    NSLog(@"class: %@", NSStringFromClass([object class]));
//  }
}

@end
