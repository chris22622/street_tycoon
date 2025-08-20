# Street Tycoon™
## Criminal Empire Simulation Game

**Copyright © 2025 Chrissano Leslie. All Rights Reserved.**

---

### 🎮 **Game Overview**
Street Tycoon is a comprehensive criminal empire simulation game built with Flutter. Manage your criminal organization across 9 different operational areas including drug trafficking, gang warfare, heist operations, bribery networks, and asset management.

**⚠️ FICTIONAL CONTENT DISCLAIMER:** This game features entirely fictional gangs, organizations, and scenarios. All names including "Blue Wolves," "Red Serpents," "Golden Eagles Empire," and similar organizations are completely fictional and created for entertainment purposes only. No real-world criminal organizations are depicted or referenced.

### 🏆 **Key Features**
- **Market Trading** - Buy and sell contraband across multiple cities with dynamic pricing
- **Gang Warfare** - Control territories with fictional characters and strategic operations
- **Heist Operations** - Execute high-risk bank robberies and federal reserve jobs
- **Asset Management** - Build a fleet of vehicles, properties, and luxury items
- **Bribery Networks** - Corrupt law enforcement and government officials
- **Banking System** - Secure your wealth with interest-earning deposits (0.1% daily)
- **Federal Investigations** - Navigate law enforcement pressure and heat management
- **Prison Operations** - Manage incarceration risks and escape planning
- **Interstate Operations** - Expand your empire across state lines with master criminal status

### 🎯 **Game Mechanics**
- **Dynamic Market System** - Prices fluctuate based on supply, demand, and law enforcement
- **Heat Management** - Actions increase police attention, requiring strategic cooling-off periods
- **Net Worth Goals** - Achieve victory by building a $1M+ criminal empire within time limits
- **Risk vs Reward** - Balance profit opportunities against law enforcement risks
- **Character Progression** - Recruit gang members, corrupt officials, and build your organization

### 🛡️ **Copyright Notice**
```
Street Tycoon™ - Criminal Empire Simulation
Copyright (c) 2025 Chrissano Leslie
All Rights Reserved

This game and its source code are proprietary software.
No license is granted for use, modification, or distribution.
Commercial use, copying, or distribution without written 
permission is strictly prohibited.
```

### ⚠️ **IMPORTANT DISCLAIMER**
**This app is a fictional simulation for entertainment purposes only.** All names, prices, events, and mechanics are completely invented and bear no relation to reality. **DO NOT use this app for real-world guidance of any kind.** This is a game, not reality. All content is fictional and for entertainment only.

### 📝 **Legal Protection**
- **Proprietary Software** - All rights reserved under copyright law
- **Trademark Protected** - Street Tycoon™ is a trademark of Chrissano Leslie
- **No Open Source License** - This is not open source software
- **Educational Viewing Only** - Code viewing permitted for educational purposes only

### 🚨 **Usage Restrictions**
- ❌ No copying, modification, or distribution
- ❌ No commercial use without permission
- ❌ No reverse engineering or decompilation
- ❌ No creation of derivative works
- ✅ Educational/reference viewing only

## 📸 **Screenshots & Gameplay**

### Market Trading Interface
*Dynamic pricing system with real-time market fluctuations*
![Market Trading](screenshots/market_trading.png)

### Gang Warfare Operations  
*Control territories with fictional organizations across multiple states*
![Gang Warfare](screenshots/gang_warfare.png)

### Heat Management System
*Navigate law enforcement pressure and federal investigations*
![Heat System](screenshots/heat_management.png)

### Asset Management
*Build your criminal empire with luxury vehicles and properties*
![Assets](screenshots/asset_management.png)

### Banking & Finance
*Secure wealth management with interest-earning deposits*
![Banking](screenshots/banking_system.png)

*Screenshots coming soon - Game is fully functional and ready to play!*

## 🎮 **Quick Start**

### Prerequisites

- Flutter SDK (3.10.0 or later)
- Android SDK
- Android Studio or VS Code with Flutter extensions

