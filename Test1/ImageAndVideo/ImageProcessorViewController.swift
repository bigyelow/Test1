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
  private static var index = 3
  private let imageView = UIImageView(image: ImageProcessorViewController.cover)
  private let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)

  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.contentMode = .scaleAspectFill
    imageView.frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.height - 100)
    imageView.clipsToBounds = true
    view.addSubview(imageView)

    indicator.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 20)
    view.addSubview(indicator)

    if #available(iOS 11, *) {
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(openActionSheet))
    }
  }

  @available(iOS 11, *)
  @objc private func detectFace() {
    guard let image = imageView.image else { return }
    indicator.startAnimating()
    ImageProcessor.detectFace(of: image) { [weak self] (rects) in
      guard let sself = self else { return }
      sself.indicator.stopAnimating()

      guard let rects = rects else { return }
      sself.imageView.image = image.drawRectangles(withBoundingBoxes: rects)
    }
  }

  @available(iOS 11, *)
  @objc private func detectFaceLandmarks() {
    guard let image = imageView.image else { return }
    indicator.startAnimating()
    ImageProcessor.detectFaceLandmarks(of: image) { [weak self] (landmarksTuples) in
      guard let sself = self else { return }
      sself.indicator.stopAnimating()

      guard let landmarksTuples = landmarksTuples else { return }
      sself.imageView.image = image.draw(landmarksTuples)
    }
  }

  @objc private func changeCover() {
    imageView.image = ImageProcessorViewController.cover
  }

  @available(iOS 11, *)
  @objc private func openActionSheet() {
    let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let action1 = UIAlertAction(title: "Detect Face", style: .default) { (_) in
      self.detectFace()
    }
    let action2 = UIAlertAction(title: "Detect Face Landmarks", style: .default) { (_) in
      self.detectFaceLandmarks()
    }
    let changeCover = UIAlertAction(title: "Change Image", style: .default) { (_) in
      self.changeCover()
    }
    let cancel = UIAlertAction(title: "Cancel", style: .default) { [weak controller] (_) in
      guard let ctr = controller else { return }
      ctr.dismiss(animated: true, completion: nil)
    }
    controller.addAction(action1)
    controller.addAction(action2)
    controller.addAction(changeCover)
    controller.addAction(cancel)

    present(controller, animated: true, completion: nil)
  }

  static var cover: UIImage? {
    let image = UIImage(named: "Cover\(index % 8)")
    index += 1
    return image
  }
}

