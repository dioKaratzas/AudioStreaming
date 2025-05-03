//
//  BiMapTests.swift
//  AudioStreamingTests
//
//  Created by Dimitrios Chatzieleftheriou on 26/05/2020.
//  Copyright © 2020 Decimal. All rights reserved.
//

import Testing
@testable import AudioStreaming

@Suite
struct BiMapTests {
    @Test
    func biMapCanStoreAndRetrieveValues() {
        var map = BiMap<SomeClass, SomeOtherClass>()
        let someClass = SomeClass(item: 0)
        let someOtherClass = SomeOtherClass(item: 0)
        map[someClass] = someOtherClass

        #expect(map[someClass] == someOtherClass)
        #expect(map[someOtherClass] == someClass)
    }

    @Test
    func biMapCanRetrieveLeftAndRightValues() {
        var map = BiMap<SomeClass, SomeOtherClass>()
        let someClass = SomeClass(item: 0)
        let someOtherClass = SomeOtherClass(item: 0)
        map[someClass] = someOtherClass

        #expect(map.leftValues == [someClass])
        #expect(map.rightValues == [someOtherClass])
    }

    @Test
    func biMapCanStoreUsingEitherValueAsKey() {
        var map = BiMap<SomeClass, SomeOtherClass>()
        let someClass = SomeClass(item: 0)
        let someOtherClass = SomeOtherClass(item: 0)

        // Storing using the right value as key
        map[someOtherClass] = someClass

        // Storing using the left value as key
        map[someClass] = someOtherClass

        #expect(map[someOtherClass] == someClass)
        #expect(map[someClass] == someOtherClass)
    }

    @Test
    func biMapCanRemoveValueWhenPassingNil() {
        var map = BiMap<SomeClass, SomeOtherClass>()
        let someClass = SomeClass(item: 0)
        let someOtherClass = SomeOtherClass(item: 0)

        // Storing using the right value as key
        map[someOtherClass] = someClass

        // Storing using the left value as key
        map[someClass] = someOtherClass

        // Setting to nil
        map[someClass] = nil

        #expect(map.leftValues.isEmpty)
        #expect(map.rightValues.isEmpty)
    }
}

// For Convenience

class SomeClass: Hashable {
    static func == (lhs: SomeClass, rhs: SomeClass) -> Bool {
        lhs.item == rhs.item
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(item)
    }

    var item: Int

    init(item: Int) {
        self.item = item
    }
}

class SomeOtherClass: Hashable {
    static func == (lhs: SomeOtherClass, rhs: SomeOtherClass) -> Bool {
        lhs.item == rhs.item
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(item)
    }

    var item: Int

    init(item: Int) {
        self.item = item
    }
}
