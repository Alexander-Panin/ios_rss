#import <Foundation/Foundation.h>

@protocol XmlUsable
-(void) run:(NSArray*) buffer;
@end

@interface MyXmlLoader : NSObject<NSXMLParserDelegate>
+(id) loader;
-(void) load:(NSURL *)url;
@property(nonatomic, assign) id<XmlUsable> delegate;
@end