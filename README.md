# Admit

An iOS app that helps users control their screen time by forcing them to message their friends when exceeding usage limits on select apps.

## Features

- Create app usage restrictions with customizable time limits
- Set cooldown periods (5-15 minutes) for bypassing restrictions
- View, edit, and delete existing restrictions
- Persistent storage of user preferences between app sessions

## Implementation Details

### Data Model

The app uses a `Restriction` model to represent app usage restrictions:

- **appName**: Name of the app to restrict
- **timeLimit**: Daily time limit in minutes
- **cooldownTime**: Additional time granted after sending a message (5-15 minutes)
- **usedTime**: Tracking time used in minutes
- **inCooldown**: Flag indicating if the app is in cooldown mode

### Storage Mechanism

Restrictions are persisted using `UserDefaults` with JSON encoding/decoding to ensure data is preserved between app sessions. The implementation:

1. Encodes restriction objects to JSON data
2. Stores the encoded data in UserDefaults
3. Retrieves and decodes the data when the app launches

### View Architecture

The app follows the MVVM (Model-View-ViewModel) architecture:

- **Models**: Data structures representing restrictions
- **Views**: UI components for creating and managing restrictions
- **ViewModels**: Manages state and business logic, connecting views to models

## Future Enhancements

- Implement app usage tracking
- Create blocking screen for exceeded time limits
- Add contact selection and messaging workflow
