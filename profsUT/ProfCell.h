#import <UIKit/UIKit.h>

@interface ProfCell : UITableViewCell

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *courseLabel;
@property (nonatomic, retain) UIImageView *portraitView;

// To do: courses should be array of dicts

// designated initializer
- (instancetype)initWithFullName:(NSString *)name;
- (instancetype)initWithFirstName:(NSString *)first
                         lastName:(NSString *)last
                          courses:(NSDictionary *)courses
                         imageURL:(NSString *)imageURL;

@end
