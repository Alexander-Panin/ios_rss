#import <Foundation/Foundation.h>

@interface MyDatabase : NSObject
+(NSArray *) mine;
+(NSArray *) mineWithFilter:(NSString *)filter;
+(void)saveAsync:(NSArray*) data;
@end
