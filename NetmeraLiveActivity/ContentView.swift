import SwiftUI
import ActivityKit
import NetmeraCore
import NetmeraLiveActivity

struct ContentView: View {
    @State private var matchActivity: Activity<MatchScoreAttributes>?
    @State private var deliveryActivity: Activity<DeliveryTrackingAttributes>?
    @State private var transportActivity: Activity<PublicTransportAttributes>?
    @State private var flightActivity: Activity<FlightTrackingAttributes>?
    @State private var pomodoroActivity: Activity<PomodoroAttributes>?
    @State private var errorMessage: String?
    @State private var showError = false
    
    var body: some View {
        NavigationView {
            List {
                Section("Match Score") {
                    Button("Start Match Activity") {
                        startMatchActivity()
                    }
                    Button("Update Score") {
                        updateMatchScore()
                    }
                    Button("End Match Activity") {
                        endMatchActivity()
                    }
                }
                
                Section("Delivery Tracking") {
                    Button("Start Delivery Activity") {
                        startDeliveryActivity()
                    }
                    Button("Update Delivery Status") {
                        updateDeliveryStatus()
                    }
                    Button("End Delivery Activity") {
                        endDeliveryActivity()
                    }
                }
                
                Section("Public Transport") {
                    Button("Start Transport Activity") {
                        startTransportActivity()
                    }
                    Button("Update Transport Status") {
                        updateTransportStatus()
                    }
                    Button("End Transport Activity") {
                        endTransportActivity()
                    }
                }
                
                Section("Flight Tracking") {
                    Button("Start Flight Activity") {
                        startFlightActivity()
                    }
                    Button("Update Flight Status") {
                        updateFlightStatus()
                    }
                    Button("End Flight Activity") {
                        endFlightActivity()
                    }
                }
                
                Section("Pomodoro Timer") {
                    Button("Start Pomodoro") {
                        startPomodoroActivity()
                    }
                    Button("Update Timer") {
                        updatePomodoroTimer()
                    }
                    Button("End Pomodoro") {
                        endPomodoroActivity()
                    }
                }
            }
            .navigationTitle("Live Activities Demo")
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage ?? "Unknown error")
            }
        }
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showError = true
    }
    
    // MARK: - Match Score Activity
