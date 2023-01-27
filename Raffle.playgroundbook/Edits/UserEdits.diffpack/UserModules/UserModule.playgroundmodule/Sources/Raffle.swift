
public struct Raffle {
    let prizes: [Prize]
    let participants: [Participant]
    
    public let results: [Raffle.Result]    
    public let resultDescription: String
    
    public init(prizeNames: [String], participantNames: [String]) {
        self.prizes = prizeNames.map { name in Prize(name) }
        self.participants = participantNames.map { name in Participant(name) }
        
        self.results = Raffle.perform(prizes: self.prizes, participants: self.participants)
        self.resultDescription = Raffle.describe(results: self.results)
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
                results.append(Result(participant: nil, prize: prize))
                return
            }
            results.append(Result(participant: winner, prize: prize))
        }
        results.append(contentsOf: remainingParticipants.map { losingParticipant in
            Result(participant: losingParticipant, prize: nil) 
        })
        
        return results
    }
    
    fileprivate static func describe(results: [Result]) -> String {
        return "RESULTS\n-------\n" + results.map { $0.description }.joined(separator: "\n")
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
        
        fileprivate static func describeResult(participant: Participant?, prize: Prize?) -> String {
            let participantName = participant?.name ?? "Nobody"
            let prizeName = prize?.name ?? "Nothing"
            
            return "\(participantName) won \(prizeName)"
        }
    }
}