//
//  JMPRfarnebackOf.h
//  openCVImplementation
//
//  Created by johndoe on 24/07/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import <Foundation/Foundation.h>

using namespace cv;
using namespace std;


@interface JMPRfarnebackOf : NSObject

Mat sfm( Mat& img1, Mat& img2, Mat& cam_matrix, Mat& dist_coeff );

@end
