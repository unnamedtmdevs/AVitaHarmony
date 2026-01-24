//
//  WorkoutService.swift
//  AVitaHarmony
//

import Foundation

class WorkoutService {
    static let shared = WorkoutService()
    
    private init() {}
    
    // MARK: - Generate Adaptive Workouts
    func generateWorkouts(for profile: UserProfile) -> [Workout] {
        var workouts: [Workout] = []
        
        // Generate workouts based on fitness level and goals
        switch profile.fitnessGoal {
        case .weightLoss:
            workouts.append(contentsOf: generateWeightLossWorkouts(level: profile.fitnessLevel))
        case .muscleGain:
            workouts.append(contentsOf: generateMuscleGainWorkouts(level: profile.fitnessLevel))
        case .endurance:
            workouts.append(contentsOf: generateEnduranceWorkouts(level: profile.fitnessLevel))
        case .flexibility:
            workouts.append(contentsOf: generateFlexibilityWorkouts(level: profile.fitnessLevel))
        case .general:
            workouts.append(contentsOf: generateGeneralWorkouts(level: profile.fitnessLevel))
        case .stressRelief:
            workouts.append(contentsOf: generateStressReliefWorkouts(level: profile.fitnessLevel))
        }
        
        return workouts
    }
    
    // MARK: - Weight Loss Workouts
    private func generateWeightLossWorkouts(level: FitnessLevel) -> [Workout] {
        let duration = durationForLevel(level)
        let multiplier = multiplierForLevel(level)
        
        return [
            Workout(
                name: "HIIT Fat Burner",
                description: "High-intensity interval training to maximize calorie burn",
                duration: duration,
                difficulty: level,
                category: .hiit,
                exercises: [
                    Exercise(name: "Jumping Jacks", description: "Full body cardio warm-up", duration: 30 * multiplier, instructions: ["Stand with feet together", "Jump while spreading legs and raising arms", "Return to start position"], targetMuscles: ["Full Body"]),
                    Exercise(name: "Burpees", description: "Ultimate fat burning exercise", duration: 30 * multiplier, reps: 10, instructions: ["Start standing", "Drop to plank", "Push up", "Jump up"], targetMuscles: ["Full Body"]),
                    Exercise(name: "Mountain Climbers", description: "Core and cardio combo", duration: 30 * multiplier, instructions: ["Start in plank position", "Alternate bringing knees to chest"], targetMuscles: ["Core", "Legs"]),
                    Exercise(name: "High Knees", description: "Cardio intensity builder", duration: 30 * multiplier, instructions: ["Run in place", "Bring knees to chest level"], targetMuscles: ["Legs", "Cardio"]),
                    Exercise(name: "Rest", description: "Active recovery", duration: 30, instructions: ["Walk in place", "Deep breathing"], targetMuscles: [])
                ],
                caloriesBurned: 300 * multiplier
            ),
            Workout(
                name: "Cardio Blast",
                description: "Steady-state cardio for fat burning",
                duration: duration + 300,
                difficulty: level,
                category: .cardio,
                exercises: [
                    Exercise(name: "Running in Place", description: "Cardio warm-up", duration: 60 * multiplier, instructions: ["Start with light jog", "Increase pace gradually"], targetMuscles: ["Legs"]),
                    Exercise(name: "Jump Rope (or simulated)", description: "Cardio endurance", duration: 120 * multiplier, instructions: ["Jump with both feet", "Maintain steady rhythm"], targetMuscles: ["Legs", "Cardio"]),
                    Exercise(name: "Butt Kicks", description: "Cardio and leg workout", duration: 60 * multiplier, instructions: ["Run in place", "Kick heels to glutes"], targetMuscles: ["Legs"]),
                    Exercise(name: "Skaters", description: "Lateral cardio movement", duration: 60 * multiplier, instructions: ["Leap side to side", "Land on one foot"], targetMuscles: ["Legs", "Core"])
                ],
                caloriesBurned: 250 * multiplier
            )
        ]
    }
    
