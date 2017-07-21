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
      clip(with: tuple, containerSize: size)
    }
  }

  @available(iOS 11, *)
  func clip(with landmarksTuple: (CGRect, VNFaceLandmarks2D), containerSize size: CGSize) {
    let points = createCGPoints(with: landmarksTuple)
    clip(with: points, scaledFrame: landmarksTuple.0, containerFrame: CGRect(origin: .zero, size: size))
  }

  @available(iOS 11, *)
  func strokeLines(with landmarksTuples: [(CGRect, VNFaceLandmarks2D)], containerSize size: CGSize) {
    for tuple in landmarksTuples {
      strokeLines(with: tuple, containerSize: size)
    }
  }

  @available(iOS 11, *)
  func strokeLines(with landmarksTuple: (CGRect, VNFaceLandmarks2D), containerSize size: CGSize) {
    let points = createCGPoints(with: landmarksTuple)
    strokeLines(with: points, scaledFrame: landmarksTuple.0, containerFrame: CGRect(origin: .zero, size: size))
  }

  @available(iOS 11, *)
  /// 生成包含人脸的最小矩形图
  func boundingImage(_ image: CGImage?, with landmarksTuple: (CGRect, VNFaceLandmarks2D), containerSize size: CGSize) -> CGImage? {
    var points = createCGPoints(with: landmarksTuple)
    let frame = ImageProcessor.convertToFrame(withScaledFrame: landmarksTuple.0, containerFrame: CGRect(origin: .zero, size: size))
    points = points.map { ImageProcessor.convertToPoint(withScaledPoint: $0, containerFrame: frame) }

    var minX: CGFloat = size.width, minY: CGFloat = size.height, maxX: CGFloat = 0, maxY: CGFloat = 0
    for point in points {
      if point.x < minX {
        minX = point.x
      }
      if point.y < minY {
        minY = point.y
      }
      if point.x > maxX {
        maxX = point.x
      }
      if point.y > maxY {
        maxY = point.y
      }
    }

    let boundingFrame = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    return image?.cropping(to: boundingFrame)
  }

  // MARK: Private

  @available(iOS 11, *)
  private func createCGPoints(with tuple: (CGRect, VNFaceLandmarks2D)) -> [CGPoint] {
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
    closePath(withScaledPoints: points, scaledFrame: scaledFrame, containerFrame: containerFrame)
    strokePath()
  }

  private func clip(with points: [CGPoint], scaledFrame: CGRect, containerFrame: CGRect) {
    closePath(withScaledPoints: points, scaledFrame: scaledFrame, containerFrame: containerFrame)
    clip()
  }

  /// - Parameters:
  ///   - points: `points` is in the `scaledFrame`.
  ///   - scaledFrame: is relative to containerFrame
  private func closePath(withScaledPoints points: [CGPoint], scaledFrame: CGRect, containerFrame: CGRect) {
    guard points.count > 0 else { return }

    let cgPoints = points.map { ImageProcessor.convertToPoint(withScaledPoint: $0,
                                                              scaledFrame: scaledFrame,
                                                              containerFrame: containerFrame) }

    addLines(between: cgPoints)
    closePath()
  }
}

