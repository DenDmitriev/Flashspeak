//
//  ListMakerViewController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 21.04.2023.
//
// swiftlint:disable weak_delegate

import UIKit
import Combine

class ListMakerViewController: UIViewController {
    
    // MARK: - Properties
    
    var tokens = [String]()
    var tokenCollection: UICollectionView?
    var removeCollection: UICollectionView?
    
    // MARK: - Private properties
    
    private var tokenPublisher = PassthroughSubject<String, Never>()
    private var store = Set<AnyCancellable>()
    private let presenter: ListMakerViewOutput
    private let tokenFieldDelegate: UITextFieldDelegate
    private let collectionDataSource: UICollectionViewDataSource
    private let collectionDelegate: UICollectionViewDelegate
    private let collectionDragDelegate: UICollectionViewDragDelegate
    private let collectionDropDelegate: UICollectionViewDropDelegate
    private let textDropDelegate: UITextDropDelegate
    
    // MARK: - Constraction
    
    var listMakerView: ListMakerView {
        return self.view as? ListMakerView ?? ListMakerView()
    }
    
    init(
        presenter: ListMakerPresenter,
        tokenFieldDelegate: UITextFieldDelegate,
        collectionDataSource: UICollectionViewDataSource,
        collectionDelegate: UICollectionViewDelegate,
        collectionDragDelegate: UICollectionViewDragDelegate,
        collectionDropDelegate: UICollectionViewDropDelegate,
        textDropDelegate: UITextDropDelegate
    ) {
        self.presenter = presenter
        self.tokenFieldDelegate = tokenFieldDelegate
        self.collectionDataSource = collectionDataSource
        self.collectionDelegate = collectionDelegate
        self.collectionDragDelegate = collectionDragDelegate
        self.collectionDropDelegate = collectionDropDelegate
        self.textDropDelegate = textDropDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = ListMakerView()
        listMakerView.style = presenter.list.style
        tokenCollection = listMakerView.tokenCollectionView
        removeCollection = listMakerView.removeCollectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.subscribe()
        configureView()
        addActions()
        sinkPublishers()
        print(#function)
    }

    // MARK: - Private functions
    
    private func configureView() {
        listMakerView.tabBarHeight = tabBarController?.tabBar.frame.height
        configureTokenField()
        configureTokenCollection()
    }

    private func configureTokenCollection() {
        listMakerView.tokenCollectionView.delegate = collectionDelegate
        listMakerView.tokenCollectionView.dataSource = collectionDataSource
        listMakerView.tokenCollectionView.dragDelegate = collectionDragDelegate
        listMakerView.tokenCollectionView.dropDelegate = collectionDropDelegate
        listMakerView.tokenCollectionView.register(
            TokenCell.self,
            forCellWithReuseIdentifier: TokenCell.identifier
        )
        
        listMakerView.removeCollectionView.dataSource = collectionDataSource
        listMakerView.removeCollectionView.delegate = collectionDelegate
        listMakerView.removeCollectionView.dropDelegate = collectionDropDelegate
        listMakerView.removeCollectionView.register(
            ButtonCell.self,
            forCellWithReuseIdentifier: ButtonCell.identifier
        )
    }
    
    private func configureTokenField() {
        listMakerView.tokenFiled.delegate = tokenFieldDelegate
        listMakerView.tokenFiled.textDropDelegate = textDropDelegate
    }
    
    private func addActions() {
        listMakerView.generateButton.addTarget(
            self,
            action: #selector(generateDidTap(sender:)),
            for: .touchUpInside
        )
        listMakerView.addButton.addTarget(
            self,
            action: #selector(addDidTab(sender:)),
            for: .touchUpInside
        )
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: listMakerView.helpButton)
        listMakerView.helpButton.addTarget(
            self,
            action: #selector(helpDidTap(sender:)),
            for: .touchUpInside
        )
        listMakerView.deleteButton.addTarget(
            self,
            action: #selector(deleteDidTap(sender:)),
            for: .touchUpInside
        )
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: listMakerView.backButton)
        listMakerView.backButton.addTarget(
            self,
            action: #selector(backButtonDidTap(sender:)),
            for: .touchUpInside
        )
    }
    
    private func sinkPublishers() {
        tokenPublisher
            .receive(on: RunLoop.main)
            .map({ [self] text in
                // Add demands
                let isApprove = self.tokens.count >= Settings.minWordsInList
                changeTitleButton()
                return (text.cleanText(), isApprove)
            })
            .sink { [self] text, isApprove in
                guard
                    !text.isEmpty,
                    !self.tokens.contains(text)
                else { return }
                self.tokens.append(text)
                let item = self.tokens.index(before: self.tokens.endIndex)
                let insertIndexPath = IndexPath(item: item, section: 0)
                self.listMakerView.tokenCollectionView.insertItems(at: [insertIndexPath])
                
                if isApprove {
                    self.listMakerView.generateButton(isEnabled: isApprove)
                }
            }
            .store(in: &store)
        
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: listMakerView.tokenFiled)
            .receive(on: RunLoop.main)
            .map { ($0.object as? UITextField)?.text ?? "" }
            .eraseToAnyPublisher()
            .sink { text in
                let isEnable = text.isEmpty ? false : true
                let isHide = text.isEmpty ? true : false
                self.listMakerView.addButton(isHidden: isHide, isEnabled: isEnable)
                /*self.listMakerView.removeButton(isEnabled: isEnable)*/
            }
            .store(in: &store)
    }
    
    private func changeTitleButton() {
        let num = Settings.minWordsInList - self.tokens.count
        let button = self.listMakerView.generateButton
        if self.tokens.count < Settings.minWordsInList && self.tokens.count > 4 {
            button.setTitle(NSLocalizedString("Create \(num) more word", comment: "Button"), for: .normal)
        } else if self.tokens.count <= 4 && self.tokens.count > 1 {
            button.setTitle(NSLocalizedString("Create \(num) more words", comment: "Button"), for: .normal)
        } else if self.tokens.count <= 1 {
            button.setTitle(NSLocalizedString("Create \(num) more words", comment: "Button"), for: .normal)
        } else {
            button.setTitle(NSLocalizedString("Create cards", comment: "Button"), for: .normal)
        }
    }

    // MARK: - Actions
    
    @objc func generateDidTap(sender: UIButton) {
        generateList()
    }
    
    @objc func addDidTab(sender: UIButton) {
        guard
            let token = listMakerView.tokenFiled.text?.lowercased()
        else { return }
        addToken(token: token)
        listMakerView.tokenFiled.becomeFirstResponder()
    }
    
    @objc func helpDidTap(sender: UIButton) {
        helpDidTap()
    }
    
    @objc func deleteDidTap(sender: UIButton) {
        clearField()
    }
    
    @objc func backButtonDidTap(sender: UIButton) {
        backButtonDidTap()
        print(#function)
    }
    
}

