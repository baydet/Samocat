//
//  Extensions.swift
//  Meme
//
//  Created by Orangesoft Developer on 14.04.17.
//  Copyright © 2017 Orangesoft. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert);
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
