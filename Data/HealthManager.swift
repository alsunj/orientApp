//
//  HealthManager.swift
//  orientApp
//
//  Created by Alex Šunjajev on 29.12.2023.
//

import Foundation
import HealthKit


class HealthManager: ObservableObject{
    static let shared = HealthManager()

    @Published var stepCount: Int = 0  // New property to hold step count

    @Published var currentSession: Session?
    private let startDate: Date

    private let healthStore = HKHealthStore()
    init()
    {  
        
        let startDateComponents = DateComponents(year: 2023, month: 12, day: 29, hour: 11, minute: 0, second: 0)
        startDate = Calendar.current.date(from: startDateComponents) ?? Date()


        let steps = HKQuantityType(.stepCount)
        let healthTypes: Set = [steps]
        print("try1")
        Task{
            print("try2")

            do{        print("try3")

                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
            } catch{
                print("error fetching healthdata")
            }
            
        }
    }
    func fetchSessionSteps()
    {        print("try4")

        let steps = HKQuantityType(.stepCount)
   //     let predicate = HKQuery.predicateForSamples(withStart: currentSession?.createdAt, end: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else{
                print("error fetching todays step data")
                return
            }
            let stepcount = Int(quantity.doubleValue(for: .count()))
            DispatchQueue.main.async {
            self.stepCount = stepcount
            }
        }
        healthStore.execute(query)
    }
}

