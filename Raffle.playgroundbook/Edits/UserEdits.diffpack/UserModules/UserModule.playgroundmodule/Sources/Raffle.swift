
public struct Raffle {
    let prizes: [Prize]
    let participants: [Participant]
    
    public let results: [Raffle.Result]    
    public var resultDescription: String { self.results.description }
    
    public init(prizeNames: [String], participantNames: [String]) {
        self.prizes = prizeNames.map { name in Prize(name) }
        self.participants = participantNames.map { name in Participant(name) }
        
        self.results = Raffle.perform(prizes: self.prizes, participants: self.participants)
    }
    
    // This is a raffle where each participant can win only one resource.
    // Remaining resources are left un-allocated.
    // 50% odds that there's a technical name for this type of raffle
    // 25% odds that that technical name hasn't been workplace-appropriate since the '80s
    fileprivate static func perform(prizes: [Prize], participants: [Participant]) -> [Raffle.Result] {
        var remainingParticipants = participants
        var results = [Result]()
        
        prizes.forEach { prize in
            remainingParticipants.shuffle()
            
            guard let winner = remainingParticipants.popLast() else {
                results.append(Result(unclaimedPrize: prize))
                return
            }
            results.append(Result(participant: winner, prize: prize))
        }
        results.append(contentsOf: remainingParticipants.map { losingParticipant in
            Result(losingParticipant: losingParticipant)
        })
        
        return results
    }

    public struct Result {
        public let participant: Participant?
        public let prize: Prize?
        public let description: String
        
        public init(participant: Participant?, prize: Prize?) {
            self.participant = participant
            self.prize = prize
            self.description = Result.describeResult(participant: participant, prize: prize) 
        }

        public init(unclaimedPrize: Prize) {
            self.init(participant: nil, prize: unclaimedPrize)
        }

        public init(losingParticipant: Participant) {
            self.init(participant: losingParticipant, prize: nil)
        }

        fileprivate static func describeResult(participant: Participant?, prize: Prize?) -> String {
            let participantName = participant?.name ?? "Nobody"
            let prizeName = prize?.name ?? "Nothing"
            
            return "\(participantName) won \(prizeName)"
        }
    }
}

extension Array where Element == Raffle.Result {
    public var description: String {
        return (["RESULTS", "-------"]
                    + self.map { $0.description })
            .joined(separator: "\n")
    }
}
