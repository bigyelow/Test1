//
//  UIImageExtension.swift
//  Test1
//
//  Created by bigyelow on 12/07/2017.
//  Copyright © 2017 huangduyu. All rights reserved.
//

import UIKit
import CoreImage
import Vision

extension UIImage {
  // MARK: Draw

  @available(iOS 11, *)
  func draw(_ image: UIImage, to landmarks: (CGRect, VNFaceLandmarks2D)) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)

    draw(in: CGRect(origin: .zero, size: size))
    let boundingFrame = ImageProcessor.boundingBox(for: landmarks, containerSize: size)
    image.draw(in: boundingFrame)

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }

  // MARK: Stroke

  @available(iOS 11, *)
  func strokeLines(with landmarksTuples: [(CGRect, VNFaceLandmarks2D)]) -> UIImage? {
    guard landmarksTuples.count > 0 else { return nil }
    UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
    guard let context = UIGraphicsGetCurrentContext() else { return nil}

    draw(in: CGRect(origin: .zero, size: size))
    context.setLineWidth(2)
    context.strokeLines(with: landmarksTuples, containerSize: size)

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }

  @available(iOS 11, *)
  func drawBoundingRectangles(with landmarksTuples: [(CGRect, VNFaceLandmarks2D)]) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
    guard let context = UIGraphicsGetCurrentContext() else { return nil}

    // 1. Draw original image
    draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

    // 2. Draw rectangle
    context.setStrokeColor(UIColor.yellow.cgColor)
    context.setLineWidth(2)
    for tuple in landmarksTuples {
      let boundingFrame = ImageProcessor.boundingBox(for: tuple, containerSize: size)
      context.addRect(boundingFrame)
      context.strokePath()
    }

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }

  /// - Parameter boundingBoxes: see `VNFaceObservation.boundingBox`
  func drawRectangles(withBoundingBoxes boundingBoxes: [CGRect]) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
    guard let context = UIGraphicsGetCurrentContext() else { return nil}

    // 1. Draw original image
    draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

    // 2. Draw rectangle
    context.setStrokeColor(UIColor.yellow.cgColor)
    context.setLineWidth(2)
    for boundingBox in boundingBoxes {
      context.stroke(ImageProcessor.convertToFrame(withScaledFrame: boundingBox,
                                                   containerFrame: CGRect(origin: .zero, size: size)))
    }

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
      let cgImage = ImageProcessor.boundingImage(image?.convertToCGImage(), with: landmarksTuple, containerSize: size)
      image = cgImage != nil ? UIImage(cgImage: cgImage!) : nil
    }

    UIGraphicsEndImageContext()
    return image
  }

  // MARK: Utils

  var ciImage: CIImage? {
    return CIImage(image: self)
  }

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

  // MARK: CIImage
  var autoEnhanced: UIImage? {
    guard let ciImage = ciImage else { return nil }

    var options = [String: Any]()
    if let orientation = ciImage.properties[kCGImagePropertyOrientation.string] {
      options[CIDetectorImageOrientation] = orientation
    }
    let addjustments = ciImage.autoAdjustmentFilters(options: options)
    var inputImage = ciImage

    for filter in addjustments {
      filter.setValue(inputImage, forKey: kCIInputImageKey)
      if let outputImage = filter.outputImage {
        inputImage = outputImage
      } else {
        break
      }
    }

    return inputImage.convertToUIImage(withOriginalImage: ciImage)
  }
}

extension CIImage {
  func convertToUIImage(withOriginalImage originalImage: CIImage) -> UIImage? {
    let context = CIContext(options: nil)
    guard let cgImage = context.createCGImage(self, from: originalImage.extent) else { return nil }
    return UIImage(cgImage: cgImage)
  }
}

extension CFString {
  var string: String {
    return  (self as NSString) as String
  }
}

