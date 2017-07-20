//
//  CoreGraphicsExtension.swift
//  Test1
//
//  Created by bigyelow on 13/07/2017.
//  Copyright © 2017 huangduyu. All rights reserved.
//

import Vision
import CoreGraphics
import UIKit

extension CGContext {

  @available(iOS 11, *)
  func clip(with landmarksTuples: [(CGRect, VNFaceLandmarks2D)], containerSize size: CGSize) {
    for tuple in landmarksTuples {
      let points = createPoints(with: tuple, containerSize: size)
      clip(with: points, scaledFrame: tuple.0, containerFrame: CGRect(origin: .zero, size: size))
    }
  }

  @available(iOS 11, *)
  func strokeLines(with landmarksTuples: [(CGRect, VNFaceLandmarks2D)], containerSize size: CGSize) {
    for tuple in landmarksTuples {
      let points = createPoints(with: tuple, containerSize: size)
      strokeLines(with: points, scaledFrame: tuple.0, containerFrame: CGRect(origin: .zero, size: size))
    }
  }

  @available(iOS 11, *)
  private func createPoints(with tuple: (CGRect, VNFaceLandmarks2D), containerSize size: CGSize) -> [CGPoint] {
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

    return points
  }

  private func strokeLines(with points: [CGPoint], scaledFrame: CGRect, containerFrame: CGRect) {
    setStrokeColor(UIColor.yellow.cgColor)
    setLineWidth(4)
    closePath(with: points, scaledFrame: scaledFrame, containerFrame: containerFrame)
    strokePath()
  }

  private func clip(with points: [CGPoint], scaledFrame: CGRect, containerFrame: CGRect) {
    closePath(with: points, scaledFrame: scaledFrame, containerFrame: containerFrame)
    clip()
  }

  private func closePath(with points: [CGPoint], scaledFrame: CGRect, containerFrame: CGRect) {
    guard points.count > 0 else { return }

    let frame = ImageProcessor.convertToFrame(withScaledFrame: scaledFrame, containerFrame: containerFrame)
    let cgPoints = points.map { ImageProcessor.convertToPoint(withScaledPoint: $0, containerFrame: frame) }

    addLines(between: cgPoints)
    closePath()
  }
}
