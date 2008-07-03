#import "MyDocument.h"

@implementation MyDocument

- (id)init {
    self = [super init];
    if (self) {
        WebPreferences *wpref = [[[WebPreferences alloc] initWithIdentifier:@"com.rentzsch.webedit.user-modify"] autorelease];
        [wpref setUserStyleSheetEnabled:YES];
        
        NSURL *cssFileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"user-modify" ofType:@"css"] isDirectory:NO];
        [wpref setUserStyleSheetLocation:cssFileURL];
    }
    return self;
}

- (NSString*)windowNibName {
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController*)controller_ {
    assert(webView);
    assert(htmlSourceView);
           
    [super windowControllerDidLoadNib:controller_];
    
    [webView setEditingDelegate:self];
    
    [[webView mainFrame] loadHTMLString:@"<html><head><title>title</title></head><body>body</body></html>"
                                baseURL:nil];
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
    [self webViewDidChange:nil];
}

- (void)webViewDidChange:(NSNotification*)notification_ {
    [htmlSourceView setString:[(DOMHTMLElement*)[[[webView mainFrame] DOMDocument] documentElement] outerHTML]];
}

- (NSData*)dataOfType:(NSString*)typeName_ error:(NSError**)error_
{
    // Insert code here to write your document to data of the specified type. If the given outError != NULL, ensure that you set *outError when returning nil.

    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    // For applications targeted for Panther or earlier systems, you should use the deprecated API -dataRepresentationOfType:. In this case you can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.

    if (error_) {
		*error_ = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return nil;
}

- (BOOL)readFromData:(NSData*)data_ ofType:(NSString*)typeName_ error:(NSError**)error_
{
    // Insert code here to read your document from the given data of the specified type.  If the given outError != NULL, ensure that you set *outError when returning NO.

    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead. 
    
    // For applications targeted for Panther or earlier systems, you should use the deprecated API -loadDataRepresentation:ofType. In this case you can also choose to override -readFromFile:ofType: or -loadFileWrapperRepresentation:ofType: instead.
    
    if (error_) {
		*error_ = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
}

@end
