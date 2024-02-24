//
//  Loan.swift
//  Loliloan
//
//  Created by Ilyas Bintang Prayogi on 24/02/24.
//

import Foundation


// MARK: - LoanElement
struct Loan: Codable {
    var id: String?
    var amount: Int?
    var interestRate: Double?
    var term: Int?
    var purpose: Purpose?
    var riskRating: RiskRating?
    var borrower: Borrower?
    var collateral: Collateral?
    var documents: [Document]?
    var repaymentSchedule: RepaymentSchedule?
}

// MARK: - Borrower
struct Borrower: Codable {
    var id, name, email: String?
    var creditScore: Int?
}

// MARK: - Collateral
struct Collateral: Codable {
    var type: CollateralType?
    var value: Int?
}

enum CollateralType: String, Codable {
    case realEstate = "Real Estate"
}

// MARK: - Document
struct Document: Codable {
    var type: DocumentType?
    var url: String?
}

enum DocumentType: String, Codable {
    case incomeStatement = "Income Statement"
}

enum Purpose: String, Codable {
    case businessExpansion = "Business Expansion"
    case education = "Education"
    case homeImprovement = "Home Improvement"
    case others = "Others"
}

// MARK: - RepaymentSchedule
struct RepaymentSchedule: Codable {
    var installments: [Installment]?
}

// MARK: - Installment
struct Installment: Codable {
    var dueDate: String?
    var amountDue: Int?
}

enum RiskRating: String, Codable {
    case a = "A"
    case b = "B"
    case c = "C"
}
