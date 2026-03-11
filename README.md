# LMS-Spike

A relatively simple, modern Ruby on Rails application designed as a "spike" for a Learning Management System (LMS). It allows instructors to create structured lessons with rich-text content, interactive surveys, and memory match games.

## Key Features

- **Lesson Management**: Organize educational content into lessons and pages.
- **Rich Text Support**: Integrated Trix editor (via Action Text) for content creation.
- **Interactive Surveys**: Multiple-choice questions with real-time aggregated results for instructors.
- **Gamified Learning**: A built-in "Social Wellbeing" memory match game to reinforce learning concepts.
- **Dual View Modes**: 
  - **Instructor Mode**: Full CRUD access to lessons, pages, and games (protected by Devise).
  - **Student Mode**: Read-only, focused view for consuming content and taking surveys.
- **QR Code Integration**: Automatically generate QR codes for quick student access to specific lessons or the index.
- **Modern UI**: Fully responsive design with a clean, card-based layout.
- **Analytics**: Anonymous tracking of student interactions with game modules.

## Getting Started

### Prerequisites

- Ruby version: 3.2.0 or higher
- Rails version: 7.2 or higher
- PostgreSQL

### Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/your-repo/lms-spike.git
    cd lms-spike
    ```

2.  **Install dependencies**:
    ```bash
    bundle install
    ```

3.  **Database Setup**:
    ```bash
    rails db:create
    rails db:migrate
    ```

4.  **Seed Data**:
    Populate the database with a default instructor account and sample lessons:
    ```bash
    rails db:seed
    ```
    *Default credentials:* `instructor@example.com` / `password123`

5.  **Start the Server**:
    ```bash
    bin/dev # or rails s
    ```

## Running Tests

We use Minitest for both model and integration testing.

```bash
rails test
```

## Deployment

This project is configured for deployment on [Render](https://render.com/). It includes a `render.yaml` and a `bin/render-build.sh` script to handle asset precompilation and migrations automatically.

## Contributing

We welcome contributions from the community! To ensure a smooth process, please follow these standard open-source guidelines:

1.  **Fork the repository** on GitHub.
2.  **Create a new branch** for your feature or bug fix: `git checkout -b feature/your-feature-name`.
3.  **Implement your changes** and follow the existing code style (standard Rails conventions).
4.  **Write tests** for any new functionality or bug fixes.
5.  **Ensure all tests pass**: `rails test`.
6.  **Commit your changes** with a clear, descriptive message.
7.  **Push to your fork** and **submit a Pull Request**.

### Code of Conduct

Please be respectful and professional in all communications. We aim to foster an inclusive and welcoming environment for everyone.

## License

This project is open-source and available under the [MIT License](LICENSE).
