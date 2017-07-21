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
  private let container = UIImageView(image: ImageProcessorViewController.cover)
  private let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
  private let candidate = UIImageView(image: UIImage(named: "Head1"))

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white

    container.contentMode = .scaleAspectFit
    container.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.height - 200)
    container.clipsToBounds = true
    view.addSubview(container)

    candidate.contentMode = .scaleAspectFit
    let candidateHeight = UIScreen.main.bounds.size.height - container.frame.maxY - 20
    candidate.frame = CGRect(x: 10, y: container.frame.maxY + 10, width: candidateHeight * 0.7, height: candidateHeight)
    candidate.clipsToBounds = true
    view.addSubview(candidate)

    indicator.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 20)
    view.addSubview(indicator)

    var items = [UIBarButtonItem]()
    if #available(iOS 11, *) {
      let editItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(openActionSheet))
      items.append(editItem)
    }
    items.append(UIBarButtonItem(title: "Change",
                                 style: .plain,
                                 target: self,
                                 action: #selector(changeCover)))

    navigationItem.rightBarButtonItems = items
  }

  @available(iOS 11, *)
  @objc private func detectFace() {
    guard let image = container.image else { return }
    indicator.startAnimating()
    ImageProcessor.detectFace(of: image) { [weak self] (rects) in
      guard let sself = self else { return }
      sself.indicator.stopAnimating()

      guard let rects = rects else { return }
      sself.container.image = image.drawRectangles(withBoundingBoxes: rects)
    }
  }

  @available(iOS 11, *)
  @objc private func detectFaceLandmarks() {
    guard let image = container.image else { return }
    indicator.startAnimating()

    ImageProcessor.detectFaceLandmarks(of: image) { [weak self] (landmarksTuples) in
      guard let sself = self else { return }
      sself.indicator.stopAnimating()

      guard let tuples = landmarksTuples else { return }
      sself.container.image = image.strokeLines(with: tuples)
    }
  }

  @available(iOS 11, *)
  /// Change face of the first detected one.
  @objc private func swapFace() {
    guard let candidateImage = candidate.image else { return }
    indicator.startAnimating()

    // Get face
    ImageProcessor.detectFaceLandmarks(of: candidateImage) { [weak self] (landmarksTuples) in
      guard let sself = self else { return }
      guard let landmarksTuples = landmarksTuples, landmarksTuples.count > 0 else { return }
      sself.candidate.image = candidateImage.getClippedImage(from: landmarksTuples[0])

      // Draw face to container
      guard let image = sself.container.image else { return }
      ImageProcessor.detectFaceLandmarks(of: image) { [weak sself] (landmarksTuples) in
        guard let wself = sself else { return }
        wself.indicator.stopAnimating()

        guard let landmarksTuples = landmarksTuples, landmarksTuples.count > 0, let face = wself.candidate.image else { return }
        wself.container.image = image.draw(face, to: landmarksTuples[0])  // change first one
      }
    }

  }

  @objc private func changeCover() {
    container.image = ImageProcessorViewController.cover
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
    let action3 = UIAlertAction(title: "Swap Face", style: .default) { (_) in
      self.swapFace()
    }
    let cancel = UIAlertAction(title: "Cancel", style: .default) { [weak controller] (_) in
      guard let ctr = controller else { return }
      ctr.dismiss(animated: true, completion: nil)
    }
    controller.addAction(action1)
    controller.addAction(action2)
    controller.addAction(action3)
    controller.addAction(cancel)

    present(controller, animated: true, completion: nil)
  }

  static var cover: UIImage? {
    let image = UIImage(named: "Cover\(index % 8)")
    index += 1
    return image
  }
}


