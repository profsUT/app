//
//  VideoFeedCell.m
//  profsUT
//
//  Created by Zac Ioannidis on 1/5/15.
//  Copyright (c) 2015 Teacher's Pet. All rights reserved.
//

#import "VideoFeedCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation VideoFeedCell

-(instancetype)initWithThumbnailURL:(NSString *)thumbnailURL
                      professorName:(NSString *)professorName {
    self = [super init];
    if (self) {
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
        self.nameLabel.text = professorName;
        [self.nameLabel sizeToFit];
        self.nameLabel.frame = CGRectMake(0, 0, 100, 100);
        self.nameLabel.numberOfLines = 0;
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}


@end
