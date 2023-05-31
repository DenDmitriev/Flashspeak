//
//  ProgressCell.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 31.05.2023.
//

import UIKit
import Combine

class ProgressCell: UICollectionViewCell {
    
    static let identifier = "ProgressCell"
    
    @Published var isRight: Bool?
    private var store = Set<AnyCancellable>()
    
    func configure() {
        backgroundColor = .systemGray4
        layer.cornerRadius = frame.height / 2
        self.$isRight
            .receive(on: RunLoop.main)
            .sink { [weak self] isRight in
                guard let isRight = isRight else { return }
                UIView.animate(withDuration: 0.3) {
                    self?.backgroundColor = isRight ? .systemGreen : .systemRed
                }
            }
            .store(in: &store)
    }
}
