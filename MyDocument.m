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

static NSString* prettyPrint(NSString *html) {
    html = [html stringByReplacingOccurrencesOfString:@"<br>" withString:@"<br/>"]; // This line saves us from having to do NSXMLDocumentTidyHTML.
    
    NSError *error = nil;
    NSXMLDocument *xmlDoc = [[[NSXMLDocument alloc] initWithXMLString:html options:0 error:&error] autorelease];
    if (xmlDoc) {
        return [[xmlDoc XMLStringWithOptions:NSXMLNodePrettyPrint] substringFromIndex:1];
    } else {
        NSLog(@"\nERROR\n%@\n\nSOURCE\n%@", error, html);
        return nil;
    }
}

- (void)windowControllerDidLoadNib:(NSWindowController*)controller_ {
    assert(webView);
    assert(htmlSourceView);
           
    [super windowControllerDidLoadNib:controller_];
    
    [webView setEditingDelegate:self];
    [webView setUIDelegate:self];
    
    NSString *html = prettyPrint(@"<html><head><title>title</title></head><body><p>body</p></body></html>");
    [[webView mainFrame] loadHTMLString:html baseURL:nil];
    [htmlSourceView setString:html];
}

- (void)webViewDidChange:(NSNotification*)notification_ {
    [htmlSourceView setString:prettyPrint([(DOMHTMLElement*)[[[webView mainFrame] DOMDocument] documentElement] outerHTML])];
}

- (void)textDidChange:(NSNotification*)notification_ {
    [[webView mainFrame] loadHTMLString:prettyPrint([htmlSourceView string]) baseURL:nil];
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

- (IBAction)outlineAction:(id)sender_ {
    [webView stringByEvaluatingJavaScriptFromString:@"document.execCommand('InsertUnorderedList', false, null);"];
}

#pragma mark -
#pragma mark WebUIDelegate

- (void)webView:(WebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame {
    NSLog(@"js: %@", message);
}

@end
