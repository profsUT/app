#import <UIKit/UIKit.h>

@interface CourseVC : UIViewController

// designated initializer
- (instancetype)initWithCourseID:(NSString *)courseID
                      courseName:(NSString *)courseName
                        profName:(NSString *)profName;

@end
