#import "Util.h"

@implementation Util

+ (NSString *)intoLowerCaseExceptForFirstLetter:(NSString *)string {
  if (string && [string length] > 0) {
    NSString *lower = [string lowercaseString];
    return [lower stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                           withString:[[lower substringToIndex:1] capitalizedString]];
  } else {
    return @"";
  }
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
  //UIGraphicsBeginImageContext(newSize);
  // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
  // Pass 1.0 to force exact pixel size.
  UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
  [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

@end