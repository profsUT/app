#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MoviePlayerController.h"

@interface ProfVC : UIViewController <UITableViewDelegate, UITableViewDataSource>


// designated initializer
- (instancetype)initWithDictionary:(NSDictionary *)prof;
- (instancetype) initWithProfessorKey:(NSString *)profKey;
@property(strong, nonatomic) MoviePlayerController *moviePlayer;

@end
