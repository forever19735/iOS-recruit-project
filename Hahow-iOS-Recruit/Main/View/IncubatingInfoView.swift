//
//  IncubatingInfoView.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import UIKit

struct IncubatingInfoViewData {
    let goal: String
    let incubateTime: String
    let proposalDueTime: String
}

class IncubatingInfoView: UIView {
    typealias ViewData = IncubatingInfoViewData
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.pingFangBold, fontSize: 16), textColor: UIColor(hex: "#8E8E8E"), numberOfLines: 1)
        return label
    }()

    private let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#F2AA62")
        return view
    }()

    private let timeButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.setTitleColor(UIColor(hex: "#8E8E8E"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.font = UIFont.font(.pingFangRegular, fontSize: 14)
        button.setImage(UIImage(asset: .iconEye)?.tint(with: UIColor(hex: "#8E8E8E")), for: .normal)
        return button
    }()

    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
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

private extension IncubatingInfoView {
    func setupConstraint() {
        addSubview(horizontalStackView)
        let goalView = setupGoalView()

        horizontalStackView.addArrangeSubviews([goalView, timeButton, spacerView])
        horizontalStackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }

    func setupGoalView() -> UIView {
        let containerView = UIView()
        containerView.addSubviews([titleLabel, bottomLineView])
        titleLabel.snp.makeConstraints({
            $0.top.leading.trailing.equalToSuperview()
        })
        bottomLineView.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(5)
        })
        return containerView
    }

}

extension IncubatingInfoView: ConfigUI {
    func configure(viewData: IncubatingInfoViewData) {
        titleLabel.text = viewData.goal
        if let time = viewData.incubateTime.daysUntil(to: viewData.proposalDueTime) {
            timeButton.setTitle("倒數 \(time) 天", for: .normal)
        }
    }
}
