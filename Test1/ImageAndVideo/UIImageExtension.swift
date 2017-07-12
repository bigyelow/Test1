//
//  UIImageExtension.swift
//  Test1
//
//  Created by bigyelow on 12/07/2017.
//  Copyright © 2017 huangduyu. All rights reserved.
//

import UIKit

extension UIImage {
  func convertToCGImage() -> CGImage? {
    guard let ciImage = CIImage(image: self) else { return nil }
    let context = CIContext(options: nil)
    return context.createCGImage(ciImage, from: ciImage.extent)
  }

  /// - Parameter boundingBoxes: see `VNFaceObservation.boundingBox`
  func drawRectangles(withBoundingBoxes boundingBoxes: [CGRect]) -> UIImage? {
    UIGraphicsBeginImageContext(size)
    guard let context = UIGraphicsGetCurrentContext() else { return nil}

    // 1. Draw original image
    draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

    // 2. Draw rectangle
    context.setStrokeColor(UIColor.yellow.cgColor)
    context.setLineWidth(4)
    for boundingBox in boundingBoxes {
      context.stroke(convertToFrame(withBoundingBox: boundingBox))
    }

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }

  private func convertToFrame(withBoundingBox boundingBox: CGRect) -> CGRect {
    let aSize = CGSize(width: size.width * boundingBox.size.width, height: size.height * boundingBox.size.height)
    let aPoint = CGPoint(x: size.width * boundingBox.origin.x, y: size.height * (1 - boundingBox.origin.y) - aSize.height)

    return CGRect(origin: aPoint, size: aSize)
  }
}

