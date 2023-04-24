//
//  ListMakerViewController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 21.04.2023.
//

import UIKit
import Combine

class ListMakerViewController: UIViewController {
    
    private var presenter: ListMakerViewOutput
    private let tokenFieldDelegate: UITextFieldDelegate
    private let collectionDataSource: UICollectionViewDataSource
    private let collectionDelegate: UICollectionViewDelegate
    private let collectionDragDelegate: UICollectionViewDragDelegate
    private let collectionDropDelegate: UICollectionViewDropDelegate
    private let textDropDelegate: UITextDropDelegate
    
    var tokens = [String]()
    
    var tokenPublisher = PassthroughSubject<String, Never>()
    var store = Set<AnyCancellable>()
    
    var tokenCollection: UICollectionView?
    var removeCollection: UICollectionView?
    
    var listMakerView: ListMakerView {
        return self.view as! ListMakerView
    }
    
    //MARK: - Init
    
    init(presenter: ListMakerPresenter, tokenFieldDelegate: UITextFieldDelegate, collectionDataSource: UICollectionViewDataSource, collectionDelegate: UICollectionViewDelegate, collectionDragDelegate: UICollectionViewDragDelegate, collectionDropDelegate: UICollectionViewDropDelegate, textDropDelegate: UITextDropDelegate) {
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
    
    override func loadView() {
        super.loadView()
        self.view = ListMakerView()
        listMakerView.style = presenter.list.style
        tokenCollection = listMakerView.tokenCollectionView
        removeCollection = listMakerView.removeCollectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTokenField()
        configureTokenCollection()
        addActions()
        sinkPublishers()
    }


    private func configureTokenCollection() {
        listMakerView.tokenCollectionView.delegate = collectionDelegate
        listMakerView.tokenCollectionView.dataSource = collectionDataSource
        listMakerView.tokenCollectionView.dragDelegate = collectionDragDelegate
        listMakerView.tokenCollectionView.dropDelegate = collectionDropDelegate
        listMakerView.removeCollectionView.dropDelegate = collectionDropDelegate
        listMakerView.tokenCollectionView.register(TokenCell.self, forCellWithReuseIdentifier: TokenCell.identifier)
    }
    
    private func configureTokenField() {
        listMakerView.tokenFiled.delegate = tokenFieldDelegate
        listMakerView.tokenFiled.textDropDelegate = textDropDelegate
    }
    
    private func addActions() {
        listMakerView.generateButton.addTarget(self, action: #selector(generateDidTap(sender:)), for: .touchUpInside)
    }
    
    private func sinkPublishers() {
        tokenPublisher
            .receive(on: RunLoop.main)
            .map({ $0.cleanText() })
            .sink { text in
                if self.tokens.firstIndex(of: text) == nil {
                    self.tokens.append(text)
                    let item = self.tokens.index(before: self.tokens.endIndex)
                    let insertIndexPath = IndexPath(item: item, section: 0)
                    self.listMakerView.tokenCollectionView.insertItems(at: [insertIndexPath])
                }
            }
            .store(in: &store)
    }
    
    //MARK: - Methods
    
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
    }
    
    func addToken(token: String) {
        tokenPublisher.send(token)
    }
    
    func updateRemoveArea(isActive: Bool) {
        listMakerView.updateRemoveArea(isActive: isActive)
    }
    
    func hideRemoveArea(isHidden: Bool) {
        listMakerView.hideRemoveArea(isHidden: isHidden)
    }
    
    @objc func generateDidTap(sender: UIButton) {
        presenter.generateList(words: tokens)
    }
    
}

extension ListMakerViewController: ListMakerViewInput {
    
}
