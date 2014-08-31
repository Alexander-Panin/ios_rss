#import "MyDatabase.h"
#import <CoreData/CoreData.h>

@interface core_data_t : NSObject
@property(nonatomic, retain) NSManagedObjectContext* context;
@property(nonatomic, retain) NSEntityDescription * entity;
@end

@implementation core_data_t
+(id) factory {
    NSURL * u = [[NSBundle mainBundle] URLForResource:@"MyModel"
                                        withExtension:@"momd"];
    NSManagedObjectModel *m = [[[NSManagedObjectModel alloc]
                                initWithContentsOfURL:u] autorelease];
    NSURL *st_u0 = [[[NSFileManager defaultManager]
                     URLsForDirectory:NSDocumentDirectory
                     inDomains:NSUserDomainMask]
                    lastObject];
    NSURL *st_u = [st_u0 URLByAppendingPathComponent:@"console.sqlite"];
    NSPersistentStoreCoordinator *c = [[[NSPersistentStoreCoordinator alloc]
                                        initWithManagedObjectModel:m] autorelease];
    NSError *err = nil;
    [c addPersistentStoreWithType:NSSQLiteStoreType configuration:nil
                              URL:st_u options:nil error:&err];
    if (err) {
        NSLog(@"%@ %@", err, [err userInfo]);
        abort();
    }
    NSManagedObjectContext* context = [[[NSManagedObjectContext alloc]
                                        init] autorelease];
    [context setPersistentStoreCoordinator:c];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"MyData"
                                               inManagedObjectContext:context];
    
    // sort of copy and swap idiom
    core_data_t* obj = [[[self alloc] init] autorelease];
    obj.context = context;
    obj.entity = entity;
    return obj;
}

-(void) dealloc { self.context = 0; self.entity = 0; [super dealloc]; }
@end

void set_data_from_array(core_data_t* db, NSArray* arr) {
    for (NSDictionary* dict in arr) {
        NSManagedObject* core_obj = [NSEntityDescription
                                     insertNewObjectForEntityForName:[db.entity name]
                                     inManagedObjectContext:db.context];
        for (NSString* k in dict) [core_obj setValue:dict[k] forKey:k];
    }
}

@implementation MyDatabase : NSObject
    
  +(NSArray *) mine {
    core_data_t* db = [core_data_t factory];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorealease];
    [request setEntity:db.entity];
    NSSortDescriptor *d = [[[NSSortDescriptor alloc]
      initWithKey:@"pub_date" ascending:NO] autorelease];
    [request setSortDescriptors:@[d]];
    return [db.context executeFetchRequest:request];
  }

  +(NSArray *) mineWithFilter:(NSString *)filter {
    core_data_t* db = [core_data_t factory];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorealease];
    [request setEntity:db.entity];
    NSPredicate *p = [NSPredicate predicateWithFormat:
      @"title LIKE[c] '%@'", filter];
    [request setPredicate:p];
    NSSortDescriptor *d = [[[NSSortDescriptor alloc]
      initWithKey:@"pub_date" ascending:NO] autorelease];
    [request setSortDescriptors:@[d]];
    return [db.context executeFetchRequest:request];
  }
  +(void)saveAsync:(NSArray*) data {
    dispatch_queue_t global_q = dispatch_get_global_queue(
      DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); 
    dispatch_async(global_q , ^{
      core_data_t* db = [core_data_t factory];
      set_data_from_array(db, data);
      [db.context save:nil];
    }); 
  }

@end
