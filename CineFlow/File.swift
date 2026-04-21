//
//  File.swift
//  CineFlow
//
//  Created by hamza nejjar on 07/04/2026.
//

import Foundation

/*
We are building a program to manage a gym's membership. The gym has multiple members, each with a unique ID, name, and membership status. The program allows gym staff to add new members, update members status, and get membership statistics.

Definitions:
* A "member" is an object that represents a gym member. It has properties for the ID, name, and membership status.
* A "membership" is a class which is used for managing members in the gym.

To begin with, we present you with two tasks:
1-1) Read through and understand the code below. Please take as much time as necessary, and feel free to run the code.
1-2) The test for Membership is not passing due to a bug in the code. Make the necessary changes to Membership to fix the bug.
*/

/*
We are currently updating our system to include information about workouts for our members. As part of this update, we have introduced the Workout class, which represents a single workout session for a member. Each object of the Workout class has a unique ID, as well as a start time and end time that are represented in the number of minutes spent from the start of the day. You can assume that all the Workouts are from the same day.

To implement these changes, we need to add two functions to the Membership class:

2.1) The `addWorkout` function should be used to add a workout session for a member. If the given member does not exist while calling this function, the workout can be ignored.

2.2) The `getAverageWorkoutDurations` function should calculate the average duration of workouts for each member in minutes and return the results as a map.

To assist you in testing these new functions, we have provided the testGetAverageWorkoutDurations function.
*/

import XCTest

enum MembershipStatus {
    /*
        Membership Status is of three types: BRONZE, SILVER and GOLD.
        BRONZE is the default membership a new member gets.
        SILVER and GOLD are paid memberships for the gym.
    */
    case bronze
    case silver
    case gold
}

class Workout {
    /**
     * This class represents a single workout session for a member.
     * Each object of the Workout class has a unique ID, as well as
     * a start time and end time that are represented in the number
     * of minutes spent from the start of the day.
     */
    
    let id: Int
    let startTime: Int
    let endTime: Int
    
    init(id: Int, startTime: Int, endTime: Int) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
    }
    
    func getDuration() -> Int {
        return endTime - startTime
    }
}

class Member {
    /* Data about a gym member.*/
    var memberId: Int
    var name: String
    var membershipStatus: MembershipStatus
    
    init(memberId: Int, name: String, membershipStatus: MembershipStatus) {
        self.memberId = memberId
        self.name = name
        self.membershipStatus = membershipStatus
    }
    
    var description: String {
        return "Member ID: \(memberId), Name: \(name), Membership Status: \(membershipStatus)"
    }
}

class Membership {
    /*
        Data for managing a gym membership, and methods which staff can
        use to perform any queries or updates.
    */
    var members: [Member] = []
    var workouts: [Int: [Workout]] = [:]
    
    func addMember(_ member: Member) {
        members.append(member)
    }
    
    func addWorkout(memberId: Int, workout: Workout) {
        if let member = members.filter{$0.memberId == memberId}?.first {
            var workouts = workouts[memberId] ?? []
            guard let workout = workouts.filter{$0.id == workout.id} else {
              continue
            }
            workouts.append(workout)
            workouts[memberId, default: []] = workouts
        }
    }
    
    func updateMembership(memberId: Int, membershipStatus: MembershipStatus) {
        for member in members {
            if member.memberId == memberId {
                member.membershipStatus = membershipStatus
                break
            }
        }
    }
    
    func getMembershipStatistics() -> MembershipStatistics {
        let totalMembers = members.count
        var totalPaidMembers = 0
        for member in members {
            if member.membershipStatus == .gold || member.membershipStatus == .silver {
                totalPaidMembers += 1
            }
        }
        let conversionRate = (Double(totalPaidMembers) / Double(totalMembers)) * 100.0
        return MembershipStatistics(total_members: totalMembers,
                                  total_paid_members: totalPaidMembers,
                                  conversion_rate: conversionRate)
    }
    
    func getAverageWorkoutDurations() -> [Int: Double] {
        for member in members {
            let workouts = workouts[member.memberId] ?? []
            
        }
    }
    
    
}

class MembershipStatistics {
    /*
        Class for returning the getMembershipStatistics result
    */
    var total_members: Int
    var total_paid_members: Int
    var conversion_rate: Double
    
    init(total_members: Int, total_paid_members: Int, conversion_rate: Double) {
        self.total_members = total_members
        self.total_paid_members = total_paid_members
        self.conversion_rate = conversion_rate
    }
}

