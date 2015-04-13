#import "ProfCell.h"

@implementation ProfCell

- (instancetype)initWithFirstName:(NSString *)first
                         lastName:(NSString *)last
                          courses:(NSArray *)courses
                            image:(UIImage *)image {
  self = [super init];
  if (self) {
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:24.0];
    self.nameLabel.text = [NSString stringWithFormat:@"%@, %@", last, first];
    [self.nameLabel sizeToFit];
    self.nameLabel.frame = CGRectMake(100, 50 - self.nameLabel.frame.size.height,
                                      self.frame.size.width - 100, self.nameLabel.frame.size.height+20);
    self.nameLabel.numberOfLines = 0;
//    self.nameLabel.layer.borderColor = [[UIColor redColor] CGColor];
//    self.nameLabel.layer.borderWidth = 2.0;
    
    self.courseLabel = [[UILabel alloc] init];
    self.courseLabel.font = [UIFont fontWithName:@"Copse" size:16.0];

    NSString *courseString = @"";
      
    BOOL first = true;
    for (NSString *course in courses) {
//      if (first) {
//        courseString = course;
//        first = FALSE;
//      } else {
//        courseString = [courseString stringByAppendingString:[NSString stringWithFormat:@", %@", course]];
//      }
//        NSLog(@"Zac%@", course);
    }
      
    courseString = @"bla";
    self.courseLabel.text = courseString;
    
    self.courseLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.courseLabel.numberOfLines = 0;
    [self.courseLabel sizeToFit];
    self.courseLabel.frame = CGRectMake(100, 50,
                                        self.frame.size.width - 100, self.courseLabel.frame.size.height * 2);
    
    self.portraitView = [[UIImageView alloc] initWithImage:image];
    self.portraitView.frame = CGRectMake(self.imageView.frame.origin.x + 10,
                                         self.imageView.frame.origin.y + 10, 80, 80);

    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.courseLabel];
    [self.contentView addSubview:self.portraitView];
  }
  return self;
}

@end
