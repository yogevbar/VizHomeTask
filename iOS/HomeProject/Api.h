//
//  Api.h
//  HomeProject
//
//  Created by Yogev Barber on 21/03/2018.
//  Copyright © 2018 Yogev Barber. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FaceDetectModel;

@interface Api : NSObject
+(void)getFaceElementsFromImage:(UIImage *)image success:(void (^)(NSArray<FaceDetectModel*> *faces))success failure:(void (^)(NSError *error))failure;
@end
