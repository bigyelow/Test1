//
//  ImageProcessor.swift
//  Test1
//
//  Created by bigyelow on 10/07/2017.
//  Copyright © 2017 huangduyu. All rights reserved.
//

import Vision
import UIKit

@available(iOS 11, *)
class ImageProcessor {
  static func detectFace(of image: UIImage, completion: @escaping ([CGRect]?) -> Void) {
    getFaceObservations(of: image) { (observations) in
      guard let observations = observations else {
        completion(nil)
        return
      }
      completion(observations.map { $0.boundingBox })
    }
  }

  static func detectFaceLandmarks(of image: UIImage) {
    getFaceObservations(of: image) { (observations) in
      guard let observations = observations else {
        return
      }


    }
  }

  private static func getFaceObservations(of image: UIImage, completion: @escaping ([VNFaceObservation]?) -> Void) {
    guard let cgImage = image.convertToCGImage() else { return }

    let request = VNDetectFaceRectanglesRequest { (request, error) in
      guard var results = request.results as? [VNFaceObservation] else {
        completion(nil)
        return
      }
      results = results.filter { $0.confidence > 0.9 }
      completion(results)
    }

    let handler = VNImageRequestHandler(cgImage: cgImage)
    do {
      try handler.perform([request])
    } catch {
      print(error)
    }
  }
}
