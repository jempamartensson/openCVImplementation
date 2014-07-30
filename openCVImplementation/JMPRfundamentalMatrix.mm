//
//  JMPRfundamentalMatrix.m
//  openCVImplementation
//
//  Created by johndoe on 29/07/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import "JMPRfundamentalMatrix.h"
#import "JMPRcheckRot.h"

using namespace cv;
using namespace std;


@implementation JMPRfundamentalMatrix

void fundamentalMatrix(vector<Point2f> img_1_pts,vector<Point2f> img_2_pts,Mat cameraM, Mat &F, Mat &E,Matx34d &P,Matx34d &P1){
    
        F = findFundamentalMat(img_1_pts, img_2_pts,FM_RANSAC,0.1,0.99);
        E = cameraM.t() * F * cameraM;
    
    SVD svd(E);
    Matx33d W(0,-1,0,1,0,0,0,0,1);
    Mat_<double> R = svd.u * Mat(W) * svd.vt;
    Mat_<double> t = svd.u.col(2);
    Matx34d cameraP1(R(0,0),R(0,1),R(0,2),t(0),
               R(1,0),R(1,1),R(1,2),t(1),
               R(2,0),R(2,1),R(2,2),t(2));
    
   
    
    if(checkrot(R)){
        cout<<"The rotation is ok \n";
    }
    
    P = 0;
    P1 = cameraP1;
    
    }

@end
