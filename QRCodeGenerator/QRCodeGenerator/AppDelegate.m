//
//  AppDelegate.m
//  QRCodeGenerator
//
//  Created by kaifeng.
//  Copyright © 2016 kaifeng. All rights reserved.
//

#import "AppDelegate.h"
#import <QuartzCore/CoreImage.h>
#import "QRImageView.h"

@interface AppDelegate ()
@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet QRImageView *imageView;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSButton *btnSave;
@property (unsafe_unretained) IBOutlet NSTextView *textViewContent;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.btnSave.enabled = NO;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
- (IBAction)generate:(id)sender {
    
    NSString *content = _textViewContent.string;
    if(content == nil) {
        content = @"";
    }
    
    [self.progressIndicator startAnimation:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [content dataUsingEncoding:NSISOLatin1StringEncoding];
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        [filter setValue:data forKey:@"inputMessage"];
        [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
        
        self.imageView.qrImage = filter.outputImage;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressIndicator stopAnimation:nil];
            self.btnSave.enabled = YES;
        });
    });
}
- (IBAction)save:(id)sender {
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    savePanel.allowedFileTypes = @[@"png"];
    savePanel.allowsOtherFileTypes = NO;
    [savePanel setNameFieldStringValue:@"untitled"];
    [savePanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if(result == NSFileHandlingPanelOKButton) {
            NSBitmapImageRep *rep = [[NSBitmapImageRep alloc]initWithCIImage:self.imageView.qrImage];
            NSData *pngData = [rep representationUsingType:NSPNGFileType properties:[NSDictionary dictionary]];
            [pngData writeToURL:savePanel.URL atomically:YES];
        }
    }];
    
}

@end
