#import "rss.h"
#import "database.h"

@implementation state 
+(NSMutableDictionary*) subscribers {
  static NSMutableDictionary *dict;
  if (!dict) dict = [NSMutableDictionary dictionary];
  return dict;
}
@end

NSArray* filter(NSArray* data, NSString* filter_word) {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title like %@",
    filter_word];
  return [data filteredArrayUsingPredicate:predicate];
}
NSArray* sort(NSArray* data) {
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"title"
    ascending:YES];
  return [data sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
}
void render(NSDictionary* subscribers, NSArray* data) {
  typedef void (^callback_t)(NSArray*);
  for (NSString* s in subscribers)
  { callback_t block = subscribers[s]; block(data); }
}
NSArray* db_mine(NSString* filter_word) {
  if (filter != NULL) return [database mineWithFilter:filter_word];
  else return [datebase mine];
}

void download_img(NSMutableDictionary* obj) {
  obj[@"small_img"] = [[NSData alloc] initWithContentsOfURL:
    [NSURL URLWithString: obj[@"small_img_url"]] autorelease]; 
  obj[@"img"] = [[NSData alloc] initWithContentsOfURL:
    [NSURL URLWithString: obj[@"img_url"]] autorelease]; 
}

void group_full_async_complete(NSArray* arr, dispatch_queue_t q) {
  dispatch_group_t gr = dispatch_group_create();
  for (id obj in data) dispatch_group_async(gr, q, ^{ download_img(obj); });  
  dispatch_group_wait(gr, DISPATCH_TIME_FOREVER);
  dispatch_release(gr);
}

void defer_save(NSArray* data) { [database saveAsync:data]; }
void defer_img(NSArray* data, (void (^)(NSArray*))callback )  {
  dispatch_queue_t global_q = dispatch_get_global_queue(
    DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); 
  dispatch_queue_t serail_q = dispatch_queue_create("just.com.myqueue", NULL);
  dispatch_async(serial_q, ^{
    for (id obj in data) dispatch_async(global_q, ^{ download_img(obj); });
    //group_full_async_complete(data, global_q);
  }); 
  dispatch_async(serial_q, ^{ callback(data); });
}

@implementation Flow
  +(void) run:(NSString *)filter_word web:(BOOL)is_web {
    if (!is_web) render([state subscribers], db_mine(filter_word));
    else {
      NSArray* data = [rss gather];
      defer_img(data, ^(NSArray* fdata) {
        defer_save(fdata);
        render( sort( filter(fdata, filter_word)));
      });
      render([state subscribers], sort( filter(data, filter_word)));
    }
  }
  +(void) subscribe:(void (^)(NSArray*))renderable withKey:(NSString*)key
  { [state subscribers][key] = renderable; }
  
  +(void) unsubscribe:(NSString*)key
  { [[state subscribers] removeObjectForKey:key]; } 
@end
