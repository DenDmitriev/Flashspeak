//
//  NewListViewController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 17.04.2023.
//

import UIKit
import Combine

class NewListViewController: UIViewController {
    
    var styleList: GradientStyle?
    private let presenter: NewListPresenter
    private let newListColorCollectionDelegate: UICollectionViewDelegate
    private let newListColorCollectionDataSource: UICollectionViewDataSource
    private let gestureRecognizerDelegate: UIGestureRecognizerDelegate
    private let textFieldDelegate: UITextFieldDelegate
    private var subscriptions: Set<AnyCancellable>
    
    init(presenter: NewListPresenter, newListColorCollectionDelegate: UICollectionViewDelegate, newListColorCollectionDataSource: UICollectionViewDataSource, gestureRecognizerDelegate: UIGestureRecognizerDelegate, textFieldDelegate: UITextFieldDelegate) {
        self.presenter = presenter
        self.newListColorCollectionDelegate = newListColorCollectionDelegate
        self.newListColorCollectionDataSource = newListColorCollectionDataSource
        self.gestureRecognizerDelegate = gestureRecognizerDelegate
        self.textFieldDelegate = textFieldDelegate
        self.subscriptions = Set<AnyCancellable>()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var newListView: NewListView {
        return self.view as! NewListView
    }
    
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
    }
    
    //MARK: - Configure UI
    
    private func configureTitleField() {
        self.newListView.titleFiled.delegate = textFieldDelegate
        
        let publisher = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self.newListView.titleFiled)
            .map { ($0.object as? UITextField)?.text  ?? "" }
            .map { title in
                return  !(title ?? "").isEmpty && (title ?? "").count >= 3
            }
            .eraseToAnyPublisher()
        
        publisher
            .receive(on: RunLoop.main)
            .print()
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { isEnabled in
                self.newListView.doneButton.isEnabled = isEnabled
            })
            .store(in: &subscriptions)
    }
    
    private func addActions() {
        self.newListView.switchImageOn.addTarget(self, action: #selector(didChangedSwitch(sender:)), for: .valueChanged)
        self.newListView.doneButton.addTarget(self, action: #selector(didTapDone(sender:)), for: .touchUpInside)
    }
    
    private func addGesture() {
        let tapBackground = UITapGestureRecognizer(target: self, action: #selector(didTapBackroundView(sender:)))
        tapBackground.delegate = gestureRecognizerDelegate
        self.newListView.addGestureRecognizer(tapBackground)
    }
    
    private func configureCollectionView() {
        self.newListView.colorCollectionView.dataSource = newListColorCollectionDataSource
        self.newListView.colorCollectionView.delegate = newListColorCollectionDelegate
    }
    
    //MARK: - Actions
    
    @objc private func didTapBackroundView(sender: UIView) {
        dissmisView()
    }
    
    @objc private func didChangedSwitch(sender: UISwitch) {
        print(#function, sender.isOn)
    }
    
    @objc private func didTapDone(sender: UIButton) {
        guard
            let title = newListView.titleFiled.text
        else {
            self.dismiss(animated: true)
            return
        }
        let style = styleList ?? .grey
        let imageFlag = self.newListView.switchImageOn.isOn
        
        createList(title: title, style: style, imageFlag: imageFlag)
    }
}

extension NewListViewController: NewListViewInput {
    
    func createList(title: String, style: GradientStyle, imageFlag: Bool) {
        presenter.newList(title: title, style: style, imageFlag: imageFlag)
    }
    
    func dissmisView() {
        presenter.close()
    }
}
