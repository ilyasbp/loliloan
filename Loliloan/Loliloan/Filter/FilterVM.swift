//
//  FilterVM.swift
//  Loliloan
//
//  Created by Ilyas Bintang Prayogi on 25/02/24.
//

import RxSwift
import RxRelay

// MARK: - INIT
class FilterVM {
    
    /// - Note: Variable
    let purposeList = BehaviorRelay<[LoanFilter]>(value: [])
    let termList = BehaviorRelay<[LoanFilter]>(value: [])
    let riskList = BehaviorRelay<[LoanFilter]>(value: [])
    let filterCount = BehaviorRelay<Int>(value: 0)
    let publishFilter = PublishSubject<([String],[String],[String])>()
    
    init() {
        addPurposeList()
        addTermList()
        addRiskList()
    }
}


// MARK: - SERVICE
extension FilterVM{
    func addPurposeList(){
        var list: [LoanFilter] = []
        list.append(LoanFilter(name: "Business Expansion", isActive: false))
        list.append(LoanFilter(name: "Education", isActive: false))
        list.append(LoanFilter(name: "Home Improvement", isActive: false))
        list.append(LoanFilter(name: "Others", isActive: false))
        purposeList.accept(list)
    }
    func addTermList(){
        var list: [LoanFilter] = []
        list.append(LoanFilter(name: "30", isActive: false))
        list.append(LoanFilter(name: "60", isActive: false))
        list.append(LoanFilter(name: "120", isActive: false))
        termList.accept(list)
    }
    func addRiskList(){
        var list: [LoanFilter] = []
        list.append(LoanFilter(name: "A", isActive: false))
        list.append(LoanFilter(name: "B", isActive: false))
        list.append(LoanFilter(name: "C", isActive: false))
        riskList.accept(list)
    }
    
    func publishAllFilter(){
        publishFilter.onNext((
            purposeList.value.filter{ $0.isActive }.map{ $0.name },
            termList.value.filter{ $0.isActive }.map{ $0.name },
            riskList.value.filter{ $0.isActive }.map{ $0.name }
        ))
    }
}
