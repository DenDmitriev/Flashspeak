//
//  StudyViewController.swift
//  Lingocard
//
//  Created by Denis Dmitriev on 12.04.2023.
//
// swiftlint:disable weak_delegate

import UIKit

class StudyViewController: UIViewController {
    
    // MARK: - Properties
    
    var studyCellModels = [StudyCellModel]()
    
    // MARK: - Private properties
    
    internal let presenter: StudyViewOutput
    private let studyCollectionDataSource: UICollectionViewDataSource?
    private let studyCollectionDelegate: UICollectionViewDelegate?
    
    // MARK: - Constraction
    
    init(
        presenter: StudyViewOutput,
        studyCollectionDataSource: UICollectionViewDataSource?,
        studyCollectionDelegate: UICollectionViewDelegate?
    ) {
        self.presenter = presenter
        self.studyCollectionDataSource = studyCollectionDataSource
        self.studyCollectionDelegate = studyCollectionDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var studyView: StudyView {
        return view as? StudyView ?? StudyView()
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        view = StudyView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.subscribe()
        configureButtons()
        configureCollectionView()
    }
    
    // MARK: - Private functions
    
    private func configureCollectionView() {
        studyView.collectionView.delegate = studyCollectionDelegate
        studyView.collectionView.dataSource = studyCollectionDataSource
        studyView.collectionView.register(StudyCell.self, forCellWithReuseIdentifier: StudyCell.identifier)
        
        presenter.getStudy()
    }
    
    private func configureButtons() {
        studyView.settingsButton.addTarget(
            self,
            action: #selector(didTapSettings(sender:)),
            for: .touchUpInside
        )
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: studyView.settingsButton)
    }
    
    // MARK: - Actions
    
    @objc private func didTapSettings(sender: UIButton) {
        print(#function)
        didTabSettingsButton()
    }

}

extension StudyViewController: StudyViewInput {
    
    // MARK: - Functions
    
    func reloadStudyView() {
        studyView.collectionView.reloadData()
    }
    
    func didTabItem(indexPath: IndexPath) {
        presenter.didTabLearn(index: indexPath.item)
    }
    
    func didTabSettingsButton() {
        presenter.didTabSettings()
    }
    
    func configureLearnSettings(settings: LearnSettings) {
        studyView.configureSettingsButton(settings: settings)
    }

}

// swiftlint:enable weak_delegate
