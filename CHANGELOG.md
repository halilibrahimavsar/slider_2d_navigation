# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-30

### Added
- Initial release of slider_2d_navigation package
- **DynamicSlider**: Main 2D navigation slider widget
- **Horizontal Navigation**: Smooth sliding between different states (savedMoney, transactions, debt)
- **Vertical Navigation**: Sub-menu carousel for each state with arrow indicators
- **Mini Buttons**: Context-sensitive action buttons with overlay support
- **Smooth Animations**: Cube-like transitions with haptic feedback
- **Slider Models**: `MiniButtonData`, `SubMenuItem`, and `SliderState` enum
- **SliderStateHelper**: Helper functions for state management, colors, icons, and labels
- **SliderConfig**: Configuration constants for styling and animations
- **Full Customization**: Configurable colors, labels, actions, and animation timing
- **Responsive Design**: Adapts to different screen sizes
- **Example Implementation**: Complete example showing all features
- **Documentation**: Comprehensive README with usage examples
- **License**: MIT License for open source use

### Features
- **Touch Gestures**: Horizontal drag for navigation, vertical drag for sub-menu scrolling
- **Programmatic Control**: AnimationController integration for programmatic navigation
- **State Management**: Efficient state tracking and callbacks
- **Visual Feedback**: Hover effects, active states, and smooth transitions
- **Accessibility**: Proper semantic labels and touch target sizes
- **Performance**: Optimized animations and minimal rebuilds