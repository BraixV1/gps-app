//
//  AppIntentProvider.swift
//  map-project
//
//  Created by Brajan Kukk on 08.01.2025.
//


class AppIntentProvider {
    static let shared = AppIntentProvider()
    private var viewModelMap: [String: WeakViewModel] = [:]
    
    struct WeakViewModel {
        weak var reference: LocationViewModel?
    }
    
    func registerViewModel(_ viewModel: LocationViewModel, forActivityId id: String) {
        viewModelMap[id] = WeakViewModel(reference: viewModel)
    }
    
    func unregisterViewModel(forActivityId id: String) {
        viewModelMap.removeValue(forKey: id)
    }
    
    func getViewModel(forActivityId id: String) -> LocationViewModel? {
        return viewModelMap[id]?.reference
    }
}