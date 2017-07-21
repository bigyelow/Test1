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
  func draw(_ image: UIImage, to landmarks: (CGRect, VNFaceLandmarks2D)) -> UIImage? {
    UIGraphicsBeginImageContext(size)

    draw(in: CGRect(origin: .zero, size: size))
    let containerFaceFrame = ImageProcessor.convertToFrame(withScaledFrame: landmarks.0,
                                                           containerFrame: CGRect(origin: .zero, size: size))
    image.draw(in: containerFaceFrame)

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }

  // MARK: Stroke

  @available(iOS 11, *)
  func strokeLines(with landmarksTuples: [(CGRect, VNFaceLandmarks2D)]) -> UIImage? {
    guard landmarksTuples.count > 0 else { return nil }
    UIGraphicsBeginImageContext(size)
    guard let context = UIGraphicsGetCurrentContext() else { return nil}

    draw(in: CGRect(origin: .zero, size: size))
    context.strokeLines(with: landmarksTuples, containerSize: size)

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }

  // MARK: Clip

  @available(iOS 11, *)
  func getClippedImage(from landmarksTuples: [(CGRect, VNFaceLandmarks2D)]) -> UIImage? {
    guard landmarksTuples.count > 0 else { return nil }
    UIGraphicsBeginImageContext(size)
    guard let context = UIGraphicsGetCurrentContext() else { return nil}

    context.clip(with: landmarksTuples, containerSize: size)
    draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }

  @available(iOS 11, *)
  /// - Parameters:
  ///   - minimizeBounding: 是否要返回包含人脸的最小矩形图
  func getClippedImage(from landmarksTuple: (CGRect, VNFaceLandmarks2D), minimizeBounding: Bool = true) -> UIImage? {
    UIGraphicsBeginImageContext(size)
    guard let context = UIGraphicsGetCurrentContext() else { return nil}

    context.clip(with: landmarksTuple, containerSize: size)
    draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

    var image = UIGraphicsGetImageFromCurrentImageContext()
    if minimizeBounding {
      let cgImage = context.boundingImage(image?.convertToCGImage(), with: landmarksTuple, containerSize: size)
      image = cgImage != nil ? UIImage(cgImage: cgImage!) : nil
    }

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

  func saveToDocument(withFileName fileName: String) throws {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let filePath = paths[0] + "/" + fileName
    let filePathURL = URL(fileURLWithPath: filePath)
    try UIImagePNGRepresentation(self)?.write(to: filePathURL)
  }
}

