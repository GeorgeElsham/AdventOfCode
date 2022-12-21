typealias ValveName = Substring

struct Valve {
    let rate: Int
    let valves: [ValveName]
}

struct ValveWithCost {
    let rate: Int
    let tunnels: [Tunnel]
}

struct Tunnel {
    let destination: ValveName
    let cost: Int
}

func getInput(string: String) -> [ValveName: Valve] {
    var dict = [ValveName: Valve]()

    for line in string.split(separator: "\n") {
        let regex = #/
            Valve\s(?<name>\w\w).*
            rate=(?<rate>\d+).*
            valves?\s(?<valves>.*)
        /#
        let match = line.firstMatch(of: regex)!.output
        dict[match.name] = Valve(
            rate: Int(match.rate)!,
            valves: match.valves.split(separator: ", ")
        )
    }

    return dict
}

func maxPressureReleased(current: ValveName, valvesWithCostDict: [ValveName: ValveWithCost], dontOpen: Set<ValveName>, time: Int, leaking: Int, total: Int) -> Int {
    guard time > 0 else {
        return total
    }
    guard dontOpen.count != valvesWithCostDict.count else {
        return total + leaking * time
    }

    var currentMax = 0
    let currentValve = valvesWithCostDict[current]!

    for tunnel in currentValve.tunnels where !dontOpen.contains(tunnel.destination) {
        let fullCost = tunnel.cost + 1

        if time >= fullCost {
            var newDontOpen = dontOpen
            newDontOpen.insert(tunnel.destination)

            let result = maxPressureReleased(
                current: tunnel.destination,
                valvesWithCostDict: valvesWithCostDict,
                dontOpen: newDontOpen,
                time: time - fullCost,
                leaking: leaking + valvesWithCostDict[tunnel.destination]!.rate,
                total: total + leaking * fullCost
            )
            if result > currentMax {
                currentMax = result
            }
        }
    }

    return currentMax
}

func getMaxPressureReleased(input: String) -> Int {
    let valvesDict = getInput(string: input)
    var dontOpen = Set<ValveName>()
    for valve in valvesDict where valve.value.rate == 0 {
        dontOpen.insert(valve.key)
    }

    var valvesWithCostDict = [ValveName: ValveWithCost]()
    for source in valvesDict {
        var dist = [ValveName: Int]()
        var q = Set<ValveName>()
        for valve in valvesDict.keys {
            dist[valve] = .max
            q.insert(valve)
        }
        dist[source.key] = 0

        while !q.isEmpty {
            let u = q.min { dist[$0]! < dist[$1]! }!
            q.remove(u)

            for v in valvesDict[u]!.valves.filter(q.contains) {
                let alt = dist[u]! + 1
                if alt < dist[v]! {
                    dist[v] = alt
                }
            }
        }

        var tunnels = [Tunnel]()
        for (destination, cost) in dist {
            guard source.key != destination && valvesDict[destination]!.rate > 0 else {
                continue
            }
            tunnels.append(Tunnel(destination: destination, cost: cost))
        }
        valvesWithCostDict[source.key] = ValveWithCost(rate: source.value.rate, tunnels: tunnels)
    }

    let result = maxPressureReleased(
        current: "AA",
        valvesWithCostDict: valvesWithCostDict,
        dontOpen: dontOpen,
        time: 30,
        leaking: 0,
        total: 0
    )

    return result
}