extension ListMakerViewController: ListMakerViewInput {
    
    // MARK: - Functions
    
    func generateList() {
        presenter.createList(words: tokens)
    }
    
    func deleteToken(token: String) {
        if let index = tokens.firstIndex(of: token) {
            listMakerView.tokenCollectionView.performBatchUpdates({
                tokens.remove(at: index)
                listMakerView.tokenCollectionView.deleteItems(at: [IndexPath(item: index, section: .zero)])
            })
        }
    }
    
    func deleteToken(indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            listMakerView.tokenCollectionView.performBatchUpdates {
                tokens.remove(at: indexPath.item)
                listMakerView.tokenCollectionView.deleteItems(at: indexPaths)
            }
        }
        print(#function, self.tokens.count)
        print(#function, listMakerView.tokenCollectionView.numberOfItems(inSection: .zero))
    }
    
    func addToken(token: String) {
        tokenPublisher.send(token)
        listMakerView.clearField()
    }
    
    func highlightRemoveArea(isActive: Bool) {
        listMakerView.highlightRemoveArea(isActive: isActive)
    }
    
    func highlightTokenField(isActive: Bool) {
        listMakerView.highlightTokenField(isActive: isActive)
    }
    
    func spinner(isActive: Bool, title: String?) {
        listMakerView.spinner(isActive: isActive, title: title)
    }
    
    func clearField() {
        listMakerView.tokenFiled.text?.removeAll()
        listMakerView.clearField()
    }
    
    func helpDidTap() {
        presenter.showHint()
    }
    
    func backButtonDidTap() {
        presenter.showAlert()
    }
}

// swiftlint:enable weak_delegate
