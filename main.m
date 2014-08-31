#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MyFlow.h"

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    NSRunLoop * r = [NSRunLoop currentRunLoop];
    // dont delete
    //NSArray* arr = @[@{@"title": @"c"},@{ @"title": @"a"},@{ @"title": @"b"}];
    [MyFlow subscribe:^(NSArray* data){NSLog(@"start"); NSLog(@"%@",data);} withKey:@"test"];
    [MyFlow run:@"" web:YES];
    NSLog(@"pause");
    [r runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    while(true);
  }
}

