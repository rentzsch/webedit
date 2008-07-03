#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface MyDocument : NSDocument {
    IBOutlet    WebView     *webView;
    IBOutlet    NSTextView  *htmlSourceView;
}
@end
