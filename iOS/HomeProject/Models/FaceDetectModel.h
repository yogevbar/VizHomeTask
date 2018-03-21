//
//  FaceDetectModel.h
//  HomeProject
//
//  Created by Yogev Barber on 21/03/2018.
//  Copyright © 2018 Yogev Barber. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FaceRectangleModel;

@interface FaceDetectModel : NSObject
@property (nonatomic, strong) FaceRectangleModel *faceRectangle;
@property (nonatomic, strong) NSDictionary *emotions;
+(FaceDetectModel*)parseFaceDetect:(NSDictionary*)unparsedFaceDetect;
-(NSString*)getStrongestEmotion;
@end
