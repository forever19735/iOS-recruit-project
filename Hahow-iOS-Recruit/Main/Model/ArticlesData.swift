//
//  ArticlesData.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import Foundation

// MARK: - ArticlesData
struct ArticlesData: Codable {
    let staffPickArticles: [StaffPickArticle]
}

// MARK: - StaffPickArticle
struct StaffPickArticle: Codable {
    let id, title: String
    let coverImage: CoverImage
    let previewDescription: String
    let creator: Creator
    let viewCount: Int
    let createdAt, updatedAt, publishedAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, coverImage, previewDescription, creator, viewCount, createdAt, updatedAt, publishedAt
    }
}

// MARK: - CoverImage
struct CoverImage: Codable {
    let id: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case url
    }
}

// MARK: - Creator
struct Creator: Codable {
    let id, name: String
    let profileImageURL: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case profileImageURL = "profileImageUrl"
    }
}
