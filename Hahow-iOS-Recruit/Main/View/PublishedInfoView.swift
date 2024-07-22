//
//  PublishedInfoView.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import UIKit

struct PublishedInfoViewData {
    let rate: String
    let time: String
    let people: String
}

class PublishedInfoView: UIView {
    typealias ViewData = PublishedInfoViewData
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()

    private let spacerView: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }()

    init() {
        super.init(frame: .zero)
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension PublishedInfoView {
    func setupConstraint() {
        addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }

    func createButton(with type: PublishedButtonType, title: String) -> UIButton {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(type.image?.tint(with: type.color), for: .normal)
        button.setTitle(title, for: .normal)
        button.setTitleColor(type.color, for: .normal)
        button.titleLabel?.font = UIFont.font(.pingFangRegular, fontSize: 14)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        return button
    }

}

extension PublishedInfoView: ConfigUI {
    func configure(viewData: PublishedInfoViewData) {
        horizontalStackView.removeArrangeSubviews()

        PublishedButtonType.allCases.forEach({
            var title = ""
            switch $0 {
            case .rate:
                title = viewData.rate
            case .time:
                title = viewData.time
            case .people:
                title = viewData.people
            }
            let button = createButton(with: $0, title: title)
            horizontalStackView.addArrangedSubview(button)

        })
        horizontalStackView.addArrangedSubview(spacerView)
    }
}

extension PublishedInfoView {
    enum PublishedButtonType: CaseIterable {
        case rate
        case time
        case people

        var color: UIColor {
            switch self {
            case .rate:
                return UIColor(hex: "#F5BD57")
            case .time,
                 .people:
                return UIColor(hex: "#8E8E8E")
            }
        }

        var image: UIImage? {
            switch self {
            case .rate:
                return UIImage(asset: .iconStarFill)
            case .time:
                return UIImage(asset: .iconTimer)
            case .people:
                return UIImage(asset: .iconPerson)
            }
        }
    }
}
