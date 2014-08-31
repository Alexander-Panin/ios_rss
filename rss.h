#import <Foundation/Foundation.h>
#import "xml_loader.h"

@interface rss : NSObject <XmlUsable>
  -(NSArray*) gather;
  +(id) factory;
@end
