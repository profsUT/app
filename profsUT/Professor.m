#import "Professor.h"

@implementation Professor

- (instancetype)init {
  self = [super init];
  if (self) {
    _profsArray = @[@"Robert Quigley", @"Jeff Linwood", @"Miles Hutson"];
  }
  return self;
}

+ (instancetype)sharedInstance {
  static Professor *sharedProfessor = nil;
  @synchronized(self) {
    if (sharedProfessor == nil)
      sharedProfessor = [[self alloc] init];
  }
  return sharedProfessor;
}

@end
