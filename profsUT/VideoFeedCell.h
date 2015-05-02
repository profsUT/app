//
//  VideoFeedCell.h
//  profsUT
//
//  Created by Zac Ioannidis on 1/5/15.
//  Copyright (c) 2015 Teacher's Pet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoFeedCell : UITableViewCell

@property (nonatomic, retain) UILabel *nameLabel;
//@property (nonatomic, retain) UILabel *courseLabel;
@property (nonatomic, retain) UIImageView *thumbnailView;

// Designated initializer
-(instancetype)initWithThumbnailURL:(NSString *)thumbnailURL
                      professorName:(NSString *)professorName;

@end
