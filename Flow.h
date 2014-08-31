//#import <Foundation/Foundation.h>

@interface Flow : NSObject 
  +(void) run:(NSString*)filter_word web:(BOOL)is_web;
  +(void) subscribe:(void (^)(NSArray*))renderable withKey:(NSString*)key;
  +(void) unsubscribe:(NSString*)key;
@end
