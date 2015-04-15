#import <UIKit/UIKit.h>

@interface CourseCell : UITableViewCell

@property (nonatomic, retain) UILabel *courseNameLabel;
@property (nonatomic, retain) UILabel *courseIDLabel;
@property (nonatomic, retain) UILabel *profNameLabel;
//@property (nonatomic, retain) UIImageView *portraitView;

- (instancetype)initWithCourseID:(NSString *)_courseID
                      courseName:(NSString *)_courseName
                   profFirstName:(NSString *)_profFirstName
                    profLastName:(NSString *)_profLastName;

@end
