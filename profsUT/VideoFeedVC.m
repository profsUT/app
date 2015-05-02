//
//  VideoFeedVC.m
//  profsUT
//
//  Created by Zac Ioannidis on 1/5/15.
//  Copyright (c) 2015 Teacher's Pet. All rights reserved.
//

@import CoreGraphics;

#import "VideoFeedVC.h"

#import "ProfCell.h"
#import "VideoFeedCell.h"
#import "MoviePlayerController.h"
#import "Util.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString *kCellIdentifier = @"Cell Identifier";


@implementation VideoFeedVC {
  UITableView *_tableView;
  NSString *_requestURL;
  NSURLRequest *_request;
  NSMutableData *_responseData;
  
  CGFloat yEdge;

}

- (instancetype)init {
  self = [super init];
  if (self) {
    _requestURL = @"http://djangoprofs-env.elasticbeanstalk.com/profsUT/api/videos/";
      
    self.title = @"Videos";
    UIImage *tabImage = [UIImage imageNamed:@"videosIcon.png"];
    UIImage *scaledImage = [Util imageWithImage:tabImage scaledToSize:CGSizeMake(25,25)];
    self.tabBarItem.image = scaledImage;
    
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
  //  NSError *myError = nil;
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"NSURLConnectionDidFinish"
                                                      object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"Professors";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.contentInset = UIEdgeInsetsMake(0,
                                               0,
                                               self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height + self.tabBarController.tabBar.frame.size.height*2-5,
                                               0);
    [_tableView registerClass:[ProfCell class] forCellReuseIdentifier:kCellIdentifier];
    [self.view addSubview:_tableView];

    
    NSURLResponse *requestResponse;
    
    NSData *requestHandler = [NSURLConnection sendSynchronousRequest:_request returningResponse:&requestResponse error:nil];
    // optionally update the UI to say 'busy', e.g. placeholders or activity
    // indicators in parts that are incomplete until the response arrives
    [NSURLConnection sendAsynchronousRequest:_request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error) {
                                   
                               }
                               
                           }];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    return cell;
}

#pragma mark - NSURLConnectionDidFinish
- (void)refresh {
    [_tableView reloadData];
}


@end
