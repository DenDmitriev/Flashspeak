//
//  PrepareLearnViewController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 25.05.2023.
//

import UIKit

class PrepareLearnViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Private properties
    
    private var prepareLearnView: PrepareLearnView {
        return view as? PrepareLearnView ?? PrepareLearnView()
    }
    
    // MARK: - Constraction
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        view = PrepareLearnView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Private functions

    // MARK: - Actions
}

extension PrepareLearnViewController: PrepareLearnInput {
    
}
