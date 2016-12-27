//
//  QRImageView.m
//  QRCodeGenerator
//
//  Created by kaifeng.
//  Copyright © 2016 kaifeng. All rights reserved.
//

#import "QRImageView.h"
#import <QuartzCore/CoreImage.h>

@implementation QRImageView

- (void)setQrImage:(CIImage *)qrImage {
    if(qrImage != nil) {
        [self setNeedsDisplay];
        _qrImage = qrImage;
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    if(self.qrImage) {
        CGImageRef cgImageRef = [[CIContext contextWithOptions:nil] createCGImage:self.qrImage fromRect:self.qrImage.extent];
        CGContextRef context = [NSGraphicsContext currentContext].CGContext;
        CGContextSetInterpolationQuality(context, kCGInterpolationNone);
        CGContextDrawImage(context, self.bounds, cgImageRef);
        CGImageRef outImageRef = CGBitmapContextCreateImage(context);
        self.image = [[NSImage alloc]initWithCGImage:outImageRef size:NSZeroSize];
    }
}

@end
