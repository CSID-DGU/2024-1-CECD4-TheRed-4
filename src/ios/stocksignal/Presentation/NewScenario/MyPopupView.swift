//
//  MyPopupView.swift
//  stocksignal
//
//  Created by 신예빈 on 10/31/24.
//

import Foundation
import UIKit

class MyPopupView: UIView {
  private let popupView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 12
    $0.clipsToBounds = true
  }
  
  self.backgroundColor = .black.withAlphaComponent(0.3)
  self.addSubview(self.popupView)
  
    self.popupView.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(32)
      $0.centerY.equalToSuperview()
}
