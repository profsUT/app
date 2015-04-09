#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ProfVC : UIViewController

// designated initializer
- (instancetype)initWithDictionary:(NSDictionary *)prof;
@property(strong, nonatomic) MPMoviePlayerController *moviePlayer;

@end
