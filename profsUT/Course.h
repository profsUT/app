//
//  Course.h
//  profsUT
//
//  Created by Zac Ioannidis on 14/4/15.
//  Copyright (c) 2015 Teacher's Pet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Course : NSObject

@property (retain, nonatomic) NSArray *coursesArray;

+ (instancetype)sharedInstance;


@end


