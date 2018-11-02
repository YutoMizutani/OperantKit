//
//  FleshlerHoffman.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Fleshler & Hoffman VI schedule generator
public struct FleshlerHoffman {
    public init() {}

    /// Fleshler, M., & Hoffman, H. S. (1962). A PROGRESSION FOR GENERATING VARIABLE‐INTERVAL SCHEDULES 1. Journal of the experimental analysis of behavior, 5(4), 529-530.
    public func generatedInterval(value v: Int, iterations n: Int = 12) -> [Int] {
        guard n != 0 else { return [] }

        let xorshift = Xorshift128(UInt64(Date().timeIntervalSince1970))
        var rd = [Int](repeating: 0, count: n)
        var vi = [Double](repeating: 0, count: n + 1)

        for m in 1...n {
            let dv = Double(v)
            let dn = Double(n)
            let dm = Double(m)

            if m == n {

                vi[m] = dv * (1 + log(dn))

            } else {

                let s1 = (1 + log(dn)) + (dn - dm) * (log(dn - dm))
                let s2 = (dn - dm + 1) * log(dn - dm + 1)
                vi[m] = dv * (s1 - s2)

            }

            var order: Int
            repeat {
                order = Int(xorshift.xor128() % UInt64(n))
            } while rd[order] != 0

            rd[order] = Int(round(vi[m]))
        }

        let remnant = (v * n) - rd[0..<n].reduce(0, +)
        if remnant != 0 {
            rd[0] += remnant
        }

        return rd
    }

    /// Fleshler & Hoffman (1962) for VR schedule
    public func generatedRatio(value v: Int, iterations n: Int = 12) -> [Int] {
        guard n != 0 else { return [] }

        let vi: [Double] = generatedInterval(value: v * 1000, iterations: n).map({ Double($0) / 1000 })

        // VIと同様VR-Value * 1000で計算，その後Int(/1000)により1桁以下で四捨五入(0は1へ)，arrayの最後の要素で平均値とのズレを修正@YMinuztani2017
        var rd: [Int] = [Int](repeating: 0, count: n)
        var sum = 0
        for i in 0..<rd.count {
            rd[i] = Int(round(vi[i]))
            if rd[i] == 0 {
                rd[i] = 1
            }
            sum += rd[i]
        }

        var surplus:Int = v * n - (sum - rd[rd.count - 1])
        if surplus > 0 {

            rd[rd.count - 1] = surplus

        } else {

            rd[rd.count - 1] = 1
            surplus -= 1

            for i in 0...rd.count - 1 {
                let k = (rd.count - 1) - i
                if rd[k] >= 2 {
                    rd[k] -= 1
                    surplus += 1
                    if surplus >= 0 {
                        break
                    }
                }
            }

        }

        return rd
    }
}

public extension FleshlerHoffman {
    /// Hantula, D. A. (1991). A simple BASIC program to generate values for variable‐interval schedules of reinforcement. Journal of Applied Behavior Analysis, 24(4), 799-801.
    func hantula1991(value v: Int, number n: Int = 12) -> [Int] {
        guard n != 0 else { return [] }

        var rd = [Int](repeating: 0, count: n + 1)
        var vi = [Double](repeating: 0, count: n + 1)

        for m in 1...n {
            let dv = Double(v)
            let dn = Double(n)
            let dm = Double(m)

            func GOTO_130() {
                var RND: Double { return Double(arc4random_uniform(1000000000)) / 1000000000 }
                let order = Int((dn * RND + 1))
                rd[order] == 0 ? rd[order] = Int(round(vi[m])) : GOTO_130()
            }

            if m == n {
                vi[m] = dv * (1 + log(dn))
            } else {
                let s1 = (1 + log(dn)) + (dn - dm) * (log(dn - dm))
                let s2 = (dn - dm + 1) * log(dn - dm + 1)
                vi[m] = dv * (s1 - s2)
            }

            GOTO_130()
        }

        return [Int](rd.suffix(n))
    }
}
