//
//  LocationViewModel.swift
//  map-project
//
//  Created by Brajan Kukk on 15.12.2024.
//

import Foundation
import CoreLocation
import ActivityKit
import Combine

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var config: Config = Config()
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var lastLocation: CLLocation?
    @Published var distance: Double = 0
    @Published var track: [CLLocation] = []
    var unsentPoints: [GpsLocation] = []
    @Published var checkpoints: [Waypoint] = []
    @Published var waypoint: Waypoint?
    @Published var jwt: String
    @Published var gpsSessionId: UUID? = nil
    @Published var isTracking = false
    @Published var startTime: Date?
    @Published var elapsedTime: TimeInterval = 0
    @Published var isPaused = false
    @Published var isStopped = false
    @Published var averagePace: String? = nil
    @Published var averageSpeed: Double? = nil
    @Published var colored: Bool = true
    @Published var accumulatedTime: Double = 0
    @Published private(set) var locationPoints: [LocationPoint] = []
    
    
    private var pauseTime: Date?
    private var timer: AnyCancellable?
    
    private var lastNetworkUpdateTime: Date = .distantPast
    var liveActivity: Activity<DistanceWidgetAttributes>? = nil

    
    private let locationManager: CLLocationManager = CLLocationManager()
    
    init(AccessToken: String) {
        self.jwt = AccessToken

        locationManager.allowsBackgroundLocationUpdates = true
        authorizationStatus = locationManager.authorizationStatus

        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        Task {
            
        }
    }
    
    public func setGpsSessionId(gpsSessionId: UUID?) -> Void {
        self.gpsSessionId = gpsSessionId
        isStopped = false
        resetTimer()
        if self.gpsSessionId != nil {
            resetLocationViewModel()
            Task {
                await setupGpsLocation()

            }
        }
        updateVariables()

    }
    
    private func updateVariables() -> Void {
        self.averagePace = calculateAveragePace()
        self.distance = calculateTotalDistance()
        self.elapsedTime = calculateActiveDuration()
    }
    
    public func updateToken(accessToken: String) -> Void {
        self.jwt = accessToken
    }
    
    public func resetLocationViewModel() {
        self.track = []
        self.waypoint = nil
        self.checkpoints = []
        // self.gpsSessionId = nil
    }
    
        func startRun() {
            if startTime == nil {  // Only set if not already set
                startTime = Date()
                
            }
            accumulatedTime = calculateActiveDuration()
            isPaused = false
            colored = false
            resumeTimer()
        }
        
        func pauseRun() {
            guard !isPaused else { return }
            pauseTime = Date()
            timer?.cancel()
            isPaused = true
            // Store the accumulated time
            if let startTime = startTime {
                accumulatedTime += Date().timeIntervalSince(startTime)
            }
            stopTracking()
        }
        
        private func resumeTimer() {

            timer = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] _ in
                    guard let self = self, let startTime = self.startTime else { return }
                    // Add accumulated time to the current segment
                    self.elapsedTime = self.accumulatedTime + Date().timeIntervalSince(startTime)
                }
        }

    
       func stopRun() {
           pauseRun()
           isStopped = true
           stopTracking()
       }
    
    private func resetTimer() {
        startTime = Date()
        elapsedTime = 0
        isPaused = false
    }
    
    
    private func setupGpsLocation() async -> Void {
        let result = await GpsLocationService<GpsLocationResponse, GpsLocationResponse>(baseUrl: "/GpsLocations/Session/\(gpsSessionId!.uuidString)", accessToken: self.jwt).getAll()
        
        if let unwrappedData = result.data {
            // Create temporary arrays
            var newTrack: [CLLocation] = []
            var newCheckpoints: [Waypoint] = []
            var newWaypoint: Waypoint?
            
            for point in unwrappedData {
                let location = CLLocation(
                    coordinate: CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude),
                    altitude: CLLocationDistance(point.altitude),
                    horizontalAccuracy: CLLocationAccuracy(point.accuracy),
                    verticalAccuracy: CLLocationAccuracy(point.verticalAccuracy),
                    timestamp: point.recordedAt
                )
                
                if point.gpsLocationTypeId == UUID(uuidString: "00000000-0000-0000-0000-000000000001")! {
                    newTrack.append(location)
                }
                if point.gpsLocationTypeId == UUID(uuidString: "00000000-0000-0000-0000-000000000002")! {
                    newWaypoint = Waypoint(location: location, type: .waypoint)
                }
                if point.gpsLocationTypeId == UUID(uuidString: "00000000-0000-0000-0000-000000000003")! {
                    newCheckpoints.append(Waypoint(location: location, type: .checkpoint))
                }
            }
            
            // Sort the new track
            newTrack.sort(by: { $0.timestamp < $1.timestamp })
            
            // Update UI on main thread
            await MainActor.run {
                self.track = newTrack
                self.waypoint = newWaypoint
                self.checkpoints = newCheckpoints
                updateVariables()
            }
            
        }
    }
    
    
    public func startTracking() {
        startRun()
        isTracking = true
        if self.liveActivity == nil {
            startLiveActivity()
        }
        locationManager.startUpdatingLocation()
    }
    
    public func stopTracking() {
        pauseRun()
        isTracking = false
        locationManager.stopUpdatingLocation()
        retryFailedSends()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            for location in locations {
                if let lastLocation = lastLocation {
                    distance += lastLocation.distance(from: location)
                }
                lastLocation = location
                track.append(contentsOf: locations)
                
                // Create and store a new LocationPoint
                let point = LocationPoint(
                    id: UUID(),
                    location: location,
                    timestamp: location.timestamp,
                    gpsLocationTypeId: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                    isSent: false
                )
                
                
                
                locationPoints.append(point)
            }
            
            throttleNetworkUpdates()
            updateLiveActivity()
        }
    
    
    
    private func updateAverageSpeed() {
        self.averageSpeed = calculateAverageSpeed(for: track)
        self.averagePace = calculateAveragePace()
    }

    private func throttleNetworkUpdates() {
        let now = Date()
        if now.timeIntervalSince(lastNetworkUpdateTime) > 5 {
            updateAverageSpeed()
            lastNetworkUpdateTime = now
            Task {
                await sendPendingLocations()
            }
        }
    }
    
    private func sendPendingLocations() async {
        let unsentPoints = locationPoints.filter { !$0.isSent }
        guard !unsentPoints.isEmpty else { return }
        
        let gpsLocations = unsentPoints.map { $0.toGpsLocation }
        
        let result = await GpsSessionService<[GpsLocation], GpsLocationResponse>(
            baseUrl: "/GpsLocations/bulk/\(gpsSessionId!.uuidString)",
            accessToken: jwt
        ).create(data: gpsLocations)
        
        if result.errors == nil {
            // Mark points as sent
            await MainActor.run {
                for point in unsentPoints {
                    if let index = locationPoints.firstIndex(where: { $0.id == point.id }) {
                        locationPoints[index].isSent = true
                    }
                }
            }
        } else {
            print("Failed to send locations: \(result.errors ?? [])")
        }
    }

    private func sendLocationToServer(gpsLocationTypeId: UUID) async {
        guard let lastLocation = lastLocation else { return }
        let gpsLocation = GpsLocation(
            recordedAt: Date(),
            latitude: lastLocation.coordinate.latitude,
            longitude: lastLocation.coordinate.longitude,
            accuracy: lastLocation.horizontalAccuracy,
            altitude: lastLocation.altitude,
            verticalAccuracy: lastLocation.verticalAccuracy,
            gpsLocationTypeId: gpsLocationTypeId
        )
        
        // Attempt to send location to the server
        let result = await GpsSessionService<GpsLocation, GpsLocationResponse>(
            baseUrl: "/GpsLocations/\(gpsSessionId!.uuidString)",
            accessToken: jwt
        ).create(data: gpsLocation)
        
        if let errors = result.errors {
            await MainActor.run {
                unsentPoints.append(gpsLocation)
            }
            print("Failed to send location: \(errors)")
        }
    }
    
