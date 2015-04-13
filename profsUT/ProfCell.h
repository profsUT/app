#import <UIKit/UIKit.h>

@interface ProfCell : UITableViewCell

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *courseLabel;
@property (nonatomic, retain) UIImageView *portraitView;

// To do: courses should be array of dicts

// designated initializer
- (instancetype)initWithFirstName:(NSString *)first
                         lastName:(NSString *)last
                          courses:(NSDictionary *)courses
                            image:(UIImage *)image;

@end
