#import "MyDocument.h"

@implementation MyDocument

- (id)init {
    self = [super init];
    if (self) {
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
    
    [[webView mainFrame] loadHTMLString:
#if 1
     @"<html><head><title>title</title><style type=\"text/css\"></style></head><body>body</body></html>"
#else
     @"<html><head><title>title</title><style type=\"text/css\">body{color:red;}</style></head><body contentEditable=true>body</body></html>"
#endif
                                baseURL:nil];
}

// DOMCSSRule > DOMObject
// DOMCSSStyleDeclaration > DOMObject
// DOMCSSValue > DOMObject
// createCSSStyleDeclaration
// DOMStyleSheet > DOMObject

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
    //DOMCSSStyleDeclaration *style = [[webView mainFrameDocument] createCSSStyleDeclaration];
    //[style setCssText:@"-webkit-user-modify: read-write"];
    //[style setProperty:@"-webkit-user-modify" value:@"read-write" priority:@"important"];
    //--; // add `-webkit-user-modify: read-write;` css rule
    
    DOMStyleSheetList *stylesheetList = [webView mainFrameDocument].styleSheets;
    unsigned stylesheetIndex = 0, stylesheetCount = stylesheetList.length;
    for (; stylesheetIndex < stylesheetCount; stylesheetIndex++) {
        DOMCSSStyleSheet *stylesheet = (DOMCSSStyleSheet*)[stylesheetList item:stylesheetIndex];
        [stylesheet insertRule:@"body {-webkit-user-modify:read-write;}" index:0]; // TODO add our own stylesheet
        
        DOMCSSRuleList *ruleList = stylesheet.cssRules;
        unsigned ruleIndex = 0, ruleCount = ruleList.length;
        for (; ruleIndex < ruleCount; ruleIndex++) {
            DOMCSSRule *rule = [ruleList item:ruleIndex];
            //NSLog(@"rule[%d]: %@", ruleIndex, rule.cssText);
        }
    }
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
