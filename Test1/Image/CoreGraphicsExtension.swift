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
    let points = ImageProcessor.createCGPoints(with: landmarksTuple)
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
    let points = ImageProcessor.createCGPoints(with: landmarksTuple)
    strokeLines(with: points, scaledFrame: landmarksTuple.0, containerFrame: CGRect(origin: .zero, size: size))
  }

  // MARK: Private

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