    // MARK: - Muscle Gain Workouts
    private func generateMuscleGainWorkouts(level: FitnessLevel) -> [Workout] {
        let multiplier = multiplierForLevel(level)
        
        return [
            Workout(
                name: "Upper Body Strength",
                description: "Build muscle in chest, arms, and shoulders",
                duration: 1800,
                difficulty: level,
                category: .strength,
                exercises: [
                    Exercise(name: "Push-ups", description: "Classic chest builder", duration: 60, reps: 15 * multiplier, sets: 3, restTime: 60, instructions: ["Start in plank", "Lower chest to ground", "Push back up"], targetMuscles: ["Chest", "Triceps"]),
                    Exercise(name: "Diamond Push-ups", description: "Tricep focused", duration: 60, reps: 10 * multiplier, sets: 3, restTime: 60, instructions: ["Form diamond with hands", "Perform push-up"], targetMuscles: ["Triceps", "Chest"]),
                    Exercise(name: "Pike Push-ups", description: "Shoulder builder", duration: 60, reps: 12 * multiplier, sets: 3, restTime: 60, instructions: ["Form inverted V", "Lower head to ground"], targetMuscles: ["Shoulders"]),
                    Exercise(name: "Tricep Dips", description: "Arm sculptor", duration: 60, reps: 15 * multiplier, sets: 3, restTime: 60, instructions: ["Use chair or bench", "Lower body down", "Push back up"], targetMuscles: ["Triceps"])
                ],
                caloriesBurned: 200 * multiplier
            ),
            Workout(
                name: "Lower Body Power",
                description: "Leg and glute muscle building",
                duration: 1800,
                difficulty: level,
                category: .strength,
                exercises: [
                    Exercise(name: "Squats", description: "Leg power builder", duration: 60, reps: 20 * multiplier, sets: 4, restTime: 60, instructions: ["Feet shoulder-width", "Lower hips back and down", "Push through heels"], targetMuscles: ["Quads", "Glutes"]),
                    Exercise(name: "Lunges", description: "Single leg strength", duration: 60, reps: 15 * multiplier, sets: 3, restTime: 60, instructions: ["Step forward", "Lower back knee", "Push back to start"], targetMuscles: ["Quads", "Glutes"]),
                    Exercise(name: "Glute Bridges", description: "Glute activation", duration: 60, reps: 20 * multiplier, sets: 3, restTime: 60, instructions: ["Lie on back", "Lift hips up", "Squeeze glutes"], targetMuscles: ["Glutes", "Hamstrings"]),
                    Exercise(name: "Calf Raises", description: "Lower leg strength", duration: 60, reps: 25 * multiplier, sets: 3, restTime: 45, instructions: ["Stand on balls of feet", "Raise heels up", "Lower slowly"], targetMuscles: ["Calves"])
                ],
                caloriesBurned: 220 * multiplier
            )
        ]
    }
    
    // MARK: - Endurance Workouts
    private func generateEnduranceWorkouts(level: FitnessLevel) -> [Workout] {
        let multiplier = multiplierForLevel(level)
        
        return [
            Workout(
                name: "Stamina Builder",
                description: "Increase cardiovascular endurance",
                duration: 2400,
                difficulty: level,
                category: .cardio,
                exercises: [
                    Exercise(name: "Warm-up Jog", description: "Prepare the body", duration: 300, instructions: ["Start with light pace", "Gradually increase intensity"], targetMuscles: ["Cardio"]),
                    Exercise(name: "Steady Run", description: "Build endurance", duration: 900 * multiplier, instructions: ["Maintain consistent pace", "Focus on breathing"], targetMuscles: ["Legs", "Cardio"]),
                    Exercise(name: "Sprint Intervals", description: "Push your limits", duration: 60 * multiplier, sets: 5, restTime: 90, instructions: ["Sprint at max effort", "Rest between intervals"], targetMuscles: ["Legs", "Cardio"]),
                    Exercise(name: "Cool Down", description: "Recovery", duration: 300, instructions: ["Slow to walking pace", "Deep breathing"], targetMuscles: [])
                ],
                caloriesBurned: 400 * multiplier
            )
        ]
    }
    
