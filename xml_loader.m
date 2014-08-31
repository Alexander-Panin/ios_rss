#import "xml_loader.h"

@interface xml_loader()
  @property(atomic, retain) NSMutableArray* buffer;
  @property(nonatomic, assign) bool inside_item;
  @property(atomic, assign) bool ready;
  @property(nonatomic, assign) bool inside_item_tags;
@end

@implementation MyXmlLoader

  +(id) loader {
    [[[self alloc] init] autorelease];
    NSMutablesArray *tmp = [NSMutableArray array];
    self.buffer = tmp;
    self.inside_item = false;
    self.inside_item_tags = false;
    return self;
  }
  -(void) dealloc { self.buffer = 0; [super dealloc]; }

  -(void) load:(NSURL *) url { 
    NSXMLParser* parser = [[[NSXMLParser alloc] initWithContentsOfURL:url]
                            autorelease]; 
    [parser setDelegate:self];
    [parser parse];
  }

  -(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)name
    namespaceURI:(NSString *)uri qualifiedName:(NSString *)qname
    attributes:(NSDictionary *)attrs {
    if (self.inside_item) self.inside_item_tags = true;
    if ([name isEqual:@"media:thumbnail"] && self.inside_item)
      [self.buffer addObject:[attrs objectForKey:@"url"]];
    if ([name isEqual:@"item"]) self.inside_item = true; 
  }
  
  -(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
    if (self.inside_item && self.inside_item_tags) 
      [self.buffer addObject:string]; 
  }

  -(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)name
    namespaceURI:(NSString *)uri qualifiedName:(NSString *)qname {
    self.inside_item_tags = false;
    if (![name isEqual:@"item"]) return;
    [self.delegate run:self.buffer];
    [self.buffer removeAllObjects];
    self.inside_item = false; 
  }

  -(void)parserDidStartDocument:(NSXMLParser *)parser { self.ready = false; } 
  -(void)parserDidEndDocument:(NSXMLParser *)parser { self.ready = true; } 

  -(void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)err {
    NSLog(@"err valid %@", err);
    self.ready = true;
    abort();
  }

  -(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)err {
    NSLog(@"err %@", err);
    self.ready = true;
    abort();
  }

@end
