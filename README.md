# Teacher's Pet

**Created By:** \
Ashley Valdez (macintAsh1984) \
Roshini Pothapragada (rpothapr) \
Sai Chamarty (SaiChamarty) \
Sukhpreet Aulakh (Sukhpreet0927) \
Toniya Patil (tbpatil)

# About Teacher’s Pet
---

Teacher's Pet is a multi-platorm app aimed at streamlining the office hours process for students and instructors in an effective, efficient manner. We were inspired by our own experiences in office hours as students, forgetting our places in line, being in office hours with a packed house and never receiving help.

Don't believe us? Here are some students crowding around our professor to ask him questions:

![IMG_4535-2](https://github.com/macintAsh1984/TeachersPet/assets/84110959/a228ca2a-da37-4a9e-8a7a-fc7d6fea5c86)

# Technical Stack
---

## Frameworks

Teacher’s Pet utilizes the following technologies:

| |  |
| --- | --- |
| Programming Language | Swift |
| Frameworks/Libraries | SwiftUI, ActivityKit, WidgetKit, Firebase, CoreImage, CodeScanner|
| Prototyping | Figma |

# User Flows
---

Teacher’s Pet comprises for two main views the **Student View** and the **Instructor View**. The **Student View** is where users can register for Teacher’s Pet as a student, join their class, and join the office hours line. The **Instructor View** is where users can register as instructors (which encompasses teachers, professors, teaching assistants (TAs), and learning assistants (LAs)), create classes for their students to join, and set up their upcoming office hours sessions.

## Student View User Flow
![Untitled](https://github.com/macintAsh1984/TeachersPet/assets/84110959/fb2fdc88-3a85-46e6-b682-ee8e30caaa14)

## Instructor View User Flow
![Untitled 1](https://github.com/macintAsh1984/TeachersPet/assets/84110959/ac223514-d8af-4fe7-9321-45a67fd45362)


# Features
Teacher's Pet contains the following features for students and instructors.

##For Students
- One-time process for joining a class for Office Hours via QR Code Scanning.
- Live Office Hours line and students can join and leave with their position in lines being updated in real time.
- Live Activity displaying a student's place in line that updates as they move up in line.

##For Instructors
- One-time process for creating a class for students to join Office Hours that includes a generated QR code and 5-digit join code.
- Visual view of students in Office Hours line with options to remove specific students from the line and remove all students from line when Office Hours ends.

# User Flow Walkthrough

## Creating And Joining Classes on Teacher's Pet
1. An instructor creates an account on Teacher's Pet.
2. Instructors are then directed to type in the name of their course. Once that is complete, Teacher's Pet will generate a QR Code and 5-digit join code for instructors to give to their students to join their Teacher's Pet class.
3. Instructors will be taken to their dashboard which displays the classes they have created.
4. Students can then create an account with Teacher's Pet and either scan the QR Code or enter the provided join code to join their instructor's class.
5. Students will be taken to their dashboard which displays the classes they have joined.

## Managing The Office Hours Line

### Students
1. From the dashboard, students can tap into their class, fill out the Office Hours questionnaire, and join the Office Hours Line.
2. Once students join the line, they are taken to page that displays their position in line. A Live Activity with their position number also starts in the background.
3. Student can leave the Office Hours line whenever they wish from the same page that displays their position in line.
4. Once a student leaves the line, the line position numbers of any remaining students in line update. For a student that is first in line, Teacher's Pet will tell the student they are "Up Next" instead of displaying the number one.

### Instructors
5. From the dashboard, instructors can tap into their class, and see a list of students waiting in their Office Hours.
6. Instructors can remove specific students in line. For instance, if they have already helped the first person in line, instructors can remove them to update the remaining students' positions in line and help the next student.
7. When Office Hours have ended for the day, instructors can press the **End Office Hours** button to remove all students from the line.
