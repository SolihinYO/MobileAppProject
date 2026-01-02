# TaskifyU – Student Task Management Mobile Application
Introduction

University students often face difficulties in managing academic assignments, deadlines, and daily tasks due to tight schedules and poor task organization. While many task management applications exist, they are often overly complex or not specifically designed to meet students’ academic productivity needs.

TaskifyU is a simple hybrid mobile application designed to help students plan, organize, and track their academic tasks efficiently. The application focuses on usability, a clean user interface, and essential productivity features. TaskifyU allows users to manage tasks anytime and anywhere using a mobile or web-based platform built with Flutter and Firebase technologies.

Objectives

To help students manage academic tasks and deadlines efficiently
To provide a simple and user-friendly task tracking system
To demonstrate hybrid mobile/web app development using Flutter Web
To integrate Firebase services for authentication and data storage

Target Users

University students
College students
Any individual who needs simple task planning

Features & Functionalities

Core Features

User Registration & Login (Firebase Authentication)
Add New Tasks (title, description, due date, priority)
Edit & Delete Tasks
Mark Tasks as Completed
Task List View (Pending / Completed)

Optional Enhancement

Task filter by priority or deadline
Simple dashboard (task count summary)

Proposed UI Screens

Login Page
Register Page
Task List (Home Dashboard)
Add / Edit Task Form

Architecture and Technical Design

Framework - Flutter Web (Runs on Google Chrome only)
State Management - setState or Provider
Navigation - Named routes (Navigator.pushNamed)

Firebase Integration 

- Firebase Authentication (Email & Password)
- Cloud Firestore (Task data storage)

Collection: users
Field	Type
uid	String
email	String
createdAt	Timestamp

Collection: tasks
Field	Type
title	String
description	String
dueDate	Timestamp
priority	String
isCompleted	Boolean
userId	String

User Flow (Simple)

User registers / logs in
User lands on task dashboard
User adds a new task
Tasks are saved to Firestore
User updates task status

