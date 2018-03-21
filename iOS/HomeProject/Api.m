//
//  Api.m
//  HomeProject
//
//  Created by Yogev Barber on 21/03/2018.
//  Copyright © 2018 Yogev Barber. All rights reserved.
//

#import "Api.h"
#import "AFNetworking.h"
#import "FaceDetectModel.h"

#define SERVER_URL @"http://192.168.14.83:4000/getImageData"
#define MAX_REQUEST_TIMEOUT 30.0
#define POST @"POST"
#define IMAGE_NAME @"image"
#define FILE_NAME @"picture.jpg"
#define MIME_TYPE @"image/jpeg"
#define IMAGE_UPLOAD_QUALITY 0.1

@implementation Api

+(void)getFaceElementsFromImage:(UIImage *)image success:(void (^)(NSArray<FaceDetectModel*> *faces))success failure:(void (^)(NSError *error))failure{
    
    NSData *imageData = UIImageJPEGRepresentation(image, IMAGE_UPLOAD_QUALITY);
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:POST URLString:SERVER_URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData
                                    name:IMAGE_NAME
                                fileName:FILE_NAME
                                mimeType:MIME_TYPE];
    } error:nil];
    
    [request setTimeoutInterval:MAX_REQUEST_TIMEOUT];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:nil
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      
                      if (error) {
                          failure(error);
                          return;
                      }
                      
                      if (!responseObject || ![responseObject count]) {
                          NSError *e = [NSError errorWithDomain:@"ResponseObjectNotValid" code:100 userInfo:@{NSLocalizedDescriptionKey : @"No results - please try again"}];
                          failure(e);
                          return;
                      }
                      
                      NSMutableArray<FaceDetectModel*> *faces = [NSMutableArray array];
                      for (id unparsedFace in responseObject) {
                          FaceDetectModel *face = [FaceDetectModel parseFaceDetect:unparsedFace];
                          [faces addObject:face];
                      }                      
                      
                      if (!faces.count) {
                          NSError *e = [NSError errorWithDomain:@"ParseFaceDetectFaild" code:101 userInfo:@{NSLocalizedDescriptionKey : @"face detect parsing faild."}];
                          failure(e);
                          return;
                      }
                      
                      success(faces);
                  }];
    
    [uploadTask resume];
}
@end
