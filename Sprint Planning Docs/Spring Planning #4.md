# Sprint Planning #4

**Trello Board**: https://trello.com/b/Do4WCnFy/teachers-pet-🐢

# Project Summary

Teacher's Pet is an app aimed at streamlining the office hours process. The goal of this app is to help instructors best help their students during office hours with ease in an effective, efficient manner. 

# Tasks Completed

**Everyone**
- [Contributed to student office hours line frontend/backend implementation](https://github.com/macintAsh1984/TeachersPet/issues/19).

**Ashley Valdez**
- [Connected student and instructor pages together](https://github.com/macintAsh1984/TeachersPet/issues/18).
    - Includes questionnaire being accessible from the student dashboard
- [Created UI for showing student’s position in the OH line and showing students in the OH line for instructors](https://github.com/macintAsh1984/TeachersPet/commit/bb6a032cc84e434f601eabff748c5d610f7708ab).
- [Fixed issue where students were not being added to the office hours line in Firebase backend](https://github.com/macintAsh1984/TeachersPet/issues/21).
- [Saved TA accounts as a separate Firebase collection under instructors](https://github.com/macintAsh1984/TeachersPet/commit/0cc5154f69787a420d3121a60713b3d6449b365e).

**Roshini Pothapragada**
- [Created UI for questionnaire](https://github.com/macintAsh1984/TeachersPet/issues/18).

**Sai Chamarty**
- [Completed Student Dashboard](https://github.com/macintAsh1984/TeachersPet/commit/de2b46b8e136129bb4bc1ddd12e880bd09e9e6a1).

**Sukhpreet Aulakh**
- Helped implement queue on the student side
- Created student collection under professors for Firebase
- Created TA collection under professors to solve TA problem
- Updated sign-in implementation for students and instructors

**Toniya Patil**
- Implemented Student Sign In - in works.
- [Implemented Students Join Class using QR code](https://github.com/macintAsh1984/TeachersPet/commit/0a57dc94b6777f8d5fa26853f6fb6999376708e3).

# Planned Tasks

## Individual Tasks
**Ashley Valdez**
- [Created Live Activity](https://github.com/macintAsh1984/TeachersPet/issues/22) that displays a student's position in an Office Hours Line in real time.
- Began code cleanup by [refactoring views](https://github.com/macintAsh1984/TeachersPet/commit/bc0e16c82b1c5a1ab382f148e66857b74a2240ae) and [reorganizing view model methods](https://github.com/macintAsh1984/TeachersPet/commit/33e7db358fc204542bd8cd1f89c44a90bf2c7352).
- Bug Fixes
    - [Fixed app navigation issues](https://github.com/macintAsh1984/TeachersPet/commit/c461251fbae05973a396ce0cd711b8f4dc6b4b6d).
    - [Hid QR Code scanning button ](https://github.com/macintAsh1984/TeachersPet/commit/f062a0a85b8e411b5ea700e6bd7e0d5c8729c2e3) on macOS version of Teacher's Pet.

**Sai Chamarty**
- [Fixed the student dashboard to display the course names of a student's enrolled courses](https://github.com/macintAsh1984/TeachersPet/commit/04306aae8771140ecafc3cee0004daa9a97509ec).
- Implement office hours set up for professors.
- Working on training an ML model for grouping students based on similar questions.

**Toniya Patil**
- [Implemented loading screen for joining a class as a student](https://github.com/macintAsh1984/TeachersPet/commit/c523d8ecdaca33f2a5a203899efd700f6667e29a).
- Work on the instructor Dashboard and view Students in the queue.
- Creating a logo for the app and refining the UI of the app.

**Sukhpreet Aulakh**
- Have signing in/out of instructor, TA, and student accounts fully functioning.
- Fix an issue where signed in students do not recieve an accurrate line position on the frontend.

**Roshini Pothapragada**
- [Work on removing students from the Office Hours line](https://github.com/macintAsh1984/TeachersPet/commit/9d1013247e32466fb33ced92e40035017ff6d3d2) when the **Leave Line** button is pressed.
