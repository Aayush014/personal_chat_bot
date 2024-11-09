# ZenAI

ZenAI is a powerful AI-driven chat application built with Flutter, utilizing Google’s advanced generative AI model (Gemini API) to create meaningful and insightful conversations. Designed with a sleek dark-themed UI, ZenAI provides a seamless chat experience, allowing users to interact with the AI, save and revisit past conversations, and perform quick actions like copying responses. This project showcases the potential of generative AI in mobile applications with an emphasis on user experience, elegant design, and responsive interactions.

## Table of Contents

- [Features](#features)
- [Screenshots](#screenshots)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
  - [Initiating Conversations](#initiating-conversations)
  - [Storing and Loading Chats](#storing-and-loading-chats)
  - [Copying Responses](#copying-responses)
- [App Structure and Key Components](#app-structure-and-key-components)
- [Dependencies](#dependencies)
- [Contributing](#contributing)
- [License](#license)

## Features

- **AI-Powered Conversations**: Users can input prompts to generate intelligent responses from Google’s Gemini AI.
- **Typewriter Animation**: AI-generated responses appear with a typewriter effect, enhancing readability and user engagement.
- **Chat History Management**: Users can save each chat session, accessible via the drawer for easy reloading of previous conversations.
- **Automatic Sorting**: Saved chats are automatically sorted by date, with the latest conversations at the top.
- **Copy to Clipboard**: Easily copy responses with a tap, ideal for sharing insights or saving specific responses.
- **Dark Theme**: Sleek, dark-themed UI featuring a blend of Cupertino and Material components for an intuitive, cross-platform experience.

## Screenshots

<details> 
  <summary><h2>📸Video</h2></summary>
  <p>
    <table align="center">
  <tr>
    <td><video src="https://github.com/user-attachments/assets/c24416c2-3cd3-48b2-bee2-9c88d2aab07d" width="420" height="315"></video>
  </tr>
    </table>    
  </p>
  </details>

## Getting Started

Follow these steps to get ZenAI up and running on your local environment.

### Prerequisites

- **Flutter SDK**: Make sure you have Flutter installed. Instructions are available on the [Flutter official site](https://flutter.dev).
- **Gemini API Key**: Obtain an API key for Google’s Generative AI model from the Google Cloud Platform. This key will be necessary to enable AI-driven responses in the app.

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Aayush014/personal_chat_bot.git
   cd zenai
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Set Up the API Key**:
   - Open `HomeController` in your code editor.
   - Replace `"YOUR_API_KEY"` with your actual Google API key in the `generateResponse` method.

4. **Run the App**:
   ```bash
   flutter run
   ```

   You can run the app on an emulator or a physical device. Make sure to select a device compatible with Flutter.

## Usage

### Initiating Conversations

1. **Enter a prompt**: Type any question or statement in the input field at the bottom of the screen.
2. **Send the message**: Tap the send button to initiate the AI response generation.
3. **View the response**: AI responses appear in the chat with a typing animation, creating an engaging user experience.

### Storing and Loading Chats

- **Save Conversations**: Tap the add button in the top-right corner of the app bar to store your current conversation. Your conversation will be saved with a timestamp and can be accessed from the drawer.
- **Load Previous Conversations**: Open the drawer by tapping on the menu icon. From there, select a previous conversation to load its responses into the chat window.

### Copying Responses

- To copy any response from the AI, tap the copy icon next to the response. The text will be copied to your clipboard for easy sharing.

## App Structure and Key Components

ZenAI leverages several key Flutter and GetX components for efficient state management and smooth user experience. Here is a brief overview:

- **GetX for State Management**: `HomeController` manages the entire app's state, including user inputs, chat history, and loading states.
- **GenerativeModel (Gemini API)**: Integrated to generate responses to user prompts.
- **CupertinoTextField**: Provides a user-friendly input field with Cupertino styling.
- **MarkdownBody**: Used for rendering formatted text responses in Markdown, making the content visually rich and structured.

## Dependencies

ZenAI uses the following dependencies to power its functionality and design:

- **`get`**: A lightweight state management solution for managing app state and UI updates efficiently.
- **`flutter_markdown`**: Allows AI responses to be rendered as Markdown, making responses more readable and professional-looking.
- **`google_fonts`**: Customizes the app’s typography, enhancing its visual appeal.
- **`google_generative_ai`**: Integrates Google’s Generative AI model (Gemini API) for generating interactive AI responses.

## Contributing

We welcome contributions from the community! If you'd like to contribute:

1. Fork this repository.
2. Create a new branch with your feature or bug fix.
3. Submit a pull request detailing your changes.

## License

This project is licensed under the MIT License. You are free to use, modify, and distribute this project as per the license terms.
