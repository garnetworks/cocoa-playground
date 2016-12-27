//
//  QRImageView.h
//  QRCodeGenerator
//
//  Created by kaifeng.
//  Copyright © 2016 kaifeng. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface QRImageView : NSImageView
@property (strong, nonatomic) CIImage *qrImage;
@end
