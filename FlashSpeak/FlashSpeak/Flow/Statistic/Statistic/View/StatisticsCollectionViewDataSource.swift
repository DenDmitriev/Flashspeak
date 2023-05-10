//
//  StatisticsCollectionViewDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 10.05.2023.
//
// swiftlint: disable line_length

import UIKit

class StatisticsCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    weak var viewController: (UIViewController & StatisticViewInput)?
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return StatisticViewModel.Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard
            let section = StatisticViewModel.Section.section(by: section)
        else { return .zero }
        
        switch section {
        case .today:
            return viewController?.statisticDayViewModels.count ?? .zero
        case .all:
            return viewController?.statisticAllViewModels.count ?? .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StatisticReusable.Identifier, for: indexPath) as? StatisticReusable,
            let section = StatisticViewModel.Section.section(by: indexPath.section)
        else { return UICollectionReusableView() }
        let title = section.title
        sectionHeader.label.text = title
        return sectionHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatisticCell.identifier, for: indexPath) as? StatisticCell,
            let section = StatisticViewModel.Section.section(by: indexPath.section)
        else { return UICollectionViewCell() }
        
        let viewModel: StatisticViewModel?
        switch section {
        case .today:
            viewModel = viewController?.statisticDayViewModels[indexPath.item]
        case .all:
            viewModel = viewController?.statisticAllViewModels[indexPath.item]
        }
        guard let viewModel = viewModel else { return UICollectionViewCell() }
        cell.configure(viewModel: viewModel)
        return cell
    }
}

// swiftlint: enable line_length
