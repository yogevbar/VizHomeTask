//
//  UIImage+Crop.h
//  HomeProject
//
//  Created by Yogev Barber on 21/03/2018.
//  Copyright © 2018 Yogev Barber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Crop)
- (UIImage *) croppedImage:(CGRect)cropRect;
@end
