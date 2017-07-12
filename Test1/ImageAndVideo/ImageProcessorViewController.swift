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
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(openActionSheet))
    }
  }

  @available(iOS 11, *)
  @objc private func detectFace() {
    guard let image = imageView.image else { return }
    ImageProcessor.detectFace(of: image) { [weak self] (rects) in
      guard let sself = self, let rects = rects else { return }
      sself.imageView.image = image.drawRectangles(withBoundingBoxes: rects)
    }
  }

  @available(iOS 11, *)
  @objc private func detectFaceLandmarks() {
    guard let image = imageView.image else { return }
    ImageProcessor.detectFaceLandmarks(of: image) { (landmarks) in
      guard let landmarks = landmarks else { return }
      image.draw(landmarks)
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
    index += 1
    return UIImage(named: "Cover\(index % 3)")
  }
}

