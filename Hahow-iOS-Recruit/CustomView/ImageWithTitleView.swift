//
//  ImageWithTitleView.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import UIKit

struct ImageWithTitleViewData {
    let imageName: String
    let title: String
}

class ImageWithTitleView: UIView {
    typealias ViewData = ImageWithTitleViewData
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.pingFangRegular, fontSize: 14), textColor: UIColor(hex: "#8E8E8E"))
        return label
    }()

    init() {
        super.init(frame: .zero)
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ImageWithTitleView {
    func setupConstraint() {
        addSubviews([imageView, titleLabel])
        imageView.snp.makeConstraints({
            $0.top.leading.bottom.equalToSuperview()
            $0.width.height.equalTo(16)
        })
        titleLabel.snp.makeConstraints({
            $0.leading.equalTo(imageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(imageView)
        })
    }
}

extension ImageWithTitleView: ConfigUI {
    func configure(viewData: ImageWithTitleViewData) {
        imageView.downloadImage(with: viewData.imageName)
        titleLabel.text = viewData.title
    }
}
