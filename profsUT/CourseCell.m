#import "CourseCell.h"


static CGFloat leftPadding = 20.0;
static CGFloat rightPadding = 35.0;
static CGFloat topPadding = 30.0;

@implementation CourseCell

-(instancetype)initWithCourseID:(NSString *)_courseID
                     courseName:(NSString *)_courseName {
  
  self = [super init];
  if (self) {
    leftPadding = 15.0;
    rightPadding = 35.0;
    topPadding = 15.0;
    
    self.courseNameLabel = [[UILabel alloc] init];
    self.courseIDLabel = [[UILabel alloc] init];
    
    self.courseNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    self.courseNameLabel.text = _courseName;
    [self.courseNameLabel sizeToFit];
    self.courseNameLabel.frame = CGRectMake(leftPadding, topPadding - self.courseNameLabel.frame.size.height,
                                            self.frame.size.width - rightPadding, self.courseNameLabel.frame.size.height+20);
    self.courseNameLabel.numberOfLines = 0;
    
    self.courseIDLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    self.courseIDLabel.text = _courseID;
    [self.courseIDLabel sizeToFit];
    self.courseIDLabel.frame = CGRectMake(leftPadding, topPadding,
                                          self.frame.size.width - 100, self.courseIDLabel.frame.size.height * 2);
    
    [self.contentView addSubview:self.courseNameLabel];
    [self.contentView addSubview:self.courseIDLabel];



  }
  
  return self;
}

- (instancetype)initWithCourseID:(NSString *)_courseID
                      courseName:(NSString *)_courseName
                   profFirstName:(NSString *)_profFirstName
                    profLastName:(NSString *)_profLastName {
  

  self = [super init];
  if (self) {
    
    CGFloat leftPadding = 20.0;
    CGFloat rightPadding = 35.0;
    CGFloat topPadding = 30.0;
    self.courseNameLabel = [[UILabel alloc] init];
    self.courseIDLabel = [[UILabel alloc] init];
    self.profNameLabel = [[UILabel alloc] init];
    
    self.courseNameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
    self.courseNameLabel.text = _courseName;
    [self.courseNameLabel sizeToFit];
    self.courseNameLabel.frame = CGRectMake(leftPadding, topPadding - self.courseNameLabel.frame.size.height,
                                      self.frame.size.width - rightPadding, self.courseNameLabel.frame.size.height+20);
    self.courseNameLabel.numberOfLines = 0;
//    self.courseNameLabel.layer.borderColor = [[UIColor redColor] CGColor];
//    self.courseNameLabel.layer.borderWidth = 2.0;
    
    
    self.courseIDLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    self.courseIDLabel.text = _courseID;
    [self.courseIDLabel sizeToFit];
    self.courseIDLabel.frame = CGRectMake(leftPadding+2, topPadding,
                                          self.frame.size.width - 50, self.courseIDLabel.frame.size.height * 2);
    
    
    self.profNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    self.profNameLabel.text = [NSString stringWithFormat:@"%@, %@", _profLastName, _profFirstName];
    [self.profNameLabel sizeToFit];
    self.profNameLabel.frame = CGRectMake(leftPadding+2, topPadding+topPadding/2,
                                          self.frame.size.width - 50, self.profNameLabel.frame.size.height * 2);
    
//    self.profNameLabel.layer.borderColor = [[UIColor greenColor] CGColor];
//    self.profNameLabel.layer.borderWidth = 2.0;
    
    [self.contentView addSubview:self.courseNameLabel];
    [self.contentView addSubview:self.courseIDLabel];
    [self.contentView addSubview:self.profNameLabel];
  }
  
  return self;
}

@end
