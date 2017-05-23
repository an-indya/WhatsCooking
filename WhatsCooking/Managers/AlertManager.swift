//
//  AlertManager.swift
//  Atom.Spark.iOS
//
//  Created by Anindya Sengupta on 3/22/17.
//  Copyright © 2017 Anindya Sengupta. All rights reserved.
//

import UIKit

class AlertManager: NSObject {

    static func showAlert(message: String, title: String, in viewController: UIViewController, with actions: [UIAlertAction]?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        if let actionList = actions {
            for action in actionList {
                alert.addAction(action)
            }
        }
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }

    class func showComingSoon(in viewController: UIViewController) {
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        showAlert(message: "Coming Soon!", title: "", in: viewController, with: [action])
    }

}
