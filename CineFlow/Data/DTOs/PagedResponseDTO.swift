//
//  PagedResponseDTO.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation

// MARK: - Paged Response DTO
struct PagedResponseDTO<T: Decodable & Sendable>: Decodable, Sendable {
    let page: Int
    let results: [T]
    let totalPages: Int
    let totalResults: Int
}