### Installation

1. Clone or download the project
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## 🏗️ **Building for Release**

### Debug APK (Development)
```bash
flutter build apk --debug
```
*Output: `build/app/outputs/flutter-apk/app-debug.apk`*

### Release APK (Production)
```bash
flutter build apk --release
```
*Output: `build/app/outputs/flutter-apk/app-release.apk`*

### Windows Desktop
```bash
flutter build windows --release
```
*Output: `build/windows/runner/Release/`*

### 📱 **Download & Play**
- **Latest Release APK**: [Download from Releases](../../releases)
- **System Requirements**: Android 5.0+ or Windows 10+
- **File Size**: ~50MB
- **No Permissions Required**: Offline gameplay

## 🧪 **Testing & Quality**

### Automated Testing
```bash
flutter test
```

### Code Analysis
```bash
flutter analyze
```

### Key Test Coverage
- ✅ Market price calculations and fluctuations
- ✅ Heat system and law enforcement mechanics  
- ✅ Net worth calculations with current market prices
- ✅ Gang territory management and fictional organizations
- ✅ Banking system with realistic interest rates
   storePassword=<password from previous step>
   keyPassword=<password from previous step>
   keyAlias=upload
   storeFile=../upload-keystore.jks
   ```

3. Build release APK:
   ```bash
   flutter build apk --release
   ```

The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

## Game Mechanics

### Core Loop
1. **Buy/Sell** - Trade items across different areas
2. **Travel** - Move between areas with different price modifiers
3. **Manage Heat** - Keep a low profile to avoid law enforcement
4. **Upgrades** - Improve capacity, heat management, and legal defense
5. **End Day** - Progress time, process events, update prices

### Risk Management
- **Heat Level** - Increases with activity, attracts law enforcement
- **Law Enforcement** - Random encounters based on heat level
- **Court System** - Conviction chances, bail, sentencing
- **Incarceration** - Time skips, asset confiscation, heat reduction

### Win Conditions
- Reach target net worth within the time limit
- Avoid extended incarceration
- Manage risk vs. reward effectively

## Technical Details

### Architecture
- **State Management**: Riverpod
- **Charts**: FL Chart
- **Storage**: SharedPreferences with JSON serialization
- **Navigation**: GoRouter
- **UI**: Material 3 design system

### Key Services
- `PriceEngine` - Dynamic pricing with trends and volatility
- `HeatService` - Risk level calculations
- `EnforcementService` - Law enforcement simulation
- `UpgradeService` - Player progression systems
- `BankService` - Financial management

## Troubleshooting

### Flutter Doctor Issues
```bash
flutter doctor
```
Resolve any issues shown before building.

### Gradle Issues
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Build Issues
- Ensure Android SDK is properly installed
- Check that `key.properties` is correctly configured for release builds
- Verify minimum SDK version compatibility

### 📧 **Contact**
For licensing inquiries, permissions, or business opportunities:
- **Developer**: Chrissano Leslie
- **Project**: Street Tycoon™ Criminal Empire Simulation
- **Repository**: https://github.com/chris22622/street_tycoon

### ⚖️ **Legal Notice**
Unauthorized use, reproduction, or distribution of this software or any portion thereof may result in severe civil and criminal penalties, and will be prosecuted to the fullest extent under the law.

---

**Street Tycoon™ © 2025 Chrissano Leslie - All Rights Reserved**
├── data/           # Models, storage, constants
├── logic/          # Game mechanics, services
├── ui/             # Screens and widgets
├── theme/          # App theming
├── util/           # Utilities and formatters
└── providers.dart  # State management setup
```

### Adding Features
1. Define data models in `data/models.dart`
2. Implement logic in appropriate service files
3. Create UI components in `ui/widgets/`
4. Wire up with Riverpod providers

## License

This project is for educational and entertainment purposes only. All content is fictional.

## Support

This is a fictional simulation game. For technical issues with the Flutter app, check the standard Flutter documentation and resources.
