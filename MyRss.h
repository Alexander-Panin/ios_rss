
#import <Foundation/Foundation.h>
#import "MyXmlLoader.h"

@interface MyRss : NSObject <XmlUsable>
-(NSArray*) gather;
+(id) factory;
@end