//    private func sendUnsentLocationsToServer() async {
//            guard !unsentPoints.isEmpty else { return }
//            
//            // Debug print
//            print("Attempting to send \(unsentPoints.count) unsent locations")
//            
//            // Validate all points before sending
//            let validPoints = unsentPoints.filter { $0.isValid }
//            if validPoints.count != unsentPoints.count {
//                print("Warning: \(unsentPoints.count - validPoints.count) invalid points filtered out")
//            }
//            
//            guard !validPoints.isEmpty else {
//                print("No valid points to send")
//                return
//            }
//            
//            // Debug print the first few points
//            print("First few points to send: \(validPoints.prefix(3))")
//            
//            let result = await GpsSessionService<[GpsLocation], GpsLocationResponse>(
//                baseUrl: "/GpsLocations/bulk/\(gpsSessionId!.uuidString)",
//                accessToken: jwt
//            ).create(data: validPoints)
//            
//            if let errors = result.errors {
//                print("Failed to send unsent locations: \(errors)")
//                print("Request details:")
//                print("- Number of points: \(validPoints.count)")
//                print("- Session ID: \(gpsSessionId?.uuidString ?? "nil")")
//                // Keep the failed points in the queue
//            } else {
//                await MainActor.run {
//                    print("Successfully sent \(validPoints.count) locations")
//                    // Remove only the successfully sent points
//                    unsentPoints = unsentPoints.filter { point in
//                        !validPoints.contains { $0.recordedAt == point.recordedAt }
//                    }
//                }
//            }
//        }
    
    
    func updateLiveActivity() {
        Task {
            guard let activity = liveActivity else {
                return
            }
            
            let contentState: DistanceWidgetAttributes.ContentState = DistanceWidgetAttributes.ContentState(distance: calculateTotalDistance(), elapsedTime: elapsedTime, pace: averagePace)
            
            await activity.update(
                ActivityContent(
                    state: contentState,
                    staleDate: .distantFuture,
                    relevanceScore: 50
                ),
                alertConfiguration: nil
            )
        }
    }
    
    func startLiveActivity() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("You can't start live activity.")
            return
        }
        
        do {
            let attribute = DistanceWidgetAttributes()
            let initialState = DistanceWidgetAttributes.ContentState(
                distance: distance,
                elapsedTime: elapsedTime,
                pace: averagePace
            )
            
            let activity = try Activity<DistanceWidgetAttributes>.request(
                attributes: attribute,
                content: .init(
                    state: initialState,
                    staleDate: .distantFuture,
                    relevanceScore: 100
                ),
                pushType: nil
            )
            
            self.liveActivity = activity
            
            AppIntentProvider.shared.registerViewModel(self, forActivityId: activity.id)
        } catch {
            print(error)
        }
    }
    
    func endLiveActivity() {
        if let activity = liveActivity {
            AppIntentProvider.shared.unregisterViewModel(forActivityId: activity.id)
            Task {
                await activity.end(dismissalPolicy: .immediate)
            }
        }
        liveActivity = nil
    }

    
    func addWaypoint() {
        guard let currentLocation = lastLocation else { return }
        waypoint = Waypoint(location: currentLocation, type: .waypoint)
        
        // Store waypoint in locationPoints
        let point = LocationPoint(
            id: UUID(),
            location: currentLocation,
            timestamp: Date(),
            gpsLocationTypeId: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
            isSent: false
        )
        locationPoints.append(point)
        
        Task {
            await sendPendingLocations()
        }
    }
    
    func addCheckPoint() {
        guard let currentLocation = lastLocation else { return }
        let waypoint = Waypoint(location: currentLocation, type: .checkpoint)
        checkpoints.append(waypoint)
        
        // Store checkpoint in locationPoints
        let point = LocationPoint(
            id: UUID(),
            location: currentLocation,
            timestamp: Date(),
            gpsLocationTypeId: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
            isSent: false
        )
        locationPoints.append(point)
        
        Task {
            await sendPendingLocations()
        }
    }
    
    func retryFailedSends() {
        Task {
            await sendPendingLocations()
        }
    }
    
    // Clean up old sent points periodically
    func cleanupOldPoints() {
        let sixHoursAgo = Date().addingTimeInterval(-6 * 60 * 60)
        locationPoints.removeAll { $0.isSent && $0.timestamp < sixHoursAgo }
    }
    
    func calculateActiveDuration() -> TimeInterval {
        guard track.count > 1 else { return 0 }

        let activeTrackingThreshold: TimeInterval = 30 // If points are more than 30 seconds apart, consider it a tracking gap
        var totalDuration: TimeInterval = 0
        let sortedTrack = track.sorted { $0.timestamp < $1.timestamp }

        for i in 1..<sortedTrack.count {
            let current = sortedTrack[i]
            let previous = sortedTrack[i - 1]
            let timeDifference = current.timestamp.timeIntervalSince(previous.timestamp)
            
            if timeDifference <= activeTrackingThreshold {
                totalDuration += timeDifference
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.elapsedTime = totalDuration
        }

        return totalDuration
    }
    
    func calculateTotalDistance(threshold: TimeInterval = 600) -> Double {
        guard track.count > 1 else { return 0 }

        var totalDistance: Double = 0

        for i in 1..<track.count {
            let previousLocation = track[i - 1]
            let currentLocation = track[i]
            let timeDifference = currentLocation.timestamp.timeIntervalSince(previousLocation.timestamp)

            if timeDifference <= threshold {
                totalDistance += previousLocation.distance(from: currentLocation)
            }
        }

        return totalDistance
    }
    
    func calculateWaypointSpeed() -> Double? {
        guard let waypoint = waypoint else { return nil } // No waypoint recorded

        var totalDistance: Double = 0
        var totalTime: TimeInterval = 0

        for i in 1..<track.count {
            let previousLocation = track[i - 1]
            let currentLocation = track[i]

            if previousLocation == waypoint.location || currentLocation == waypoint.location {
                let distance = previousLocation.distance(from: currentLocation)
                let timeDifference = currentLocation.timestamp.timeIntervalSince(previousLocation.timestamp)

                if timeDifference > 0 { // Avoid division by zero
                    totalDistance += distance
                    totalTime += timeDifference
                }
            }
        }

        return totalTime > 0 ? totalDistance / totalTime : nil // Speed in meters/second
    }
    
    func calculateAverageSpeed(for dataPoints: [CLLocation]) -> Double? {
        guard dataPoints.count >= 2 else { return nil }

        var totalDistance: Double = 0
        var totalTime: TimeInterval = 0

        for i in 1..<dataPoints.count {
            let previousLocation = dataPoints[i - 1]
            let currentLocation = dataPoints[i]

            let distance = previousLocation.distance(from: currentLocation)
            let timeDifference = currentLocation.timestamp.timeIntervalSince(previousLocation.timestamp)

            if timeDifference > 0 {
                totalDistance += distance
                totalTime += timeDifference
            }
        }

        return totalTime > 0 ? totalDistance / totalTime : nil
    }


    
    func calculateCheckpointSpeed() -> Double? {
        return calculateAverageSpeed(for: checkpoints.map { $0.location})
    }

    func calculateAveragePace() -> String? {
        guard let averageSpeedMps = calculateAverageSpeed(for: track) else { return nil }
        
        // Convert meters/second to kilometers/hour
        let speedKmh = averageSpeedMps * 3.6

        // Calculate hours per kilometer
        guard speedKmh > 0 else { return nil }
        let hoursPerKm = 1 / speedKmh

        // Convert hours to minutes and seconds for better readability
        let totalMinutes = hoursPerKm * 60
        let minutes = Int(totalMinutes)
        let seconds = Int((totalMinutes - Double(minutes)) * 60)
        if minutes > 99 {
            return "99+ min \(seconds) sec / km"
        }
        return "\(minutes) min \(seconds) sec / km"
    }
    
    func calculateCheckpointPace() -> String? {
        guard let averageSpeedMps = calculateCheckpointSpeed() else { return nil }
        
        // Convert meters/second to kilometers/hour
        let speedKmh = averageSpeedMps * 3.6

        // Calculate hours per kilometer
        guard speedKmh > 0 else { return nil }
        let hoursPerKm = 1 / speedKmh

        // Convert hours to minutes and seconds for better readability
        let totalMinutes = hoursPerKm * 60
        let minutes = Int(totalMinutes)
        let seconds = Int((totalMinutes - Double(minutes)) * 60)

        return "\(minutes) min \(seconds) sec / km"
    }

    func calculateWaypointPace() -> String? {
        guard let averageSpeedMps = calculateWaypointSpeed() else { return nil }
        
        let speedKmh = averageSpeedMps * 3.6

        guard speedKmh > 0 else { return nil }
        let hoursPerKm = 1 / speedKmh


        let totalMinutes = hoursPerKm * 60
        let minutes = Int(totalMinutes)
        let seconds = Int((totalMinutes - Double(minutes)) * 60)

        return "\(minutes) min \(seconds) sec / km"
    }

    // Calculate calories burned based on distance, time, and estimated MET value
        func calculateCaloriesBurned(weightKg: Double = 70.0) -> Double {
            let averageSpeedKmH = (calculateAverageSpeed(for: track) ?? 0) * 3.6
            
            // MET values based on speed (rough estimates)
            let met: Double
            switch averageSpeedKmH {
                case 0..<4: met = 2.0    // Very slow walk
                case 4..<6: met = 3.5    // Walking
                case 6..<8: met = 5.0    // Fast walk
                case 8..<10: met = 7.0   // Slow jog
                case 10..<12: met = 9.0  // Jogging
                case 12..<14: met = 11.0 // Running
                default: met = 13.0      // Fast running
            }
            
            // Calorie calculation formula: MET * weight(kg) * time(hours)
            let activeTime = calculateActiveDuration() / 3600 // Convert seconds to hours
            let calories = met * weightKg * activeTime
            
            return calories
        }
        
        // Estimate steps based on distance and stride length
        func calculateSteps(strideLength: Double = 0.75) -> Int {
            let totalDistance = calculateTotalDistance()
            return Int(totalDistance / strideLength)
        }
        
        // Calculate highest speed achieved over any 10-second interval
        func calculateHighestSpeed() -> Double? {
            guard track.count > 1 else { return nil }
            
            let intervalDuration: TimeInterval = 10 // 10 seconds interval
            var highestSpeed: Double = 0
            
            for i in 0..<track.count {
                let currentLocation = track[i]
                let relevantLocations = track.filter {
                    abs($0.timestamp.timeIntervalSince(currentLocation.timestamp)) <= intervalDuration
                }
                
                if relevantLocations.count > 1 {
                    let distances = relevantLocations.map { currentLocation.distance(from: $0) }
                    let maxDistance = distances.max() ?? 0
                    let speed = maxDistance / intervalDuration // meters per second
                    highestSpeed = max(highestSpeed, speed)
                }
            }
            
            return highestSpeed > 0 ? highestSpeed : nil
        }
        
        // Calculate elevation gain and loss
        func calculateElevationStats() -> (gain: Double, loss: Double) {
            var totalGain: Double = 0
            var totalLoss: Double = 0
            
            guard track.count > 1 else { return (0, 0) }
            
            for i in 1..<track.count {
                let elevationDiff = track[i].altitude - track[i-1].altitude
                if elevationDiff > 0 {
                    totalGain += elevationDiff
                } else {
                    totalLoss += abs(elevationDiff)
                }
            }
            
            return (totalGain, totalLoss)
        }
        
        // Calculate average pace for each kilometer
    func calculateKilometerSplits() -> [(kilometer: Int, pace: String)] {
        guard track.count > 1 else { return [] }
        
        var splits: [(kilometer: Int, pace: String)] = []
        // var currentDistance: Double = 0
        var lastKilometerTime: Date = track.first!.timestamp
        var lastKilometerIndex = 0
        
        // Precompute cumulative distances
        var cumulativeDistances: [Double] = [0]
        for i in 1..<track.count {
            let distance = track[i - 1].distance(from: track[i])
            cumulativeDistances.append(cumulativeDistances.last! + distance)
        }
        
        for i in 1..<track.count {
            let distanceFromStart = cumulativeDistances[i]
            let currentKilometer = Int(distanceFromStart / 1000)
            
            // Check if we've completed a new kilometer
            if currentKilometer > lastKilometerIndex {
                let splitTime = track[i].timestamp.timeIntervalSince(lastKilometerTime)
                let paceMinutes = Int(splitTime / 60)
                let paceSeconds = Int(splitTime.truncatingRemainder(dividingBy: 60))
                let paceString = String(format: "%d:%02d min/km", paceMinutes, paceSeconds)
                
                splits.append((kilometer: lastKilometerIndex + 1, pace: paceString))
                
                lastKilometerIndex = currentKilometer
                lastKilometerTime = track[i].timestamp
            }
        }
        
        return splits
    }

        
        // Calculate workout intensity zones based on speed
        func calculateIntensityZones() -> [String: TimeInterval] {
            var zones: [String: TimeInterval] = [
                "Easy": 0,
                "Moderate": 0,
                "Hard": 0,
                "Sprint": 0
            ]
            
            guard track.count > 1 else { return zones }
            
            for i in 1..<track.count {
                let distance = track[i-1].distance(from: track[i])
                let time = track[i].timestamp.timeIntervalSince(track[i-1].timestamp)
                let speed = distance / time * 3.6 // Convert to km/h
                
                let duration = track[i].timestamp.timeIntervalSince(track[i-1].timestamp)
                
                switch speed {
                    case 0..<6: zones["Easy"]! += duration
                    case 6..<10: zones["Moderate"]! += duration
                    case 10..<14: zones["Hard"]! += duration
                    default: zones["Sprint"]! += duration
                }
            }
            
            return zones
        }


}