    // MARK: - Flexibility Workouts
    private func generateFlexibilityWorkouts(level: FitnessLevel) -> [Workout] {
        return [
            Workout(
                name: "Full Body Stretch",
                description: "Improve flexibility and mobility",
                duration: 1200,
                difficulty: level,
                category: .stretching,
                exercises: [
                    Exercise(name: "Neck Rolls", description: "Neck mobility", duration: 60, instructions: ["Slowly roll neck in circles", "Reverse direction"], targetMuscles: ["Neck"]),
                    Exercise(name: "Shoulder Stretch", description: "Upper body flexibility", duration: 90, instructions: ["Pull arm across body", "Hold for 30 seconds each side"], targetMuscles: ["Shoulders"]),
                    Exercise(name: "Forward Fold", description: "Hamstring stretch", duration: 120, instructions: ["Stand and bend forward", "Reach for toes", "Hold position"], targetMuscles: ["Hamstrings", "Back"]),
                    Exercise(name: "Hip Flexor Stretch", description: "Hip mobility", duration: 120, instructions: ["Lunge position", "Push hips forward", "Hold each side"], targetMuscles: ["Hip Flexors"]),
                    Exercise(name: "Quad Stretch", description: "Leg flexibility", duration: 90, instructions: ["Stand on one leg", "Pull foot to glutes", "Hold each side"], targetMuscles: ["Quads"]),
                    Exercise(name: "Butterfly Stretch", description: "Inner thigh stretch", duration: 120, instructions: ["Sit with soles together", "Press knees down", "Lean forward"], targetMuscles: ["Inner Thighs"])
                ],
                caloriesBurned: 80
            ),
            Workout(
                name: "Yoga Flow",
                description: "Dynamic stretching and flexibility",
                duration: 1800,
                difficulty: level,
                category: .yoga,
                exercises: [
                    Exercise(name: "Cat-Cow Stretch", description: "Spine mobility", duration: 120, instructions: ["Start on all fours", "Arch and round back", "Flow with breath"], targetMuscles: ["Spine", "Core"]),
                    Exercise(name: "Downward Dog", description: "Full body stretch", duration: 180, instructions: ["Form inverted V", "Press heels down", "Relax shoulders"], targetMuscles: ["Full Body"]),
                    Exercise(name: "Warrior Pose", description: "Strength and flexibility", duration: 120, instructions: ["Lunge with arms extended", "Hold each side"], targetMuscles: ["Legs", "Core"]),
                    Exercise(name: "Child's Pose", description: "Relaxation stretch", duration: 180, instructions: ["Sit on heels", "Extend arms forward", "Rest forehead on ground"], targetMuscles: ["Back", "Shoulders"])
                ],
                caloriesBurned: 100
            )
        ]
    }
    
    // MARK: - General Workouts
    private func generateGeneralWorkouts(level: FitnessLevel) -> [Workout] {
        let multiplier = multiplierForLevel(level)
        
        return [
            Workout(
                name: "Full Body Workout",
                description: "Balanced routine for overall fitness",
                duration: 1800,
                difficulty: level,
                category: .fullBody,
                exercises: [
                    Exercise(name: "Jumping Jacks", description: "Warm-up", duration: 60, instructions: ["Full body movement", "Increase heart rate"], targetMuscles: ["Full Body"]),
                    Exercise(name: "Push-ups", description: "Upper body", duration: 60, reps: 12 * multiplier, sets: 3, restTime: 45, instructions: ["Standard push-up form"], targetMuscles: ["Chest", "Arms"]),
                    Exercise(name: "Squats", description: "Lower body", duration: 60, reps: 15 * multiplier, sets: 3, restTime: 45, instructions: ["Proper squat form"], targetMuscles: ["Legs"]),
                    Exercise(name: "Plank", description: "Core strength", duration: 45 * multiplier, sets: 3, restTime: 60, instructions: ["Hold plank position", "Keep body straight"], targetMuscles: ["Core"]),
                    Exercise(name: "Burpees", description: "Full body cardio", duration: 60, reps: 10 * multiplier, sets: 2, restTime: 60, instructions: ["Complete burpee cycle"], targetMuscles: ["Full Body"])
                ],
                caloriesBurned: 250 * multiplier
            )
        ]
    }
    
