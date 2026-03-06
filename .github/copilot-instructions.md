# Copilot Instructions — rufus10411

## Project Overview
FRC Team 10411 robot ("Rufus") — 2026 season.
Java, WPILib 2026.1.1, CTRE Phoenix 6, ChoreoLib, AdvantageKit.

## Robot Connection
- **Deploy IP:** `10.104.11.2` (non-standard, hardcoded in `build.gradle`)
- **Deploy command:** `./gradlew deploy`
- **CANivore bus name:** `main` (swerve drive motors)
- **RoboRIO bus name:** `rio` (all other motors)

## Subsystems & Motors

| Subsystem | Motor | CAN ID | Bus | Inversion |
|---|---|---|---|---|
| Intake | Pivot | 20 | rio | CounterClockwise_Positive |
| Intake | Rollers | 22 | rio | Clockwise_Positive |
| Floor | — | 15 | rio | CounterClockwise_Positive |
| Feeder | — | 19 | rio | Clockwise_Positive |
| Shooter | Left | 21 | rio | CounterClockwise_Positive |
| Shooter | Middle | 16 | rio | CounterClockwise_Positive |
| Shooter | Right | 18 | rio | Clockwise_Positive |
| Hanger | — | 14 | rio | Clockwise_Positive |

Hood uses PWM servos: Left = port 3, Right = port 4.
Swerve drive motors are configured in `TunerConstants.java` on the `main` CANivore bus.

## Controller Bindings (Driver — port 0)

| Input | Action |
|---|---|
| Left Stick | Drive (field-centric) |
| Right Stick X | Rotate |
| Right Trigger | Aim at hub + auto-shoot when ready |
| Right Bumper | Spin up to dashboard RPM + feed when ≥3500 RPM |
| Left Trigger | Deploy intake and run rollers |
| Left Bumper | Stow intake pivot |
| A | Lock heading 180° (toward opponent wall) |
| B | Lock heading 90° CW (right) |
| X | Lock heading 90° CCW (left) |
| Y | Lock heading 0° (toward own wall) |
| Back | Re-zero field-centric orientation |
| D-Pad Up | Hanger to HANGING position |
| D-Pad Down | Hanger to HUNG position |
| D-Pad Left | Reverse floor + shooter (jam clear, hold) |

## Shooter Notes
- Feed threshold: **3500 RPM** — floor/feeder only start once shooter crosses this
- Overshoot factor: **1.15×** — motors are commanded 15% above target to overcome bus voltage sag
- `PeakReverseVoltage` is set to `-12V` to allow reverse
- KI = 2 with velocity voltage control — watch for windup at high targets
- Supply voltage per motor is published to SmartDashboard for diagnosing sag

## Test Mode
- Homing (intake pivot, hanger) is suppressed in test mode
- Swerve `seedFieldCentric()` and operator perspective setup are suppressed in test mode

## Logging (AdvantageKit)
- Logs saved to `/home/lvuser/logs/` on roboRIO as `.wpilog`
- Also published live via NT4 (visible in AdvantageScope when connected)
- Retrieve after session: `sftp lvuser@10.104.11.2:/home/lvuser/logs/*.wpilog .`
- Open in AdvantageScope for timeline analysis

## Key Conventions
- All subsystems use `SmartDashboard.putData(this)` for Shuffleboard visibility
- Hanger homing uses `kCancelSelf` — any position command will interrupt it
- `Robot` extends `LoggedRobot` (AdvantageKit), not `TimedRobot`
- Shooter default command calls `stop()` so explicit stop calls in `end()` are not needed
