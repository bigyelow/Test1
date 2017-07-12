//
//  ImageProcessorViewController.swift
//  Test1
//
//  Created by bigyelow on 11/07/2017.
//  Copyright © 2017 huangduyu. All rights reserved.
//

import UIKit
import Foundation

class ImageProcessorViewController: UIViewController {
  private let imageView = UIImageView(image: UIImage(named: "Cover"))

  private let label = UILabel()

  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.contentMode = .scaleAspectFill
    imageView.frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 500)
    view.addSubview(imageView)

    label.backgroundColor = UIColor.white

    if #available(iOS 11, *) {
      navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Detect", style: .plain, target: self, action: #selector(detectFace))
    }
  }

  @available(iOS 11, *)
  @objc private func detectFace() {
    guard let image = imageView.image else { return }
    ImageProcessor.detectFace(image: image) { [weak self] (rect) in
      guard let sself = self, let rect = rect else { return }
      let detectedImage = image.drawRectangle(withBoundingBox: rect)
      sself.imageView.image = detectedImage
      sself.view.setNeedsDisplay()
    }
  }

  private func unNormalizedRect(fromContainer container: CGRect, normaliezedRect rect: CGRect) -> CGRect {
    return CGRect(x: container.maxX * rect.origin.x,
                  y: container.maxY * rect.origin.y,
                  width: container.size.width * rect.size.width,
                  height: container.size.height * rect.size.height)
  }

  @objc private func download() {
    guard let url = URL(string: "https://img1.doubanio.com/view/photo/raw/public/p2475060299.jpg") else { return }
    downloadImage(with: url) { [weak self] (image, error) in
      guard let sself = self else { return }
      if error == nil && image != nil {
        sself.imageView.image = image!
        sself.view.setNeedsLayout()
      }
    }
  }

  private func downloadImage(with url: URL, completion: @escaping (UIImage?, Error?) -> Swift.Void) {
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
      guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
        let data = data,
        let image = UIImage(data: data),
        error == nil else {
          completion(nil, error)
          return
      }

      completion(image, nil)
    }

//    let task = URLSession.shared.downloadTask(with: url) { (location, _, error) in
//      do {
//        guard error == nil, let location = location, let image = try UIImage(data: Data(contentsOf: location)) else {
//          completion(nil, error)
//          return
//        }
//        completion(image, nil)
//      } catch {
//        print(error)
//      }
//    }

    task.resume()
  }
}

