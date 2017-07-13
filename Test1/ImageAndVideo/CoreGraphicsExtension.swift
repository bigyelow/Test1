//
//  CoreGraphicsExtension.swift
//  Test1
//
//  Created by bigyelow on 13/07/2017.
//  Copyright © 2017 huangduyu. All rights reserved.
//

import Vision
import CoreGraphics

extension CGContext {
  @available(iOS 11, *)
  func drawPoints(_ points: UnsafePointer<vector_float2>, count: Int, scaledFrame: CGRect, containerFrame: CGRect) {
    let frame = ImageProcessor.convertToFrame(withScaledFrame: scaledFrame, containerFrame: containerFrame)
    let cgPoints = ImageProcessor.convertToCGPoints(from: points, count: count).map {
      ImageProcessor.convertToPoint(withScaledPoint: $0, containerFrame: frame)
    }

    addLines(between: cgPoints)
    strokePath()
  }
}
