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

void fundamentalMatrix(vector<Point2f> &img_1_pts,vector<Point2f> &img_2_pts,Mat K, Mat &F, Mat &E,Matx34d &P,Matx34d &P1){
    
    vector<uchar> status(img_1_pts.size());
    
    
        F = findFundamentalMat(img_1_pts, img_2_pts,FM_RANSAC,3.0,0.99,status);
        E = K.t() * F * K;
    
    SVD svd(E);
    Matx33d W(0,-1,0,1,0,0,0,0,1);
    Mat_<double> R = svd.u * Mat(W) * svd.vt;
    Mat_<double> t = svd.u.col(2);
    Matx34d cameraP1(R(0,0),R(0,1),R(0,2),t(0),
                     R(1,0),R(1,1),R(1,2),t(1),
                     R(2,0),R(2,1),R(2,2),t(2));
    
    for (int i = 0;i<status.size();i++)
    {
        if(status[i]){
                cout<<"The Status for :"<<img_1_pts[i]<<" is --> "<<status[i]<<endl;
        }
    }
    
    cout<<"the status size is "<<status.size()<<" and the n points is "<<img_1_pts.size()<<endl;
    
    
   
    
    if(checkrot(R)){
        cout<<"The rotation is ok \n";
    }
    
    P = 0;
    P1 = cameraP1;
    
    vector<Point2f> correct_img_1_pts, correct_img_2_pts;
    correctMatches(F, img_1_pts, img_2_pts, correct_img_1_pts, correct_img_2_pts);
    
    img_1_pts = correct_img_1_pts;
    img_2_pts = correct_img_2_pts;
    
    
    
    cout<<"The ext cam is :"<<P1<<"\n";
    
    
    }

@end
