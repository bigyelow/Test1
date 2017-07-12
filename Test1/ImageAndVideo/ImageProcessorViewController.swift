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
  private static var index = -1
  private let imageView = UIImageView(image: ImageProcessorViewController.cover)
  private let label = UILabel()

  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.contentMode = .scaleAspectFill
    imageView.frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 500)
    view.addSubview(imageView)

    label.backgroundColor = UIColor.white

    if #available(iOS 11, *) {
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Detect", style: .plain, target: self, action: #selector(detectFace))
    }

    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Change", style: .plain, target: self, action: #selector(changeCover))
  }

  @available(iOS 11, *)
  @objc private func detectFace() {
    guard let image = imageView.image else { return }
    ImageProcessor.detectFace(of: image) { [weak self] (rects) in
      guard let sself = self, let rects = rects else { return }
      let detectedImage = image.drawRectangles(withBoundingBoxes: rects)
      sself.imageView.image = detectedImage
    }
  }

  @objc private func changeCover () {
    imageView.image = ImageProcessorViewController.cover
  }

  static var cover: UIImage? {
    index += 1
    return UIImage(named: "Cover\(index % 3)")
  }

//  @objc private func download() {
//    guard let url = URL(string: "https://img1.doubanio.com/view/photo/raw/public/p2475060299.jpg") else { return }
//    downloadImage(with: url) { [weak self] (image, error) in
//      guard let sself = self else { return }
//      if error == nil && image != nil {
//        sself.imageView.image = image!
//        sself.view.setNeedsLayout()
//      }
//    }
//  }
//
//  private func downloadImage(with url: URL, completion: @escaping (UIImage?, Error?) -> Swift.Void) {
//    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//      guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//        let data = data,
//        let image = UIImage(data: data),
//        error == nil else {
//          completion(nil, error)
//          return
//      }
//
//      completion(image, nil)
//    }
//
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
//
//    task.resume()
//  }
}

