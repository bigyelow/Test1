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
  func draw(_ image: UIImage, to landmarksTuples: [(CGRect, VNFaceLandmarks2D)]) -> UIImage? {
    
    return nil
  }

  @available(iOS 11, *)
func getClippedImage(from landmarksTuples: [(CGRect, VNFaceLandmarks2D)]) -> UIImage? {
  guard landmarksTuples.count > 0 else { return nil }

  UIGraphicsBeginImageContext(size)
  guard let context = UIGraphicsGetCurrentContext() else { return nil}

  // Clip face between points
  for tuple in landmarksTuples {
    let containerFrame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

    // Face contour
    var points = [CGPoint]()
    if let faceContourPoints = tuple.1.faceContour?.points, let count = tuple.1.faceContour?.pointCount {
      points.append(contentsOf: ImageProcessor.convertToCGPoints(from: faceContourPoints, count: count).reversed())
    }

    // Left eyebrow
    if let leftEyebrowPoints = tuple.1.leftEyebrow?.points, let count = tuple.1.leftEyebrow?.pointCount {
      points.append(contentsOf: ImageProcessor.convertToCGPoints(from: leftEyebrowPoints, count: count))
    }

    // Right eyebrow
    if let rightEyebrowPoints = tuple.1.rightEyebrow?.points, let count = tuple.1.rightEyebrow?.pointCount {
      points.append(contentsOf: ImageProcessor.convertToCGPoints(from: rightEyebrowPoints, count: count))
    }

    context.clip(with: points, scaledFrame: tuple.0, containerFrame: containerFrame)
  }

    // Draw image in cliped area
    draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
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
