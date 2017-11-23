//
//  TestNullabilityViewController.swift
//  Test1
//
//  Created by bigyelow on 17/07/2017.
//  Copyright © 2017 huangduyu. All rights reserved.
//

import UIKit

class TestNullabilityViewController: UIViewController {

  let commond: TCommond?

  init(commond: TCommond?) {
    self.commond = commond
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Test", style: .plain, target: self, action: #selector(test))
  }

  @objc private func test() {
    guard let commond = commond else { return }
    print("id = \(commond.identifier), name = \(commond.name)")
    print(commond.url.absoluteString)
  }
}


