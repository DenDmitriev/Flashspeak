//
//  PrepareLearnView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 25.05.2023.
//

import UIKit

class PrepareLearnView: UIView {
    
    // MARK: - Properties
    
    // MARK: - Private properties
    
    // MARK: - Subviews
    
    // MARK: - Constraction
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    // MARK: - Functions
    
    // MARK: - Private Functions
    
    // MARK: - UI
    
    private func configureSubviews() {
    }
    
    private func setupConstraints() {
        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            
        ])
    }

}
