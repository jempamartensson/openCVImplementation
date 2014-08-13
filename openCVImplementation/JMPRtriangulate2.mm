//
//  JMPRtriangulate2.m
//  openCVImplementation
//
//  Created by johndoe on 04/08/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import "JMPRtriangulate2.h"
#import "JMPRlinearLSTriangulation.h"
#import "JMPRiterativeLinearLSTriangulation.h"
#import <fstream>


using namespace cv;
using namespace std;


@implementation JMPRtriangulate2

double JMPRtriangulateTwo(vector<Point2f> img_1_pts,vector<Point2f> img_2_pts,Matx34d P,Matx34d P1,const Mat& K,
                                const Mat &Kinv,vector<Point3d> &pointCloud){
    
    //convert image points to homogenous
    unsigned int pts_size = int(img_1_pts.size());
    vector<double> reproj_error;
    
    ofstream myfile;
    myfile.open("/Users/johndoe/Develop/statue_picture/example.txt");
    
    for (unsigned int i = 0; i< pts_size; i++)
    {
        Point2d kp = img_1_pts[i];
		Point3d u(kp.x,kp.y,1.0);
		Mat_<double> um = Kinv * Mat_<double>(u);
		u.x = um(0); u.y = um(1); u.z = um(2);
        //cout<<u.x<<" "<<u.y<<" "<<u.z<<"\n";
        
        
		Point2d kp1 = img_2_pts[i];
		Point3d u1(kp1.x,kp1.y,1.0);
		Mat_<double> um1 = Kinv * Mat_<double>(u1);
		u1.x = um1(0); u1.y = um1(1); u1.z = um1(2);
        //cout<<u1.x<<" "<<u1.y<<" "<<u1.z<<"\n";
        
        //Mat_<double> X = IterativeLinearLSTriangulation(u, P, u1, P1);
        
		Mat_<double> X = LinearLSTriangulation(u,P,u1,P1);
        //cout<<"X is :\n"<<X<<"\n";
        
        //calculate reprojection error
//        Mat_<double> xPt_img = K * Mat(P1) * X;
//        Point2d xPt_img_(xPt_img(0)/xPt_img(2),xPt_img(1)/xPt_img(2));
//        reproj_error.push_back(norm(xPt_img_-kp1));
        
        //store 3D point
        pointCloud.push_back(Point3d(X(0),X(1),X(2)));
        myfile<<X(0)<<" "<<X(1)<<" "<<X(2)<<"\n";
        

        
        
    
    }
    
    myfile.close();
    cout<<"The size of the pointcloud is :"<<pointCloud.size()<<endl;
    
    //return mean reprojection error
    Scalar me = mean(reproj_error);
    
    cout<<"The reproj error is  :"<<me[0]<<endl;
    return me[0];
    
}


@end
