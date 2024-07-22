//
//  MainViewController.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import UIKit

class MainViewController: BaseViewController {

    private lazy var dataSource = makeDataSource()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewlayout)
        collectionView.backgroundColor = UIColor(hex: "#F5F5F5")
        collectionView.register(cellWithClass: BigCoursesCollectionViewCell.self)
        collectionView.register(cellWithClass: SmallCoursesCollectionViewCell.self)
        collectionView.register(cellWithClass: ArticlesCollectionViewCell.self)
        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: HeaderCollectionReusableView.self)
        return collectionView
    }()

    private lazy var collectionViewlayout: UICollectionViewLayout = {
        UICollectionViewCompositionalLayout { [unowned self] index, enviroment in
            let section = Section(rawValue: index) ?? .smallCourse
            let layout = generateLayoutSection(sectionType: section)
            return layout
        }
    }()
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

    private let viewModel: MainViewModel

    init(viewModel: MainViewModel = MainViewModel(dataLoader: DataLoader.shared)) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        viewModel.getDatas()
    }

    override func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }

}

extension MainViewController {
    enum Section: Int, CaseIterable {
        case bigCourse
        case smallCourse
        case article

        var headerTitle: String? {
            switch self {
            case .bigCourse:
                return "熱門課程"
            case .smallCourse:
                return nil
            case .article:
                return "精選文章"
            }
        }
    }

    enum Item: Hashable {
        case bigCourse(SmallCoursesViewData)
        case smallCourse(SmallCoursesViewData)
        case article(ArticlesViewData)
    }
}

private extension MainViewController {
    func binding() {
        let maxCourses = UIDevice.current.userInterfaceIdiom == .pad ? 5 : 3
        viewModel.$coursesData
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .map { Array($0.prefix(maxCourses)) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coursesData in
                self?.configureCourseDataSource(coursesDatas: coursesData)
            }
            .store(in: &cancellables)

        let maxArticles = UIDevice.current.userInterfaceIdiom == .pad ? 6 : 3
        viewModel.$articlesData
            .compactMap { $0?.staffPickArticles }
            .filter { !$0.isEmpty }
            .map { Array($0.prefix(maxArticles)) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] articlesData in
                self?.configureArticleDataSource(staffPickArticles: articlesData)
            }
            .store(in: &cancellables)

        viewModel.errorMessage
            .sink { dataError in
                print(dataError)
            }
            .store(in: &cancellables)
    }
}


private extension MainViewController {
    func generateLayoutSection(sectionType: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120))
        let group: NSCollectionLayoutGroup

        if UIDevice.current.userInterfaceIdiom == .pad && sectionType != .bigCourse {
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        } else {
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        }

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = contentInsets(for: sectionType)

        if sectionType == .bigCourse || sectionType == .article {
            section.boundarySupplementaryItems = [createHeader()]
        }

        return section
    }

    func contentInsets(for sectionType: Section) -> NSDirectionalEdgeInsets {
        switch sectionType {
        case .bigCourse,
             .article:
            return NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        case .smallCourse:
            return NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        }
    }

    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Item> {
        let dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            collectionView, indexPath, item in
            switch item {
            case .bigCourse(let model):
                let cell = collectionView.dequeueReusableCell(withClass: BigCoursesCollectionViewCell.self, for: indexPath)
                cell.configure(viewData: model)
                return cell
            case .smallCourse(let model):
                let cell = collectionView.dequeueReusableCell(withClass: SmallCoursesCollectionViewCell.self, for: indexPath)
                cell.configure(viewData: model)
                return cell
            case .article(let model):
                let cell = collectionView.dequeueReusableCell(withClass: ArticlesCollectionViewCell.self, for: indexPath)
                cell.configure(viewData: model)
                return cell
            }
        }
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            self?.supplementary(collectionView: collectionView, kind: kind, indexPath: indexPath)
        }

        return dataSource
    }

    func configureCourseDataSource(coursesDatas: [CoursesData]) {
        snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.bigCourse, .smallCourse])

        for (index, value) in coursesDatas.enumerated() {
            if index == 0 {
                let items = Item.bigCourse(SmallCoursesViewData(model: value))
                snapshot.appendItems([items], toSection: .bigCourse)
            } else {
                let items = Item.smallCourse(SmallCoursesViewData(model: value))
                snapshot.appendItems([items], toSection: .smallCourse)
            }
        }

        dataSource.apply(snapshot)
    }

    func configureArticleDataSource(staffPickArticles: [StaffPickArticle]) {
        snapshot.appendSections([.article])
        staffPickArticles.forEach({
            let items = Item.article(ArticlesViewData(model: $0))
            snapshot.appendItems([items], toSection: .article)
        })

        dataSource.apply(snapshot)
    }
}

private extension MainViewController {
   func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.pinToVisibleBounds = false
        return header
    }

    func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: HeaderCollectionReusableView.self, for: indexPath)
        header.configure(viewData: HeaderCollectionViewData(tag: indexPath.section,
                                                            backgroundColor: UIColor.white,
                                                            title: section.headerTitle))
        return header
    }
}

