//
//  ListsView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 12.04.2023.
//

import UIKit

class ListsView: UIView {
    
    //MARK: - SubViews
    
    var newListButton = UIButton()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - UI
    private func configureUI() {
        self.backgroundColor = .Theme.backgroundWhite
        addNewListButton()
        setupConstraints()
    }
    
    private func addNewListButton() {
        var configuration = UIButton.Configuration.gray()
        configuration.baseForegroundColor = .Theme.tint
        configuration.baseBackgroundColor = .Theme.backgroundLightGray
        configuration.cornerStyle = .capsule
        configuration.buttonSize = .large

        newListButton = UIButton(configuration: configuration)
        newListButton.setImage(UIImage(systemName: "plus"), for: .normal)
        newListButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(newListButton)
    }

    private func setupConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        let inset: CGFloat = 16
        
        NSLayoutConstraint.activate([
            newListButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset),
            newListButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -inset * 2)
        ])
    }
 
}
