//
//  AlertView.swift
//  WeatherApp
//
//  Created by Rakesh Deshaboina on 11/04/23.
//

import Foundation
import UIKit

protocol NormalAlert {}
protocol ShowAlert {}

var alertViewController = UIAlertController()
    
extension NormalAlert where Self:UIViewController{
    func normalAlert(title:String,message:String,_ ok:@escaping()->Void){
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            ok()
        }
        alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertViewController.addAction(okAction)
        self.present(alertViewController, animated: true, completion: nil)
        
    }
}
extension ShowAlert where Self:UIViewController{
    func showAlert(title:String,message:String,_ ok:@escaping()->Void,_ cancel:@escaping()->Void){
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            ok()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
            cancel()
        }
        alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertViewController.addAction(okAction)
        alertViewController.addAction(cancelAction)
        self.present(alertViewController, animated: true, completion: nil)
        
    }
}
