import SwiftUI
import ActivityKit
import NetmeraCore
import NetmeraLiveActivity

struct ContentView: View {
    @State private var matchActivity: Activity<MatchScoreAttributes>?
    @State private var deliveryActivity: Activity<DeliveryTrackingAttributes>?
    @State private var transportActivity: Activity<PublicTransportAttributes>?
    @State private var flightActivity: Activity<FlightTrackingAttributes>?
    @State private var fintechActivity: Activity<FintechAttributes>?
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
                
                Section("Fintech Tracking") {
                    Button("Start Fintech Activity") {
                        startFintechActivity()
                    }
                    Button("Update  Fintech Activity") {
                        updateFintechStatus()
                    }
                    Button("End  Fintech Activity") {
                        endFintechActivity()
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
            matchStatus: "1st half"
        )
        
        do {
            matchActivity = try Activity.request(
                attributes: attributes,
                contentState: contentState,
                pushType: .token
            ) as Activity<MatchScoreAttributes>
            if let matchActivity{
                // Netmera üzerinden başlatılmayan, yani uygulama tarafından local olarak başlatılan Live Activity’ler için
                // Netmera.observeActivity(_:) metodunun çağrılması gerekir.

                // Eğer daha önce register işlemi yapıldıysa, teorik olarak Netmera bu activity’nin başlatıldığını algılayabilir.
                // Ancak bu durum her zaman garanti değildir. Bu nedenle, **özellikle activity uygulama tarafından local olarak başlatılıyorsa**
                // güvenilir bir izleme sağlamak amacıyla observe işlemi mutlaka manuel olarak yapılmalıdır.

                // Bu yöntemle, activity’nin yaşam döngüsü boyunca Netmera’nın ilgili token’ı takip etmesi ve gerektiğinde güncellemeleri işlemesi sağlanır.

                // Bu adım, sadece local başlatma senaryoları için geçerlidir; remote başlatmalarda gerekli değildir.

                Netmera.observeActivity(matchActivity)
            }
           
            // Netmera.unregister(name: matchActivity)
            // Netmera.unregister senaryo : bir maç favoriden kaldırılsa

            
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
                    matchStatus: "Second Half"
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
        let attributes = FlightTrackingAttributes(netmeraGroupId: "testGroupIdForFlight", flightNumber: "THY123", arrivalCity: "London", airlineLogo: "thy_logo", departureCity: "Istanbul")
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
    
    // MARK: - Fintech Activity
    private func startFintechActivity() {
        let attributes = FintechAttributes()
        let contentState = FintechAttributes.ContentState(
            balance: 1.2,
            changePercentage: 1.3,
            isPositive: true,
            investmentProgress: 2.4
        )
        
        do {
            fintechActivity = try Activity.request(
                attributes: attributes,
                contentState: contentState,
                pushType: nil
            )
        } catch {
            print("Error starting Fintech activity: \(error.localizedDescription)")
        }
    }
    
    private func updateFintechStatus() {
        Task {
            let updatedContentState = FintechAttributes.ContentState(
                balance: 2.2,
                changePercentage: 5.3,
                isPositive: false,
                investmentProgress: 4.4
            )
            
            await fintechActivity?.update(using: updatedContentState)
        }
    }
    
    private func endFintechActivity() {
        Task {
            await fintechActivity?.end(dismissalPolicy: .immediate)
        }
    }
} 
