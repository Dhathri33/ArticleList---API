# 📰 ArticleList iOS App

An iOS app built using **Swift**, demonstrating the latest concurrency patterns (`async/await`) along with a clean **MVVMC (Model–View–ViewModel–Coordinator)** architecture.

---

## 🚀 Features

- Fetches and displays a list of articles from a remote API
- Supports **search filtering** (author, description, etc.)
- Pull-to-refresh for updated data
- Handles both **articles** and **countries** with separate view models
- Graceful error handling and user-friendly alerts
- Image loading with Swift concurrency (`async/await`)
- Clean separation of concerns with MVVMC
- **Tab Bar Controller** for switching between multiple modules (e.g., Articles and Countries)

---

## 🏗️ Architecture

This project is structured using **MVVMC**:

- **Model** → Defines app data structures (`ArticleDetails`, `Country`, etc.).
- **View** → UIKit-based UI (`ArticleViewController`, `ArticleTableCell`, etc.).
- **ViewModel** → Business logic, parsing, filtering, and state management (`ArticleViewModel`, `CountryViewModel`).
- **Coordinator** → Handles navigation flow between screens.
- **Controller** → Manages UIKit lifecycle and connects Views with ViewModels.

Additionally, the app uses a **UITabBarController** to organize major sections of the app (Articles & Countries) for a clean and intuitive user experience.

---

## ⚡ Concurrency with Async/Await

The project leverages Swift’s modern concurrency model:

- **Networking**:
  ```swift
  let (data, _) = try await URLSession.shared.data(from: serverURL)
<img width="975" height="581" alt="image" src="https://github.com/user-attachments/assets/cabd3386-7462-4267-8190-5f319fdfddde" />
<img width="903" height="520" alt="image" src="https://github.com/user-attachments/assets/e1c7f8ea-eb64-43fd-9cc3-1c615d9646ac" />
<img width="859" height="416" alt="image" src="https://github.com/user-attachments/assets/7d2807dc-46c2-49f0-b17b-0fcf02d86476" />