let result = getMaxPressureReleased(input: """
Valve QP has flow rate=0; tunnels lead to valves IS, DG
Valve MC has flow rate=0; tunnels lead to valves XX, QQ
Valve OT has flow rate=7; tunnels lead to valves OE, BL, DJ, JS, LS
Valve CZ has flow rate=0; tunnels lead to valves IC, ZL
Valve GI has flow rate=0; tunnels lead to valves OM, GF
Valve YB has flow rate=0; tunnels lead to valves DQ, MX
Valve EJ has flow rate=0; tunnels lead to valves GB, ES
Valve IS has flow rate=19; tunnels lead to valves AS, OB, QP
Valve WI has flow rate=21; tunnels lead to valves SS, AK
Valve JS has flow rate=0; tunnels lead to valves OT, HV
Valve UR has flow rate=0; tunnels lead to valves OM, ZI
Valve UC has flow rate=0; tunnels lead to valves QX, NG
Valve BL has flow rate=0; tunnels lead to valves YW, OT
Valve AK has flow rate=0; tunnels lead to valves WI, AL
Valve QQ has flow rate=16; tunnels lead to valves MC, WH, MS, IY
Valve PW has flow rate=0; tunnels lead to valves ZL, EK
Valve AS has flow rate=0; tunnels lead to valves IS, MS
Valve ZL has flow rate=9; tunnels lead to valves CD, QX, PW, CZ, PQ
Valve OB has flow rate=0; tunnels lead to valves HS, IS
Valve OE has flow rate=0; tunnels lead to valves IC, OT
Valve AL has flow rate=0; tunnels lead to valves VX, AK
Valve AM has flow rate=0; tunnels lead to valves OM, YW
Valve QX has flow rate=0; tunnels lead to valves UC, ZL
Valve DJ has flow rate=0; tunnels lead to valves OT, ST
Valve ZI has flow rate=0; tunnels lead to valves VX, UR
Valve PQ has flow rate=0; tunnels lead to valves ZL, YW
Valve OM has flow rate=22; tunnels lead to valves GI, AM, EK, UR
Valve NG has flow rate=13; tunnels lead to valves UC, HS, GF
Valve AA has flow rate=0; tunnels lead to valves UJ, ES, JP, HY, ST
Valve HY has flow rate=0; tunnels lead to valves GZ, AA
Valve MS has flow rate=0; tunnels lead to valves AS, QQ
Valve JK has flow rate=0; tunnels lead to valves YW, GB
Valve JP has flow rate=0; tunnels lead to valves AA, PF
Valve ST has flow rate=0; tunnels lead to valves AA, DJ
Valve CD has flow rate=0; tunnels lead to valves SS, ZL
Valve ES has flow rate=0; tunnels lead to valves EJ, AA
Valve PF has flow rate=0; tunnels lead to valves JP, HV
Valve RL has flow rate=0; tunnels lead to valves GB, IC
Valve IY has flow rate=0; tunnels lead to valves QQ, SN
Valve UJ has flow rate=0; tunnels lead to valves IC, AA
Valve HS has flow rate=0; tunnels lead to valves NG, OB
Valve WH has flow rate=0; tunnels lead to valves QQ, MX
Valve YA has flow rate=0; tunnels lead to valves GB, HV
Valve SN has flow rate=0; tunnels lead to valves IY, DG
Valve GF has flow rate=0; tunnels lead to valves GI, NG
Valve YW has flow rate=8; tunnels lead to valves GZ, JK, BL, PQ, AM
Valve DG has flow rate=17; tunnels lead to valves QP, SN
Valve MX has flow rate=11; tunnels lead to valves WH, YB
Valve DQ has flow rate=0; tunnels lead to valves YB, HV
Valve SS has flow rate=0; tunnels lead to valves CD, WI
Valve HV has flow rate=4; tunnels lead to valves YA, DQ, TO, JS, PF
Valve GB has flow rate=6; tunnels lead to valves LS, RL, JK, EJ, YA
Valve EK has flow rate=0; tunnels lead to valves OM, PW
Valve LS has flow rate=0; tunnels lead to valves GB, OT
Valve IC has flow rate=5; tunnels lead to valves CZ, OE, UJ, TO, RL
Valve XX has flow rate=0; tunnels lead to valves MC, FM
Valve VX has flow rate=25; tunnels lead to valves ZI, AL
Valve GZ has flow rate=0; tunnels lead to valves HY, YW
Valve FM has flow rate=20; tunnel leads to valve XX
Valve TO has flow rate=0; tunnels lead to valves IC, HV
""")
print(result)
