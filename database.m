@interface database()
  @property(nonatomic, retain) NSManagedObjectContext* context; 
  @property(nonatomic, retain) NSEntityDescription * entity;
@end

@implementation core_data
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

    [[[self alloc] init] autorelease];
    self.context = context;
    self.entity = entity;
    return self;
  }
  -(void) dealloc { self.context = self.entity = 0; [super dealloc]; }
@end

void set_data_from_array(core_data* db, NSArray* arr) {
  for (NSDictionary* dict in arr) {
    NSManagedObject* core_obj = [NSEntityDescription
      insertNewObjectForEntityForName:[db.entity name]
      inManagedObjectContext:db.context];
    for (NSString* k in dict) [obj setValue:dict[k] forKey:k]; 
  }
}
@implementation database
    
  +(NSArray *) mine {
    core_data* db = [core_data factory];     
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorealease];
    [request setEntity:db.entity];
    NSSortDescriptor *d = [[[NSSortDescriptor alloc]
      initWithKey:@"pub_date" ascending:NO] autorelease];
    [request setSortDescriptors:@[d]];
    return [db.context executeFetchRequest:request];
  }

  +(NSArray *) mineWithFilter:(NSString *)filter {
    core_data* db = [core_data factory];     
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
  +(void)async_save:(NSArray*) data {
    dispatch_queue_t global_q = dispatch_get_global_queue(
      DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); 
    dispatch_async(global_q , ^{
      core_data* db = [core_data factory];     
      set_data_from_array(db, data);
      [db.context save:nil];
    }); 
  }

@end
