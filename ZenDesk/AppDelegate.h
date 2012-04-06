#import <Cocoa/Cocoa.h>
#import "XmlDelegate.h"
@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak)IBOutlet XmlDelegate *xmlDelegate;





@end
