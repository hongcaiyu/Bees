//
//  CenterBee.swift
//  Bees
//
//  Created by hongcaiyu on 15/1/18.
//
//  Copyright (c) 2017 Caiyu Hong <hongcaiyu@live.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#if os(macOS)
import AppKit
public struct Offset {

    public var horizontal: CGFloat

    public var vertical: CGFloat

    public init() {
        horizontal = 0
        vertical = 0
    }

    public init(horizontal: CGFloat, vertical: CGFloat) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
}
#else
import UIKit
public typealias Offset = UIOffset
#endif

extension QueenBee {
    public var center: CenterBee {
        return CenterBee(queenBee: self)
    }
}

public struct CenterConstraintSet: ConstraintSet {
    public let x: LayoutConstraint
    public let y: LayoutConstraint
    
    public func activate() {
        x.isActive = true
        y.isActive = true
    }
    
    public func deactivate() {
        x.isActive = false
        y.isActive = false
    }
    
    public var constants: Offset {
        get {
            return Offset(horizontal: x.constant, vertical: y.constant)
        }
        
        nonmutating set {
            x.constant = newValue.horizontal
            y.constant = newValue.vertical
        }
    }
    
}

public class CenterBee: Formation {
    public typealias ConstraintsType = CenterConstraintSet
    
    private let x: Pollen
    private let y: Pollen

    init(queenBee: QueenBee) {
        self.x = Pollen(attribute: .centerX, bee: queenBee)
        self.y = Pollen(attribute: .centerY, bee: queenBee)
    }
    
    public func offset(horizontal: CGFloat = 0, vertical: CGFloat = 0) -> CenterBee {
        self.x.add(horizontal)
        self.y.add(vertical)
        return self
    }
    
    public func offset(_ offset: Offset) -> CenterBee {
        return self.offset(horizontal: offset.horizontal, vertical: offset.vertical)
    }
    
    public static func makeConstraints(lhs: CenterBee, rhs: CenterBee, relation: LayoutRelation) -> CenterConstraintSet {
        lhs.x.disableAutoresizingTranslating()
        let xConstraint = Pollen.makeConstraint(lhs: lhs.x, rhs: rhs.x, relation: relation)
        let yConstraint = Pollen.makeConstraint(lhs: lhs.y, rhs: rhs.y, relation: relation)
        return CenterConstraintSet(x: xConstraint, y: yConstraint)
    }
    
    public static func prioritize(lhs: CenterBee, rhs: LayoutPriority) {
        lhs.x.prioritize(rhs)
        lhs.y.prioritize(rhs)
    }
    
}
