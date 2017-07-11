//
//  ImageProcessor.swift
//  Test1
//
//  Created by bigyelow on 10/07/2017.
//  Copyright © 2017 huangduyu. All rights reserved.
//

import Foundation
import CoreImage
import CoreGraphics
import UIKit
import Vision

@available(iOS 11, *)
class ImageProcessor {
  static func detectFace(image: UIImage, completion: @escaping (CGRect?) -> Void) {
    let request = VNDetectFaceRectanglesRequest { (request, error) in
      guard let results = request.results as? [VNFaceObservation], let topResult = results.first else {
        assert(false)
        completion(nil)
      }
      print("confidence = \(topResult.confidence), rect = \(topResult.boundingBox))")
      completion(topResult.boundingBox)
    }

    guard let cgImage = createCGImage(from: image) else { return }
    let handler = VNImageRequestHandler(cgImage: cgImage)
    do {
      try handler.perform([request])
    } catch {
      print(error)
    }
  }

  static private func createCGImage(from image: UIImage) -> CGImage? {
    guard let ciImage = CIImage(image: image) else { return nil }
    let context = CIContext(options: nil)
    return context.createCGImage(ciImage, from: ciImage.extent)
  }
}
