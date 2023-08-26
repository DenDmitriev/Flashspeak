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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray4
        layer.cornerRadius = frame.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isRight = nil
        backgroundColor = .systemGray4
    }
    
    func configure() {
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
