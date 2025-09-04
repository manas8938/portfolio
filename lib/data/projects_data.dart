import '../models/project.dart';

final List<Project> myProjects = [
  Project(
    title: 'Parcel Delivery System App',
    description: 'A full-stack parcel delivery system built using Flutter for the frontend and NestJS with MySQL for the backend. Features include parcel tracking, real-time updates, and delivery management.',
    imagePath: 'assets/images/home.jpeg',
    techStack: ['Flutter', 'Figma', 'Docker', 'NestJS', 'MySQL', 'Swagger', 'REST API'],
    repoUrl: 'https://github.com/manas8938/smart-delivery',
  ),
  Project(
    title: 'Fitness Tracker App',
    description: 'Fitness Tracker app built during an internship. Tracks workouts, steps, calories, and sleep; includes workout plans, progress charts, local storage, user authentication, and exportable reports. Built with clean architecture for easy expansion and integration.',
    imagePath: 'assets/images/fitnessTrackerApp.jpg',
    techStack: [
      'Flutter',
      'Dart',
      'Firebase',
      'Figma',
    ],
    repoUrl: 'https://github.com/manas8938/CodeAlpha_FitnessTracker',
  ),

  Project(
    title: 'Food Delivery App',
    description: 'A frontend prototype of a food delivery app showcasing restaurant listings, menu browsing, and modern UI elements using Flutter and Figma.',
    imagePath: '',
    techStack: ['Flutter', 'Figma'],
    repoUrl: 'https://github.com/manas8938/smart-delivery',
  ),
];
