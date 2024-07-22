//
//  SmallCoursesCollectionViewCell.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import UIKit

struct SmallCoursesViewData: Hashable {
    static func == (lhs: SmallCoursesViewData, rhs: SmallCoursesViewData) -> Bool {
        lhs.model.id == rhs.model.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(model.id)
    }

    let model: CoursesData
}

class SmallCoursesCollectionViewCell: UICollectionViewCell, ConfigUI {
    typealias ViewData = SmallCoursesViewData

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let tagView: TagView = {
        let tagView = TagView()
        return tagView
    }()

    private let coursesView: CoursesView = {
        let coursesView = CoursesView()
        return coursesView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewData: SmallCoursesViewData) {
        let model = viewData.model
        imageView.downloadImage(with: model.coverImage.url)
        tagView.configure(viewData: TagViewData(title: model.coursesType.title,
                                                  textColor: .white,
                                                  backgroundColor: model.coursesType.backgroundColor,
                                                  maskedCorners: [.layerMinXMinYCorner, .layerMaxXMaxYCorner]))
        coursesView.configure(viewData: CoursesViewData(model: model))
    }
}

private extension SmallCoursesCollectionViewCell {
    func setupConstraint() {
        contentView.addSubviews([imageView, tagView, coursesView])
        let width = contentView.bounds.size.width / 3
        let height = (80 / 130) * width
        imageView.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10).priority(.low)
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        })
        tagView.snp.makeConstraints({
            $0.trailing.bottom.equalTo(imageView)
        })
        coursesView.snp.makeConstraints({
            $0.leading.equalTo(imageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalTo(imageView)
        })
    }
}
