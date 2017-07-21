//
//  ImageProcessor.swift
//  Test1
//
//  Created by bigyelow on 10/07/2017.
//  Copyright © 2017 huangduyu. All rights reserved.
//

import Vision
import UIKit

class ImageProcessor {
  // MARK: Detection

  @available(iOS 11, *)
  static func detectFace(of image: UIImage, completion: @escaping ([CGRect]?) -> Void) {
    getFaceObservations(of: image) { (observations) in
      guard let observations = observations else {
        completion(nil)
        return
      }
      completion(observations.map { $0.boundingBox })
    }
  }

  /// - Parameters:
  ///   - completion: CGRect - BoundingBox of a face
  @available(iOS 11, *)
  static func detectFaceLandmarks(of image: UIImage, completion: @escaping ([(CGRect, VNFaceLandmarks2D)]?) -> Void) {
    getFaceObservations(of: image) { (observations) in
      guard let observations = observations else {
        completion(nil)
        return
      }

      let request = VNDetectFaceLandmarksRequest { (request, error) in
        guard error == nil, var results = request.results as? [VNFaceObservation] else {
          completion(nil)
          return
        }

        results = results.filter { $0.confidence > 0.9 && $0.landmarks != nil}
        completion(results.map { ($0.boundingBox, $0.landmarks!) })
      }

      guard let cgImage = image.convertToCGImage() else { return }
      request.inputFaceObservations = observations
      let handler = VNImageRequestHandler(cgImage: cgImage)
      do {
        try handler.perform([request])
      } catch {
        print(error)
      }
    }
  }

  @available(iOS 11, *)
  private static func getFaceObservations(of image: UIImage, completion: @escaping ([VNFaceObservation]?) -> Void) {
    guard let cgImage = image.convertToCGImage() else { return }

    let request = VNDetectFaceRectanglesRequest { (request, error) in
      guard error == nil, var results = request.results as? [VNFaceObservation] else {
        completion(nil)
        return
      }
      results = results.filter { $0.confidence > 0.9 }

      DispatchQueue.main.sync {
        completion(results)
      }
    }

    let handler = VNImageRequestHandler(cgImage: cgImage)
    DispatchQueue.global().async {
      do {
        try handler.perform([request])
      } catch {
        print(error)
      }
    }
  }

  // MARK: Utils

  /// - Parameters:
  ///   - scaledPoint: uses lower-left corner. scaledPoint 坐标是相对 containerFrame 的，均是 0-1 正则化了的。
  ///   - containerFrame: uses upper-left corner. `containerFrame` 为 `scaledPoint` 所在的 frame. `containerFrame` 的 point
  ///   是真实位置（不一定是 (0, 0)）
  static func convertToPoint(withScaledPoint scaledPoint: CGPoint, containerFrame: CGRect) -> CGPoint {
    return CGPoint(x: containerFrame.size.width * scaledPoint.x + containerFrame.origin.x,
                   y: containerFrame.size.height * (1 - scaledPoint.y) + containerFrame.origin.y)
  }

  /// - Parameters:
  ///   - scaledFrame: scaledFrame uses lower-left corner.
  ///   - containerFrame: uses upper-left corner. 同 convertToPoint() 中的 `containerFrame` 参数。
  static func convertToFrame(withScaledFrame scaledFrame: CGRect, containerFrame: CGRect) -> CGRect {
    let aSize = CGSize(width: containerFrame.size.width * scaledFrame.size.width,
                       height: containerFrame.size.height * scaledFrame.size.height)
    let aPoint = CGPoint(x: containerFrame.size.width * scaledFrame.origin.x + containerFrame.origin.x,
                         y: containerFrame.size.height * (1 - scaledFrame.origin.y) - aSize.height + containerFrame.origin.y)

    return CGRect(origin: aPoint, size: aSize)
  }


  /// - Parameters:
  ///   - scaledPoint: `scaledPoint` related to `scaledFrame`
  ///
  /// - Note: this method just combines `convertToPoint(withScaledPoint:containerFrame)` with `convertToFrame(withScaledFrame:containerFrame)`
  static func convertToPoint(withScaledPoint scaledPoint: CGPoint,
                             scaledFrame: CGRect,
                             containerFrame: CGRect) -> CGPoint {
    let frame = convertToFrame(withScaledFrame: scaledFrame, containerFrame: containerFrame)
    return convertToPoint(withScaledPoint: scaledPoint, containerFrame: frame)
  }

  static func convertToCGPoints(from points: UnsafePointer<vector_float2>, count: Int) -> [CGPoint] {
    var cgPoints = [CGPoint]()
    for i in 0 ..< count {
      cgPoints.append(CGPoint(x: Double(points[i].x), y: Double(points[i].y)))
    }
    return cgPoints
  }
}

