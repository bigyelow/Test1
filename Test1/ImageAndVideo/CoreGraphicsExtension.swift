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
  func clip(with points: [CGPoint], scaledFrame: CGRect, containerFrame: CGRect) {
    guard points.count > 0 else { return }

    setStrokeColor(UIColor.yellow.cgColor)
    setLineWidth(4)

    let frame = ImageProcessor.convertToFrame(withScaledFrame: scaledFrame, containerFrame: containerFrame)
    let cgPoints = points.map { ImageProcessor.convertToPoint(withScaledPoint: $0, containerFrame: frame) }

    addLines(between: cgPoints)
    closePath()
    clip()
  }
}
