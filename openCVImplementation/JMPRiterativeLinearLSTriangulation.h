//
//  JMPRiterativeLinearLSTriangulation.h
//  openCVImplementation
//
//  Created by johndoe on 04/08/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import <Foundation/Foundation.h>

using namespace cv;
using namespace std;

@interface JMPRiterativeLinearLSTriangulation : NSObject


Mat_<double> IterativeLinearLSTriangulation(Point3d u,	//homogenous image point (u,v,1)
											Matx34d P,			//camera 1 matrix
											Point3d u1,			//homogenous image point in 2nd camera
											Matx34d P1			//camera 2 matrix
);

@end
