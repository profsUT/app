#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface Professor : NSObject

@property (retain, nonatomic) NSArray *profsArray;

+ (instancetype)sharedInstance;

@end
