#import <UIKit/UIKit.h>

@interface CourseVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) BOOL showInstructor;

// designated initializer
- (instancetype)initWithCourseKey:(NSString *)courseKey;
-(instancetype)initWithCourseKey:(NSString *)courseKey showInstructor:(int)showInstructor;
- (instancetype)initWithCourseID:(NSString *)courseID
                      courseName:(NSString *)courseName
                       courseKey:(NSString *)courseKey
                        profName:(NSString *)profName;

@end