extension LocationViewModel {
    func exportToGPX() -> URL? {
        let gpxHeader = """
        <?xml version="1.0" encoding="UTF-8"?>
        <gpx version="1.1" creator="map-project" xmlns="http://www.topografix.com/GPX/1/1">
        """
        
        let trackSegment = track.map { location in
            """
            <trkpt lat="\(location.coordinate.latitude)" lon="\(location.coordinate.longitude)">
                <ele>\(location.altitude)</ele>
                <time>\(ISO8601DateFormatter().string(from: location.timestamp))</time>
            </trkpt>
            """
        }.joined(separator: "\n")
        
        let checkpointsSegment = checkpoints.map { checkpoint in
            """
            <wpt lat="\(checkpoint.location.coordinate.latitude)" lon="\(checkpoint.location.coordinate.longitude)">
                <name>\(checkpoint.type.rawValue)</name>
                <time>\(ISO8601DateFormatter().string(from: checkpoint.location.timestamp))</time>
            </wpt>
            """
        }.joined(separator: "\n")
        
        let gpxFooter = """
        </gpx>
        """
        
        let gpxContent = """
        \(gpxHeader)
        <trk>
            <name>Exported Track</name>
            <trkseg>
                \(trackSegment)
            </trkseg>
        </trk>
        \(checkpointsSegment)
        \(gpxFooter)
        """
        
        let tempDirectory = FileManager.default.temporaryDirectory
        let gpxFileURL = tempDirectory.appendingPathComponent("track_and_checkpoints.gpx")

        do {
            try gpxContent.write(to: gpxFileURL, atomically: true, encoding: String.Encoding.utf8)
            return gpxFileURL
        } catch {
            print("Error saving GPX file: \(error)")
            return nil
        }
    }
}
