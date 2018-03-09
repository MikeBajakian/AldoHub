//
//  Extensions.swift
//  AldoHub
//
//  Created by Mgrditch Bajakian on 2018-03-04.
//  Copyright © 2018 Mike Bajakian. All rights reserved.
//

import Foundation
import UIKit



//-----------------------------------------------------------------------------------------------------------------
// MARK: - UIImageView
extension UIImageView {
    func setRounded() { // to show a rounded image mainly for avatars
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
