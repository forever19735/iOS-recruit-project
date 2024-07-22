//
//  BigCoursesCollectionViewCell.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import UIKit

class BigCoursesCollectionViewCell: UICollectionViewCell, ConfigUI {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
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
                                                  maskedCorners: [.layerMinXMinYCorner]))
        coursesView.configure(viewData: CoursesViewData(model: model))
    }
}

private extension BigCoursesCollectionViewCell {
    func setupConstraint() {
        contentView.addSubviews([imageView, tagView, coursesView])
        let height = (250 / 375) * UIScreen.main.bounds.size.width
        imageView.snp.makeConstraints({
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(height)
        })
        tagView.snp.makeConstraints({
            $0.trailing.bottom.equalTo(imageView)
        })
        coursesView.snp.makeConstraints({
            $0.top.equalTo(imageView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-20)
        })
    }
}

