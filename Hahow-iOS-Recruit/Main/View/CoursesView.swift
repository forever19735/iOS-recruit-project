//
//  CoursesView.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import UIKit

struct CoursesViewData {
    let model: CoursesData
}

class CoursesView: UIView {
    typealias ViewData = CoursesViewData
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.pingFangBold, fontSize: 16), textColor: .black, numberOfLines: 2)
        return label
    }()

    private let incubatingInfoView: IncubatingInfoView = {
        let view = IncubatingInfoView()
        return view
    }()

    private let publishedInfoView: PublishedInfoView = {
        let view = PublishedInfoView()
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

private extension CoursesView {
    func setupConstraint() {
        addSubviews([titleLabel, incubatingInfoView, publishedInfoView])
        titleLabel.snp.makeConstraints({
            $0.top.leading.trailing.equalToSuperview()
        })

        incubatingInfoView.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.trailing.bottom.leading.equalToSuperview()
        })
        publishedInfoView.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        })
    }
}

extension CoursesView: ConfigUI {
    func configure(viewData: CoursesViewData) {
        let model = viewData.model
        titleLabel.text = model.title

        let type = model.coursesType
        switch type {
        case .incubating:
            publishedInfoView.isHidden = true
            incubatingInfoView.isHidden = false
            incubatingInfoView.configure(viewData: IncubatingInfoViewData(goal: "達標 \(model.goal)%", 
                                                                          incubateTime: model.incubateTime,
                                                                          proposalDueTime: model.proposalDueTime))
        case .published:
            incubatingInfoView.isHidden = true
            publishedInfoView.isHidden = false
            let rate = "\(model.averageRating) (\(model.numRating))"
            publishedInfoView.configure(viewData: PublishedInfoViewData(rate: rate,
                                                                        time: model.totalVideoMinutes,
                                                                        people: "\(model.numSoldTickets)"))
        }
    }
}
