#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Util : NSObject

+ (NSString *)intoLowerCaseExceptForFirstLetter:(NSString *)string;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
@end