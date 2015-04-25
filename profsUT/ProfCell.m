#import "ProfCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

static CGFloat leftPadding = 15.0;

@implementation ProfCell

- (instancetype)initWithFullName:(NSString *)name {
  self = [super init];
  if (self) {
    self.nameLabel = [[UILabel alloc] init];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    self.nameLabel.text = name;
    [self.nameLabel sizeToFit];
    self.nameLabel.frame = CGRectMake(leftPadding, 0,
                                      self.frame.size.width - 100, self.nameLabel.frame.size.height+20);
    self.nameLabel.numberOfLines = 0;
    
    [self.contentView addSubview:self.nameLabel];

  }
  
  return self;
}

- (instancetype)initWithFirstName:(NSString *)first
                         lastName:(NSString *)last
                          courses:(NSDictionary *)courses
                            imageURL:(NSString *)imageURL {
  self = [super init];
  if (self) {
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont fontWithName:@"Copse" size:20.0];
    self.nameLabel.text = [NSString stringWithFormat:@"%@, %@", last, first];
    [self.nameLabel sizeToFit];
    self.nameLabel.frame = CGRectMake(100, 50 - self.nameLabel.frame.size.height,
                                      self.frame.size.width - 130, self.nameLabel.frame.size.height+20);
    self.nameLabel.numberOfLines = 0;
//    self.nameLabel.layer.borderColor = [[UIColor redColor] CGColor];
//    self.nameLabel.layer.borderWidth = 2.0;
    
    self.courseLabel = [[UILabel alloc] init];
    self.courseLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];

    NSString *courseString = @"";
      
    BOOL first = true;
    for (NSString *course in courses) {
      // Collapse multiple whitespaces to one
      NSString *_course = course; // Do this because can't modify enumerator in ARC
      NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
      NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
      
      NSArray *parts = [_course componentsSeparatedByCharactersInSet:whitespaces];
      NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
      _course = [filteredArray componentsJoinedByString:@" "];
      
      if (first) {
        courseString = _course;
        first = FALSE;
      } else {
        courseString = [courseString stringByAppendingString:[NSString stringWithFormat:@", %@", _course]];
      }

    }
      

    self.courseLabel.text = courseString;
    
//    self.courseLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    self.courseLabel.numberOfLines = 0;
    [self.courseLabel sizeToFit];
    self.courseLabel.frame = CGRectMake(100, 50,
                                        self.frame.size.width - 130, self.courseLabel.frame.size.height * 2);
    
////    Functional code
//    self.portraitView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quigley.png"]];
//    self.portraitView.frame = CGRectMake(self.imageView.frame.origin.x + 10,
//                                         self.imageView.frame.origin.y + 10, 80, 80);

//    NSLog(@"%@", imageURL);
    
    if([imageURL isEqual:@""]) {
      self.portraitView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profCell.png"]];
      self.portraitView.frame = CGRectMake(self.imageView.frame.origin.x + 10,
                                           self.imageView.frame.origin.y + 10, 80, 80);
    }
    else {
      [self.imageView
       sd_setImageWithURL:[NSURL URLWithString:imageURL]
       placeholderImage:[UIImage imageNamed:@"quigley.png"]];

    }
    
    
//    [self.portraitView
//     sd_setImageWithURL:[NSURL URLWithString:@"http://django-profs-prod.s3.amazonaws.com/media/profile_pics/chyi.jpg"]
//      placeholderImage:[UIImage imageNamed:@"quigley.png"]];
    
//    NSLog(@"imageView frame x: %f, y: %f", self.imageView.frame.origin.x, self.imageView.frame.origin.y);
//    self.portraitView.frame = CGRectMake(self.imageView.frame.origin.x + 10,
//                                         self.imageView.frame.origin.y + 10, 80, 80);


    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.courseLabel];
    [self.contentView addSubview:self.portraitView];
  }
  return self;
}

@end