class TestSuite: XCTestCase {
    /*
        This is not a complete test suite, but tests some basic functionality of
        the code and shows how to use it.
    */
    static var allTests = [
        ("testMember", testMember),
        ("testMembership", testMembership),
        ("testGetAverageWorkoutDurations", testGetAverageWorkoutDurations),
    ]

    func testMember() {
        print("Running testMember")
        let testMember = Member(memberId: 1, name: "John Doe", membershipStatus: .bronze)
        XCTAssertEqual(testMember.memberId, 1)
        XCTAssertEqual(testMember.name, "John Doe")
        XCTAssertEqual(testMember.membershipStatus, .bronze)
    }
    
    func testMembership() {
        print("Running testMembership")
        let testMembership = Membership()
        let testMember = Member(memberId: 1, name: "John Doe", membershipStatus: .bronze)
        testMembership.addMember(testMember)
        XCTAssertEqual(testMembership.members.count, 1)
        XCTAssertIdentical(testMembership.members[0], testMember)
        
        testMembership.updateMembership(memberId: 1, membershipStatus: .silver)
        XCTAssertEqual(testMembership.members[0].membershipStatus, .silver)
        
        let testMember2 = Member(memberId: 2, name: "Alex C", membershipStatus: .bronze)
        testMembership.addMember(testMember2)
        
        let testMember3 = Member(memberId: 3, name: "Marie C", membershipStatus: .gold)
        testMembership.addMember(testMember3)
        
        let testMember4 = Member(memberId: 4, name: "Joe D", membershipStatus: .silver)
        testMembership.addMember(testMember4)

        let testMember5 = Member(memberId: 5, name: "June R", membershipStatus: .bronze)
        testMembership.addMember(testMember5)

        let testMember6 = Member(memberId: 6, name: "Westley D", membershipStatus: .silver)
        testMembership.addMember(testMember6)

        let attendanceStats = testMembership.getMembershipStatistics()
        XCTAssertEqual(attendanceStats.total_members, 6)
        XCTAssertEqual(attendanceStats.total_paid_members, 4)
        XCTAssertLessThan(abs(attendanceStats.conversion_rate - 66.67), 0.1)
    }
    
    func testGetAverageWorkoutDurations() {
        print("Running testGetAverageWorkoutDurations")
        let testMembership = Membership()
        let testMember1 = Member(memberId: 12, name: "John Doe", membershipStatus: .silver)
        testMembership.addMember(testMember1)
        
        let testMember2 = Member(memberId: 22, name: "Alex Cleeve", membershipStatus: .bronze)
        testMembership.addMember(testMember2)
        
        let testMember3 = Member(memberId: 31, name: "Marie Cardiff", membershipStatus: .gold)
        testMembership.addMember(testMember3)
        
        let testMember4 = Member(memberId: 37, name: "George Costanza", membershipStatus: .silver)
        testMembership.addMember(testMember4)
        
        let testWorkout1 = Workout(id: 11, startTime: 10, endTime: 20)
        let testWorkout2 = Workout(id: 24, startTime: 15, endTime: 35)
        let testWorkout3 = Workout(id: 32, startTime: 45, endTime: 90)
        let testWorkout4 = Workout(id: 47, startTime: 100, endTime: 155)
        let testWorkout5 = Workout(id: 56, startTime: 120, endTime: 200)
        let testWorkout6 = Workout(id: 62, startTime: 300, endTime: 400)
        let testWorkout7 = Workout(id: 78, startTime: 1000, endTime: 1010)
        let testWorkout8 = Workout(id: 80, startTime: 1010, endTime: 1045)
        
        testMembership.addWorkout(memberId: 12, workout: testWorkout1)
        testMembership.addWorkout(memberId: 22, workout: testWorkout2)
        testMembership.addWorkout(memberId: 31, workout: testWorkout3)
        testMembership.addWorkout(memberId: 12, workout: testWorkout4)
        testMembership.addWorkout(memberId: 22, workout: testWorkout5)
        testMembership.addWorkout(memberId: 31, workout: testWorkout6)
        testMembership.addWorkout(memberId: 12, workout: testWorkout7)
        testMembership.addWorkout(memberId: 4, workout: testWorkout8)
        
        let averageDurations = testMembership.getAverageWorkoutDurations()
        XCTAssertLessThan(abs(averageDurations[12]! - 25.0), 0.1)
        XCTAssertLessThan(abs(averageDurations[22]! - 50.0), 0.1)
        XCTAssertLessThan(abs(averageDurations[31]! - 72.5), 0.1)
        XCTAssertFalse(averageDurations.keys.contains(4))
    }
}

XCTMain([testCase(TestSuite.allTests)])
