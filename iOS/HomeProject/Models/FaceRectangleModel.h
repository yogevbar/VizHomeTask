//
//  FaceRectangleModel.h
//  HomeProject
//
//  Created by Yogev Barber on 21/03/2018.
//  Copyright © 2018 Yogev Barber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaceRectangleModel : NSObject
@property (nonatomic, assign) float x;
@property (nonatomic, assign) float y;
@property (nonatomic, assign) float width;
@property (nonatomic, assign) float height;
+(FaceRectangleModel*)parseFaceRectangle:(NSDictionary*)unparsedFaceRectangle;
-(CGRect)getRect;
@end
