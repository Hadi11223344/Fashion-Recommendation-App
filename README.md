# 👗 Fashion & Hairstyle Recommendation App

An AI-powered mobile app that recommends outfits and hairstyles based on user-uploaded wardrobe items and face shape detection. Built using Flutter, Django, and deep learning models for real-time recommendations.

---

## ✨ Key Features

- 📷 Face detection and face shape classification
- 👕 Upload wardrobe images for personalized outfit suggestions
- ✂️ AI-powered hairstyle recommendations based on face shape
- 🔄 Dynamic recommendations with user feedback (like/dislike)
- 🔐 User authentication via OAuth & email/password
- 🔄 Real-time data sync with Django backend

---

## 🛠 Tech Stack

### Frontend
- Flutter (cross-platform)
- Google ML Kit (for face detection)

### Backend
- Django + Django REST Framework
- PostgreSQL / SQLite (development)
- JWT / OAuth2 Authentication

### AI/ML
- Pre-trained CNN for image embeddings
- K-Means clustering
- Custom CNN model for face shape classification
- Item-based Collaborative Filtering (recommendations)

---

## 📲 Screenshots

> *To be added soon*

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK
- Python 3.10+
- pip + virtualenv

### Setup Flutter App

```bash
git clone https://github.com/Hadi11223344/Fashion-Recommendation-App.git
cd Fashion-Recommendation-App
flutter pub get
flutter run
