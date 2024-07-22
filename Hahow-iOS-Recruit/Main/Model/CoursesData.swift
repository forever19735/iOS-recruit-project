//
//  CoursesData.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import Foundation

struct CoursesData: Codable {
    let id, status: String
    let coursesType: CoursesType
    let successCriteria: SuccessCriteria
    let numSoldTickets: Int
    let averageRating: Double
    let numRating: Int
    let title: String
    let coverImage: CoursesCoverImage
    let totalVideoLengthInSeconds: Int
    let totalVideoMinutes: String
    let createdAt, incubateTime, proposalDueTime: String
    let publishTime: String?
    let goal: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case status, successCriteria, numSoldTickets, averageRating, numRating, title, coverImage, totalVideoLengthInSeconds, createdAt, incubateTime, proposalDueTime, publishTime
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        status = try values.decode(String.self, forKey: .status)
        successCriteria = try values.decode(SuccessCriteria.self, forKey: .successCriteria)
        numSoldTickets = try values.decode(Int.self, forKey: .numSoldTickets)
        averageRating = try values.decode(Double.self, forKey: .averageRating)
        numRating = try values.decode(Int.self, forKey: .numRating)
        title = try values.decode(String.self, forKey: .title)
        coverImage = try values.decode(CoursesCoverImage.self, forKey: .coverImage)
        totalVideoLengthInSeconds = try values.decode(Int.self, forKey: .totalVideoLengthInSeconds)
        createdAt = try values.decode(String.self, forKey: .createdAt)
        incubateTime = try values.decode(String.self, forKey: .incubateTime)
        proposalDueTime = try values.decode(String.self, forKey: .proposalDueTime)
        publishTime = try values.decodeIfPresent(String.self, forKey: .publishTime)
        let type = CoursesType(rawValue: status) ?? .published
        coursesType = type
        totalVideoMinutes = "\(totalVideoLengthInSeconds / 60) 分"
        goal = (numSoldTickets / successCriteria.numSoldTickets).formattedWithThousandSeparator()
    }
}

// MARK: - CoursesCoverImage
struct CoursesCoverImage: Codable {
    let id: String
    let url: String
    let height, width: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case url, height, width
    }
}

// MARK: - SuccessCriteria
struct SuccessCriteria: Codable {
    let numSoldTickets: Int
}
