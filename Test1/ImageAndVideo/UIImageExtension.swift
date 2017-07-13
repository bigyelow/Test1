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
      print("face bounding = \(tuple.0)\n")
      let cgPoints = convertToCGPoints(from: points, count: count)
      for cgPoint in cgPoints {
        print("x = \(cgPoint.x), y = \(cgPoint.y)")
      }
    }
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

  // MARK: Utils
  func convertToCGImage() -> CGImage? {
    guard let ciImage = CIImage(image: self) else { return nil }
    let context = CIContext(options: nil)
    return context.createCGImage(ciImage, from: ciImage.extent)
  }

  private func convertToCGPoints(from points: UnsafePointer<vector_float2>, count: Int) -> [CGPoint] {
    var cgPoints = [CGPoint]()
    for i in 0 ..< count {
      cgPoints.append(CGPoint(x: Double(points[i].x), y: Double(points[i].y)))
    }
    return cgPoints
  }

  private func convertToFrame(withBoundingBox boundingBox: CGRect) -> CGRect {
    let aSize = CGSize(width: size.width * boundingBox.size.width, height: size.height * boundingBox.size.height)
    let aPoint = CGPoint(x: size.width * boundingBox.origin.x, y: size.height * (1 - boundingBox.origin.y) - aSize.height)

    return CGRect(origin: aPoint, size: aSize)
  }
}


