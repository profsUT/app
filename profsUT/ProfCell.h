#import <UIKit/UIKit.h>

@interface ProfCell : UITableViewCell

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *courseLabel;
@property (nonatomic, retain) UIImageView *portraitView;

// designated initializer
- (instancetype)initWithFirstName:(NSString *)first
                         lastName:(NSString *)last
                          courses:(NSArray *)courses
                            image:(UIImage *)image;

@end
