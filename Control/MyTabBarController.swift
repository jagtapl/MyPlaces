//
//  MyTabBarController.swift
//  MyPlaces
//
//  Created by LALIT JAGTAP on 5/5/18.
//  Copyright © 2018 LALIT JAGTAP. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var childViewControllerForStatusBarStyle: UIViewController? {
        return nil
    }
}
