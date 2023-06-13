//
//  NewListViewController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 17.04.2023.
//
// swiftlint:disable weak_delegate

import UIKit
import Combine

class NewListViewController: UIViewController {
    
    // MARK: - Properties
    
    var styles: [GradientStyle] {
        GradientStyle.allCases
    }
    @Published var viewModel: ListViewModel
    
    var newListView: NewListView {
        return self.view as? NewListView ?? NewListView()
    }
    
    // MARK: - Private properties
    
    private let presenter: NewListPresenter
    private let newListColorCollectionDelegate: UICollectionViewDelegate
    private let newListColorCollectionDataSource: UICollectionViewDataSource
    private let gestureRecognizerDelegate: UIGestureRecognizerDelegate
    private let textFieldDelegate: UITextFieldDelegate
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Constraction
    
    init(
        presenter: NewListPresenter,
        viewModel: ListViewModel,
        newListColorCollectionDelegate: UICollectionViewDelegate,
        newListColorCollectionDataSource: UICollectionViewDataSource,
        gestureRecognizerDelegate: UIGestureRecognizerDelegate,
        textFieldDelegate: UITextFieldDelegate
    ) {
        self.presenter = presenter
        self.viewModel = viewModel
        self.newListColorCollectionDelegate = newListColorCollectionDelegate
        self.newListColorCollectionDataSource = newListColorCollectionDataSource
        self.gestureRecognizerDelegate = gestureRecognizerDelegate
        self.textFieldDelegate = textFieldDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = NewListView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTitleField()
        addGesture()
        addActions()
        configureCollectionView()
        subscribe()
        loadList()
    }
    
    // MARK: - Private functions
    
    private func subscribe() {
        let textFieldPublisher = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self.newListView.titleFiled)
            .map { ($0.object as? UITextField)?.text ?? "" }
            .eraseToAnyPublisher()
        
        textFieldPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] title in
                self?.viewModel.title = title
            }
            .store(in: &subscriptions)
        
        $viewModel
            .receive(on: RunLoop.main)
            .sink { [weak self] viewModel in
                guard
                    let text = self?.newListView.titleFiled.text
                else { return }
                let isEmpty = text.isEmpty
                self?.newListView.doneButton.isEnabled = !isEmpty
                if !isEmpty, let isChanged = self?.presenter.isChanged(viewModel) {
                    self?.newListView.doneButton.isEnabled = isChanged
                }
            }
            .store(in: &subscriptions)
        
    }
    
    private func configureTitleField() {
        self.newListView.titleFiled.delegate = textFieldDelegate
    }
    
    private func addActions() {
        self.newListView.switchImageOn.addTarget(
            self,
            action: #selector(didChangedSwitch(sender:)),
            for: .valueChanged
        )
        self.newListView.doneButton.addTarget(
            self,
            action: #selector(didTapDone(sender:)),
            for: .touchUpInside
        )
    }
    
    private func addGesture() {
        let tapBackground = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapBackroundView(sender:))
        )
        tapBackground.delegate = gestureRecognizerDelegate
        self.newListView.addGestureRecognizer(tapBackground)
    }
    
    private func configureCollectionView() {
        self.newListView.colorCollectionView.dataSource = newListColorCollectionDataSource
        self.newListView.colorCollectionView.delegate = newListColorCollectionDelegate
    }
    
    private func loadList() {
        newListView.titleFiled.text = viewModel.title
        newListView.switchImageOn.isOn = viewModel.imageFlag
        newListView.configureTitles(isNewList: viewModel.title.isEmpty)
    }
    
    // MARK: - Actions
    
    @objc private func didTapBackroundView(sender: UIView) {
        dismissView()
    }
    
    @objc private func didChangedSwitch(sender: UISwitch) {
        viewModel.imageFlag = sender.isOn
    }
    
    @objc private func didTapDone(sender: UIButton) {
        createList(viewModel)
    }
}

extension NewListViewController: NewListViewInput {
    
    // MARK: - Functions
    
    func createList(_ viewModel: ListViewModel?) {
        presenter.presentList(viewModel)
    }
    
    func dismissView() {
        presenter.close()
    }
    
    func selectStyle(_ style: GradientStyle) {
        viewModel.style = style
    }
}

// swiftlint:enable weak_delegate
