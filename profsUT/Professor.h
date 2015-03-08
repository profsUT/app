#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface Professor : NSObject

@property (copy, nonatomic) NSString *firstName;
@property (copy, nonatomic) NSString *lastName;
@property (retain, nonatomic) NSArray *courses;
@property (retain, nonatomic) UIImage *portrait;

@property (retain, nonatomic) NSArray *profsArray;

+ (instancetype)sharedInstance;

@end
