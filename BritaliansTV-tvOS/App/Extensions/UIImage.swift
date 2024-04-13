//
//  UIImage.swift
//  BritaliansTV-tvOS
//
//  Created by miqo on 07.01.24.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        let aspectWidth = size.width / self.size.width
        let aspectHeight = size.height / self.size.height
        let aspectRatio = min(aspectWidth, aspectHeight)
        let fitSize = CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio)
        
        return UIGraphicsImageRenderer(size: fitSize).image { _ in
            draw(in: CGRect(origin: .zero, size: fitSize))
        }
    }
}
