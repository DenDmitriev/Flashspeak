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
    
    private var subscriptions = Set<AnyCancellable>()
    
    private var newListView: NewListView {
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
        self.newListView.titleFiled.delegate = self
        
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
        tapBackground.delegate = self
        self.newListView.addGestureRecognizer(tapBackground)
    }
    
    private func configureCollectionView() {
        self.newListView.colorCollectionView.dataSource = self
        self.newListView.colorCollectionView.delegate = self
    }
    
    //MARK: - Actions
    
    @objc private func didTapBackroundView(sender: UIView) {
        self.dismiss(animated: true)
    }
    
    @objc private func didChangedSwitch(sender: UISwitch) {
        print(#function, sender.isOn)
    }
    
    @objc private func didTapDone(sender: UIButton) {
        guard
            let style = styleList,
            let title = newListView.titleFiled.text
        else {
            self.dismiss(animated: true)
            return
        }
        let list = List(
            title: title,
            words: [],
            style: style,
            created: Date.now,
            addImageFlag: self.newListView.switchImageOn.isOn)
        
        //Go to new list create view controller
        print(#function, list)
        self.dismiss(animated: true)
    }
    
}

extension NewListViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}

extension NewListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GradientStyle.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as? ColorCell else { return UICollectionViewCell() }
        let style = GradientStyle.allCases[indexPath.item]
        cell.configure(style: style)
        if style == .grey {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        }
        return cell
    }
    
    
}

extension NewListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Get selected style
        styleList = GradientStyle.allCases[indexPath.item]
    }
}

extension NewListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (newListView.container.frame.width - (CGFloat(GradientStyle.allCases.count - 1) * newListView.separator)) / 8
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return newListView.separator
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return newListView.separator
    }
}

extension NewListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
