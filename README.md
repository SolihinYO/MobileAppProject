# 📱 TaskifyU – Student Task Management Mobile Application

## 📌 Application Domain
**Productivity / Utilities**

---

## 1. Introduction

University students often struggle to manage assignments, deadlines, and daily academic tasks efficiently due to tight schedules and poor organization. Many existing task management applications are either overly complex or not specifically designed for student productivity.

TaskifyU is a simple hybrid mobile application developed to help students plan, organize, and track their academic tasks effectively. The application focuses on usability, clean user interface design, and essential productivity features. TaskifyU is built using Flutter and Firebase, allowing users to manage tasks anytime and anywhere through a mobile or web-based platform.

---

## 2. Problem Statement

University students often face difficulties in managing multiple academic tasks and deadlines simultaneously. The lack of simple, student-focused task management tools leads to poor organization, missed deadlines, and reduced productivity. Therefore, there is a need for a lightweight and user-friendly task management application that is specifically tailored to students’ academic needs.

---

## 3. Project Objectives

The objectives of this project are:

- To help students manage academic tasks and deadlines efficiently  
- To provide a simple and user-friendly task tracking system  
- To demonstrate hybrid mobile/web application development using Flutter  
- To integrate Firebase services for authentication and cloud-based data storage  

---

## 4. Target Users

The target users of TaskifyU include:

- University students  
- College students  
- Individuals who require simple and effective task planning  

---

## 5. Features and Functionalities

### 5.1 Core Features

- User registration and login using Firebase Authentication  
- Add new tasks with title, description, due date, and priority  
- Edit and delete existing tasks  
- Mark tasks as completed  
- View task list categorized by task status (Pending / Completed)  

### 5.2 Optional Enhancements

- Task filtering by priority or due date  
- Simple dashboard displaying task summary (total, completed, pending tasks)  

---

## 6. Proposed UI Screens

- **Login Page**  
  Allows users to log in using email and password.

- **Register Page**  
  Enables new users to create an account.

- **Task List (Home Dashboard)**  
  Displays all tasks created by the user with task status.

- **Add / Edit Task Form**  
  Allows users to create or update task details.

---

## 7. Architecture and Technical Design

TaskifyU follows a client–cloud architecture model. The Flutter application handles the user interface and user interactions. Firebase Authentication manages user login and registration. Cloud Firestore is used to store and retrieve task data in real time.

---

## 8. Technology Stack

- **Framework:** Flutter  
- **Platform:** Hybrid Mobile / Web (Google Chrome & Mobile)  
- **State Management:** Provider  
- **Navigation:** Named Routes (`Navigator.pushNamed`)  
- **Authentication:** Firebase Authentication (Email & Password)  
- **Database:** Cloud Firestore  

---

## 9. Data Model

### Collection: `users`

| Field | Type |
|------|------|
| uid | String |
| email | String |
| createdAt | Timestamp |

### Collection: `tasks`

| Field | Type |
|------|------|
| title | String |
| description | String |
| dueDate | Timestamp |
| priority | String |
| isCompleted | Boolean |
| userId | String |

---

## 10. User Flow (Sequence Explanation)

1. User launches the application  
2. User registers or logs into the system  
3. User is redirected to the task dashboard  
4. User adds a new task  
5. Task data is stored in Cloud Firestore  
6. Task list updates in real time  
7. User can edit, complete, or delete tasks  

---

## 11. References

- Flutter Official Documentation  
- Firebase Authentication Documentation  
- Cloud Firestore Documentation  
- Material Design Guidelines  

---
