//
//  HeaderCollectionReusableView.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import UIKit

struct HeaderCollectionViewData {
    let tag: Int
    var backgroundColor: UIColor = .clear
    var textColor: UIColor = .black
    let title: String?
    var titleFont: UIFont = UIFont.font(.pingFangBold, fontSize: 18)
}

class HeaderCollectionReusableView: UICollectionReusableView {
    typealias ViewData = HeaderCollectionViewData

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.pingFangMedium, fontSize: 16), textColor: .black)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HeaderCollectionReusableView: ConfigUI {
    func configure(viewData: HeaderCollectionViewData) {
        self.backgroundColor = viewData.backgroundColor
        titleLabel.textColor = viewData.textColor
        titleLabel.text = viewData.title
        titleLabel.font = viewData.titleFont
    }
}

private extension HeaderCollectionReusableView {
    func setupConstraint() {
        addSubview(titleLabel)
        titleLabel.snp.remakeConstraints({
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        })
    }
}
