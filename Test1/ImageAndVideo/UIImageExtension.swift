//
//  UIImageExtension.swift
//  Test1
//
//  Created by bigyelow on 12/07/2017.
//  Copyright © 2017 huangduyu. All rights reserved.
//

import Foundation

extension UIImage {
  func drawRectangle(withBoundingBox boundingBox: CGRect) -> UIImage? {
    UIGraphicsBeginImageContext(size)
    guard let context = UIGraphicsGetCurrentContext() else { return nil}

    // 1. Draw original image
    draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

    // 2. Draw rectangle
    let drawSize = CGSize(width: size.width * boundingBox.size.width, height: size.height * boundingBox.size.height)
    let drawPoint = CGPoint(x: size.width * boundingBox.origin.x, y: size.height * (1 - boundingBox.origin.y) - drawSize.height)
    context.setStrokeColor(UIColor.yellow.cgColor)
    context.setLineWidth(5)
    context.stroke(CGRect(origin: drawPoint, size: drawSize))

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
}
