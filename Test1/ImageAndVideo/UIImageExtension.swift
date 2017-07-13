//
//  UIImageExtension.swift
//  Test1
//
//  Created by bigyelow on 12/07/2017.
//  Copyright © 2017 huangduyu. All rights reserved.
//

import UIKit
import Vision

extension UIImage {
  // MARK: Draw
  @available(iOS 11, *)
  func draw(_ landmarksTuples: [(CGRect, VNFaceLandmarks2D)]) {
    for tuple in landmarksTuples {
      guard let points = tuple.1.faceContour?.points, let count = tuple.1.faceContour?.pointCount else { continue }
      let faceFrame = ImageProcessor.convertToFrame(withScaledFrame: tuple.0,
                                                    containerFrame: CGRect(origin: .zero, size: size))
      let cgPoints = ImageProcessor.convertToCGPoints(from: points, count: count).map {
        CGPoint(x: $0.x * faceFrame.size.width, y: $0.y * faceFrame.size.height)
      }
    }
  }

  /// - Parameter boundingBoxes: see `VNFaceObservation.boundingBox`
  @available(iOS 11, *)
  func drawRectangles(withBoundingBoxes boundingBoxes: [CGRect]) -> UIImage? {
    UIGraphicsBeginImageContext(size)
    guard let context = UIGraphicsGetCurrentContext() else { return nil}

    // 1. Draw original image
    draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

    // 2. Draw rectangle
    context.setStrokeColor(UIColor.yellow.cgColor)
    context.setLineWidth(4)
    for boundingBox in boundingBoxes {
      context.stroke(ImageProcessor.convertToFrame(withScaledFrame: boundingBox,
                                                   containerFrame: CGRect(origin: .zero, size: size)))
    }

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }

  // MARK: Utils
  func convertToCGImage() -> CGImage? {
    guard let ciImage = CIImage(image: self) else { return nil }
    let context = CIContext(options: nil)
    return context.createCGImage(ciImage, from: ciImage.extent)
  }
}
