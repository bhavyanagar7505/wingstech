# Taskify – Real-time Task Management App

Flutter practical assignment for **Wings Tech Solutions Pvt Ltd**

---

## 📌 Project Overview

**Taskify** is a real-time task management and collaboration mobile application built using **Flutter** and **Firebase**.  
The app allows users to authenticate, create and manage tasks, track progress in real time, and receive notifications.

This project demonstrates:
- Clean Flutter architecture
- Real-time Firestore integration
- Firebase Authentication & Messaging
- State management using GetX

---

## 🛠 Tech Stack

- **Flutter**
- **Firebase Authentication**
- **Cloud Firestore**
- **Firebase Cloud Messaging (FCM)**
- **GetX (State Management & Navigation)**

---

## ✨ Features Implemented

### 1️⃣ Authentication 
- Email & Password Login
- Registration
- Form validation & error handling
- Persisted authentication state
- Logout functionality

---

### 2️⃣ Task Management 
- Create tasks
- Update task status (Pending / In Progress / Completed)
- Delete tasks
- Assign task to logged-in user
- Real-time task list updates
- Dashboard with task statistics:
  - Total tasks
  - Pending tasks
  - In-progress tasks
  - Completed tasks

---

### 3️⃣ Dashboard & Real-time Updates 
- Firestore real-time listeners
- Live dashboard counters
- Instant UI updates on task changes

---

### 4️⃣ Search, Filter & Sorting 
- Search tasks by title (real-time)
- Debounced search (300ms)
- Filter tasks:
  - All
  - Pending
  - Completed
- Sort tasks by:
  - Created date
  - Due date (if available)
  - Priority (if available)

---

### 5️⃣ Notifications (FCM) 
- Firebase Messaging initialized
- Device FCM token generated and stored
- Notifications screen UI
- Foreground notification listener

> Automatic push notifications via Cloud Functions are done.

---

### 6️⃣ Offline Support 
- Firestore offline persistence enabled
- Cached data available when offline

---

## 🔐 Firestore Security Rules

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    match /tasks/{taskId} {
      allow create: if request.auth != null;
      allow read, update, delete: if request.auth != null
        && request.auth.uid == resource.data.assignedTo;
    }
  }
}
