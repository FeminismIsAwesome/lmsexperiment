# LMS-Spike: Detailed Review & Future Roadmap

This document provides a comprehensive review of the current `lms-spike` codebase, focusing on accessibility, collaboration, cultural localization, and technical debt. It serves as a roadmap for transitioning the current "spike" into a more robust and inclusive production system.

## 1. Accessibility (a11y)

### Current State
The current interactive elements (Memory Match and Categorize games) primarily use `div` and `span` tags with click listeners. While functional for mouse users, these are not naturally focusable or interactable for screen reader users or those relying on keyboard navigation.

### Recommendations
- **Focusable Elements:** Replace `div`-based cards and category buttons with standard `<button>` tags. This automatically provides keyboard focus (Tab) and accessibility roles.
- **ARIA Attributes:** Implement `aria-live` regions for game status updates (e.g., "Correct!", "Game Over") so screen readers announce changes in real-time.
- **Color Contrast:** Audit the current color palette (green/red feedback) to ensure it meets WCAG 2.1 AA standards for contrast and is distinguishable for color-blind users.
- **Text-to-Speech (TTS):** Add a "Read Aloud" button for Page content and Game items to support students with reading difficulties or visual impairments.

## 2. Collaboration

### Current State
The system is currently single-instructor focused. While `devise` is present, there is no multi-tenancy or shared ownership of lessons.

### Recommendations
- **Multi-Tenancy:** Implement a `School` or `Organization` model to scope lessons and users, allowing multiple instructors to work within the same environment without seeing each other's content.
- **Collaborative Editing:** Add a "Shared with" feature for Lessons, allowing multiple instructors to edit the same lesson.
- **Comment/Feedback Loop:** Allow instructors to leave "internal notes" on pages or games for peer review during content creation.

## 3. Cultural Localization

### Current State
We have implemented `PageTranslation` for multi-language support on content pages. However, Games still rely on a single set of options (defaults or custom).

### Recommendations
- **GameTranslation Model:** Create a `GameTranslation` model similar to `PageTranslation` to allow translating game titles and item labels (e.g., "Fruit" -> "Fruta").
- **Asset Localization:** Allow different image links or audio files per locale to ensure cultural relevance (e.g., using local fruits or region-specific emotional expressions).
- **RTL Support:** Ensure the CSS layout (especially the sidebar and game grids) handles Right-to-Left languages like Arabic or Hebrew correctly.

## 4. Technical Debt & Architecture

### Current State
Game logic is split between models and Stimulus controllers. As we add more game types (Memory Match, Categorize, Emotions), the JS logic is becoming duplicated and harder to maintain.

### Recommendations
- **Game Engine Abstraction:** Refactor Stimulus controllers to use a base `GameController` with shared logic for timers, scoring, and event tracking.
- **JSON Schema Validation:** Use a JSON schema to validate the `options` field in the `Game` model to prevent malformed data from causing runtime errors.
- **Component Library:** Move reusable UI elements (like the "Saving..." indicator or the reorder handle) into `ViewComponents` for consistency across the app.
- **Analytics Granularity:** Instead of just "Completed," track *how long* it took and *how many errors* occurred to help instructors identify which students are struggling with specific concepts.

## 5. Prioritized Roadmap

1. **Phase 1 (Immediate):** Refactor game elements to focusable buttons and add basic ARIA roles.
2. **Phase 2 (Near-term):** Implement `GameTranslation` to match the `PageTranslation` system.
3. **Phase 3 (Medium-term):** Standardize the "Game Engine" frontend architecture.
4. **Phase 4 (Long-term):** Add multi-tenant organizational support.
