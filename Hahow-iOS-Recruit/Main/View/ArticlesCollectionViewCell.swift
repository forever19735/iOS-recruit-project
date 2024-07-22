//
//  ArticlesCollectionViewCell.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import SnapKit
import UIKit

struct ArticlesViewData: Hashable {
    static func == (lhs: ArticlesViewData, rhs: ArticlesViewData) -> Bool {
        lhs.model.id == rhs.model.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(model.id)
    }

    let model: StaffPickArticle
}

class ArticlesCollectionViewCell: UICollectionViewCell, ConfigUI {
    typealias ViewData = ArticlesViewData

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.pingFangBold, fontSize: 16), textColor: .black, numberOfLines: 2)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.pingFangRegular, fontSize: 14), textColor: UIColor(hex: "#8E8E8E"), numberOfLines: 2)
        return label
    }()

    private let userNameView: ImageWithTitleView = {
        let view = ImageWithTitleView()
        return view
    }()

    private let viewsButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.setTitleColor(UIColor(hex: "#8E8E8E"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.font = UIFont.font(.pingFangRegular, fontSize: 14)
        button.setImage(UIImage(asset: .iconEye)?.tint(with: .black), for: .normal)
        return button
    }()

    private let spacerView: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }()

    private let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#F6F7F9")
        return view
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewData: ArticlesViewData) {
        let model = viewData.model
        titleLabel.text = model.title
        descriptionLabel.text = model.previewDescription
        userNameView.configure(viewData: ImageWithTitleViewData(imageName: model.creator.profileImageURL, title: model.creator.name))
        viewsButton.setTitle("\(model.viewCount)", for: .normal)
        imageView.downloadImage(with: model.coverImage.url)
    }
}

private extension ArticlesCollectionViewCell {
    func setupConstraint() {
        let containerView = setupContainerView()
        contentView.addSubviews([titleLabel, containerView, bottomLineView])
        titleLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        })
        containerView.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(titleLabel)
            $0.bottom.equalToSuperview().offset(-10).priority(.low)
        })
        bottomLineView.snp.makeConstraints({
            $0.leading.trailing.equalTo(titleLabel)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        })
    }

    func setupContainerView() -> UIView {
        let containerView = UIView()
        let infoView = setupInfoView()
        containerView.addSubviews([infoView, imageView])
        infoView.snp.makeConstraints({
            $0.top.leading.bottom.equalToSuperview()
        })

        let width = contentView.bounds.size.width / 3
        let height = (80 / 130) * width
        imageView.snp.makeConstraints({
            $0.top.trailing.equalToSuperview()
            $0.leading.equalTo(infoView.snp.trailing).offset(10)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        })
        return containerView
    }

    func setupInfoView() -> UIView {
        let containerView = UIView()
        let buttons = setupButtons()
        containerView.addSubviews([descriptionLabel, buttons])
        descriptionLabel.snp.makeConstraints({
            $0.top.leading.trailing.equalToSuperview()
        })
        buttons.snp.makeConstraints({
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(16)
        })
        return containerView
    }

    func setupButtons() -> UIView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.addArrangedSubview(userNameView)
        stackView.addArrangedSubview(viewsButton)
        stackView.addArrangedSubview(spacerView)
        return stackView
    }
}
