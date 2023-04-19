//
//  Extension.swift
//  WeatherApp
//
//  Created by Rakesh Deshaboina on 11/04/23.
//

import Foundation
import UIKit
import CoreLocation


extension UIView {
   // create center anchor
    func centerXAnchor(inview view:UIView){
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    // create constraints for a view
    func anchor(top:NSLayoutYAxisAnchor? = nil,
                left:NSLayoutXAxisAnchor? = nil,
                right:NSLayoutXAxisAnchor? = nil,
                bottom:NSLayoutYAxisAnchor? = nil,
                topPadding:CGFloat = 0,
                leftPadding:CGFloat = 0,
                rightPadding:CGFloat = 0,
                bottomPadding:CGFloat = 0,
                width:CGFloat? = nil,
                height:CGFloat? = nil){
        
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant:  topPadding).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant:  leftPadding).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant:  -rightPadding).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant:  -bottomPadding).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        
        
    }
    
    func displayStackView(view1:UILabel , view2:UILabel, imageName: String , text1:String , text2:String){
        let viewImage = UIImageView()
        viewImage.image = UIImage(named: imageName)
        viewImage.sizeToFit()
        self.addSubview(viewImage)
        
        let view1 = UILabel()
        view1.text = text1
        view1.backgroundColor = .yellow
        view1.textAlignment = .center
        self.addSubview(view1)
        
        let view2 = UILabel()
        view2.text = text2
        view2.backgroundColor = .cyan
        view2.textAlignment = .center
        self.addSubview(view2)
        
        viewImage.anchor(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor,leftPadding: 20,rightPadding: 20,height: 75)
        
        view1.anchor(top: viewImage.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor,height: 20)

        view2.anchor(top: view1.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor,height: 20)
    }
    
}

extension CLLocation{
    func fetchCityName(complition:@escaping(_ city:String? , _ error:Error?)->()) {
        CLGeocoder().reverseGeocodeLocation(self) { (placeMark, error) in
            complition(placeMark?.first?.locality, error)
        }
    }
}
