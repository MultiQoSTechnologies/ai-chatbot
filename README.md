
# ai_chatbot

This project is a single-page Flutter application that integrates with the Gemini API from Google
Generative AI to provide a chat interface. The application allows users to interact with the Gemini
model and supports text and image prompts. It also includes features for loading indicators, image
selection, and markdown rendering.

## Features

- Chat Interface: Communicate with the Gemini API using text inputs.
- Image Prompt Support: Select images from the camera or gallery and send them as part of the chat.
- Markdown Rendering: Display chat messages with markdown formatting.
- Loading Indicators: Show progress while waiting for API responses.
- Overlay Loader: Full-screen loading indicators for long-running operations.

- Time Formatting: Display timestamps for chat messages using the intl package.
- This project is a starting point for a Flutter application.
- A few resources to get you started if this is your first Flutter project:


<div style="display: flex; justify-content: space-between;"> 
  <img src="https://github.com/user-attachments/assets/e149c0a4-0520-431e-a78a-8634559fce62" alt="Screenshot 2" width="30%" />
  <img src="https://github.com/user-attachments/assets/7daea479-1be2-466e-968d-b02cada6a5e5" alt="Screenshot 1" width="30%" />
  <img src="https://github.com/user-attachments/assets/b5a9965c-f279-48e3-bf4f-58836df25be4" alt="Screenshot 3" width="30%" />
</div> 


## *Libraries Used*

## 1. google_generative_ai
Integrates with the Google Generative AI Gemini API.
Used for sending chat messages and receiving responses.

## 2. image_picker
Allows users to pick images from the camera or gallery.
Used for sending image prompts to the Gemini API.

## 3. loading_indicator
Provides customizable loading animations.
Used for showing progress indicators during API requests.

## 4. flutter_overlay_loader
Displays a full-screen loading overlay.
Used for long-running operations like image processing.

## 5. intl
Provides internationalization and date formatting support.
Used for formatting timestamps in the chat.

## 6. flutter_markdown
Renders markdown text in Flutter applications.
Used for displaying formatted chat messages.


