//
//  TagView.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import UIKit

struct TagViewData {
    let title: String
    let textColor: UIColor
    let backgroundColor: UIColor
    let maskedCorners: CACornerMask
}

class TagView: UIView {
    typealias ViewData = TagViewData
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.pingFangMedium, fontSize: 12), textColor: UIColor.white, textAlignment: .center)
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

private extension TagView {
    func setupConstraint() {
        layer.cornerRadius = 8
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(2)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.bottom.equalToSuperview().offset(-2)
        })
    }
}

extension TagView: ConfigUI {
    func configure(viewData: TagViewData) {
        titleLabel.text = viewData.title
        titleLabel.textColor = viewData.textColor
        backgroundColor = viewData.backgroundColor
        layer.maskedCorners = viewData.maskedCorners
    }
}