//    Dökümana localden başlatılan activitynin update edilebilmesi için eklenecek örnek
//    🔴 - [LiveActivityManagerImpl.swift] Cannot observe activity, missing required attribute: netmeraGroupId - group ıd verilmediğinde gelen log. Localden bir activity başlatılırken group id set ettiğinizden emin olun gibi dökümana eklenecek
 
    private func startMatchActivity() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            showError("Live Activities are not enabled")
            return
        }
        
        let attributes = MatchScoreAttributes(netmeraGroupId: "testGroupId",homeTeamName: "Barcelona",
                                              awayTeamName: "Real Madrid",
                                              homeTeamLogo: "barcelona_logo",
                                              awayTeamLogo: "madrid_logo")
        let contentState = MatchScoreAttributes.ContentState(
            homeTeamScore: 0,
            awayTeamScore: 0,
            minute: 0
        )
        
        do {
            matchActivity = try Activity.request(
                attributes: attributes,
                contentState: contentState,
                pushType: .token
            ) as Activity<MatchScoreAttributes>
            if let matchActivity{
                Netmera.observeActivity(matchActivity)
//                - sadece localden başlatmak isteyenler için, register yaptıysa başlatıldığından haberimiz oluyor ama garantiye almak için o yüzden müşteriye kendiniz başlatıyorsanız localden observeu mutlaka çağırın şeklinde ekleyeceğiz doc'a
            }
            
//            Netmera.unregister senaryo : bir maç favoriden kaldırılsa

            
            print("Match activity started successfully")
        } catch {
            showError("Error starting match activity: \(error.localizedDescription)")
        }
    }
    
    private func updateMatchScore() {
        guard let activity = matchActivity else {
            showError("No active match activity")
            return
        }
        
        Task {
            do {
                let updatedContentState = MatchScoreAttributes.ContentState(
                    homeTeamScore: Int.random(in: 0...5),
                    awayTeamScore: Int.random(in: 0...5),
                    minute: Int.random(in: 1...90)
//                    homeTeamName: "Barcelona",
//                    awayTeamName: "Real Madrid",
//                    homeTeamLogo: "barcelona_logo",
//                    awayTeamLogo: "madrid_logo"
                )
                
                await activity.update(using: updatedContentState)
                print("Match score updated successfully")
            } catch {
                showError("Error updating match score: \(error.localizedDescription)")
            }
        }
    }
    
    private func endMatchActivity() {
        guard let activity = matchActivity else {
            showError("No active match activity")
            return
        }
        
        Task {
            do {
                await activity.end(dismissalPolicy: .immediate)
                matchActivity = nil
                print("Match activity ended successfully")
            } catch {
                showError("Error ending match activity: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Delivery Tracking Activity
    private func startDeliveryActivity() {
        let attributes = DeliveryTrackingAttributes()
        let contentState = DeliveryTrackingAttributes.ContentState(
            deliveryStatus: "In Transit",
            remainingStops: 5,
            estimatedDeliveryTime: Date().addingTimeInterval(3600),
            courierName: "John Doe"
        )
        
        do {
            deliveryActivity = try Activity.request(
                attributes: attributes,
                contentState: contentState,
                pushType: nil
            )
        } catch {
            print("Error starting delivery activity: \(error.localizedDescription)")
        }
    }
    
    private func updateDeliveryStatus() {
        Task {
            let updatedContentState = DeliveryTrackingAttributes.ContentState(
                deliveryStatus: "In Transit",
                remainingStops: Int.random(in: 0...5),
                estimatedDeliveryTime: Date().addingTimeInterval(Double.random(in: 1800...7200)),
                courierName: "John Doe"
            )
            
            await deliveryActivity?.update(using: updatedContentState)
        }
    }
    
    private func endDeliveryActivity() {
        Task {
            await deliveryActivity?.end(dismissalPolicy: .immediate)
        }
    }
    
    // MARK: - Public Transport Activity
    private func startTransportActivity() {
        let attributes = PublicTransportAttributes()
        let contentState = PublicTransportAttributes.ContentState(
            vehicleNumber: "34BZ",
            remainingTime: 5,
            stopName: "Mecidiyeköy",
            vehicleType: "bus"
        )
        
        do {
            transportActivity = try Activity.request(
                attributes: attributes,
                contentState: contentState,
                pushType: nil
            )
        } catch {
            print("Error starting transport activity: \(error.localizedDescription)")
        }
    }
    
    private func updateTransportStatus() {
        Task {
            let updatedContentState = PublicTransportAttributes.ContentState(
                vehicleNumber: "34BZ",
                remainingTime: Int.random(in: 1...10),
                stopName: "Mecidiyeköy",
                vehicleType: "bus"
            )
            
            await transportActivity?.update(using: updatedContentState)
        }
    }
    
    private func endTransportActivity() {
        Task {
            await transportActivity?.end(dismissalPolicy: .immediate)
        }
    }
    
    // MARK: - Flight Tracking Activity
    private func startFlightActivity() {
        let attributes = FlightTrackingAttributes(netmeraGroupId: "testGroupIdForFlight", flightNumber: "123", arrivalCity: "IST", airlineLogo: "logo", departureCity: "ANK")
        let contentState = FlightTrackingAttributes.ContentState(
//            flightNumber: "THY123",
            departureTime: Date().addingTimeInterval(3600),
            arrivalTime: Date().addingTimeInterval(7200),
//            departureCity: "Istanbul",
//            arrivalCity: "London",
            gateNumber: "210"
//            airlineLogo: "thy_logo"
        )
        
        do {
            flightActivity = try Activity.request(
                attributes: attributes,
                contentState: contentState,
                pushType: nil
            )
        } catch {
            print("Error starting flight activity: \(error.localizedDescription)")
        }
    }
    
    private func updateFlightStatus() {
        Task {
            let updatedContentState = FlightTrackingAttributes.ContentState(
//                flightNumber: "THY123",
                departureTime: Date().addingTimeInterval(3600),
                arrivalTime: Date().addingTimeInterval(7200),
//                departureCity: "Istanbul",
//                arrivalCity: "London",
                gateNumber: String(Int.random(in: 200...300))
//                airlineLogo: "thy_logo"
            )
            
            await flightActivity?.update(using: updatedContentState)
        }
    }
    
    private func endFlightActivity() {
        Task {
            await flightActivity?.end(dismissalPolicy: .immediate)
        }
    }
    
    // MARK: - Pomodoro Activity
    private func startPomodoroActivity() {
        let attributes = PomodoroAttributes(netmeraGroupId: "groupIdForPomodoro", taskName: "test")
        let contentState = PomodoroAttributes.ContentState(
            remainingTime: 1500, // 25 minutes
//            taskName: "English Study",
            isBreak: false
        )
        
        do {
            pomodoroActivity = try Activity.request(
                attributes: attributes,
                contentState: contentState,
                pushType: nil
            )
        } catch {
            print("Error starting pomodoro activity: \(error.localizedDescription)")
        }
    }
    
    private func updatePomodoroTimer() {
        Task {
            let updatedContentState = PomodoroAttributes.ContentState(
                remainingTime: Double.random(in: 300...1500),
//                taskName: "English Study",
                isBreak: Bool.random()
            )
            
            await pomodoroActivity?.update(using: updatedContentState)
        }
    }
    
    private func endPomodoroActivity() {
        Task {
            await pomodoroActivity?.end(dismissalPolicy: .immediate)
        }
    }
} 
