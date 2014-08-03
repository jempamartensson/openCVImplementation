//
//  JMPRtriangulate.h
//  openCVImplementation
//
//  Created by johndoe on 03/08/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import <Foundation/Foundation.h>


using namespace cv;
using namespace std;

@interface JMPRtriangulate : NSObject

void JMPRtriangulatePoints(Matx34d camera1,Matx34d camera2, vector<Point2f> &img_1_pts,vector<Point2f> &img_2_pts,Mat pts_3d);


@end
