//
//  UIImage+Crop.m
//  HomeProject
//
//  Created by Yogev Barber on 21/03/2018.
//  Copyright © 2018 Yogev Barber. All rights reserved.
//

#import "UIImage+Crop.h"

@implementation UIImage (Crop)
- (UIImage *) croppedImage:(CGRect)cropRect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect( [self CGImage], cropRect );
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:1.0f orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return croppedImage;
}
@end
