#import "xml_loader.h"
#define HAVE_TO_COUNT_IN_ITEM 9

@interface rss() {}
  @property(atomic, retain) NSMutableArray* data;
@end

NSDate* str2date(NSString* str) { 
  NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease]; 
  [formatter setDateFormat:@"EE, d LLLL yyyy HH:mm:ss Z"];
  return [formatter dateFromString:str];
}
NSString* concat3(NSString* str, NSString* str2, NSString* str3)
{ return [NSString stringWithFormat:@"%@%@%@", str, str2, str3]; }

@implementation rss
  +(id) factory { 
    NSMutableArray *tmp = [NSMutableArray array];
    [[[self alloc] init] autorelease]; 
    self.data = tmp;
    return self;
  }
  -(void) run:(NSArray *) buf {
    if ([buf count] != HAVE_TO_COUNT_IN_ITEM) return; //skip bad formated  
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    // order matter
    NSArray *fields = @[ @"title", @"desc", @"link", @"guid",
                         @"pubDate", @"small_img_url", @"img_url" ];
    int i = 0;
    for (NSString* f in fields) {
      if ([f isEqual:@"link"]) dict[f] = concat3(buf[i++], buf[i++], buf[i++]);
      else if ([f isEqual:@"pubDate"]) dict[f] = str2date(buf[i++]);
      else dict[f] = buffer[i++]; 
    }
    [self.data addObject:dict];
  }
  -(NSArray*) gather { 
    xml_loader* loader = [xml_loader loader];
    [loader setDelegate:self];
    [loader load:[NSURL URLWithString:@"http://feeds.bbci.co.uk/news/rss.xml"]];
    return self.data;
  }
  -(void)dealloc { self.data = 0; [super dealloc]; }
@end