    // MARK: - Stress Relief Workouts
    private func generateStressReliefWorkouts(level: FitnessLevel) -> [Workout] {
        return [
            Workout(
                name: "Relaxing Yoga",
                description: "Gentle movements for stress relief",
                duration: 1800,
                difficulty: level,
                category: .yoga,
                exercises: [
                    Exercise(name: "Deep Breathing", description: "Calm the mind", duration: 180, instructions: ["Inhale deeply for 4 counts", "Hold for 4", "Exhale for 4"], targetMuscles: []),
                    Exercise(name: "Gentle Stretching", description: "Release tension", duration: 300, instructions: ["Slow, gentle movements", "Focus on breathing"], targetMuscles: ["Full Body"]),
                    Exercise(name: "Restorative Poses", description: "Deep relaxation", duration: 600, instructions: ["Hold comfortable positions", "Let go of stress"], targetMuscles: ["Full Body"]),
                    Exercise(name: "Meditation", description: "Mental relaxation", duration: 300, instructions: ["Sit comfortably", "Focus on breath", "Clear your mind"], targetMuscles: [])
                ],
                caloriesBurned: 100
            )
        ]
    }
    
    // MARK: - Helper Methods
    private func durationForLevel(_ level: FitnessLevel) -> Int {
        switch level {
        case .beginner: return 900  // 15 minutes
        case .intermediate: return 1800  // 30 minutes
        case .advanced: return 2700  // 45 minutes
        }
    }
    
    private func multiplierForLevel(_ level: FitnessLevel) -> Int {
        switch level {
        case .beginner: return 1
        case .intermediate: return 2
        case .advanced: return 3
        }
    }
    
    // MARK: - Adapt Workout Based on Performance
    func adaptWorkout(_ workout: Workout, performance: Double) -> Workout {
        var adaptedWorkout = workout
        
        // If performance is high (>0.8), increase difficulty
        if performance > 0.8 {
            adaptedWorkout.exercises = workout.exercises.map { exercise in
                var adapted = exercise
                if let reps = exercise.reps {
                    adapted.reps = Int(Double(reps) * 1.2)
                }
                if let sets = exercise.sets {
                    adapted.sets = min(sets + 1, 5)
                }
                adapted.duration = Int(Double(exercise.duration) * 1.1)
                return adapted
            }
        }
        // If performance is low (<0.5), decrease difficulty
        else if performance < 0.5 {
            adaptedWorkout.exercises = workout.exercises.map { exercise in
                var adapted = exercise
                if let reps = exercise.reps {
                    adapted.reps = Int(Double(reps) * 0.8)
                }
                adapted.duration = Int(Double(exercise.duration) * 0.9)
                return adapted
            }
        }
        
        return adaptedWorkout
    }
    
    // MARK: - Calculate Calories
    func calculateCalories(duration: TimeInterval, weight: Double?, intensity: Double) -> Int {
        let userWeight = weight ?? 70.0 // Default 70kg if not provided
        let hours = duration / 3600.0
        let met = 3.0 + (intensity * 8.0) // MET value based on intensity (3-11)
        return Int(met * userWeight * hours)
    }
}
