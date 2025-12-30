# MobileAppProject
Introduction

University students often struggle to manage assignments, deadlines, and daily academic tasks efficiently. Many existing tools are either too complex or not tailored for student productivity. TaskifyU is a simple, web-based task management application designed to help students plan, organize, and track their academic tasks effectively. The system focuses on usability, clean UI, and productivity while being fully accessible through a web browser (Google Chrome).

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

Framework - Flutter Web (Runs on Google Chrome only)
State Management - setState or Provider
Navigation - Named routes (Navigator.pushNamed)
Firebase Integration - Firebase Authentication (Email & Password)
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

