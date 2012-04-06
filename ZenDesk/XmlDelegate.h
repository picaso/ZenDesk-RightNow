#import <WebKit/WebKit.h>
#import <Foundation/Foundation.h>

@interface XmlDelegate : NSObjectController
@property (weak) IBOutlet NSSearchField *uri;
@property (weak) IBOutlet NSButton *GoButton;
@property (weak) IBOutlet NSTextField *test;
@property (weak) IBOutlet WebView *safari;

- (IBAction)connectToUrl:(id)sender;

@end
