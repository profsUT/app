#import <UIKit/UIKit.h>

@interface CourseVC : UIViewController

// designated initializer
- (instancetype)initWithCourseKey:(NSString *)courseKey;
- (instancetype)initWithCourseID:(NSString *)courseID
                      courseName:(NSString *)courseName
                       courseKey:(NSString *)courseKey
                        profName:(NSString *)profName;

@end
