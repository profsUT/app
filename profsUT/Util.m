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

@end