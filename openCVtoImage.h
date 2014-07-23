//
//  openCVtoImage.h
//  openCVImplementation
//
//  Created by johndoe on 16/07/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (openCVtoImage)

+ (NSImage*)imageWithCVMat:(const cv::Mat&)cvMat;
- (id)initWithCVMat:(const cv::Mat&)cvMat;
- (cv::Ptr<cv::Mat>)cvMat;

@end
